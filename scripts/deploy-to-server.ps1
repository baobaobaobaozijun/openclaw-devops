# 包子铺自动化部署脚本
# 使用方法: .\deploy-to-server.ps1
# 前置条件: Install-Module Posh-SSH

Import-Module Posh-SSH

$ServerIP = "8.137.175.240"
$pass = ConvertTo-SecureString "Qaz4568213!" -AsPlainText -Force
$cred = New-Object System.Management.Automation.PSCredential("root", $pass)

Write-Host "=== 包子铺部署脚本 ===" -ForegroundColor Green

# 1. 上传后端 JAR
Write-Host "[1/5] 上传后端 JAR..." -ForegroundColor Yellow
Set-SCPItem -ComputerName $ServerIP -Credential $cred -AcceptKey -Path "F:\openclaw\code\backend\target\backend-1.0.0-SNAPSHOT.jar" -Destination "/opt/baozipu/backend/"
Write-Host "  JAR 上传完成" -ForegroundColor Green

# 2. 上传前端 dist
Write-Host "[2/5] 上传前端 dist..." -ForegroundColor Yellow
Set-Location F:\openclaw\code\frontend
tar -cf dist.tar -C dist .
Set-SCPItem -ComputerName $ServerIP -Credential $cred -AcceptKey -Path "F:\openclaw\code\frontend\dist.tar" -Destination "/opt/baozipu/frontend/"
Remove-Item "dist.tar" -Force
Write-Host "  前端上传完成" -ForegroundColor Green

# 3. SSH 连接服务器执行部署
$session = New-SSHSession -ComputerName $ServerIP -Credential $cred -AcceptKey

# 解压前端
Write-Host "[3/5] 解压前端文件..." -ForegroundColor Yellow
Invoke-SSHCommand -SessionId $session.SessionId -Command "cd /opt/baozipu/frontend && tar -xf dist.tar && rm dist.tar"

# 重启后端
Write-Host "[4/5] 重启后端服务..." -ForegroundColor Yellow
Invoke-SSHCommand -SessionId $session.SessionId -Command "pkill -f backend-1.0.0-SNAPSHOT.jar 2>/dev/null; sleep 2; cd /opt/baozipu/backend && nohup java -jar backend-1.0.0-SNAPSHOT.jar --server.port=8080 > app.log 2>&1 &"
Start-Sleep -Seconds 8

# 重载 Nginx
Write-Host "[5/5] 重载 Nginx..." -ForegroundColor Yellow
Invoke-SSHCommand -SessionId $session.SessionId -Command "systemctl reload nginx"

# 验证
Write-Host ""
Write-Host "=== 验证部署 ===" -ForegroundColor Green
$r = Invoke-SSHCommand -SessionId $session.SessionId -Command "curl -s -o /dev/null -w '%{http_code}' http://localhost/ && echo ' Frontend OK'; curl -s -o /dev/null -w '%{http_code}' http://localhost:8080/api/ && echo ' Backend OK'"
Write-Host $r.Output

Remove-SSHSession -SessionId $session.SessionId | Out-Null
Write-Host ""
Write-Host "部署完成! 访问 http://${ServerIP}/" -ForegroundColor Green
