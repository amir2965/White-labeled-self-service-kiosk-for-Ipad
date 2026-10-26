import 'dart:convert';
import 'package:uuid/uuid.dart';
import 'api_datasource.dart';
import '../../domain/entities/merchant.dart';
import '../../domain/entities/product.dart';
import '../../domain/entities/modifier.dart';
import '../../domain/entities/order.dart';
import '../../domain/entities/payment_session.dart';
import '../../domain/entities/kiosk_template.dart';

/// Mock data source for offline demo mode
class MockApiDataSource implements ApiDataSource {
  final _uuid = Uuid();
  final Map<String, Merchant> _merchants = {};
  final Map<String, List<Category>> _categories = {};
  final Map<String, List<Product>> _products = {};
  final Map<String, Order> _orders = {};
  final Map<String, PaymentSession> _paymentSessions = {};

  @override
  Future<Merchant> createMerchant(Map<String, dynamic> data) async {
    await Future.delayed(Duration(milliseconds: 300));

    final merchant = Merchant(
      id: _uuid.v4(),
      businessName: data['businessName'] as String,
      abn: data['abn'] as String?,
      contactEmail: data['contactEmail'] as String,
      businessType: BusinessType.values.firstWhere(
        (e) => e.name == data['businessType'],
        orElse: () => BusinessType.cafe,
      ),
      createdAt: DateTime.now(),
      isActive: true,
      paymentConfig: data['paymentConfig'] != null
          ? PaymentConfig.fromJson(data['paymentConfig'])
          : PaymentConfig(payAtCounterEnabled: true, qrPayEnabled: true),
    );

    _merchants[merchant.id] = merchant;
    return merchant;
  }

  @override
  Future<Merchant> getMerchant(String id) async {
    await Future.delayed(Duration(milliseconds: 100));
    return _merchants[id]!;
  }

  @override
  Future<Merchant> updateMerchant(String id, Map<String, dynamic> data) async {
    await Future.delayed(Duration(milliseconds: 200));
    final existing = _merchants[id]!;
    final updated = Merchant(
      id: existing.id,
      businessName: data['businessName'] ?? existing.businessName,
      abn: data['abn'] ?? existing.abn,
      contactEmail: data['contactEmail'] ?? existing.contactEmail,
      businessType: data['businessType'] != null
          ? BusinessType.values.firstWhere(
              (e) => e.name == data['businessType'],
            )
          : existing.businessType,
      createdAt: existing.createdAt,
      isActive: data['isActive'] ?? existing.isActive,
      paymentConfig: data['paymentConfig'] != null
          ? PaymentConfig.fromJson(data['paymentConfig'])
          : existing.paymentConfig,
    );
    _merchants[id] = updated;
    return updated;
  }

  @override
  Future<List<Category>> getCategories(String merchantId) async {
    await Future.delayed(Duration(milliseconds: 100));
    return _categories[merchantId] ?? [];
  }

  @override
  Future<List<Product>> getProducts(
    String merchantId, {
    String? categoryId,
  }) async {
    await Future.delayed(Duration(milliseconds: 150));
    final allProducts = _products[merchantId] ?? [];
    if (categoryId != null) {
      return allProducts.where((p) => p.categoryId == categoryId).toList();
    }
    return allProducts;
  }

  @override
  Future<Product> createProduct(
    String merchantId,
    Map<String, dynamic> data,
  ) async {
    await Future.delayed(Duration(milliseconds: 200));
    final product = Product.fromJson({...data, 'id': _uuid.v4()});

    if (!_products.containsKey(merchantId)) {
      _products[merchantId] = [];
    }
    _products[merchantId]!.add(product);
    return product;
  }

  @override
  Future<void> importProducts(
    String merchantId,
    List<Map<String, dynamic>> products,
  ) async {
    await Future.delayed(Duration(milliseconds: 500));
    for (var data in products) {
      await createProduct(merchantId, data);
    }
  }

  @override
  Future<Order> createOrder(Map<String, dynamic> data) async {
    await Future.delayed(Duration(milliseconds: 200));
    final order = Order.fromJson({...data, 'id': _uuid.v4()});
    _orders[order.id] = order;
    return order;
  }

  @override
  Future<Order> getOrder(String id) async {
    await Future.delayed(Duration(milliseconds: 100));
    return _orders[id]!;
  }

  @override
  Future<Order> updateOrderStatus(String id, OrderStatus status) async {
    await Future.delayed(Duration(milliseconds: 150));
    final existing = _orders[id]!;
    final updated = Order(
      id: existing.id,
      merchantId: existing.merchantId,
      deviceId: existing.deviceId,
      items: existing.items,
      subtotal: existing.subtotal,
      serviceFee: existing.serviceFee,
      total: existing.total,
      status: status,
      paymentMethod: existing.paymentMethod,
      paymentSessionId: existing.paymentSessionId,
      notes: existing.notes,
      createdAt: existing.createdAt,
      completedAt: status == OrderStatus.completed ? DateTime.now() : null,
    );
    _orders[id] = updated;
    return updated;
  }

  @override
  Future<void> markOrderPaid(String orderId) async {
    await updateOrderStatus(orderId, OrderStatus.completed);
  }

  @override
  Future<PaymentSession> createPaymentSession(Map<String, dynamic> data) async {
    await Future.delayed(Duration(milliseconds: 200));
    final session = PaymentSession(
      id: _uuid.v4(),
      orderId: data['orderId'] as String,
      merchantId: data['merchantId'] as String,
      amountItems: (data['amountItems'] as num).toDouble(),
      feeAmount: (data['feeAmount'] as num).toDouble(),
      amountTotal: (data['amountTotal'] as num).toDouble(),
      status: PaymentSessionStatus.created,
      createdAt: DateTime.now(),
      expiresAt: DateTime.now().add(Duration(minutes: 15)),
    );
    _paymentSessions[session.id] = session;
    return session;
  }

  @override
  Future<PaymentSession> getPaymentSession(String id) async {
    await Future.delayed(Duration(milliseconds: 100));
    return _paymentSessions[id]!;
  }

  @override
  Future<PaymentSession> updatePaymentSessionStatus(
    String id,
    PaymentSessionStatus status,
  ) async {
    await Future.delayed(Duration(milliseconds: 150));
    final existing = _paymentSessions[id]!;
    final updated = PaymentSession(
      id: existing.id,
      orderId: existing.orderId,
      merchantId: existing.merchantId,
      amountItems: existing.amountItems,
      feeAmount: existing.feeAmount,
      amountTotal: existing.amountTotal,
      status: status,
      createdAt: existing.createdAt,
      expiresAt: existing.expiresAt,
      paidAt: status == PaymentSessionStatus.paid ? DateTime.now() : null,
      paymentIntentId: existing.paymentIntentId,
      metadata: existing.metadata,
    );
    _paymentSessions[id] = updated;
    return updated;
  }

  @override
  Future<List<KioskTemplate>> getTemplates() async {
    await Future.delayed(Duration(milliseconds: 200));
    return _getDefaultTemplates();
  }

  @override
  Future<KioskTemplate> getTemplate(String id) async {
    await Future.delayed(Duration(milliseconds: 100));
    return _getDefaultTemplates().firstWhere((t) => t.id == id);
  }

  @override
  Future<KioskTemplate> saveCustomTemplate(Map<String, dynamic> data) async {
    await Future.delayed(Duration(milliseconds: 200));
    return KioskTemplate.fromJson({
      ...data,
      'id': _uuid.v4(),
      'isCustom': true,
    });
  }

  @override
  Future<void> sendPaymentWebhook(
    String sessionId,
    Map<String, dynamic> data,
  ) async {
    await Future.delayed(Duration(milliseconds: 100));
    // Mock webhook - in real app, this would notify the kiosk
  }

  List<KioskTemplate> _getDefaultTemplates() {
    return [
      KioskTemplate(
        id: 'minimal-grid',
        name: 'Minimal Grid',
        description: 'Clean grid layout with focus on product images',
        style: TemplateStyle.minimalGrid,
        layoutConfig: LayoutConfig(
          categoryStyle: CategoryStyle.tabs,
          productCardStyle: ProductCardStyle.imageHeavy,
        ),
      ),
      KioskTemplate(
        id: 'big-tiles',
        name: 'Big Tiles',
        description: 'Large, bold product tiles for easy selection',
        style: TemplateStyle.bigTiles,
        layoutConfig: LayoutConfig(
          categoryStyle: CategoryStyle.grid,
          productCardStyle: ProductCardStyle.imageHeavy,
          fontScale: FontScale.large,
        ),
      ),
      KioskTemplate(
        id: 'coffee-menu',
        name: 'Coffee Menu',
        description: 'Optimized for coffee shops and cafes',
        style: TemplateStyle.coffeeMenu,
        layoutConfig: LayoutConfig(
          showHeroSection: true,
          categoryStyle: CategoryStyle.tabs,
          productCardStyle: ProductCardStyle.compact,
        ),
      ),
    ];
  }

  // Helper method to seed demo data
  void seedDemoData(String merchantId, BusinessType type) {
    if (type == BusinessType.cafe) {
      _seedCafeData(merchantId);
    } else if (type == BusinessType.restaurant) {
      _seedRestaurantData(merchantId);
    }
  }

  void _seedCafeData(String merchantId) {
    // Categories
    _categories[merchantId] = [
      Category(id: 'cat-coffee', name: 'Coffee', sortOrder: 0),
      Category(id: 'cat-tea', name: 'Tea', sortOrder: 1),
      Category(id: 'cat-food', name: 'Food', sortOrder: 2),
    ];

    // Products
    _products[merchantId] = [
      Product(
        id: 'prod-1',
        name: 'Latte',
        description: 'Espresso with steamed milk',
        price: 4.50,
        categoryId: 'cat-coffee',
        modifierGroups: [
          ModifierGroup(
            id: 'mg-size',
            name: 'Size',
            isRequired: true,
            modifiers: [
              Modifier(id: 'mod-small', name: 'Small', priceAdjustment: -0.50),
              Modifier(id: 'mod-medium', name: 'Medium', priceAdjustment: 0.0),
              Modifier(id: 'mod-large', name: 'Large', priceAdjustment: 0.50),
            ],
          ),
        ],
      ),
      Product(
        id: 'prod-2',
        name: 'Cappuccino',
        description: 'Espresso with foamed milk',
        price: 4.50,
        categoryId: 'cat-coffee',
      ),
    ];
  }

  void _seedRestaurantData(String merchantId) {
    _categories[merchantId] = [
      Category(id: 'cat-appetizers', name: 'Appetizers', sortOrder: 0),
      Category(id: 'cat-mains', name: 'Main Courses', sortOrder: 1),
      Category(id: 'cat-desserts', name: 'Desserts', sortOrder: 2),
    ];

    _products[merchantId] = [
      Product(
        id: 'prod-1',
        name: 'Caesar Salad',
        description: 'Fresh romaine with parmesan',
        price: 12.00,
        categoryId: 'cat-appetizers',
      ),
    ];
  }
}
