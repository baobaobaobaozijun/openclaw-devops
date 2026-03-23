# OpenClaw Deployment Script (PowerShell)
# Usage: .\deploy.ps1 [up|down|restart|logs|status]

param(
    [Parameter(Position=0)]
    [ValidateSet('up','down','restart','logs','status','rebuild')]
    [string]$Action = 'up',
    
    [Parameter(Position=1)]
    [string]$Service = ''
)

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
Set-Location $ScriptDir

# Load environment variables from .env if exists
$EnvFile = Join-Path $ScriptDir '.env'
if (Test-Path $EnvFile) {
    Get-Content $EnvFile | ForEach-Object {
        if ($_ -match '^\s*([^#][^=]+)=(.*)\s*$') {
            $name = $matches[1].Trim()
            $value = $matches[2].Trim()
            [Environment]::SetEnvironmentVariable($name, $value, 'Process')
        }
    }
}

switch ($Action) {
    'up' {
        Write-Host "Starting OpenClaw services..." -ForegroundColor Green
        docker-compose up -d
        Write-Host "Services started. Check logs with: .\deploy.ps1 logs" -ForegroundColor Green
    }
    'down' {
        Write-Host "Stopping OpenClaw services..." -ForegroundColor Yellow
        docker-compose down
        Write-Host "Services stopped." -ForegroundColor Green
    }
    'restart' {
        Write-Host "Restarting OpenClaw services..." -ForegroundColor Yellow
        docker-compose restart
        Write-Host "Services restarted." -ForegroundColor Green
    }
    'logs' {
        if ($Service) {
            docker-compose logs -f $Service
        } else {
            docker-compose logs -f
        }
    }
    'status' {
        docker-compose ps
    }
    'rebuild' {
        Write-Host "Rebuilding and restarting services..." -ForegroundColor Cyan
        docker-compose up -d --build
        Write-Host "Build complete." -ForegroundColor Green
    }
    default {
        Write-Host "Usage: .\deploy.ps1 {up|down|restart|logs|status|rebuild} [service]" -ForegroundColor Red
        exit 1
    }
}
