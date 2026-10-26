# Self-Service Kiosk - Quick Start

Write-Host "🚀 Self-Service Kiosk Setup" -ForegroundColor Blue
Write-Host ""

Write-Host "Step 1: Generating code with build_runner..." -ForegroundColor Yellow
flutter pub run build_runner build --delete-conflicting-outputs

if ($LASTEXITCODE -eq 0) {
    Write-Host "✓ Code generation complete!" -ForegroundColor Green
} else {
    Write-Host "✗ Code generation failed" -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "Step 2: Listing available devices..." -ForegroundColor Yellow
flutter devices

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Setup Complete! 🎉" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Next steps:" -ForegroundColor Yellow
Write-Host "1. Connect your iPad/Android tablet" -ForegroundColor White
Write-Host "2. Run: flutter run -d <device_id>" -ForegroundColor White
Write-Host "3. Or run in landscape: flutter run -d <device_id> --device-orientation landscape" -ForegroundColor White
Write-Host ""
Write-Host "📚 Documentation:" -ForegroundColor Yellow
Write-Host "   - README.md - Project overview" -ForegroundColor White
Write-Host "   - DELIVERABLES.md - Complete feature list" -ForegroundColor White
Write-Host "   - docs/API.md - API specification" -ForegroundColor White
Write-Host ""
