# 包子铺安全部署脚本
# 凭据从 .local/deploy-config.json 读取，不硬编码
# 用法: .\deploy-to-server.ps1 [-ConfigPath "path\to\deploy-config.json"]

param(
    [string]$ConfigPath = "F:\openclaw\agent\workspace-suancai\.local\deploy-config.json"
)

# 读取配置
if (-not (Test-Path $ConfigPath)) {
    Write-Host "ERROR: 配置文件不存在: $ConfigPath" -ForegroundColor Red
    Write-Host "请创建 .local/deploy-config.json（参考 deploy-config.example.json）"
    exit 1
}

$config = Get-Content $ConfigPath | ConvertFrom-Json
$ServerIP = $config.server.ip
$ServerUser = $config.server.user
$ServerPass = $config.server.password
$JarPath = $config.paths.backendJar
$DistPath = $config.paths.frontendDist
$RemoteBackend = $config.paths.remoteBackend
$RemoteFrontend = $config.paths.remoteFrontend
$RemoteBackup = $config.paths.remoteBackup

Import-Module Posh-SSH

$pass = ConvertTo-SecureString $ServerPass -AsPlainText -Force
$cred = New-Object System.Management.Automation.PSCredential($ServerUser, $pass)

Write-Host "=== 包子铺部署 ===" -ForegroundColor Green
Write-Host "目标: $ServerIP"
Write-Host "时间: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')"

# 1. 连接服务器
Write-Host "`n[1/7] 连接服务器..." -ForegroundColor Yellow
$session = New-SSHSession -ComputerName $ServerIP -Credential $cred -AcceptKey
if (-not $session) { Write-Host "ERROR: SSH 连接失败" -ForegroundColor Red; exit 1 }
Write-Host "  连接成功" -ForegroundColor Green

# 2. 备份旧版本
Write-Host "[2/7] 备份旧版本..." -ForegroundColor Yellow
Invoke-SSHCommand -SessionId $session.SessionId -Command "mkdir -p $RemoteBackup/$(Get-Date -Format 'yyyyMMdd-HHmm'); cp $RemoteBackend/*.jar $RemoteBackup/$(Get-Date -Format 'yyyyMMdd-HHmm')/ 2>/dev/null; echo BACKUP_OK"

# 3. 上传后端 JAR
Write-Host "[3/7] 上传后端 JAR..." -ForegroundColor Yellow
if (Test-Path $JarPath) {
    Set-SCPItem -ComputerName $ServerIP -Credential $cred -AcceptKey -Path $JarPath -Destination "$RemoteBackend/"
    Write-Host "  JAR 上传完成" -ForegroundColor Green
} else {
    Write-Host "  WARNING: JAR 不存在，跳过" -ForegroundColor Yellow
}

# 4. 上传前端 dist
Write-Host "[4/7] 上传前端 dist..." -ForegroundColor Yellow
if (Test-Path "$DistPath\index.html") {
    $tarPath = "$DistPath\..\dist.tar"
    tar -cf $tarPath -C $DistPath .
    Set-SCPItem -ComputerName $ServerIP -Credential $cred -AcceptKey -Path $tarPath -Destination "$RemoteFrontend/"
    Invoke-SSHCommand -SessionId $session.SessionId -Command "cd $RemoteFrontend && tar -xf dist.tar && rm dist.tar"
    Remove-Item $tarPath -Force
    Write-Host "  前端上传完成" -ForegroundColor Green
} else {
    Write-Host "  WARNING: dist 不存在，跳过" -ForegroundColor Yellow
}

# 5. 重启后端
Write-Host "[5/7] 重启后端服务..." -ForegroundColor Yellow
Invoke-SSHCommand -SessionId $session.SessionId -Command "pkill -f backend-1.0.0-SNAPSHOT.jar 2>/dev/null; sleep 2; cd $RemoteBackend && nohup java -jar backend-1.0.0-SNAPSHOT.jar --server.port=8080 > app.log 2>&1 &"
Start-Sleep -Seconds 8
Write-Host "  后端重启完成" -ForegroundColor Green

# 6. 重载 Nginx
Write-Host "[6/7] 重载 Nginx..." -ForegroundColor Yellow
$nginxTest = Invoke-SSHCommand -SessionId $session.SessionId -Command "nginx -t 2>&1"
if ($nginxTest.Output -match "successful") {
    Invoke-SSHCommand -SessionId $session.SessionId -Command "systemctl reload nginx"
    Write-Host "  Nginx 重载成功" -ForegroundColor Green
} else {
    Write-Host "  WARNING: Nginx 配置有误，跳过重载" -ForegroundColor Yellow
}

# 7. 冒烟测试
Write-Host "[7/7] 冒烟测试..." -ForegroundColor Yellow
$frontendCheck = Invoke-SSHCommand -SessionId $session.SessionId -Command "curl -s -o /dev/null -w '%{http_code}' http://localhost/"
$backendCheck = Invoke-SSHCommand -SessionId $session.SessionId -Command "curl -s -o /dev/null -w '%{http_code}' http://localhost:8080/api/"

$frontendOK = $frontendCheck.Output -match "200"
$backendOK = $backendCheck.Output -match "200|401|403"

Write-Host "  前端: HTTP $($frontendCheck.Output) $(if($frontendOK){'OK'}else{'FAIL'})" -ForegroundColor $(if($frontendOK){"Green"}else{"Red"})
Write-Host "  后端: HTTP $($backendCheck.Output) $(if($backendOK){'OK'}else{'FAIL'})" -ForegroundColor $(if($backendOK){"Green"}else{"Red"})

# 如果冒烟测试失败，回滚
if (-not $frontendOK -and -not $backendOK) {
    Write-Host "`n!!! 冒烟测试全部失败，执行回滚 !!!" -ForegroundColor Red
    $latestBackup = Invoke-SSHCommand -SessionId $session.SessionId -Command "ls -t $RemoteBackup/ | head -1"
    Invoke-SSHCommand -SessionId $session.SessionId -Command "cp $RemoteBackup/$($latestBackup.Output)/*.jar $RemoteBackend/ 2>/dev/null; cd $RemoteBackend && pkill -f backend && nohup java -jar backend-1.0.0-SNAPSHOT.jar --server.port=8080 > app.log 2>&1 &"
    Write-Host "  回滚完成" -ForegroundColor Yellow
}

Remove-SSHSession -SessionId $session.SessionId | Out-Null

Write-Host "`n=== 部署完成 ===" -ForegroundColor Green
Write-Host "访问: http://$ServerIP/"
