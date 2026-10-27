import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_spacing.dart';
import '../../core/constants/app_typography.dart';
import '../../core/widgets/app_button.dart';
import '../providers/cart_provider.dart';

class OrderConfirmationScreen extends ConsumerStatefulWidget {
  final String orderId;
  final double total;
  final List<Map<String, dynamic>> items;

  const OrderConfirmationScreen({
    super.key,
    required this.orderId,
    required this.total,
    required this.items,
  });

  @override
  ConsumerState<OrderConfirmationScreen> createState() =>
      _OrderConfirmationScreenState();
}

class _OrderConfirmationScreenState
    extends ConsumerState<OrderConfirmationScreen>
    with SingleTickerProviderStateMixin {
  Timer? _autoCloseTimer;
  Timer? _extendedTimer;
  int _remainingSeconds = 6;
  bool _showExtendOption = false;
  bool _isExtended = false;
  bool _dialogActionTaken = false; // Track if user took action in dialog
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();

    // Clear the cart immediately when order is confirmed
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        ref.read(cartProvider.notifier).clear();
      }
    });

    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _startAutoCloseTimer();
  }

  void _startAutoCloseTimer() {
    _autoCloseTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }

      setState(() {
        _remainingSeconds--;
      });

      if (_remainingSeconds == 0 && !_showExtendOption) {
        // After 5 seconds, show dialog asking if they want to stay
        timer.cancel();
        _showExtendDialog();
      }
    });
  }

  void _showExtendDialog() {
    if (!mounted) return;

    setState(() {
      _dialogActionTaken = false;
    });

    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0.7),
      builder: (dialogContext) => _ExtendDialog(
        onStayLonger: () {
          Navigator.of(dialogContext).pop();
          _dialogActionTaken = true;
          setState(() {
            _isExtended = true;
            _remainingSeconds = 10;
          });
          _startExtendedTimer();
        },
        onReturnNow: () {
          Navigator.of(dialogContext).pop();
          _dialogActionTaken = true;
          _returnToMenu();
        },
      ),
    ).then((_) {
      // If dialog dismissed without action, return to menu
      if (!_dialogActionTaken && mounted) {
        _returnToMenu();
      }
    });
  }

  void _startExtendedTimer() {
    _extendedTimer?.cancel(); // Cancel any existing timer
    _extendedTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }

      setState(() {
        _remainingSeconds--;
      });

      if (_remainingSeconds <= 0) {
        timer.cancel();
        _extendedTimer = null;
        _returnToMenu();
      }
    });
  }

  void _stayLonger() {
    _extendedTimer?.cancel(); // Cancel any existing timer
    setState(() {
      _isExtended = true;
      _remainingSeconds = 10;
    });
    _startExtendedTimer();
  }

  void _returnToMenu() {
    if (mounted) {
      // Pop all Navigator screens first (order confirmation, then checkout)
      // This ensures we clear the pushed screens from Navigator stack
      Navigator.of(context).popUntil((route) => route.isFirst);

      // Then use go_router to navigate to menu
      // This ensures we're on the menu route, not just back at previous route
      context.go('/menu');
    }
  }

  @override
  void dispose() {
    _autoCloseTimer?.cancel();
    _extendedTimer?.cancel();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final compact = MediaQuery.sizeOf(context).width < 600;
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Stack(
          children: [
            // Main content
            Center(
              child: SizedBox(
                width: double.infinity,
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: compact
                      ? const EdgeInsets.fromLTRB(20, 96, 20, 24)
                      : EdgeInsets.all(AppSpacing.screenPadding),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: MediaQuery.of(context).size.height - 100,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Success icon with pulse animation
                        ScaleTransition(
                          scale: _pulseAnimation,
                          child: Container(
                            width: compact ? 88 : 140,
                            height: compact ? 88 : 140,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  AppColors.blue,
                                  AppColors.blue.withOpacity(0.8),
                                ],
                              ),
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.blue.withOpacity(0.3),
                                  blurRadius: 30,
                                  offset: const Offset(0, 10),
                                ),
                              ],
                            ),
                            child: Icon(
                              Icons.check_circle_outline,
                              size: compact ? 52 : 80,
                              color: AppColors.white,
                            ),
                          ),
                        ),
                        SizedBox(height: AppSpacing.xxl),

                        // Success message
                        Text(
                          'Order Received!',
                          style: AppTypography.display1.copyWith(
                            fontSize: compact ? 32 : 48,
                            fontWeight: FontWeight.w800,
                          ),
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
                            border: Border.all(
                              color: AppColors.gray300,
                              width: 2,
                            ),
                          ),
                          child: Text(
                            'Order #${widget.orderId}',
                            style: AppTypography.h2.copyWith(
                              color: AppColors.blue,
                              fontWeight: FontWeight.w700,
                              fontSize: compact ? 20 : 28,
                              letterSpacing: 1.2,
                            ),
                          ),
                        ),
                        SizedBox(height: AppSpacing.xxl),

                        // Instructions
                        Container(
                          padding: EdgeInsets.all(compact ? 16 : AppSpacing.xl),
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
                              Icon(
                                Icons.storefront,
                                size: 48,
                                color: AppColors.gray700,
                              ),
                              SizedBox(height: AppSpacing.md),
                              Text(
                                'Please pay at the counter',
                                style: AppTypography.h3.copyWith(fontSize: 24),
                              ),
                              SizedBox(height: AppSpacing.lg),
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: AppSpacing.lg,
                                  vertical: AppSpacing.sm,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.gray100,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  'Total: \$${widget.total.toStringAsFixed(2)}',
                                  style: AppTypography.priceLarge.copyWith(
                                    fontSize: 36,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Show extend option after initial 6 seconds
                        if (_showExtendOption && !_isExtended) ...[
                          SizedBox(height: AppSpacing.xxl),
                          Container(
                            padding: EdgeInsets.all(AppSpacing.xl),
                            decoration: BoxDecoration(
                              color: AppColors.blue.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: AppColors.blue.withOpacity(0.3),
                                width: 2,
                              ),
                            ),
                            child: Column(
                              children: [
                                Text(
                                  'Need more time?',
                                  style: AppTypography.h3.copyWith(
                                    color: AppColors.blue,
                                  ),
                                ),
                                SizedBox(height: AppSpacing.md),
                                AppButton(
                                  label: 'Stay 10 More Seconds',
                                  onPressed: _stayLonger,
                                  size: AppButtonSize.large,
                                  icon: Icons.timer,
                                ),
                              ],
                            ),
                          ),
                        ],

                        // Show countdown timer when extended
                        if (_isExtended) ...[
                          SizedBox(height: AppSpacing.xl),
                          Text(
                            'Returning to menu in ${_remainingSeconds}s',
                            style: AppTypography.bodyLarge.copyWith(
                              color: AppColors.gray600,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // Top timer indicator (subtle) - only show initial countdown
            if (!_showExtendOption && !_isExtended)
              Positioned(
                top: AppSpacing.lg,
                right: AppSpacing.lg,
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                    vertical: AppSpacing.sm,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.schedule, size: 20, color: AppColors.gray600),
                      SizedBox(width: AppSpacing.xs),
                      Text(
                        '${_remainingSeconds}s',
                        style: AppTypography.bodyMedium.copyWith(
                          fontWeight: FontWeight.w600,
                          color: AppColors.gray700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

            // Manual return button
            Positioned(
              top: AppSpacing.lg,
              left: AppSpacing.lg,
              child: AppButton(
                label: 'Back to Menu',
                onPressed: _returnToMenu,
                variant: AppButtonVariant.outline,
                size: AppButtonSize.medium,
                icon: Icons.arrow_back,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Dialog widget for asking user to stay longer
class _ExtendDialog extends StatefulWidget {
  final VoidCallback onStayLonger;
  final VoidCallback onReturnNow;

  const _ExtendDialog({required this.onStayLonger, required this.onReturnNow});

  @override
  State<_ExtendDialog> createState() => _ExtendDialogState();
}

class _ExtendDialogState extends State<_ExtendDialog> {
  int _countdown = 10;
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
        if (mounted) {
          widget.onReturnNow();
        }
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
              'Returning to menu in ${_countdown} seconds',
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
                    label: 'Return Now',
                    onPressed: widget.onReturnNow,
                    variant: AppButtonVariant.outline,
                    size: AppButtonSize.large,
                  ),
                ),
                SizedBox(width: AppSpacing.md),
                Expanded(
                  child: AppButton(
                    label: 'Stay Longer',
                    onPressed: widget.onStayLonger,
                    size: AppButtonSize.large,
                    icon: Icons.add_circle_outline,
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
