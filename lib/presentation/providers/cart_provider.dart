import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/product.dart';
import '../../domain/entities/order.dart';

/// Cart item with selected modifiers and quantity
class CartItem {
  final Product product;
  final List<SelectedModifier> modifiers;
  final int quantity;
  final String? notes;

  CartItem({
    required this.product,
    this.modifiers = const [],
    this.quantity = 1,
    this.notes,
  });

  double get totalPrice {
    double base = product.price * quantity;
    double modifierTotal = modifiers.fold(
      0.0,
      (sum, m) => sum + m.modifier.priceAdjustment,
    );
    return base + (modifierTotal * quantity);
  }

  CartItem copyWith({
    Product? product,
    List<SelectedModifier>? modifiers,
    int? quantity,
    String? notes,
  }) {
    return CartItem(
      product: product ?? this.product,
      modifiers: modifiers ?? this.modifiers,
      quantity: quantity ?? this.quantity,
      notes: notes ?? this.notes,
    );
  }
}

/// Cart state
class CartState {
  final List<CartItem> items;
  final double serviceFeePercentage;
  final double serviceFeeFixed;

  CartState({
    this.items = const [],
    this.serviceFeePercentage = 2.5,
    this.serviceFeeFixed = 0.30,
  });

  double get subtotal => items.fold(0.0, (sum, item) => sum + item.totalPrice);

  double get serviceFee {
    if (items.isEmpty) return 0.0;
    return (subtotal * serviceFeePercentage / 100) + serviceFeeFixed;
  }

  double get total => subtotal + serviceFee;

  int get itemCount => items.fold(0, (sum, item) => sum + item.quantity);

  CartState copyWith({
    List<CartItem>? items,
    double? serviceFeePercentage,
    double? serviceFeeFixed,
  }) {
    return CartState(
      items: items ?? this.items,
      serviceFeePercentage: serviceFeePercentage ?? this.serviceFeePercentage,
      serviceFeeFixed: serviceFeeFixed ?? this.serviceFeeFixed,
    );
  }
}

/// Cart notifier
class CartNotifier extends StateNotifier<CartState> {
  CartNotifier() : super(CartState());

  void addItem({
    required Product product,
    List<SelectedModifier> modifiers = const [],
    int quantity = 1,
    String? notes,
  }) {
    final newItem = CartItem(
      product: product,
      modifiers: modifiers,
      quantity: quantity,
      notes: notes,
    );
    state = state.copyWith(items: [...state.items, newItem]);
  }

  void updateItem(int index, CartItem item) {
    final items = List<CartItem>.from(state.items);
    items[index] = item;
    state = state.copyWith(items: items);
  }

  void removeItem(int index) {
    final items = List<CartItem>.from(state.items);
    items.removeAt(index);
    state = state.copyWith(items: items);
  }

  void updateQuantity(int index, int quantity) {
    if (quantity <= 0) {
      removeItem(index);
      return;
    }
    final items = List<CartItem>.from(state.items);
    items[index] = items[index].copyWith(quantity: quantity);
    state = state.copyWith(items: items);
  }

  void clear() {
    state = CartState();
  }

  void updateServiceFee({double? percentage, double? fixed}) {
    state = state.copyWith(
      serviceFeePercentage: percentage ?? state.serviceFeePercentage,
      serviceFeeFixed: fixed ?? state.serviceFeeFixed,
    );
  }
}

/// Cart provider
final cartProvider = StateNotifierProvider<CartNotifier, CartState>((ref) {
  return CartNotifier();
});
