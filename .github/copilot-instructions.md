# Self-Service Kiosk - Project Setup

## Project Overview
Building a production-quality Flutter kiosk app optimized for iPad and Android tablets with minimal design (black/blue/white), QR payment integration, and multi-tenant architecture.

## Workspace Setup Progress

- [x] Create workspace structure
- [x] Scaffold Flutter project
- [x] Set up clean architecture layers
- [x] Build UI components library
- [x] Implement onboarding wizard
- [x] Create template gallery and builder
- [x] Build kiosk customer screens
- [x] Implement payment flows
- [x] Create web checkout example
- [ ] Generate code with build_runner
- [ ] Test app on device/emulator
- [ ] Review API documentation

## Technical Stack
- Flutter 3.8+
- State Management: Riverpod
- Routing: go_router
- HTTP: dio + retrofit
- Storage: Hive
- QR: qr_flutter
- Architecture: Clean (domain/data/presentation)

## Design System
- Colors: Black (#000000), Blue (#007AFF), White (#FFFFFF)
- Typography: Inter font, clean hierarchy
- Spacing: 8px base unit, generous white space
- Touch targets: Large (min 48dp)
- Orientation: Landscape primary

## Next Steps

### 1. Generate Code
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

### 2. Run App
```bash
# List devices
flutter devices

# Run on device (landscape mode)
flutter run -d <device_id> --device-orientation landscape
```

### 3. Test Onboarding
- Launch app → Onboarding wizard appears
- Complete 5 steps: Business Info → Type → Template → Products → Payment
- Use "Demo Products" button for quick setup

### 4. Test Kiosk Flow
- View category tabs and product grid
- Tap product to add to cart
- Review cart and proceed to checkout
- Test both payment methods (QR + Pay at Counter)

## File Structure
```
lib/
├── core/
│   ├── constants/      ✓ AppColors, AppSpacing, AppTypography
│   ├── theme/          ✓ AppTheme
│   └── widgets/        ✓ AppButton, ProductCard, etc.
├── domain/
│   └── entities/       ✓ Merchant, Product, Order, PaymentSession
├── data/
│   └── datasources/    ✓ MockApiDataSource (demo mode)
└── presentation/
    ├── onboarding/     ✓ 5-step wizard
    ├── kiosk/          ✓ Home screen
    └── payments/       ✓ QR + Checkout screens
```

## Known Limitations (MVP)
- Using mock data source (no real backend yet)
- Template builder is simplified (not full drag-drop)
- QR payment uses simulated polling (replace with WebSocket)
- Web checkout is HTML example (integrate Stripe for production)

## Production Checklist
- [ ] Replace MockApiDataSource with real API client
- [ ] Implement actual payment provider (Stripe)
- [ ] Add WebSocket for real-time payment updates
- [ ] Set up backend API (see docs/API.md)
- [ ] Deploy web checkout to hosting
- [ ] Add error handling and logging
- [ ] Implement analytics tracking
- [ ] Test on actual iPad/Android tablets
- [ ] Configure kiosk mode (wakelock, auto-reset)
- [ ] Add merchant dashboard for admin tasks

