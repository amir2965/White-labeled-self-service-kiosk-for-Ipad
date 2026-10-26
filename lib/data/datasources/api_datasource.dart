import '../../domain/entities/merchant.dart';
import '../../domain/entities/product.dart';
import '../../domain/entities/order.dart';
import '../../domain/entities/payment_session.dart';
import '../../domain/entities/kiosk_template.dart';

/// API contract for backend communication
abstract class ApiDataSource {
  // Merchant
  Future<Merchant> createMerchant(Map<String, dynamic> data);
  Future<Merchant> getMerchant(String id);
  Future<Merchant> updateMerchant(String id, Map<String, dynamic> data);

  // Menu
  Future<List<Category>> getCategories(String merchantId);
  Future<List<Product>> getProducts(String merchantId, {String? categoryId});
  Future<Product> createProduct(String merchantId, Map<String, dynamic> data);
  Future<void> importProducts(
    String merchantId,
    List<Map<String, dynamic>> products,
  );

  // Orders
  Future<Order> createOrder(Map<String, dynamic> data);
  Future<Order> getOrder(String id);
  Future<Order> updateOrderStatus(String id, OrderStatus status);
  Future<void> markOrderPaid(String orderId);

  // Payment Sessions
  Future<PaymentSession> createPaymentSession(Map<String, dynamic> data);
  Future<PaymentSession> getPaymentSession(String id);
  Future<PaymentSession> updatePaymentSessionStatus(
    String id,
    PaymentSessionStatus status,
  );

  // Templates
  Future<List<KioskTemplate>> getTemplates();
  Future<KioskTemplate> getTemplate(String id);
  Future<KioskTemplate> saveCustomTemplate(Map<String, dynamic> data);

  // Webhooks
  Future<void> sendPaymentWebhook(String sessionId, Map<String, dynamic> data);
}
