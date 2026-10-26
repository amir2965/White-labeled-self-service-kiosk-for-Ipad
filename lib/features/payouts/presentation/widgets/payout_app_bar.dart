import 'package:flutter/material.dart';

/// Custom app bar for payout screens with centered title and back navigation
class PayoutAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final String backLabel;
  final VoidCallback onBack;
  final Widget? trailing;

  const PayoutAppBar({
    Key? key,
    required this.title,
    this.backLabel = 'Overview',
    required this.onBack,
    this.trailing,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      automaticallyImplyLeading: false,
      leading: Padding(
        padding: const EdgeInsets.only(left: 4.0),
        child: TextButton.icon(
          onPressed: onBack,
          icon: const Icon(Icons.chevron_left, size: 20),
          label: Text(backLabel, maxLines: 1, overflow: TextOverflow.visible),
          style: TextButton.styleFrom(
            foregroundColor: const Color(0xFF007AFF),
            textStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
      leadingWidth: 140,
      centerTitle: true,
      title: Text(
        title,
        style: const TextStyle(
          color: Colors.black,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      actions: trailing != null ? [trailing!, const SizedBox(width: 16)] : null,
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(color: Colors.grey.shade200, height: 1),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 1);
}
