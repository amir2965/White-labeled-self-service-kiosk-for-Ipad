# Run Flutter App with ngrok (iPad & External Access)
# This script builds the Flutter web app, starts an HTTP server, and creates an ngrok tunnel

Write-Host "Building Flutter web app..." -ForegroundColor Cyan
Write-Host ""

# Build Flutter for web
flutter build web

if ($LASTEXITCODE -ne 0) {
    Write-Host "Flutter build failed!" -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "Build complete!" -ForegroundColor Green
Write-Host ""

# Copy checkout page to build folder
Write-Host "Copying checkout page..." -ForegroundColor Cyan
Copy-Item "web_checkout\checkout.html" "build\web\checkout.html" -Force

# Copy build/web contents to web_checkout so payment server can serve everything
Write-Host "Preparing web files..." -ForegroundColor Cyan
Copy-Item "build\web\*" "web_checkout\" -Recurse -Force

# Get local IP address
$localIP = (Get-NetIPAddress -AddressFamily IPv4 | Where-Object {$_.IPAddress -like "192.168.*" -or $_.IPAddress -like "172.*" -or $_.IPAddress -like "10.*"} | Select-Object -First 1).IPAddress

Write-Host "Starting payment server on port 8080..." -ForegroundColor Cyan

# Start Dart payment server in new window
Start-Process powershell -ArgumentList '-NoExit', '-Command', "cd '$PWD'; Write-Host '🚀 Payment Server' -ForegroundColor Green; dart run lib/server/payment_server.dart"

# Wait for server to start
Start-Sleep -Seconds 3

Write-Host "Server running!" -ForegroundColor Green
Write-Host ""

Write-Host "Starting ngrok tunnel..." -ForegroundColor Cyan
Write-Host ""

# Start ngrok in new window (dynamic URL for free accounts)
Start-Process powershell -ArgumentList '-NoExit', '-Command', "Write-Host '🌐 Ngrok Tunnel' -ForegroundColor Green; ngrok http 8080"

# Wait for ngrok to start and get URL
Start-Sleep -Seconds 4

# Get ngrok URL from API
try {
    $ngrokApi = Invoke-RestMethod -Uri "http://localhost:4040/api/tunnels"
    $publicUrl = $ngrokApi.tunnels[0].public_url
    
    Write-Host "=======================================================" -ForegroundColor Green
    Write-Host "KIOSK APP IS READY!" -ForegroundColor Green
    Write-Host "=======================================================" -ForegroundColor Green
    Write-Host ""
    Write-Host "iPad/External Access:" -ForegroundColor Yellow
    Write-Host "   $publicUrl" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "Local Network Access (Same WiFi):" -ForegroundColor Yellow
    Write-Host "   http://${localIP}:8080" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "Ngrok Inspector (view requests):" -ForegroundColor Yellow
    Write-Host "   http://localhost:4040" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "=======================================================" -ForegroundColor Green
    Write-Host ""
    Write-Host "Servers are running in separate windows." -ForegroundColor Gray
    Write-Host "Close those windows to stop the servers." -ForegroundColor Gray
}
catch {
    Write-Host "Waiting for ngrok... Check http://localhost:4040 for URL" -ForegroundColor Yellow
}
