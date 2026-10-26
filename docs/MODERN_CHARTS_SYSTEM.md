# Modern Charts System - Sales Summary Analytics

## Overview

Comprehensive, modern, minimal, luxury chart system for the Sales Summary dashboard following a minimal design aesthetic. The system intelligently adapts based on the selected time period, providing different visualizations and insights for single-day vs multi-day analysis.

## Design Philosophy

### **Modern · Minimal · Luxurious · Informative**

- **Minimal Style**: Black (#000000), Blue (#007AFF), White (#FFFFFF) color palette
- **Contextual**: Charts adapt to single-day vs multi-day periods
- **Informative**: Not just charts - includes metadata, measurements, comparisons, insights
- **Professional**: Enterprise-grade visualizations for business decision making

## Chart Components

### 1. **ModernChartCard** (`modern_chart_card.dart`)
   
**Purpose**: Container wrapper for all charts with consistent metadata display

**Features**:
- Title and subtitle with contextual information
- Metric pill (e.g., "$12,543")
- Timeframe indicator (e.g., "Live Updates", "Jan 1 - Jan 31")
- Insight banner with icon (highlights key findings)
- Optional info button for explanations
- Clean border and padding structure

**Usage**:
```dart
ModernChartCard(
  title: 'Hourly Revenue Breakdown',
  subtitle: 'Real-time sales performance by hour',
  metric: '\$12,543',
  timeframe: 'Live Updates',
  insightText: 'Peak hour: 12 PM-1 PM with \$1,234 in sales',
  insightIcon: Icons.access_time,
  chart: ModernHourlyChart(...),
)
```

### 2. **ModernHourlyChart** (`modern_hourly_chart.dart`)

**Purpose**: 24-hour revenue breakdown for single-day analysis

**Features**:
- **Smart Bar Colors**:
  - Current hour (live): Vibrant blue
  - Peak hour: Black
  - Past hours: Gray
  - No data: Light gray
- **Interactive**:
  - Hover to see tooltip with exact sales
  - "NOW" indicator on current hour
- **Stats Row**:
  - Total revenue for the day
  - Average per hour
  - Peak hour with amount
- **Visual Design**:
  - Rounded top bars
  - Y-axis with dollar labels
  - X-axis showing 3-hour intervals (12a, 3a, 6a...)
  - Smooth animations on hover

**Data Model**:
```dart
List<HourlySalesPoint> data; // 24 entries, hour 0-23
int? currentHour; // Highlight if viewing today
```

**Insights Generated**:
- Peak hour identification
- Business hours (9 AM - 5 PM) percentage
- Comparison to previous day (if available)

### 3. **ModernDailyTrendChart** (`modern_daily_trend_chart.dart`)

**Purpose**: Daily revenue trend for multi-day periods (7+ days)

**Features**:
- **Smooth Line Chart**:
  - Gradient area fill under the line
  - Smooth bezier curves connecting points
  - Blue line with white-bordered points
- **Horizontal Grid Lines**: For easier value reading
- **Dynamic X-Axis**:
  - 1-7 days: Show all days
  - 8-31 days: Show every 3rd day
  - 32+ days: Show weekly intervals
- **Stats Row**:
  - Total revenue for period
  - Daily average
  - Best performing day
  - Number of days in period
- **Legend**: Shows selected vs comparison periods

**Data Model**:
```dart
Map<String, double> dailyData; // 'yyyy-MM-dd' -> sales amount
DateTime startDate;
DateTime endDate;
```

**Insights Generated**:
- Average daily revenue
- Best performing day
- Period-over-period growth/decline
- Average orders per day

### 4. **ModernComparisonCard** (`modern_comparison_card.dart`)

**Purpose**: Show current vs previous period comparisons

**Features**:
- **Large Current Value**: Prominent display
- **Change Indicator**:
  - Up arrow (green/blue) for positive
  - Down arrow (red) for negative
  - Minus sign (gray) for no change
- **Visual Comparison Bars**:
  - Current period: Blue bar
  - Previous period: Gray bar
  - Scaled to show relative sizes
- **Percentage or Absolute Change**: Configurable

**Usage**:
```dart
ModernComparisonCard(
  title: 'Revenue',
  currentValue: 12543.50,
  previousValue: 10234.00,
  customLabel: 'vs previous day',
  showPercentage: true, // Show 22.6% instead of $2,309.50
  isRevenueMetric: true, // Format as $12.5K
)
```

### 5. **ModernInsightsPanel** (`modern_comparison_card.dart`)

**Purpose**: Display AI-generated or rule-based insights

**Features**:
- Blue-tinted background
- Lightbulb icon
- Bullet list of insights
- Responsive to period type

**Insight Types**:
- **Single Day**: Peak hour, previous day comparison, business hours %
- **Multi Day**: Daily average, best day, trend analysis, order volume

**Usage**:
```dart
ModernInsightsPanel(
  title: 'Period Insights',
  insights: [
    'Peak hour: 12 PM-1 PM with \$1,234 in sales',
    'Revenue is up 15.3% compared to previous day',
    '68% of sales occurred during business hours',
  ],
)
```

## Smart Chart Selection

### **SalesSummaryChartsSection** (`sales_summary_charts_section.dart`)

Main orchestrator that decides which charts to show based on period selection.

### Single-Day View (Today or Yesterday)

**When**: `selectedStartDate == selectedEndDate`

**Shows**:
1. **Mode Indicator**: "Today's Performance" with live dot
2. **ModernHourlyChart**: 24-hour breakdown with stats
3. **Comparison Cards** (if data available):
   - Revenue: Current vs Previous Day
   - Orders: Current vs Previous Day
4. **Insights Panel**: Single-day insights

**Purpose**: Deep dive into hourly performance

### Multi-Day View (Last 7 Days, Month, etc.)

**When**: `selectedEndDate - selectedStartDate > 0 days`

**Shows**:
1. **Mode Indicator**: "Multi-Day Analysis (30 days)"
2. **ModernDailyTrendChart**: Daily revenue trend line
3. **ModernHourlyChart** (Average): Average hourly pattern across all days
4. **Comparison Cards** (if data available):
   - Total Revenue: Current vs Previous Period
   - Total Orders: Current vs Previous Period
5. **Daily Average Card**: 
   - Daily Avg Revenue
   - Daily Avg Orders
   - Avg Order Value
6. **Insights Panel**: Multi-day insights

**Purpose**: Identify trends, patterns, and period-level performance

## Data Flow

```
sales_summary_provider.dart
  ↓
  Fetches from SalesRepository (Mock or MongoDB)
  ↓
SalesSummaryModel
  ├─ hourlySalesPointsSelectedDay: List<HourlySalesPoint>
  ├─ totalSales: double
  ├─ totalOrders: int
  └─ (dailyData calculated if multi-day)
  ↓
sales_summary_content_v2.dart
  ├─ _buildSimpleHourlyChart()
  └─ Passes data to SalesSummaryChartsSection
      ↓
SalesSummaryChartsSection
  ├─ Determines single-day vs multi-day
  ├─ _buildSingleDayView() → ModernHourlyChart
  └─ _buildMultiDayView() → ModernDailyTrendChart + ModernHourlyChart (avg)
```

## Integration Points

### Adding to Sales Summary Page

The modern charts are already integrated via `sales_summary_content_v2.dart`:

```dart
// In _buildSimpleHourlyChart method
return SalesSummaryChartsSection(
  selectedStartDate: startDate,
  selectedEndDate: endDate,
  hourlySalesData: data.hourlySalesPointsSelectedDay,
  dailyData: dailyData, // For multi-day
  totalRevenue: data.totalSales,
  totalOrders: data.totalOrders,
  previousPeriodRevenue: null, // TODO: Add comparison data
  previousPeriodOrders: null,
);
```

### Adding Comparison Data

To enable comparison features:

1. **Update Provider**: Fetch previous period data
```dart
// In sales_summary_provider.dart
Future<void> fetchWithComparison() async {
  final summary = await _repository.getSalesSummary(...);
  final previousSummary = await _repository.getSalesSummary(
    previousStartDate, previousEndDate
  );
  // Store both in state
}
```

2. **Pass to Charts**:
```dart
SalesSummaryChartsSection(
  ...,
  previousPeriodRevenue: previousData.totalRevenue,
  previousPeriodOrders: previousData.totalOrders,
)
```

## Customization

### Colors

All colors defined in `app_colors.dart`:
- Primary: `AppColors.blue` (#007AFF)
- Text: `AppColors.black`, `AppColors.gray800`, `AppColors.gray600`
- Backgrounds: `AppColors.white`, `AppColors.gray50`
- Borders: `AppColors.gray200`

### Spacing

All spacing from `app_spacing.dart`:
- `AppSpacing.sm` (8px)
- `AppSpacing.md` (16px)
- `AppSpacing.lg` (24px)
- `AppSpacing.xl` (32px)

### Chart Heights

Configurable via parameters:
- **Hourly Chart**: `maxHeight: 280` (default)
- **Daily Trend**: `maxHeight: 280` (default)
- Adjust as needed for your layout

## Future Enhancements

### Phase 1 (Current) ✓
- [x] Single-day hourly breakdown
- [x] Multi-day daily trend
- [x] Average hourly pattern for multi-day
- [x] Comparison cards
- [x] Insight generation
- [x] Smart chart selection

### Phase 2 (Planned)
- [ ] Real-time WebSocket updates for Today view
- [ ] Interactive time range selection (brush tool)
- [ ] Export chart as PNG
- [ ] Day-of-week heatmap
- [ ] Product category breakdown chart
- [ ] Payment method over time
- [ ] Kiosk performance comparison

### Phase 3 (Advanced)
- [ ] AI-powered anomaly detection
- [ ] Predictive analytics
- [ ] Goal tracking overlays
- [ ] Custom alert thresholds
- [ ] Drill-down to transaction details

## Performance Considerations

- **RepaintBoundary**: Used to isolate chart repaints
- **CustomPainter**: For smooth rendering of complex charts
- **Lazy Loading**: Only generate insights when needed
- **Memoization**: Cache calculated stats to avoid recomputation

## Testing Recommendations

### Single-Day Testing
1. Select "Today" → Should show live hourly chart with current hour highlighted
2. Select "Yesterday" → Should show historical hourly data
3. Check that peak hour is correctly identified
4. Verify business hours percentage calculation

### Multi-Day Testing
1. Select "Last 7 Days" → Should show daily trend line with 7 points
2. Select "Last 30 Days" → Should show smoothed trend
3. Check average hourly pattern makes sense
4. Verify daily average calculations
5. Test with comparison data (previous period)

### Edge Cases
- Empty data (no sales)
- Single transaction
- Very high sales day (chart scaling)
- Period with no data for some days

## Browser Testing

Tested on:
- [x] Chrome/Edge (Chromium)
- [x] Firefox
- [x] Safari

**Recommended**: Chrome or Edge for best performance

## Support

For questions or issues:
- Check console for error messages
- Verify mock data is loading: `MockSalesRepository.initialize()`
- Ensure date ranges are valid
- Check that hourly data has all 24 hours (0-23)

---

**Built with**: Flutter 3.32.5 | ❤️
