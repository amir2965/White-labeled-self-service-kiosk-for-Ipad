import 'package:flutter/material.dart';
import '../../domain/models/payout_status.dart';

/// Subtle status pill for settlements
class StatusPill extends StatelessWidget {
  final PayoutStatus status;

  const StatusPill({Key? key, required this.status}) : super(key: key);

  Color get _backgroundColor {
    return Color(
      int.parse(status.colorHex.substring(1), radix: 16) + 0xFF000000,
    );
  }

  Color get _textColor {
    return Color(
      int.parse(status.textColorHex.substring(1), radix: 16) + 0xFF000000,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: _backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        status.displayName,
        style: TextStyle(
          color: _textColor,
          fontSize: 13,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
