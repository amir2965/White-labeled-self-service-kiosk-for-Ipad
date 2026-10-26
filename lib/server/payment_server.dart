import 'dart:convert';
import 'dart:io';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as io;
import 'package:shelf_router/shelf_router.dart';
import 'package:shelf_static/shelf_static.dart';

/// In-memory storage for orders (use database in production)
final Map<String, Map<String, dynamic>> _orderStorage = {};

/// Simple backend server to handle payment webhooks
/// Run with: dart run lib/server/payment_server.dart
void main() async {
  final app = Router();

  // CORS middleware
  final handler = Pipeline()
      .addMiddleware(_corsMiddleware())
      .addMiddleware(logRequests())
      .addHandler(_router());

  final server = await io.serve(handler, InternetAddress.anyIPv4, 8080);

  print(
    '✅ Payment server running on http://${server.address.host}:${server.port}',
  );
  print(
    '📱 Checkout URL: http://${server.address.host}:${server.port}/checkout.html',
  );
}

Middleware _corsMiddleware() {
  return (Handler handler) {
    return (Request request) async {
      if (request.method == 'OPTIONS') {
        return Response.ok('', headers: _corsHeaders);
      }

      final response = await handler(request);
      return response.change(headers: _corsHeaders);
    };
  };
}

final _corsHeaders = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Methods': 'GET, POST, PUT, DELETE, OPTIONS',
  'Access-Control-Allow-Headers': 'Origin, Content-Type, Accept',
};

Handler _router() {
  final app = Router();

  // Create order session - Store order data
  app.post('/api/orders', (Request request) async {
    try {
      final payload = await request.readAsString();
      final data = jsonDecode(payload) as Map<String, dynamic>;

      final orderId = data['orderId'] as String;

      // Helper to convert to double (handles both int and double)
      double toDouble(dynamic value) {
        if (value is double) return value;
        if (value is int) return value.toDouble();
        if (value is String) return double.parse(value);
        return 0.0;
      }

      final orderData = {
        'orderId': orderId,
        'items': data['items'] as List,
        'subtotal': toDouble(data['subtotal']),
        'serviceFee': toDouble(data['serviceFee']),
        'total': toDouble(data['total']),
        'status': 'pending',
        'createdAt': DateTime.now().toIso8601String(),
      };

      _orderStorage[orderId] = orderData;

      print('✅ Order stored: $orderId');
      print('   Items: ${(orderData['items'] as List).length}');
      print('   Total: \$${orderData['total']}');

      return Response.ok(
        jsonEncode({'success': true, 'orderId': orderId}),
        headers: {'Content-Type': 'application/json'},
      );
    } catch (e, stackTrace) {
      print('❌ Error creating order: $e');
      print('Stack trace: $stackTrace');
      return Response.internalServerError(
        body: jsonEncode({'error': e.toString()}),
        headers: {'Content-Type': 'application/json'},
      );
    }
  });

  // Get order data by ID
  app.get('/api/orders/<orderId>', (Request request, String orderId) {
    print('📥 Fetching order: $orderId');

    if (!_orderStorage.containsKey(orderId)) {
      print('❌ Order not found: $orderId');
      return Response.notFound(
        jsonEncode({'error': 'Order not found'}),
        headers: {'Content-Type': 'application/json'},
      );
    }

    final orderData = _orderStorage[orderId]!;
    print('✅ Order found: $orderId');

    return Response.ok(
      jsonEncode(orderData),
      headers: {'Content-Type': 'application/json'},
    );
  });

  // Update payment status
  app.post('/api/payment-sessions/<sessionId>/status', (
    Request request,
    String sessionId,
  ) async {
    try {
      final payload = await request.readAsString();
      final data = jsonDecode(payload);
      final status = data['status'];

      print('💳 Payment status update: $sessionId -> $status');

      // Update order status in storage
      if (_orderStorage.containsKey(sessionId)) {
        _orderStorage[sessionId]!['status'] = status;
        _orderStorage[sessionId]!['paidAt'] = DateTime.now().toIso8601String();
      }

      return Response.ok(
        jsonEncode({'success': true, 'sessionId': sessionId, 'status': status}),
        headers: {'Content-Type': 'application/json'},
      );
    } catch (e) {
      return Response.internalServerError(
        body: jsonEncode({'error': e.toString()}),
        headers: {'Content-Type': 'application/json'},
      );
    }
  });

  // Process payment (Apple Pay, Google Pay, Card)
  app.post('/api/payments/process', (Request request) async {
    try {
      final payload = await request.readAsString();
      final data = jsonDecode(payload) as Map<String, dynamic>;

      final orderId = data['orderId'] as String;
      final paymentMethod = data['paymentMethod'] as String;
      final amount = (data['amount'] as num).toDouble();
      final paymentToken = data['paymentToken'];

      print('💳 Processing payment:');
      print('   Order: $orderId');
      print('   Method: $paymentMethod');
      print('   Amount: \$$amount');

      // In production: Process payment with actual payment gateway
      // - For Apple Pay: Send paymentToken to payment processor
      // - For Google Pay: Send paymentToken to payment gateway
      // - For Card: Process tokenized card data

      // For demo: Simulate successful payment
      await Future.delayed(Duration(milliseconds: 500));

      // Update order status
      if (_orderStorage.containsKey(orderId)) {
        _orderStorage[orderId]!['status'] = 'paid';
        _orderStorage[orderId]!['paymentMethod'] = paymentMethod;
        _orderStorage[orderId]!['paidAt'] = DateTime.now().toIso8601String();
      }

      print('✅ Payment processed successfully');

      return Response.ok(
        jsonEncode({
          'success': true,
          'orderId': orderId,
          'status': 'paid',
          'transactionId': 'txn_${DateTime.now().millisecondsSinceEpoch}',
        }),
        headers: {'Content-Type': 'application/json'},
      );
    } catch (e, stackTrace) {
      print('❌ Payment processing failed: $e');
      print('Stack trace: $stackTrace');
      return Response.internalServerError(
        body: jsonEncode({
          'error': 'Payment processing failed',
          'message': e.toString(),
        }),
        headers: {'Content-Type': 'application/json'},
      );
    }
  });

  // Get payment session status
  app.get('/api/payment-sessions/<sessionId>', (
    Request request,
    String sessionId,
  ) {
    if (_orderStorage.containsKey(sessionId)) {
      final order = _orderStorage[sessionId]!;
      return Response.ok(
        jsonEncode({
          'id': sessionId,
          'status': order['status'],
          'orderId': sessionId,
          'amount': order['total'],
        }),
        headers: {'Content-Type': 'application/json'},
      );
    }

    return Response.notFound(
      jsonEncode({'error': 'Session not found'}),
      headers: {'Content-Type': 'application/json'},
    );
  });

  // Get sales analytics/metrics
  app.get('/api/analytics/sales', (Request request) {
    try {
      // Filter completed/paid orders
      final paidOrders = _orderStorage.values
          .where((order) => order['status'] == 'paid')
          .toList();

      // Calculate metrics
      final totalOrders = paidOrders.length;
      final totalRevenue = paidOrders.fold<double>(
        0.0,
        (sum, order) => sum + (order['total'] as num).toDouble(),
      );
      final avgOrderValue = totalOrders > 0 ? totalRevenue / totalOrders : 0.0;

      // Get today's orders only
      final now = DateTime.now();
      final todayStart = DateTime(now.year, now.month, now.day);

      final todayOrders = paidOrders.where((order) {
        final createdAt = DateTime.parse(order['createdAt'] as String);
        return createdAt.isAfter(todayStart);
      }).toList();

      final todayOrderCount = todayOrders.length;
      final todayRevenue = todayOrders.fold<double>(
        0.0,
        (sum, order) => sum + (order['total'] as num).toDouble(),
      );
      final todayAvgOrder = todayOrderCount > 0
          ? todayRevenue / todayOrderCount
          : 0.0;

      print('📊 Analytics requested:');
      print('   Today: $todayOrderCount orders, \$$todayRevenue revenue');
      print('   All-time: $totalOrders orders, \$$totalRevenue revenue');

      return Response.ok(
        jsonEncode({
          'today': {
            'orders': todayOrderCount,
            'revenue': todayRevenue,
            'avgOrder': todayAvgOrder,
          },
          'allTime': {
            'orders': totalOrders,
            'revenue': totalRevenue,
            'avgOrder': avgOrderValue,
          },
          'recentOrders': paidOrders.take(10).toList(),
        }),
        headers: {'Content-Type': 'application/json'},
      );
    } catch (e, stackTrace) {
      print('❌ Analytics error: $e');
      print('Stack trace: $stackTrace');
      return Response.internalServerError(
        body: jsonEncode({'error': e.toString()}),
        headers: {'Content-Type': 'application/json'},
      );
    }
  });

  // Serve web checkout static files
  final staticHandler = createStaticHandler(
    'build/web',
    defaultDocument: 'index.html',
  );

  return Cascade().add(app).add(staticHandler).handler;
}
