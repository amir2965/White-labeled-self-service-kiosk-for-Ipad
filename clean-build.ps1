# Force fresh build - clears cache and rebuilds
# Use this when you see old version after making changes

Write-Host "🔄 Forcing fresh build..." -ForegroundColor Cyan
Write-Host "This will clear cache and rebuild everything" -ForegroundColor Yellow
Write-Host ""

# Stop any running Flutter processes
Write-Host "1️⃣ Stopping Flutter processes..." -ForegroundColor Green
Stop-Process -Name "dart" -Force -ErrorAction SilentlyContinue
Stop-Process -Name "flutter" -Force -ErrorAction SilentlyContinue
Start-Sleep -Seconds 1

# Clean build artifacts
Write-Host "2️⃣ Cleaning build artifacts..." -ForegroundColor Green
flutter clean
if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ Flutter clean failed" -ForegroundColor Red
    exit 1
}

# Get dependencies
Write-Host "3️⃣ Getting dependencies..." -ForegroundColor Green
flutter pub get
if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ Pub get failed" -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "✅ Clean build complete!" -ForegroundColor Green
Write-Host ""
Write-Host "Now run one of these:" -ForegroundColor Yellow
Write-Host "  .\run-dev.ps1      (Fast development)" -ForegroundColor Cyan
Write-Host "  .\run-ngrok.ps1    (ngrok + iPad)" -ForegroundColor Cyan
Write-Host ""
