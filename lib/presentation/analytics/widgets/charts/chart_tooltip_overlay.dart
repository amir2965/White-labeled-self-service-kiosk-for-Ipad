import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/chart_models.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_typography.dart';

/// Floating tooltip overlay for chart point selection
/// Dark tooltip with pointer tail
class ChartTooltipOverlay extends StatelessWidget {
  final ChartPointSelection selection;
  final Offset position;
  final VoidCallback? onDismiss;

  const ChartTooltipOverlay({
    Key? key,
    required this.selection,
    required this.position,
    this.onDismiss,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final availableWidth = constraints.maxWidth.isFinite
            ? constraints.maxWidth
            : MediaQuery.of(context).size.width;
        final availableHeight = constraints.maxHeight.isFinite
            ? constraints.maxHeight
            : MediaQuery.of(context).size.height;

        return GestureDetector(
          onTap: onDismiss,
          behavior: HitTestBehavior.translucent,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              // Backdrop for dismissal
              Positioned.fill(child: Container(color: Colors.transparent)),

              // Tooltip card
              Positioned(
                left: _calculateLeft(availableWidth),
                top: _calculateTop(availableHeight),
                child: _buildTooltipCard(),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTooltipCard() {
    return Container(
      constraints: const BoxConstraints(maxWidth: 280, minWidth: 200),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.95),
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Primary data
          _buildDataSection(
            selection.point,
            selection.dateLabel,
            isPrimary: true,
          ),

          // Comparison data (if available)
          if (selection.comparePoint != null &&
              selection.compareDateLabel != null) ...[
            Divider(color: Colors.white.withOpacity(0.2), height: 1),
            _buildDataSection(
              selection.comparePoint!,
              selection.compareDateLabel!,
              isPrimary: false,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildDataSection(
    ChartPoint point,
    String dateLabel, {
    required bool isPrimary,
  }) {
    final timeLabel = point.label ?? DateFormat('h:mm a').format(point.x);
    final amountLabel = '\$${point.grossSales.toStringAsFixed(2)}';
    final paymentsLabel =
        '${point.paymentsCount} ${point.paymentsCount == 1 ? 'PAYMENT' : 'PAYMENTS'}';

    return Padding(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Time/Label
          Text(
            timeLabel,
            style: AppTypography.bodySmall.copyWith(
              color: Colors.white.withOpacity(0.7),
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),

          // Amount (large)
          Text(
            amountLabel,
            style: AppTypography.h2.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),

          // Payments count
          Text(
            paymentsLabel,
            style: AppTypography.caption.copyWith(
              color: Colors.white.withOpacity(0.6),
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 8),

          // Date label
          Text(
            dateLabel,
            style: AppTypography.caption.copyWith(
              color: Colors.white.withOpacity(0.5),
            ),
          ),
        ],
      ),
    );
  }

  double _calculateLeft(double availableWidth) {
    const tooltipWidth = 240.0;
    const padding = 16.0;

    double left = position.dx - (tooltipWidth / 2);
    final maxLeft = math.max(padding, availableWidth - tooltipWidth - padding);

    if (left < padding) {
      left = padding;
    } else if (left > maxLeft) {
      left = maxLeft;
    }

    return left;
  }

  double _calculateTop(double availableHeight) {
    const tooltipHeight = 160.0;
    const padding = 16.0;
    double top = position.dy - (tooltipHeight + padding);

    if (top < padding) {
      top = position.dy + padding + 8;
    }

    final maxTop = math.max(padding, availableHeight - tooltipHeight - padding);
    if (top > maxTop) {
      top = maxTop;
    }

    return top;
  }
}
