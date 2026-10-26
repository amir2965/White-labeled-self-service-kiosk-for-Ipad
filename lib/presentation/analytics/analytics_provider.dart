import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:html' as html show window;
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'analytics_state.dart';

/// Analytics state provider
final analyticsProvider =
    StateNotifierProvider<AnalyticsNotifier, AnalyticsState>((ref) {
      return AnalyticsNotifier();
    });

class AnalyticsNotifier extends StateNotifier<AnalyticsState> {
  AnalyticsNotifier()
    : super(
        AnalyticsState(
          selectedDate: DateTime.now(),
          compareMode: CompareMode.priorDay,
          billStatus: BillStatus.closed,
          values: const AnalyticsValues(),
        ),
      ) {
    // Fetch data on initialization
    _fetchData();
  }

  /// Update selected date
  void setDate(DateTime date) {
    state = state.copyWith(selectedDate: date, isLoading: true);
    _fetchData();
  }

  /// Update compare mode
  void setCompareMode(CompareMode mode) {
    state = state.copyWith(compareMode: mode, isLoading: true);
    _fetchData();
  }

  /// Update bill status filter
  void setBillStatus(BillStatus status) {
    state = state.copyWith(billStatus: status, isLoading: true);
    _fetchData();
  }

  /// Fetch analytics data from real kiosk sales
  Future<void> _fetchData() async {
    try {
      // Get API URL
      String apiUrl;
      if (kIsWeb) {
        apiUrl = '${html.window.location.origin}/api/analytics/sales';
      } else {
        apiUrl = 'http://localhost:8080/api/analytics/sales';
      }

      print('📊 Analytics: Fetching sales data from: $apiUrl');

      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        final today = data['today'] as Map<String, dynamic>;
        final allTime = data['allTime'] as Map<String, dynamic>;

        final todayOrders = today['orders'] as int;
        final todayRevenue = (today['revenue'] as num).toDouble();
        final todayAvgOrder = (today['avgOrder'] as num).toDouble();

        print('✅ Analytics data loaded:');
        print(
          '   Today: $todayOrders orders, \$${todayRevenue.toStringAsFixed(2)}',
        );

        // Calculate metrics
        // Net sales = revenue (for now, assuming no returns/refunds)
        final netSales = todayRevenue;
        // Gross sales = same as net for kiosk (simplified)
        final grossSales = todayRevenue;
        // Transactions = order count
        final transactions = todayOrders;
        // Average sale = avg order value
        final avgSale = todayAvgOrder;

        // For demo: show simple comparison (can be enhanced later)
        final netSalesDelta = transactions > 0
            ? '+${transactions} today'
            : 'No sales';

        state = state.copyWith(
          values: AnalyticsValues(
            netSales: netSales,
            grossSales: grossSales,
            labourPercent: 0.0, // Not tracked yet
            compsDiscounts: 0.0, // Not tracked yet
            transactions: transactions,
            avgSale: avgSale,
            tips: 0.0, // Not tracked yet
            netSalesDelta: netSalesDelta,
            grossSalesDelta: netSalesDelta,
            labourPercentDelta: 'N/A',
            compsDiscountsDelta: 'N/A',
            transactionsDelta: '$transactions orders',
            avgSaleDelta: avgSale > 0
                ? '\$${avgSale.toStringAsFixed(2)}'
                : 'N/A',
            tipsDelta: 'N/A',
          ),
          chartPointsToday: [],
          chartPointsPreviousDay: [],
          isLoading: false,
        );
      } else {
        throw Exception('Failed to load analytics: ${response.statusCode}');
      }
    } catch (e, stackTrace) {
      print('❌ Analytics error: $e');
      print('Stack trace: $stackTrace');

      // On error, show empty state
      state = state.copyWith(
        values: const AnalyticsValues(
          netSales: 0.0,
          grossSales: 0.0,
          labourPercent: 0.0,
          compsDiscounts: 0.0,
          transactions: 0,
          avgSale: 0.0,
          tips: 0.0,
          netSalesDelta: 'Error loading data',
          grossSalesDelta: 'Error loading data',
          labourPercentDelta: 'N/A',
          compsDiscountsDelta: 'N/A',
          transactionsDelta: 'Error',
          avgSaleDelta: 'N/A',
          tipsDelta: 'N/A',
        ),
        chartPointsToday: [],
        chartPointsPreviousDay: [],
        isLoading: false,
      );
    }
  }

  /// Refresh data
  Future<void> refresh() async {
    state = state.copyWith(isLoading: true);
    await _fetchData();
  }
}
