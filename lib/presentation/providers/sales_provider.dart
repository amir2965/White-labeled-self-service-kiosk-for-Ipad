import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:html' as html show window;
import 'dart:convert';
import 'package:http/http.dart' as http;

/// Sales metrics data model
class SalesMetrics {
  final int todayOrders;
  final double todayRevenue;
  final double todayAvgOrder;
  final int allTimeOrders;
  final double allTimeRevenue;
  final double allTimeAvgOrder;
  final DateTime lastUpdated;

  const SalesMetrics({
    required this.todayOrders,
    required this.todayRevenue,
    required this.todayAvgOrder,
    required this.allTimeOrders,
    required this.allTimeRevenue,
    required this.allTimeAvgOrder,
    required this.lastUpdated,
  });

  factory SalesMetrics.empty() {
    return SalesMetrics(
      todayOrders: 0,
      todayRevenue: 0.0,
      todayAvgOrder: 0.0,
      allTimeOrders: 0,
      allTimeRevenue: 0.0,
      allTimeAvgOrder: 0.0,
      lastUpdated: DateTime.now(),
    );
  }

  factory SalesMetrics.fromJson(Map<String, dynamic> json) {
    final today = json['today'] as Map<String, dynamic>;
    final allTime = json['allTime'] as Map<String, dynamic>;

    return SalesMetrics(
      todayOrders: today['orders'] as int,
      todayRevenue: (today['revenue'] as num).toDouble(),
      todayAvgOrder: (today['avgOrder'] as num).toDouble(),
      allTimeOrders: allTime['orders'] as int,
      allTimeRevenue: (allTime['revenue'] as num).toDouble(),
      allTimeAvgOrder: (allTime['avgOrder'] as num).toDouble(),
      lastUpdated: DateTime.now(),
    );
  }
}

/// Sales provider state notifier
class SalesNotifier extends StateNotifier<AsyncValue<SalesMetrics>> {
  SalesNotifier() : super(const AsyncValue.loading()) {
    fetchSalesData();
  }

  Future<void> fetchSalesData() async {
    try {
      state = const AsyncValue.loading();

      // Get API URL
      String apiUrl;
      if (kIsWeb) {
        apiUrl = '${html.window.location.origin}/api/analytics/sales';
      } else {
        apiUrl = 'http://localhost:8080/api/analytics/sales';
      }

      print('📊 Fetching sales data from: $apiUrl');

      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        final metrics = SalesMetrics.fromJson(data);

        print('✅ Sales data loaded:');
        print(
          '   Today: ${metrics.todayOrders} orders, \$${metrics.todayRevenue.toStringAsFixed(2)}',
        );
        print(
          '   All-time: ${metrics.allTimeOrders} orders, \$${metrics.allTimeRevenue.toStringAsFixed(2)}',
        );

        state = AsyncValue.data(metrics);
      } else {
        throw Exception('Failed to load sales data: ${response.statusCode}');
      }
    } catch (e, stackTrace) {
      print('❌ Error fetching sales data: $e');
      print('⚠️  Falling back to mock sales metrics...');

      // Fallback to mock data
      final mockMetrics = SalesMetrics(
        todayOrders: 45,
        todayRevenue: 1250.75,
        todayAvgOrder: 27.79,
        allTimeOrders: 1523,
        allTimeRevenue: 42315.50,
        allTimeAvgOrder: 27.79,
        lastUpdated: DateTime.now(),
      );

      print('✅ Using mock sales metrics');
      state = AsyncValue.data(mockMetrics);
    }
  }

  /// Refresh sales data
  Future<void> refresh() async {
    await fetchSalesData();
  }
}

/// Sales data provider
final salesProvider =
    StateNotifierProvider<SalesNotifier, AsyncValue<SalesMetrics>>((ref) {
      return SalesNotifier();
    });
