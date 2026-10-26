/// Card type for debit card detection
enum CardType {
  visa,
  mastercard,
  unknown;

  String get displayName {
    switch (this) {
      case CardType.visa:
        return 'Visa';
      case CardType.mastercard:
        return 'Mastercard';
      case CardType.unknown:
        return 'Unknown';
    }
  }
}

/// Account verification status
enum VerificationStatus {
  pending,
  verified,
  failed;

  String get displayName {
    switch (this) {
      case VerificationStatus.pending:
        return 'Pending Verification';
      case VerificationStatus.verified:
        return 'Verified';
      case VerificationStatus.failed:
        return 'Verification Failed';
    }
  }
}

/// Represents a linked bank account for payouts
class BankAccount {
  final String id;
  final String bankName;
  final String accountName;
  final String bsbMasked;
  final String accountLast4;
  final bool isVerified;
  final VerificationStatus verificationStatus;
  final CardType cardType;

  const BankAccount({
    required this.id,
    required this.bankName,
    required this.accountName,
    required this.bsbMasked,
    required this.accountLast4,
    @Deprecated('Use verificationStatus instead') this.isVerified = false,
    this.verificationStatus = VerificationStatus.pending,
    this.cardType = CardType.unknown,
  });

  BankAccount copyWith({
    String? id,
    String? bankName,
    String? accountName,
    String? bsbMasked,
    String? accountLast4,
    bool? isVerified,
    VerificationStatus? verificationStatus,
    CardType? cardType,
  }) {
    return BankAccount(
      id: id ?? this.id,
      bankName: bankName ?? this.bankName,
      accountName: accountName ?? this.accountName,
      bsbMasked: bsbMasked ?? this.bsbMasked,
      accountLast4: accountLast4 ?? this.accountLast4,
      isVerified: isVerified ?? this.isVerified,
      verificationStatus: verificationStatus ?? this.verificationStatus,
      cardType: cardType ?? this.cardType,
    );
  }

  /// Detects card type from account number
  static CardType detectCardType(String accountNumber) {
    final cleaned = accountNumber.replaceAll(RegExp(r'[^0-9]'), '');
    if (cleaned.isEmpty) return CardType.unknown;

    final firstDigit = int.tryParse(cleaned[0]) ?? 0;

    // Visa starts with 4
    if (firstDigit == 4) return CardType.visa;

    // Mastercard starts with 5 (51-55) or 2 (2221-2720)
    if (firstDigit == 5) {
      if (cleaned.length >= 2) {
        final firstTwo = int.tryParse(cleaned.substring(0, 2)) ?? 0;
        if (firstTwo >= 51 && firstTwo <= 55) return CardType.mastercard;
      }
    }
    if (firstDigit == 2) {
      if (cleaned.length >= 4) {
        final firstFour = int.tryParse(cleaned.substring(0, 4)) ?? 0;
        if (firstFour >= 2221 && firstFour <= 2720) return CardType.mastercard;
      }
    }

    return CardType.unknown;
  }

  /// Formats BSB as XXX-XXX
  static String formatBsb(String bsb) {
    final cleaned = bsb.replaceAll(RegExp(r'[^0-9]'), '');
    if (cleaned.length == 6) {
      return '${cleaned.substring(0, 3)}-${cleaned.substring(3)}';
    }
    return bsb;
  }

  /// Masks BSB as ***-***
  static String maskBsb() => '***-***';
}
