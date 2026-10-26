import 'dart:math';
import '../../domain/entities/order.dart';

/// MongoDB-compatible Sales Transaction Model
/// Ready for MongoDB with ObjectId support
class SalesTransaction {
  final String id; // MongoDB ObjectId as string
  final String merchantId;
  final String? kioskId;
  final DateTime timestamp;
  final List<TransactionItem> items;
  final double subtotal;
  final double tax;
  final double serviceFee;
  final double total;
  final String paymentMethod; // 'qrCode', 'payAtCounter', 'cash', 'card'
  final String status; // 'completed', 'pending', 'cancelled'
  final Map<String, dynamic> metadata;

  SalesTransaction({
    required this.id,
    required this.merchantId,
    this.kioskId,
    required this.timestamp,
    required this.items,
    required this.subtotal,
    required this.tax,
    required this.serviceFee,
    required this.total,
    required this.paymentMethod,
    required this.status,
    Map<String, dynamic>? metadata,
  }) : metadata = metadata ?? {};

  /// Convert to MongoDB document
  Map<String, dynamic> toMongoDocument() {
    return {
      '_id': id, // MongoDB ObjectId
      'merchantId': merchantId,
      'kioskId': kioskId,
      'timestamp': timestamp.toIso8601String(),
      'date': timestamp.toIso8601String().split('T')[0], // For indexing
      'hour': timestamp.hour,
      'dayOfWeek': timestamp.weekday,
      'items': items.map((item) => item.toJson()).toList(),
      'subtotal': subtotal,
      'tax': tax,
      'serviceFee': serviceFee,
      'total': total,
      'paymentMethod': paymentMethod,
      'status': status,
      'metadata': metadata,
      'createdAt': timestamp.toIso8601String(),
      'updatedAt': timestamp.toIso8601String(),
    };
  }

  /// Create from MongoDB document
  factory SalesTransaction.fromMongoDocument(Map<String, dynamic> doc) {
    return SalesTransaction(
      id: doc['_id'] as String,
      merchantId: doc['merchantId'] as String,
      kioskId: doc['kioskId'] as String?,
      timestamp: DateTime.parse(doc['timestamp'] as String),
      items: (doc['items'] as List)
          .map((item) => TransactionItem.fromJson(item as Map<String, dynamic>))
          .toList(),
      subtotal: (doc['subtotal'] as num).toDouble(),
      tax: (doc['tax'] as num).toDouble(),
      serviceFee: (doc['serviceFee'] as num).toDouble(),
      total: (doc['total'] as num).toDouble(),
      paymentMethod: doc['paymentMethod'] as String,
      status: doc['status'] as String,
      metadata: doc['metadata'] as Map<String, dynamic>? ?? {},
    );
  }

  /// Convert Order to SalesTransaction (for saving kiosk orders)
  factory SalesTransaction.fromOrder(Order order, String merchantId) {
    final tax = order.total - order.subtotal - order.serviceFee;

    return SalesTransaction(
      id: order.id,
      merchantId: merchantId,
      kioskId: order.deviceId,
      timestamp: order.completedAt ?? order.createdAt,
      items: order.items
          .map((item) => TransactionItem.fromOrderItem(item))
          .toList(),
      subtotal: order.subtotal,
      tax: tax,
      serviceFee: order.serviceFee,
      total: order.total,
      paymentMethod: _paymentMethodToString(order.paymentMethod),
      status: _orderStatusToString(order.status),
      metadata: {
        'orderNotes': order.notes,
        'paymentSessionId': order.paymentSessionId,
      },
    );
  }

  static String _paymentMethodToString(PaymentMethod method) {
    switch (method) {
      case PaymentMethod.qrCode:
        return 'qrCode';
      case PaymentMethod.payAtCounter:
        return 'payAtCounter';
      case PaymentMethod.cash:
        return 'cash';
      case PaymentMethod.card:
        return 'card';
    }
  }

  static String _orderStatusToString(OrderStatus status) {
    switch (status) {
      case OrderStatus.completed:
        return 'completed';
      case OrderStatus.pending:
        return 'pending';
      case OrderStatus.cancelled:
        return 'cancelled';
      default:
        return 'draft';
    }
  }
}

class TransactionItem {
  final String productId;
  final String productName;
  final String category;
  final int quantity;
  final double unitPrice;
  final double totalPrice;

  TransactionItem({
    required this.productId,
    required this.productName,
    required this.category,
    required this.quantity,
    required this.unitPrice,
    required this.totalPrice,
  });

  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'productName': productName,
      'category': category,
      'quantity': quantity,
      'unitPrice': unitPrice,
      'totalPrice': totalPrice,
    };
  }

  factory TransactionItem.fromJson(Map<String, dynamic> json) {
    return TransactionItem(
      productId: json['productId'] as String,
      productName: json['productName'] as String,
      category: json['category'] as String,
      quantity: json['quantity'] as int,
      unitPrice: (json['unitPrice'] as num).toDouble(),
      totalPrice: (json['totalPrice'] as num).toDouble(),
    );
  }

  factory TransactionItem.fromOrderItem(OrderItem item) {
    return TransactionItem(
      productId: item.product.id,
      productName: item.product.name,
      category: item.product.categoryId, // Use categoryId field
      quantity: item.quantity,
      unitPrice: item.unitPrice,
      totalPrice: item.totalPrice,
    );
  }
}

/// Mock Sales Data Generator for 2 Years
/// Generates realistic sales patterns with:
/// - Seasonal trends
/// - Day of week patterns
/// - Hourly patterns (breakfast, lunch, dinner peaks)
/// - Random variations
class MockSalesDataGenerator {
  static final Random _random = Random();

  // Sample products for mock data
  static final List<Map<String, dynamic>> _products = [
    {
      'id': 'prod_001',
      'name': 'Cappuccino',
      'category': 'Coffee',
      'price': 4.50,
    },
    {'id': 'prod_002', 'name': 'Latte', 'category': 'Coffee', 'price': 4.50},
    {'id': 'prod_003', 'name': 'Espresso', 'category': 'Coffee', 'price': 3.00},
    {
      'id': 'prod_004',
      'name': 'Croissant',
      'category': 'Pastry',
      'price': 4.00,
    },
    {'id': 'prod_005', 'name': 'Muffin', 'category': 'Pastry', 'price': 3.50},
    {
      'id': 'prod_006',
      'name': 'Avocado Toast',
      'category': 'Food',
      'price': 11.00,
    },
    {
      'id': 'prod_007',
      'name': 'Bagel with Cream Cheese',
      'category': 'Food',
      'price': 5.50,
    },
    {
      'id': 'prod_008',
      'name': 'Caesar Salad',
      'category': 'Food',
      'price': 12.00,
    },
    {
      'id': 'prod_009',
      'name': 'Turkey Sandwich',
      'category': 'Food',
      'price': 10.00,
    },
    {
      'id': 'prod_010',
      'name': 'Smoothie',
      'category': 'Beverage',
      'price': 6.50,
    },
  ];

  /// Generate 2 years of mock sales data
  /// Returns list ready for MongoDB insertion
  static List<SalesTransaction> generate2YearsOfData({
    required String merchantId,
    String? kioskId,
  }) {
    final List<SalesTransaction> transactions = [];
    final now = DateTime.now();
    final twoYearsAgo = now.subtract(const Duration(days: 730));

    // Generate data day by day (including today)
    DateTime currentDate = twoYearsAgo;
    int transactionIdCounter = 1;

    while (!currentDate.isAfter(now)) {
      // Determine number of transactions for this day
      final transactionsToday = _getTransactionsForDay(currentDate);

      // Generate transactions throughout the day
      for (int i = 0; i < transactionsToday; i++) {
        final transaction = _generateTransaction(
          id: 'txn_${transactionIdCounter.toString().padLeft(8, '0')}',
          merchantId: merchantId,
          kioskId: kioskId,
          date: currentDate,
        );

        transactions.add(transaction);
        transactionIdCounter++;
      }

      currentDate = currentDate.add(const Duration(days: 1));
    }

    print('📊 Generated ${transactions.length} transactions over 2 years');
    return transactions;
  }

  /// Determine number of transactions based on day patterns
  static int _getTransactionsForDay(DateTime date) {
    // Base transactions per day
    int base = 50;

    // Weekend boost (20% more)
    if (date.weekday == DateTime.saturday || date.weekday == DateTime.sunday) {
      base = (base * 1.2).round();
    }

    // Seasonal patterns
    final month = date.month;
    double seasonalMultiplier = 1.0;

    // Summer boost (June-August)
    if (month >= 6 && month <= 8) {
      seasonalMultiplier = 1.3;
    }
    // Holiday season (November-December)
    else if (month >= 11) {
      seasonalMultiplier = 1.25;
    }
    // Slower winter (January-February)
    else if (month <= 2) {
      seasonalMultiplier = 0.85;
    }

    base = (base * seasonalMultiplier).round();

    // Add random variation (±20%)
    final variation = base * 0.2;
    base += (_random.nextDouble() * variation * 2 - variation).round();

    return base.clamp(20, 150);
  }

  /// Generate single transaction
  static SalesTransaction _generateTransaction({
    required String id,
    required String merchantId,
    String? kioskId,
    required DateTime date,
  }) {
    // Generate realistic timestamp during business hours
    final hour = _getRandomBusinessHour();
    final minute = _random.nextInt(60);
    final timestamp = DateTime(date.year, date.month, date.day, hour, minute);

    // Generate 1-4 items per transaction
    final itemCount = _random.nextInt(3) + 1;
    final items = <TransactionItem>[];
    double subtotal = 0.0;

    for (int i = 0; i < itemCount; i++) {
      final product = _products[_random.nextInt(_products.length)];
      final quantity = _random.nextInt(2) + 1; // 1-2 of each item
      final unitPrice = product['price'] as double;
      final totalPrice = unitPrice * quantity;

      items.add(
        TransactionItem(
          productId: product['id'] as String,
          productName: product['name'] as String,
          category: product['category'] as String,
          quantity: quantity,
          unitPrice: unitPrice,
          totalPrice: totalPrice,
        ),
      );

      subtotal += totalPrice;
    }

    // Calculate tax (10%) and service fee (2%)
    final tax = subtotal * 0.10;
    final serviceFee = subtotal * 0.02;
    final total = subtotal + tax + serviceFee;

    // Payment method distribution: 70% QR, 30% counter
    final paymentMethod = _random.nextDouble() < 0.7
        ? 'qrCode'
        : 'payAtCounter';

    return SalesTransaction(
      id: id,
      merchantId: merchantId,
      kioskId: kioskId,
      timestamp: timestamp,
      items: items,
      subtotal: subtotal,
      tax: tax,
      serviceFee: serviceFee,
      total: total,
      paymentMethod: paymentMethod,
      status: 'completed',
      metadata: {
        'generatedMock': true,
        'hour': hour,
        'dayOfWeek': date.weekday,
      },
    );
  }

  /// Get random business hour with realistic distribution
  static int _getRandomBusinessHour() {
    final rand = _random.nextDouble();

    // Breakfast rush (7-9 AM): 25%
    if (rand < 0.25) {
      return 7 + _random.nextInt(2);
    }
    // Lunch rush (11 AM - 2 PM): 35%
    else if (rand < 0.60) {
      return 11 + _random.nextInt(3);
    }
    // Afternoon (2-5 PM): 20%
    else if (rand < 0.80) {
      return 14 + _random.nextInt(3);
    }
    // Evening (5-8 PM): 15%
    else if (rand < 0.95) {
      return 17 + _random.nextInt(3);
    }
    // Other hours (6 AM, 10 AM, 9 PM): 5%
    else {
      final options = [6, 10, 21];
      return options[_random.nextInt(options.length)];
    }
  }

  /// Get transactions for specific date range (query simulation)
  static List<SalesTransaction> getTransactionsForDateRange(
    List<SalesTransaction> allTransactions,
    DateTime startDate,
    DateTime endDate,
  ) {
    return allTransactions.where((transaction) {
      return transaction.timestamp.isAfter(
            startDate.subtract(const Duration(seconds: 1)),
          ) &&
          transaction.timestamp.isBefore(endDate.add(const Duration(days: 1)));
    }).toList();
  }

  /// Aggregate transactions by hour (for charts)
  static Map<int, double> aggregateByHour(List<SalesTransaction> transactions) {
    final Map<int, double> hourlyData = {};

    for (int i = 0; i < 24; i++) {
      hourlyData[i] = 0.0;
    }

    for (final transaction in transactions) {
      final hour = transaction.timestamp.hour;
      hourlyData[hour] = (hourlyData[hour] ?? 0.0) + transaction.total;
    }

    return hourlyData;
  }

  /// Aggregate transactions by day (for multi-day charts)
  static Map<String, double> aggregateByDay(
    List<SalesTransaction> transactions,
  ) {
    final Map<String, double> dailyData = {};

    for (final transaction in transactions) {
      final dateKey = transaction.timestamp.toIso8601String().split('T')[0];
      dailyData[dateKey] = (dailyData[dateKey] ?? 0.0) + transaction.total;
    }

    return dailyData;
  }

  /// Calculate payment method breakdown
  static Map<String, dynamic> getPaymentBreakdown(
    List<SalesTransaction> transactions,
  ) {
    double qrTotal = 0.0;
    double counterTotal = 0.0;
    int qrCount = 0;
    int counterCount = 0;

    for (final transaction in transactions) {
      if (transaction.paymentMethod == 'qrCode') {
        qrTotal += transaction.total;
        qrCount++;
      } else if (transaction.paymentMethod == 'payAtCounter') {
        counterTotal += transaction.total;
        counterCount++;
      }
    }

    return {
      'qrTotal': qrTotal,
      'counterTotal': counterTotal,
      'qrCount': qrCount,
      'counterCount': counterCount,
    };
  }
}
