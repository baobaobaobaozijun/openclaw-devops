# Start script for Spring Boot application
# Starts the application as a background process

param(
    [string]$JarPath = $(Join-Path $PSScriptRoot "app.jar"),
    [int]$Port = 8080,
    [string]$LogDir = $(Join-Path $PSScriptRoot "logs")
)

# Ensure logs directory exists
if (!(Test-Path $LogDir)) {
    New-Item -ItemType Directory -Path $LogDir -Force
}

# Check if the JAR file exists
if (!(Test-Path $JarPath)) {
    Write-Error "JAR file not found: $JarPath"
    exit 1
}

# Define log file paths
$stdoutLog = Join-Path $LogDir "app-$(Get-Date -Format 'yyyyMMdd-HHmmss').log"
$stderrLog = Join-Path $LogDir "app-$(Get-Date -Format 'yyyyMMdd-HHmmss')-error.log"

# Check if app is already running
$existingProcesses = Get-WmiObject Win32_Process -Filter "Name='java.exe'" | Where-Object { 
    $_.CommandLine -like "*$(Split-Path $JarPath -Leaf)*" 
}

if ($existingProcesses) {
    Write-Warning "Application appears to be already running:"
    $existingProcesses | ForEach-Object { 
        Write-Host "  PID: $($_.ProcessId), Command: $($_.CommandLine)" 
    }
    $response = Read-Host "Do you want to continue? (y/N)"
    if ($response -ne 'y' -and $response -ne 'Y') {
        Write-Host "Start operation cancelled."
        exit 0
    }
}

Write-Host "Starting application on port $Port..."
Write-Host "Logging to: $stdoutLog"

# Start the application in background
$process = Start-Process -FilePath "java" -ArgumentList @(
    "-jar",
    "`"$JarPath`"",
    "--server.port=$Port"
) -RedirectStandardOutput $stdoutLog -RedirectStandardError $stderrLog -PassThru

if ($process) {
    Write-Host "Application started successfully!"
    Write-Host "PID: $($process.Id)"
    Write-Host "Port: $Port"
    Write-Host "Log: $stdoutLog"
} else {
    Write-Error "Failed to start application"
    exit 1
}

# Wait a moment and check if the process is still running
Start-Sleep -Seconds 3
$checkProcess = Get-Process -Id $process.Id -ErrorAction SilentlyContinue
if (!$checkProcess) {
    Write-Error "Application failed to start properly. Check logs: $stdoutLog"
    Get-Content $stderrLog -ErrorAction SilentlyContinue
    exit 1
} else {
    Write-Host "Application is running with PID $($process.Id)"
}