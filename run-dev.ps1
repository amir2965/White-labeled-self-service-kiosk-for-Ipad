# Fast development build for Flutter web
# Uses HTML renderer (faster than CanvasKit) and profile mode

Write-Host "Starting Flutter Web in development mode..." -ForegroundColor Green
Write-Host "Using HTML renderer for faster builds and hot reload" -ForegroundColor Yellow

flutter run -d chrome `
  --web-renderer html `
  --web-port 8080 `
  --dart-define=FLUTTER_WEB_USE_SKIA=false

# Alternative: Use this for even faster startup (skips some optimizations)
# flutter run -d chrome --web-renderer html --web-port 8080 --no-tree-shake-icons
