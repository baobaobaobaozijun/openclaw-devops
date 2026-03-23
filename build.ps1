# Build script for OpenClaw Blog System
# Builds the Maven project and copies the JAR to deploy directory

Write-Host "🚀 Starting build process..." -ForegroundColor Green

# Define paths
$projectPath = "F:\openclaw\code\backend"
$deployPath = "F:\openclaw\code\deploy"
$jarSource = "$projectPath\target\*.jar"
$jarDestination = "$deployPath\blog-system.jar"

# Ensure deploy directory exists
if (!(Test-Path $deployPath)) {
    New-Item -ItemType Directory -Path $deployPath -Force
    Write-Host "📁 Created deploy directory: $deployPath" -ForegroundColor Cyan
}

# Change to project directory
Set-Location $projectPath
Write-Host "📂 Changed to project directory: $projectPath" -ForegroundColor Cyan

# Execute Maven clean package
Write-Host "🔨 Executing Maven clean package..." -ForegroundColor Yellow
mvn clean package -DskipTests

if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ Maven build failed!" -ForegroundColor Red
    exit 1
}

# Find and copy the JAR file
$jarFiles = Get-ChildItem -Path "$projectPath\target" -Filter "*.jar" -File
if ($jarFiles.Count -eq 0) {
    Write-Host "❌ No JAR file found in target directory!" -ForegroundColor Red
    exit 1
}

$latestJar = $jarFiles | Sort-Object CreationTime -Descending | Select-Object -First 1
Write-Host "📦 Found JAR file: $($latestJar.Name)" -ForegroundColor Green

Copy-Item $latestJar.FullName $jarDestination -Force
Write-Host "✅ Copied JAR to deploy directory: $jarDestination" -ForegroundColor Green

# Verify the copied JAR file
if (Test-Path $jarDestination) {
    $jarInfo = Get-Item $jarDestination
    Write-Host "🔍 Verified JAR file size: $($jarInfo.Length) bytes" -ForegroundColor Cyan
    
    Write-Host "🎉 Build completed successfully!" -ForegroundColor Green
    Write-Host "📍 JAR file location: $jarDestination" -ForegroundColor Cyan
} else {
    Write-Host "❌ Failed to verify JAR file in deploy directory!" -ForegroundColor Red
    exit 1
}