import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_spacing.dart';
import '../../core/constants/app_typography.dart';
import '../../core/widgets/app_button.dart';
import 'qr_payment_screen.dart';
import 'order_confirmation_screen.dart';

class CheckoutScreen extends StatelessWidget {
  final List<Map<String, dynamic>> items;
  final double subtotal;
  final double serviceFee;
  final double total;

  const CheckoutScreen({
    super.key,
    required this.items,
    required this.subtotal,
    required this.serviceFee,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(AppSpacing.screenPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Order Summary', style: AppTypography.h2),
                    SizedBox(height: AppSpacing.lg),

                    // Order items
                    ...items.map((item) => _buildOrderItem(item)),

                    Divider(height: AppSpacing.xl, thickness: 1),

                    // Totals
                    _buildTotalRow('Subtotal', subtotal),
                    if (serviceFee > 0) ...[
                      SizedBox(height: AppSpacing.sm),
                      _buildTotalRow('Service Fee', serviceFee),
                    ],
                    SizedBox(height: AppSpacing.md),
                    _buildTotalRow('Total', total, isTotal: true),
                  ],
                ),
              ),
            ),
            _buildPaymentButtons(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppSpacing.screenPadding),
      decoration: BoxDecoration(
        color: AppColors.white,
        border: Border(bottom: BorderSide(color: AppColors.divider)),
      ),
      child: Row(
        children: [
          IconButton(
            icon: Icon(Icons.arrow_back, size: 32),
            onPressed: () => Navigator.pop(context),
          ),
          SizedBox(width: AppSpacing.md),
          Text('Checkout', style: AppTypography.h2),
        ],
      ),
    );
  }

  Widget _buildOrderItem(Map<String, dynamic> item) {
    final basePrice = item['basePrice'] ?? item['price'];
    final totalItemPrice = (item['price'] ?? 0) * (item['quantity'] ?? 1);

    return Padding(
      padding: EdgeInsets.symmetric(vertical: AppSpacing.sm),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.gray100,
              borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
            ),
            child: Center(
              child: Text('${item['quantity']}', style: AppTypography.h4),
            ),
          ),
          SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item['name'], style: AppTypography.h4),
                if (item['notes'] != null &&
                    item['notes'].toString().isNotEmpty) ...[
                  SizedBox(height: 4),
                  Text(
                    item['notes'],
                    style: AppTypography.caption.copyWith(
                      color: AppColors.blue,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
                if (basePrice != null)
                  Text(
                    'Base: \$${basePrice.toStringAsFixed(2)}',
                    style: AppTypography.caption.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                if (item['modifiers'] != null && item['modifiers'].isNotEmpty)
                  ...((item['modifiers'] as List).map((m) {
                    final modName = m['modifier']?['name'] ?? m['name'] ?? '';
                    final modPrice = m['modifier']?['priceAdjustment'] ?? 0.0;
                    final priceText = modPrice > 0
                        ? ' (+\$${modPrice.toStringAsFixed(2)})'
                        : '';
                    return Text(
                      '• $modName$priceText',
                      style: AppTypography.caption.copyWith(
                        color: AppColors.blue,
                        fontWeight: FontWeight.w600,
                      ),
                    );
                  })),
              ],
            ),
          ),
          Text(
            '\$${totalItemPrice.toStringAsFixed(2)}',
            style: AppTypography.h4,
          ),
        ],
      ),
    );
  }

  Widget _buildTotalRow(String label, double amount, {bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: isTotal ? AppTypography.h3 : AppTypography.bodyLarge,
        ),
        Text(
          '\$${amount.toStringAsFixed(2)}',
          style: isTotal ? AppTypography.price : AppTypography.bodyLarge,
        ),
      ],
    );
  }

  Widget _buildPaymentButtons(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppSpacing.screenPadding),
      decoration: BoxDecoration(
        color: AppColors.white,
        border: Border(top: BorderSide(color: AppColors.divider)),
      ),
      child: Column(
        children: [
          AppButton(
            label: 'Scan QR to Pay',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => QRPaymentScreen(
                    orderId: 'ord_${DateTime.now().millisecondsSinceEpoch}',
                    totalAmount: total,
                    items: items,
                    subtotal: subtotal,
                    serviceFee: serviceFee,
                  ),
                ),
              );
            },
            size: AppButtonSize.extraLarge,
            fullWidth: true,
            icon: Icons.qr_code_2,
          ),
          SizedBox(height: AppSpacing.md),
          AppButton(
            label: 'Pay at Counter',
            onPressed: () => _showPayAtCounterConfirmation(context),
            variant: AppButtonVariant.outline,
            size: AppButtonSize.extraLarge,
            fullWidth: true,
            icon: Icons.storefront,
          ),
        ],
      ),
    );
  }

  void _showPayAtCounterConfirmation(BuildContext context) {
    final orderId = DateTime.now().millisecondsSinceEpoch.toString().substring(
      0,
      8,
    );

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => OrderConfirmationScreen(
          orderId: orderId,
          total: total,
          items: items,
        ),
      ),
    );
  }
}
