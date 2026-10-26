import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/product.dart';
import '../kiosk/menu_template_config.dart';

/// Merchant state
class MerchantState {
  final String businessName;
  final String businessType;
  final MenuDisplayTemplate menuDisplayTemplate;

  MerchantState({
    this.businessName = 'Demo Café',
    this.businessType = 'cafe',
    this.menuDisplayTemplate = MenuDisplayTemplate.categorySidebar,
  });

  MerchantState copyWith({
    String? businessName,
    String? businessType,
    MenuDisplayTemplate? menuDisplayTemplate,
  }) {
    return MerchantState(
      businessName: businessName ?? this.businessName,
      businessType: businessType ?? this.businessType,
      menuDisplayTemplate: menuDisplayTemplate ?? this.menuDisplayTemplate,
    );
  }
}

/// Merchant notifier
class MerchantNotifier extends StateNotifier<MerchantState> {
  MerchantNotifier() : super(MerchantState());

  void updateBusinessName(String name) {
    state = state.copyWith(businessName: name);
  }

  void updateBusinessType(String type) {
    state = state.copyWith(businessType: type);
  }

  void updateTemplate(MenuDisplayTemplate template) {
    state = state.copyWith(menuDisplayTemplate: template);
  }
}

/// Merchant provider
final merchantProvider = StateNotifierProvider<MerchantNotifier, MerchantState>(
  (ref) {
    return MerchantNotifier();
  },
);
