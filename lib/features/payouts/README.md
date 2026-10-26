# Payouts Module

A production-ready payouts module that provides settlement history, instant transfer management, and bank account linking. The UI uses a clean, modern design with iPad responsiveness and full accessibility support.

## Features

### 1. Balances Screen
- Displays available, pending, and in-transit balances
- Large, centered amount display for available balance
- "Upcoming transfer" card with informational content
- Settings icon for quick access to transfer settings
- Responsive loading/error states

### 2. Activity Screen
- Comprehensive settlement history table with pagination
- Date range filtering with quick presets (Last 30/90 days, This/Last month)
- CSV export functionality with preview and clipboard copy
- Empty state with guidance text
- Sortable columns (Date, Net Paid)
- Row tap to view detailed settlement information

### 3. Transfer Settings Screen
- Instant transfer configuration with fee display
- Bank account linking form with validation
- Tabbed interface for linked/new accounts
- Conditional UI based on bank account status
- Sticky footer with Save/Cancel actions
- Form state management with error handling

### 4. Settlement Details Screen
- Complete breakdown of settlement amounts (Gross, Fees, GST, Net Paid)
- Settlement period display
- Timeline visualization (Pending → Processing → Paid)
- Destination bank account information
- Failure reason display (when applicable)
- Clean card-based layout

## Architecture

### Domain Layer
```
lib/features/payouts/domain/
├── models/
│   ├── money.dart              # Immutable monetary value with currency
│   ├── payout_status.dart      # Enum with display names and colors
│   ├── settlement.dart         # Settlement/payout entity
│   ├── balance_snapshot.dart   # Current balance state
│   ├── bank_account.dart       # Linked bank account
│   └── instant_transfer_config.dart  # Instant transfer settings
└── repositories/
    └── payouts_repository.dart # Repository interface
```

### Data Layer
```
lib/features/payouts/data/
└── repositories/
    └── mock_payouts_repository.dart  # Mock implementation with latency simulation
```

### Presentation Layer
```
lib/features/payouts/presentation/
├── screens/
│   ├── balances_screen.dart
│   ├── activity_screen.dart
│   ├── transfer_settings_screen.dart
│   └── settlement_details_screen.dart
├── widgets/
│   ├── payout_app_bar.dart       # Custom app bar with back navigation
│   ├── status_pill.dart          # Subtle status indicator
│   ├── pill_buttons.dart         # Primary/Secondary/Outline buttons
│   ├── date_range_pill.dart      # Date range selector with navigation
│   ├── empty_state_card.dart     # Empty state component
│   ├── bank_account_card.dart    # Bank account display
│   └── settlement_table.dart     # Paginated data table
└── providers/
    └── payouts_providers.dart    # Riverpod state management
```

## Routing

Routes defined in `lib/config/router.dart`:

- `/payouts/balances` - Balance overview
- `/payouts/activity` - Settlement history
- `/payouts/settings` - Transfer settings
- `/payouts/settlement/:id` - Settlement details

## Data Models

### Money
Represents monetary amounts in minor units (cents for AUD):
```dart
final money = Money.fromDecimal(123.45);
print(money.formatted); // "$123.45"
print(money.minorUnits); // 12345
```

### Settlement
Complete payout/settlement record:
- ID and timestamps
- Settlement period (start/end)
- Breakdown: gross, fees, GST, net paid
- Status (pending, processing, paid, failed, reversed)
- Bank account reference
- Optional failure reason

### BalanceSnapshot
Current balance state:
- Available (can be transferred)
- Pending (processing)
- In Transit (on the way)

## State Management

Using Riverpod for reactive state:

### Providers
- `balanceProvider` - Current balance
- `settlementsProvider` - Filtered settlements
- `dateRangeProvider` - Date range state
- `linkedBankAccountProvider` - Linked bank account
- `instantTransferConfigProvider` - Transfer configuration
- `bankAccountFormProvider` - Bank account linking form

### Example Usage
```dart
final balanceAsync = ref.watch(balanceProvider);
final settlements = ref.watch(settlementsProvider);
```

## CSV Export

Activity screen includes CSV export with the following columns:
- Date (dd/MM/yyyy)
- Period Start
- Period End
- Gross
- Fees
- GST
- Net Paid
- Status
- Reference

Export dialog shows preview and "Copy to Clipboard" action.

## Mock Data

The mock repository (`MockPayoutsRepository`) provides:
- Realistic latency simulation (300-1000ms)
- Random settlement generation based on date range
- Bank account linking simulation
- Instant transfer validation

## Replacing Mock with Real API

### Step 1: Create API Client
```dart
// lib/features/payouts/data/datasources/payouts_api.dart
class PayoutsApi {
  final Dio dio;
  
  Future<BalanceResponse> getBalance() async {
    final response = await dio.get('/api/payouts/balance');
    return BalanceResponse.fromJson(response.data);
  }
  
  Future<List<SettlementResponse>> getSettlements(
    DateTime startDate,
    DateTime endDate,
  ) async {
    final response = await dio.get(
      '/api/payouts/settlements',
      queryParameters: {
        'start_date': startDate.toIso8601String(),
        'end_date': endDate.toIso8601String(),
      },
    );
    return (response.data as List)
        .map((json) => SettlementResponse.fromJson(json))
        .toList();
  }
  
  // ... other methods
}
```

### Step 2: Create API Repository Implementation
```dart
// lib/features/payouts/data/repositories/api_payouts_repository.dart
class ApiPayoutsRepository implements PayoutsRepository {
  final PayoutsApi api;
  
  ApiPayoutsRepository(this.api);
  
  @override
  Future<BalanceSnapshot> getBalance() async {
    final response = await api.getBalance();
    return response.toDomain(); // Map DTO to domain model
  }
  
  // ... implement other methods
}
```

### Step 3: Update Provider
```dart
// lib/features/payouts/presentation/providers/payouts_providers.dart
final payoutsRepositoryProvider = Provider<PayoutsRepository>((ref) {
  // In production:
  // final dio = ref.watch(dioProvider);
  // final api = PayoutsApi(dio);
  // return ApiPayoutsRepository(api);
  
  // For now:
  return MockPayoutsRepository();
});
```

## Design System

### Colors
- Primary: `#007AFF` (Blue)
- Background: `Colors.grey.shade50`
- Card background: `Colors.white`
- Border: `Colors.grey.shade300`
- Text primary: `Colors.black87`
- Text secondary: `Colors.grey.shade600`

### Typography
- Page title: 20px, bold
- Section title: 18px, bold
- Body: 15px, regular
- Label: 14px, regular
- Small: 13px, regular

### Spacing
- Card padding: 24px
- Section spacing: 24px
- Element spacing: 16px
- Small spacing: 12px
- Micro spacing: 8px

### Touch Targets
Minimum 44px height for all interactive elements.

### Border Radius
- Cards: 16px
- Inner elements: 12px
- Buttons: 24px (pill)
- Small elements: 8px

## Accessibility

- Semantic labels on all interactive elements
- Minimum contrast ratio 4.5:1
- Focus indicators on keyboard navigation
- Screen reader support
- Dynamic Type support
- Safe area insets respected

## iPad Responsiveness

- Maximum content width: 1100-1400px (depending on screen)
- Centered layout with side margins
- Responsive table with horizontal scroll
- Modal sheets on smaller viewports
- Landscape-first design

## Testing

Unit tests included for:
- Money calculations and formatting
- CSV export generation
- Status mapping
- Date range filtering

Run tests:
```bash
flutter test test/features/payouts/
```

## Localization

Currently configured for:
- Currency: AUD ($)
- Date format: dd/MM/yyyy (Australian)
- Number format: English (AU)

To add more locales, update date formatters and currency symbols in respective files.

## Known Limitations (MVP)

1. Mock data only - no real backend integration
2. Bank account verification is simulated
3. Instant transfer is a stub
4. No WebSocket for real-time updates
5. CSV export uses in-memory generation (no file save)
6. No analytics/tracking integration

## Production Checklist

- [ ] Replace `MockPayoutsRepository` with real API client
- [ ] Implement actual payment provider integration
- [ ] Add WebSocket for real-time settlement updates
- [ ] Implement proper CSV file download (platform channels)
- [ ] Add error logging and monitoring
- [ ] Implement retry logic with exponential backoff
- [ ] Add loading skeletons instead of spinners
- [ ] Implement pull-to-refresh
- [ ] Add deep linking support
- [ ] Test on actual iPad devices (all sizes)
- [ ] Test with VoiceOver and TalkBack
- [ ] Implement analytics events
- [ ] Add feature flags for rollout
- [ ] Performance testing with large datasets

## Related Documentation

- See `docs/API.md` for backend API specifications
- See `.github/copilot-instructions.md` for project context
- See `lib/core/theme/app_theme.dart` for global theme

## Support

For questions or issues, contact the development team.
