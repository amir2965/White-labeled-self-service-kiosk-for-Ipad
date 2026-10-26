import 'package:flutter/material.dart';
import 'widgets/sales_summary_content_v2.dart';

/// **Premium Minimal Sales Summary Page**
///
/// Phase 1: Enterprise-ready analytics dashboard
/// Design: minimal luxury (black/white/blue)
/// Platform: iPad landscape primary
///
/// The page uses the new V2 content widget which implements:
/// - Clean 2-column layout for iPad
/// - Key metrics (Revenue, Orders, AOV, Net Sales)
/// - Payment mix (QR vs Counter)
/// - Simple hourly bar chart (no interactions)
/// - Time range selector
/// - Live status indicator
/// - Skeleton loaders
/// - Error/empty states
class SalesSummaryPage extends StatelessWidget {
  const SalesSummaryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const SalesSummaryContentV2();
  }
}
