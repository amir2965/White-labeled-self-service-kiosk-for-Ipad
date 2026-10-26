# Ultra-fast development build
# Disables some optimizations for maximum speed

Write-Host "Starting FAST development build..." -ForegroundColor Cyan
Write-Host "⚡ Optimizations: HTML renderer, no tree-shaking, no sound null safety checks" -ForegroundColor Yellow

flutter run -d chrome `
  --web-renderer html `
  --web-port 8080 `
  --no-tree-shake-icons `
  --no-sound-null-safety

Write-Host "`n✓ App should start much faster!" -ForegroundColor Green
Write-Host "Note: Use 'run-local.ps1' for production builds" -ForegroundColor Gray
