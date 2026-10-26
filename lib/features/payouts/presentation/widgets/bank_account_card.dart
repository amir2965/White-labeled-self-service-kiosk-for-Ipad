import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/bank_account.dart';
import '../../../../presentation/analytics/theme_provider.dart';

/// Card displaying linked bank account information
class BankAccountCard extends ConsumerWidget {
  final BankAccount account;
  final VoidCallback? onRemove;

  const BankAccountCard({Key? key, required this.account, this.onRemove})
    : super(key: key);

  Widget _buildCardLogo(CardType cardType, bool isDarkMode) {
    switch (cardType) {
      case CardType.visa:
        return Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: isDarkMode ? Color(0xFF2A2A2A) : Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isDarkMode
                  ? Colors.white.withOpacity(0.15)
                  : Colors.grey.shade200,
            ),
            boxShadow: isDarkMode
                ? []
                : [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
          ),
          child: Center(
            child: Text(
              'VISA',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w900,
                color: Color(0xFF1A1F71),
                letterSpacing: 1.5,
              ),
            ),
          ),
        );
      case CardType.mastercard:
        return Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: isDarkMode ? Color(0xFF2A2A2A) : Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isDarkMode
                  ? Colors.white.withOpacity(0.15)
                  : Colors.grey.shade200,
            ),
            boxShadow: isDarkMode
                ? []
                : [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Positioned(
                left: 14,
                child: Container(
                  width: 14,
                  height: 14,
                  decoration: const BoxDecoration(
                    color: Color(0xFFEB001B),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              Positioned(
                right: 14,
                child: Container(
                  width: 14,
                  height: 14,
                  decoration: const BoxDecoration(
                    color: Color(0xFFF79E1B),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ),
        );
      default:
        return Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: const Color(0xFF007AFF).withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(
            Icons.account_balance,
            color: Color(0xFF007AFF),
            size: 28,
          ),
        );
    }
  }

  Widget _buildVerificationBadge() {
    final status = account.verificationStatus;
    Color backgroundColor;
    Color iconColor;
    Color textColor;
    IconData icon;
    String text;

    switch (status) {
      case VerificationStatus.verified:
        backgroundColor = const Color(0xFF4CAF50).withOpacity(0.1);
        iconColor = const Color(0xFF4CAF50);
        textColor = const Color(0xFF4CAF50);
        icon = Icons.check_circle;
        text = 'Verified';
        break;
      case VerificationStatus.pending:
        backgroundColor = const Color(0xFFFF9800).withOpacity(0.1);
        iconColor = const Color(0xFFFF9800);
        textColor = const Color(0xFFFF9800);
        icon = Icons.schedule;
        text = 'Pending Verification';
        break;
      case VerificationStatus.failed:
        backgroundColor = const Color(0xFFF44336).withOpacity(0.1);
        iconColor = const Color(0xFFF44336);
        textColor = const Color(0xFFF44336);
        icon = Icons.error;
        text = 'Verification Failed';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: iconColor),
          const SizedBox(width: 6),
          Text(
            text,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkMode = ref.watch(themeModeProvider);

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: isDarkMode ? Color(0xFF2A2A2A) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDarkMode
              ? Colors.white.withOpacity(0.15)
              : Colors.grey.shade200,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDarkMode ? 0.4 : 0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _buildCardLogo(account.cardType, isDarkMode),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      account.bankName,
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                        color: isDarkMode ? Colors.white : Colors.black87,
                        letterSpacing: -0.2,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      account.accountName,
                      style: TextStyle(
                        fontSize: 14,
                        color: isDarkMode
                            ? Colors.white.withOpacity(0.6)
                            : Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
              _buildVerificationBadge(),
            ],
          ),
          const SizedBox(height: 20),
          Container(
            height: 1,
            color: isDarkMode
                ? Colors.white.withOpacity(0.15)
                : Colors.grey.shade100,
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'BSB',
                      style: TextStyle(
                        fontSize: 12,
                        color: isDarkMode
                            ? Colors.white.withOpacity(0.5)
                            : Colors.grey.shade500,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      account.bsbMasked,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: isDarkMode ? Colors.white : Colors.black87,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Account',
                      style: TextStyle(
                        fontSize: 12,
                        color: isDarkMode
                            ? Colors.white.withOpacity(0.5)
                            : Colors.grey.shade500,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '•••• ${account.accountLast4}',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: isDarkMode ? Colors.white : Colors.black87,
                        letterSpacing: 1.0,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (onRemove != null) ...[
            const SizedBox(height: 24),
            Container(
              height: 1,
              color: isDarkMode
                  ? Colors.white.withOpacity(0.15)
                  : Colors.grey.shade100,
            ),
            const SizedBox(height: 16),
            InkWell(
              onTap: onRemove,
              borderRadius: BorderRadius.circular(8),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.delete_outline,
                      size: 18,
                      color: Colors.red.shade600,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Remove account',
                      style: TextStyle(
                        color: Colors.red.shade600,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
