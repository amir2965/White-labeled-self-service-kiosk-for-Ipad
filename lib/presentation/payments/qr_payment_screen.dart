import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:go_router/go_router.dart';
import 'dart:html' as html show window;
import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_spacing.dart';
import '../../core/constants/app_typography.dart';
import '../../core/widgets/app_button.dart';
import '../providers/cart_provider.dart';

class QRPaymentScreen extends ConsumerStatefulWidget {
  final String orderId;
  final double totalAmount;
  final List<Map<String, dynamic>> items;
  final double subtotal;
  final double serviceFee;

  const QRPaymentScreen({
    super.key,
    required this.orderId,
    required this.totalAmount,
    required this.items,
    required this.subtotal,
    required this.serviceFee,
  });

  @override
  ConsumerState<QRPaymentScreen> createState() => _QRPaymentScreenState();
}

class _QRPaymentScreenState extends ConsumerState<QRPaymentScreen> {
  bool _isPaid = false;
  int _secondsRemaining = 300; // 5 minutes
  bool _isStoring = true;
  Timer? _countdownTimer;
  Timer? _pollingTimer;
  Timer? _successTimer;
  int _successCountdown = 5;

  @override
  void initState() {
    super.initState();
    _storeOrderData();
    _startTimer();
    _startPolling();
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    _pollingTimer?.cancel();
    _successTimer?.cancel();
    super.dispose();
  }

  Future<void> _storeOrderData() async {
    try {
      // Get API base URL
      String apiUrl;
      if (kIsWeb) {
        apiUrl = '${html.window.location.origin}/api/orders';
      } else {
        apiUrl = 'http://localhost:8080/api/orders';
      }

      // Prepare order data
      final orderData = {
        'orderId': widget.orderId,
        'items': widget.items,
        'subtotal': widget.subtotal,
        'serviceFee': widget.serviceFee,
        'total': widget.totalAmount,
      };

      print('📤 Storing order data: ${widget.orderId}');

      // POST to backend API
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(orderData),
      );

      if (response.statusCode == 200) {
        print('✅ Order stored successfully');
      } else {
        print('❌ Failed to store order: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Error storing order: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isStoring = false;
        });
      }
    }
  }

  void _startTimer() {
    _countdownTimer?.cancel();
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }

      if (_secondsRemaining > 0 && !_isPaid) {
        setState(() {
          _secondsRemaining--;
        });
      } else {
        timer.cancel();
      }
    });
  }

  void _startPolling() {
    _pollingTimer?.cancel();
    _pollingTimer = Timer.periodic(const Duration(seconds: 2), (timer) {
      if (!mounted || _isPaid) {
        timer.cancel();
        return;
      }
      _checkPaymentStatus();
    });
  }

  Future<void> _checkPaymentStatus() async {
    try {
      // Get API base URL
      String apiUrl;
      if (kIsWeb) {
        apiUrl =
            '${html.window.location.origin}/api/payment-sessions/${widget.orderId}';
      } else {
        apiUrl = 'http://localhost:8080/api/payment-sessions/${widget.orderId}';
      }

      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final status = data['status'] as String?;

        if (status == 'completed' || status == 'paid') {
          print('✅ Payment confirmed for order ${widget.orderId}');
          _onPaymentSuccess();
        }
      }
    } catch (e) {
      print('Error checking payment status: $e');
      // Continue polling even if there's an error
    }
  }

  void _onPaymentSuccess() {
    if (!mounted || _isPaid) return;

    setState(() {
      _isPaid = true;
      _successCountdown = 10; // Changed to 10 seconds
    });

    // Clear the cart when payment is successful
    ref.read(cartProvider.notifier).clear();

    // Show success dialog after brief delay, auto-close after 3 seconds
    Future.delayed(const Duration(milliseconds: 500), () {
      if (!mounted) return;
      _showSuccessDialog();
    });
  }

  void _showSuccessDialog() {
    if (!mounted) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0.7),
      builder: (dialogContext) =>
          _PaymentSuccessDialog(orderId: widget.orderId),
    );

    // Auto-close dialog after 3 seconds
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.of(context).pop();
        _startSuccessTimer();
      }
    });
  }

  void _startSuccessTimer() {
    _successTimer?.cancel(); // Cancel any existing timer
    _successTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }

      if (_successCountdown > 0) {
        setState(() {
          _successCountdown--;
        });
      } else {
        timer.cancel();
        _successTimer = null;
        _showExtendDialog();
      }
    });
  }

  void _showExtendDialog() {
    if (!mounted) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0.7),
      builder: (dialogContext) => _ExtendTimeDialog(
        onYes: () {
          Navigator.of(dialogContext).pop();
          setState(() {
            _successCountdown = 10;
          });
          _startSuccessTimer();
        },
        onNo: () {
          Navigator.of(dialogContext).pop();
          _returnToMenu();
        },
      ),
    );

    // Auto-close after 7 seconds if no response
    Future.delayed(const Duration(seconds: 7), () {
      if (mounted && Navigator.of(context).canPop()) {
        Navigator.of(context).pop();
        _returnToMenu();
      }
    });
  }

  void _returnToMenu() {
    if (mounted) {
      // Pop all Navigator screens first (QR payment, then checkout)
      // This ensures we clear the pushed screens from Navigator stack
      Navigator.of(context).popUntil((route) => route.isFirst);

      // Then use go_router to navigate to menu
      // This ensures we're on the menu route, not just back at previous route
      context.go('/menu');
    }
  }

  String get _paymentUrl {
    // Get current host for web, use configurable URL for mobile
    String baseUrl;

    if (kIsWeb) {
      // On web, use the same host as the current page
      final origin = html.window.location.origin;
      baseUrl = '$origin/checkout.html';
    } else {
      // For mobile/desktop testing, use localhost or configure your domain
      baseUrl = 'http://localhost:8080/checkout.html';
    }

    final params = {
      's': widget.orderId, // session ID
      'order': widget.orderId,
      'amount': widget.totalAmount.toString(),
    };

    final queryString = params.entries
        .map(
          (e) =>
              '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}',
        )
        .join('&');

    return '$baseUrl?$queryString';
  }

  @override
  Widget build(BuildContext context) {
    if (_isPaid) {
      return _buildSuccessScreen();
    }

    // Show loading while storing order data
    if (_isStoring) {
      return Scaffold(
        backgroundColor: AppColors.background,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(color: AppColors.blue),
              SizedBox(height: AppSpacing.lg),
              Text('Preparing payment...', style: AppTypography.bodyLarge),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.all(AppSpacing.screenPaddingLarge),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: MediaQuery.of(context).size.height - 200,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Scan to Pay', style: AppTypography.display2),
                      SizedBox(height: AppSpacing.md),
                      Text(
                        'Use your phone camera to scan',
                        style: AppTypography.bodyLarge.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                      SizedBox(height: AppSpacing.xxl),

                      // QR Code
                      Container(
                        padding: EdgeInsets.all(AppSpacing.lg),
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(
                            AppSpacing.radiusLg,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 20,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: QrImageView(
                          data: _paymentUrl,
                          version: QrVersions.auto,
                          size: 300,
                        ),
                      ),

                      SizedBox(height: AppSpacing.xxl),

                      // Amount
                      Text('Total Amount', style: AppTypography.label),
                      SizedBox(height: AppSpacing.xs),
                      Text(
                        '\$${widget.totalAmount.toStringAsFixed(2)}',
                        style: AppTypography.priceLarge,
                      ),

                      SizedBox(height: AppSpacing.xl),

                      // Timer
                      Text(
                        'Time remaining: ${_formatTime(_secondsRemaining)}',
                        style: AppTypography.bodyLarge.copyWith(
                          color: _secondsRemaining < 60
                              ? AppColors.error
                              : AppColors.textSecondary,
                        ),
                      ),

                      SizedBox(height: AppSpacing.xxl),

                      AppButton(
                        label: 'Cancel',
                        onPressed: () => Navigator.pop(context),
                        variant: AppButtonVariant.outline,
                        size: AppButtonSize.large,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.all(AppSpacing.screenPadding),
      decoration: BoxDecoration(
        color: AppColors.white,
        border: Border(bottom: BorderSide(color: AppColors.divider)),
      ),
      child: Row(
        children: [
          Text('Payment', style: AppTypography.h2),
          Spacer(),
          IconButton(
            icon: Icon(Icons.close, size: 32),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  Widget _buildSuccessScreen() {
    final receiptUrl = 'https://example.com/receipt/${widget.orderId}';

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: SizedBox(
          width: double.infinity,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.all(AppSpacing.screenPadding),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Success icon
                  Container(
                    width: 140,
                    height: 140,
                    decoration: BoxDecoration(
                      color: AppColors.success,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.success.withOpacity(0.3),
                          blurRadius: 30,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.check_circle_outline,
                      size: 80,
                      color: AppColors.white,
                    ),
                  ),
                  SizedBox(height: AppSpacing.xxl),

                  // Success message
                  Text(
                    'Thanks for Your Order!',
                    style: AppTypography.display1.copyWith(
                      fontSize: 42,
                      fontWeight: FontWeight.w800,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: AppSpacing.md),

                  // Order number
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppSpacing.xl,
                      vertical: AppSpacing.md,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.gray300, width: 2),
                    ),
                    child: Text(
                      'Order #${widget.orderId.substring(0, 8)}',
                      style: AppTypography.h2.copyWith(
                        color: AppColors.success,
                        fontWeight: FontWeight.w700,
                        fontSize: 28,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),
                  SizedBox(height: AppSpacing.xxl),

                  // Receipt QR section
                  Container(
                    padding: EdgeInsets.all(AppSpacing.xl),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.06),
                          blurRadius: 20,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Text(
                          'Scan for Receipt',
                          style: AppTypography.h3.copyWith(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: AppSpacing.md),
                        Container(
                          padding: EdgeInsets.all(AppSpacing.sm),
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: AppColors.gray300,
                              width: 1,
                            ),
                          ),
                          child: QrImageView(
                            data: receiptUrl,
                            version: QrVersions.auto,
                            size: 120,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: AppSpacing.xxl),

                  // Countdown text
                  Text(
                    'Returning to menu in ${_successCountdown}s',
                    style: AppTypography.bodyLarge.copyWith(
                      color: AppColors.gray600,
                      fontSize: 18,
                    ),
                  ),
                  SizedBox(height: AppSpacing.lg),

                  // Manual return button
                  AppButton(
                    label: 'Back to Menu',
                    onPressed: _returnToMenu,
                    variant: AppButtonVariant.outline,
                    size: AppButtonSize.large,
                    icon: Icons.arrow_back,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final secs = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }
}

// Payment success dialog (auto-closes after 3 seconds)
class _PaymentSuccessDialog extends StatelessWidget {
  final String orderId;

  const _PaymentSuccessDialog({required this.orderId});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 500),
        padding: EdgeInsets.all(AppSpacing.xl),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 40,
              offset: const Offset(0, 20),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Success icon
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: AppColors.success,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.check_circle_outline,
                size: 60,
                color: AppColors.white,
              ),
            ),
            SizedBox(height: AppSpacing.lg),

            // Title
            Text(
              'Payment Received!',
              style: AppTypography.h2.copyWith(
                fontSize: 32,
                fontWeight: FontWeight.w800,
                color: AppColors.success,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: AppSpacing.md),

            // Order number
            Text(
              'Order #${orderId.substring(0, 8)}',
              style: AppTypography.h3.copyWith(color: AppColors.gray600),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

// Extend time dialog
class _ExtendTimeDialog extends StatefulWidget {
  final VoidCallback onYes;
  final VoidCallback onNo;

  const _ExtendTimeDialog({required this.onYes, required this.onNo});

  @override
  State<_ExtendTimeDialog> createState() => _ExtendTimeDialogState();
}

class _ExtendTimeDialogState extends State<_ExtendTimeDialog> {
  int _countdown = 7;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startCountdown();
  }

  void _startCountdown() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }

      setState(() {
        _countdown--;
      });

      if (_countdown <= 0) {
        timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 500),
        padding: EdgeInsets.all(AppSpacing.xl),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 40,
              offset: const Offset(0, 20),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icon
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppColors.blue.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.timer_outlined,
                size: 48,
                color: AppColors.blue,
              ),
            ),
            SizedBox(height: AppSpacing.lg),

            // Title
            Text(
              'Need More Time?',
              style: AppTypography.h2.copyWith(
                fontSize: 32,
                fontWeight: FontWeight.w800,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: AppSpacing.md),

            // Description
            Text(
              'Returning to menu in $_countdown seconds',
              style: AppTypography.bodyLarge.copyWith(
                color: AppColors.gray600,
                fontSize: 18,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: AppSpacing.xxl),

            // Buttons
            Row(
              children: [
                Expanded(
                  child: AppButton(
                    label: 'No',
                    onPressed: widget.onNo,
                    variant: AppButtonVariant.outline,
                    size: AppButtonSize.large,
                  ),
                ),
                SizedBox(width: AppSpacing.md),
                Expanded(
                  child: AppButton(
                    label: 'More Time',
                    onPressed: widget.onYes,
                    size: AppButtonSize.large,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
