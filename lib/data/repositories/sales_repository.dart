import '../datasources/mock_sales_data_generator.dart';

/// Sales Repository Interface
/// Ready for MongoDB implementation
abstract class SalesRepository {
  /// Save a single sales transaction
  Future<void> saveTransaction(SalesTransaction transaction);

  /// Save multiple transactions (batch)
  Future<void> saveTransactionsBatch(List<SalesTransaction> transactions);

  /// Get transactions for a date range
  Future<List<SalesTransaction>> getTransactions({
    required String merchantId,
    required DateTime startDate,
    required DateTime endDate,
    String? kioskId,
  });

  /// Get transactions for a specific day
  Future<List<SalesTransaction>> getTransactionsForDay({
    required String merchantId,
    required DateTime date,
    String? kioskId,
  });

  /// Get aggregated sales summary for date range
  Future<Map<String, dynamic>> getSalesSummary({
    required String merchantId,
    required DateTime startDate,
    required DateTime endDate,
    String? kioskId,
  });
}

/// MongoDB Repository Implementation
/// Uses MongoDB queries and aggregations
class MongoSalesRepository implements SalesRepository {
  // TODO: Inject MongoDB client
  // final MongoDatabase _database;

  // MongoSalesRepository(this._database);

  @override
  Future<void> saveTransaction(SalesTransaction transaction) async {
    // MongoDB implementation:
    // await _database.collection('sales_transactions').insertOne(
    //   transaction.toMongoDocument(),
    // );

    print('💾 MongoDB: Saving transaction ${transaction.id}');
    throw UnimplementedError('MongoDB not connected yet');
  }

  @override
  Future<void> saveTransactionsBatch(
    List<SalesTransaction> transactions,
  ) async {
    // MongoDB implementation:
    // final documents = transactions.map((t) => t.toMongoDocument()).toList();
    // await _database.collection('sales_transactions').insertMany(documents);

    print('💾 MongoDB: Batch saving ${transactions.length} transactions');
    throw UnimplementedError('MongoDB not connected yet');
  }

  @override
  Future<List<SalesTransaction>> getTransactions({
    required String merchantId,
    required DateTime startDate,
    required DateTime endDate,
    String? kioskId,
  }) async {
    // MongoDB implementation:
    // final query = {
    //   'merchantId': merchantId,
    //   'timestamp': {
    //     '\$gte': startDate.toIso8601String(),
    //     '\$lte': endDate.toIso8601String(),
    //   },
    // };
    // if (kioskId != null) {
    //   query['kioskId'] = kioskId;
    // }
    //
    // final cursor = _database.collection('sales_transactions').find(query);
    // final documents = await cursor.toList();
    // return documents.map((doc) => SalesTransaction.fromMongoDocument(doc)).toList();

    print('🔍 MongoDB: Querying transactions from $startDate to $endDate');
    throw UnimplementedError('MongoDB not connected yet');
  }

  @override
  Future<List<SalesTransaction>> getTransactionsForDay({
    required String merchantId,
    required DateTime date,
    String? kioskId,
  }) async {
    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));

    return getTransactions(
      merchantId: merchantId,
      startDate: startOfDay,
      endDate: endOfDay,
      kioskId: kioskId,
    );
  }

  @override
  Future<Map<String, dynamic>> getSalesSummary({
    required String merchantId,
    required DateTime startDate,
    required DateTime endDate,
    String? kioskId,
  }) async {
    // MongoDB Aggregation Pipeline:
    // final pipeline = [
    //   {
    //     '\$match': {
    //       'merchantId': merchantId,
    //       'status': 'completed',
    //       'timestamp': {
    //         '\$gte': startDate.toIso8601String(),
    //         '\$lte': endDate.toIso8601String(),
    //       },
    //       if (kioskId != null) 'kioskId': kioskId,
    //     }
    //   },
    //   {
    //     '\$group': {
    //       '_id': null,
    //       'totalRevenue': {'\$sum': '\$total'},
    //       'totalSubtotal': {'\$sum': '\$subtotal'},
    //       'totalTax': {'\$sum': '\$tax'},
    //       'totalServiceFee': {'\$sum': '\$serviceFee'},
    //       'transactionCount': {'\$sum': 1},
    //       'qrCodeRevenue': {
    //         '\$sum': {
    //           '\$cond': [{'\$eq': ['\$paymentMethod', 'qrCode']}, '\$total', 0]
    //         }
    //       },
    //       'counterRevenue': {
    //         '\$sum': {
    //           '\$cond': [{'\$eq': ['\$paymentMethod', 'payAtCounter']}, '\$total', 0]
    //         }
    //       },
    //     }
    //   },
    // ];
    //
    // final result = await _database.collection('sales_transactions')
    //   .aggregateToStream(pipeline).toList();

    print('📊 MongoDB: Aggregating sales summary');
    throw UnimplementedError('MongoDB not connected yet');
  }
}

/// Mock Repository Implementation (for development/testing)
/// Uses in-memory data with 2 years of mock sales
class MockSalesRepository implements SalesRepository {
  // In-memory storage of mock data
  static List<SalesTransaction>? _cachedTransactions;
  static final String _defaultMerchantId = 'merchant_001';
  static final String _defaultKioskId = 'kiosk_001';

  /// Initialize mock data (generate 2 years on first call)
  static void initialize() {
    if (_cachedTransactions == null) {
      print('🎯 Initializing mock sales data (2 years)...');
      final startTime = DateTime.now();

      _cachedTransactions = MockSalesDataGenerator.generate2YearsOfData(
        merchantId: _defaultMerchantId,
        kioskId: _defaultKioskId,
      );

      final duration = DateTime.now().difference(startTime);
      print(
        '✅ Generated ${_cachedTransactions!.length} transactions in ${duration.inMilliseconds}ms',
      );
    }
  }

  @override
  Future<void> saveTransaction(SalesTransaction transaction) async {
    initialize();
    _cachedTransactions!.add(transaction);
    print('💾 Mock: Saved transaction ${transaction.id}');
  }

  @override
  Future<void> saveTransactionsBatch(
    List<SalesTransaction> transactions,
  ) async {
    initialize();
    _cachedTransactions!.addAll(transactions);
    print('💾 Mock: Batch saved ${transactions.length} transactions');
  }

  @override
  Future<List<SalesTransaction>> getTransactions({
    required String merchantId,
    required DateTime startDate,
    required DateTime endDate,
    String? kioskId,
  }) async {
    initialize();

    final filtered = _cachedTransactions!.where((transaction) {
      final matchesMerchant = transaction.merchantId == merchantId;
      final matchesKiosk = kioskId == null || transaction.kioskId == kioskId;
      final matchesDate =
          transaction.timestamp.isAfter(
            startDate.subtract(const Duration(seconds: 1)),
          ) &&
          transaction.timestamp.isBefore(endDate.add(const Duration(days: 1)));

      return matchesMerchant && matchesKiosk && matchesDate;
    }).toList();

    print(
      '🔍 Mock: Found ${filtered.length} transactions from $startDate to $endDate',
    );
    return filtered;
  }

  @override
  Future<List<SalesTransaction>> getTransactionsForDay({
    required String merchantId,
    required DateTime date,
    String? kioskId,
  }) async {
    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));

    return getTransactions(
      merchantId: merchantId,
      startDate: startOfDay,
      endDate: endOfDay,
      kioskId: kioskId,
    );
  }

  @override
  Future<Map<String, dynamic>> getSalesSummary({
    required String merchantId,
    required DateTime startDate,
    required DateTime endDate,
    String? kioskId,
  }) async {
    final transactions = await getTransactions(
      merchantId: merchantId,
      startDate: startDate,
      endDate: endDate,
      kioskId: kioskId,
    );

    if (transactions.isEmpty) {
      return {
        'totalRevenue': 0.0,
        'totalSubtotal': 0.0,
        'totalTax': 0.0,
        'totalServiceFee': 0.0,
        'transactionCount': 0,
        'averageOrderValue': 0.0,
        'qrCodeRevenue': 0.0,
        'counterRevenue': 0.0,
        'qrCodeCount': 0,
        'counterCount': 0,
        'hourlyBreakdown': {},
        'dailyBreakdown': {},
      };
    }

    double totalRevenue = 0.0;
    double totalSubtotal = 0.0;
    double totalTax = 0.0;
    double totalServiceFee = 0.0;
    double qrCodeRevenue = 0.0;
    double counterRevenue = 0.0;
    int qrCodeCount = 0;
    int counterCount = 0;

    for (final transaction in transactions) {
      totalRevenue += transaction.total;
      totalSubtotal += transaction.subtotal;
      totalTax += transaction.tax;
      totalServiceFee += transaction.serviceFee;

      if (transaction.paymentMethod == 'qrCode') {
        qrCodeRevenue += transaction.total;
        qrCodeCount++;
      } else if (transaction.paymentMethod == 'payAtCounter') {
        counterRevenue += transaction.total;
        counterCount++;
      }
    }

    final averageOrderValue = transactions.isNotEmpty
        ? totalRevenue / transactions.length
        : 0.0;

    // Aggregate hourly data
    final hourlyBreakdown = MockSalesDataGenerator.aggregateByHour(
      transactions,
    );

    // Aggregate daily data
    final dailyBreakdown = MockSalesDataGenerator.aggregateByDay(transactions);

    return {
      'totalRevenue': totalRevenue,
      'totalSubtotal': totalSubtotal,
      'totalTax': totalTax,
      'totalServiceFee': totalServiceFee,
      'transactionCount': transactions.length,
      'averageOrderValue': averageOrderValue,
      'qrCodeRevenue': qrCodeRevenue,
      'counterRevenue': counterRevenue,
      'qrCodeCount': qrCodeCount,
      'counterCount': counterCount,
      'hourlyBreakdown': hourlyBreakdown,
      'dailyBreakdown': dailyBreakdown,
    };
  }

  /// Clear cache (for testing)
  static void clearCache() {
    _cachedTransactions = null;
  }
}
