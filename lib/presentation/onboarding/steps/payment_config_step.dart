import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/widgets/app_button.dart';

class PaymentConfigStep extends StatefulWidget {
  final bool payAtCounterEnabled;
  final bool qrPayEnabled;
  final double serviceFeePercent;
  final Function(bool payAtCounter, bool qrPay, double feePercent) onChanged;

  const PaymentConfigStep({
    super.key,
    required this.payAtCounterEnabled,
    required this.qrPayEnabled,
    required this.serviceFeePercent,
    required this.onChanged,
  });

  @override
  State<PaymentConfigStep> createState() => _PaymentConfigStepState();
}

class _PaymentConfigStepState extends State<PaymentConfigStep> {
  final ScrollController _scrollController = ScrollController();
  double _scrollOffset = 0.0;
  double _maxScrollExtent = 1.0;
  bool _showScrollIndicator = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);

    Future.delayed(Duration(milliseconds: 500), () {
      if (mounted && _scrollController.hasClients) {
        setState(() {
          _maxScrollExtent = _scrollController.position.maxScrollExtent;
          _showScrollIndicator = _maxScrollExtent > 50;
        });
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (mounted) {
      setState(() {
        _scrollOffset = _scrollController.offset;
        _maxScrollExtent = _scrollController.position.maxScrollExtent;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth >= 768;

    return Listener(
      behavior: HitTestBehavior.translucent,
      onPointerSignal: (event) {
        if (event is PointerScrollEvent && _scrollController.hasClients) {
          final maxScroll = _scrollController.position.maxScrollExtent;
          final target = (_scrollController.offset + event.scrollDelta.dy)
              .clamp(0.0, maxScroll);
          _scrollController.jumpTo(target);
        }
      },
      child: Stack(
        children: [
          SingleChildScrollView(
            controller: _scrollController,
            padding: EdgeInsets.symmetric(
              horizontal: isTablet ? 48.0 : AppSpacing.screenPadding,
              vertical: AppSpacing.lg,
            ),
            child: Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: isTablet ? 700.0 : screenWidth,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Configure payment options', style: AppTypography.h2),
                    SizedBox(height: 8),
                    Text(
                      'Enable one or both payment methods',
                      style: AppTypography.bodyMedium.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    SizedBox(height: AppSpacing.xl),

                    _buildToggleCard(
                      title: 'Pay at Counter',
                      description: 'Customer orders on kiosk, pays to staff',
                      value: widget.payAtCounterEnabled,
                      onChanged: (value) => widget.onChanged(
                        value,
                        widget.qrPayEnabled,
                        widget.serviceFeePercent,
                      ),
                    ),

                    SizedBox(height: AppSpacing.lg),

                    _buildToggleCard(
                      title: 'QR Code Payment',
                      description: 'Customer scans QR and pays on their phone',
                      value: widget.qrPayEnabled,
                      onChanged: (value) {
                        widget.onChanged(
                          widget.payAtCounterEnabled,
                          value,
                          widget.serviceFeePercent,
                        );
                        Future.delayed(Duration(milliseconds: 300), () {
                          if (mounted && _scrollController.hasClients) {
                            setState(() {
                              _maxScrollExtent =
                                  _scrollController.position.maxScrollExtent;
                              _showScrollIndicator = _maxScrollExtent > 50;
                            });
                          }
                        });
                      },
                    ),

                    if (widget.qrPayEnabled) ...[
                      SizedBox(height: AppSpacing.xl),
                      Text('Service Fee', style: AppTypography.h4),
                      SizedBox(height: AppSpacing.md),
                      Text(
                        'Platform fee charged on QR payments',
                        style: AppTypography.bodyMedium.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                      SizedBox(height: AppSpacing.lg),

                      Slider(
                        value: widget.serviceFeePercent,
                        min: 0.5,
                        max: 5.0,
                        divisions: 9,
                        label:
                            '${widget.serviceFeePercent.toStringAsFixed(1)}%',
                        onChanged: (value) => widget.onChanged(
                          widget.payAtCounterEnabled,
                          widget.qrPayEnabled,
                          value,
                        ),
                      ),

                      Center(
                        child: Text(
                          '${widget.serviceFeePercent.toStringAsFixed(1)}% service fee',
                          style: AppTypography.h3,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),

          if (_showScrollIndicator && _maxScrollExtent > 50)
            _buildScrollIndicator(isTablet),
        ],
      ),
    );
  }

  Widget _buildToggleCard({
    required String title,
    required String description,
    required bool value,
    required Function(bool) onChanged,
  }) {
    return Container(
      padding: EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTypography.h4),
                SizedBox(height: AppSpacing.xs),
                Text(
                  description,
                  style: AppTypography.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: AppColors.blue,
          ),
        ],
      ),
    );
  }

  Widget _buildScrollIndicator(bool isTablet) {
    final screenHeight = MediaQuery.of(context).size.height;
    final indicatorHeight = isTablet ? 120.0 : 80.0;
    final trackHeight = screenHeight * 0.6;

    double thumbPosition = 0.0;
    if (_maxScrollExtent > 0) {
      thumbPosition =
          (_scrollOffset / _maxScrollExtent) * (trackHeight - indicatorHeight);
      thumbPosition = thumbPosition.clamp(0.0, trackHeight - indicatorHeight);
    }

    return Positioned(
      right: isTablet ? 16 : 8,
      top: screenHeight * 0.2,
      child: AnimatedOpacity(
        opacity: _scrollOffset > 20 ? 1.0 : 0.3,
        duration: Duration(milliseconds: 200),
        child: Container(
          width: isTablet ? 6 : 4,
          height: trackHeight,
          decoration: BoxDecoration(
            color: AppColors.gray200.withOpacity(0.3),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Stack(
            children: [
              AnimatedPositioned(
                duration: Duration(milliseconds: 100),
                curve: Curves.easeOut,
                top: thumbPosition,
                left: 0,
                right: 0,
                child: Container(
                  height: indicatorHeight,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColors.blue.withOpacity(0.8),
                        AppColors.blue.withOpacity(0.4),
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.blue.withOpacity(0.3),
                        blurRadius: 8,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
