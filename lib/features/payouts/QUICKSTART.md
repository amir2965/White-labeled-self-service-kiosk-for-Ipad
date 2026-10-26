# Payouts Module - Quick Start Guide

Get the Payouts module running in 5 minutes.

## Prerequisites

- Flutter 3.8+ installed
- Project dependencies installed (`flutter pub get`)

## Run the App

```bash
# Navigate to project root
cd "<path-to-project>"

# Get dependencies (if not already done)
flutter pub get

# Run on connected device or emulator
flutter run
```

## Navigate to Payouts

The app starts at `/dashboard`. From there:

### Option 1: Update Initial Route (Recommended for Testing)
Edit `lib/config/router.dart` line 18:
```dart
initialLocation: '/payouts/balances',  // Changed from '/dashboard'
```

### Option 2: Add Navigation Button
Add to your dashboard or overview screen:
```dart
ElevatedButton(
  onPressed: () => context.push('/payouts/balances'),
  child: const Text('View Payouts'),
)
```

## Routes

Navigate programmatically:
```dart
// From Overview to Balances
context.push('/payouts/balances');

// From Balances to Activity
context.push('/payouts/activity');

// From Activity to Settings
context.push('/payouts/settings');

// From Activity to Settlement Details
context.push('/payouts/settlement/po_123');
```

Or manually in browser (web):
- http://localhost:PORT/#/payouts/balances
- http://localhost:PORT/#/payouts/activity
- http://localhost:PORT/#/payouts/settings

## Test Features

### Balances Screen
1. Navigate to `/payouts/balances`
2. See $0.00 available balance (mock data)
3. Click settings icon → goes to Transfer Settings
4. Click "View all transfers" → goes to Activity

### Activity Screen
1. Navigate to `/payouts/activity`
2. Click date range pill → select preset or custom range
3. Click "Export" → see CSV preview dialog
4. Click any table row → see Settlement Details
5. Use pagination controls if many results

### Transfer Settings Screen
1. Navigate to `/payouts/settings`
2. Switch to "Link an account" tab
3. Fill form:
   - Bank Name: Commonwealth Bank
   - Account Name: Test User
   - BSB: 123-456
   - Account Number: 12345678
4. Click "Link Account"
5. Switch back to "Linked account" tab → see linked bank

### Settlement Details Screen
1. From Activity screen, click any row
2. See complete breakdown
3. See timeline visualization
4. Click back → return to Activity

## Mock Data

The `MockPayoutsRepository` provides:
- **Balance**: Always $0.00 (change in `getBalance()` method)
- **Settlements**: Random settlements based on date range (0-3 per week)
- **Bank Account**: Persists in memory during app session
- **Instant Transfer**: Simulated with delay

### Customize Mock Data

Edit `lib/features/payouts/data/repositories/mock_payouts_repository.dart`:

```dart
// Change available balance
@override
Future<BalanceSnapshot> getBalance() async {
  await _simulateDelay();
  return BalanceSnapshot(
    available: Money.fromDecimal(1250.50),  // <-- Change this
    pending: Money.fromDecimal(320.00),     // <-- And this
    inTransit: Money.fromDecimal(0.00),
    asOf: DateTime.now(),
  );
}

// Change settlement generation
final numSettlements = (daysDiff / 7 * 3).round(); // <-- Always 3 per week
```

## Troubleshooting

### Routes not working
**Error**: "Could not find a generator for route..."
**Fix**: Restart app after adding routes to `lib/config/router.dart`

### Provider errors
**Error**: "ProviderNotFoundException"
**Fix**: Ensure `ProviderScope` wraps app in `main.dart`:
```dart
void main() {
  runApp(const ProviderScope(child: KioskApp()));
}
```

### Date picker not showing
**Issue**: Material date picker needs Material app context
**Status**: Already handled in `date_range_pill.dart` with theme override

### Empty settlements
**Reason**: Mock generates 0-3 settlements per week randomly
**Fix**: Either:
1. Try different date range (last 90 days for more results)
2. Increase `numSettlements` in mock repository
3. Force settlements in mock:
```dart
// In getSettlements():
final numSettlements = 10; // Force 10 settlements
```

## Hot Reload

Most changes support hot reload (`r` in terminal):
- ✅ UI changes
- ✅ Widget updates
- ✅ Color/spacing changes
- ❌ Provider changes (need full restart)
- ❌ Route changes (need full restart)

For provider or route changes, use hot restart (`R` in terminal).

## Testing on iPad

1. **Simulator** (Mac):
   ```bash
   # List devices
   flutter devices
   
   # Run on iPad simulator
   flutter run -d "iPad Pro (12.9-inch)"
   ```

2. **Physical iPad**:
   - Connect via USB
   - Trust computer
   - Enable Developer Mode (iOS 16+)
   - Run: `flutter run -d <device-id>`

3. **Test Responsiveness**:
   - Rotate device (portrait/landscape)
   - Try Split View (iPad multitasking)
   - Test with external keyboard
   - Test VoiceOver (Settings → Accessibility)

## IDE Setup

### VS Code
1. Install Flutter extension
2. Select device: Command Palette → "Flutter: Select Device"
3. Run: F5 or Run → Start Debugging
4. Hot reload: Command+Option+F5 or Save file

### Android Studio
1. Open project
2. Select device from toolbar
3. Click Run (▶️)
4. Hot reload: Click ⚡ or Command+\

## Next Steps

1. **Integrate Real API**: See `README.md` section "Replacing Mock with Real API"
2. **Customize UI**: Edit widget files in `lib/features/payouts/presentation/widgets/`
3. **Add to Dashboard**: Create navigation cards in your overview screen
4. **Run Tests**: `flutter test test/features/payouts/`

## Quick Reference

```dart
// Navigation
context.push('/payouts/balances');
context.go('/overview');  // Replace current route

// Read data
final balance = ref.watch(balanceProvider);
final settlements = ref.watch(settlementsProvider);

// Update date range
ref.read(dateRangeProvider.notifier).setLast30Days();
ref.read(dateRangeProvider.notifier).setDateRange(start, end);

// Refresh data
ref.refresh(balanceProvider);
ref.invalidate(settlementsProvider);
```

## Demo Script

To show all features in order:

1. Start at `/payouts/balances`
   - Point out big centered amount
   - Show pending/in-transit chips (if any)
   - Read "upcoming transfer" card
   
2. Click "View all transfers"
   - Show date range selector
   - Change range, see table update
   - Sort by clicking column headers
   - Paginate if >20 rows
   - Export CSV
   
3. Click a row
   - Show breakdown
   - Point out timeline
   - Navigate back
   
4. Go to Settings (gear icon from Balances)
   - Show instant transfer section
   - Link a bank account
   - Show disabled → enabled state
   - Cancel/Save controls

Done! You've completed the full Payouts flow.
