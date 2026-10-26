import 'money.dart';

/// Configuration for instant transfer feature
class InstantTransferConfig {
  final bool enabled;
  final double feeRate;
  final Money minAmount;
  final Money maxAmount;
  final bool bankLinked;

  const InstantTransferConfig({
    required this.enabled,
    required this.feeRate,
    required this.minAmount,
    required this.maxAmount,
    required this.bankLinked,
  });

  /// Returns formatted fee rate as percentage (e.g., "1.5%")
  String get feeRateFormatted => '${(feeRate * 100).toStringAsFixed(1)}%';

  /// Calculates fee for a given amount
  Money calculateFee(Money amount) {
    final feeMinorUnits = (amount.minorUnits * feeRate).round();
    return Money(minorUnits: feeMinorUnits, currency: amount.currency);
  }

  /// Returns whether instant transfer is available
  bool get isAvailable => enabled && bankLinked;

  InstantTransferConfig copyWith({
    bool? enabled,
    double? feeRate,
    Money? minAmount,
    Money? maxAmount,
    bool? bankLinked,
  }) {
    return InstantTransferConfig(
      enabled: enabled ?? this.enabled,
      feeRate: feeRate ?? this.feeRate,
      minAmount: minAmount ?? this.minAmount,
      maxAmount: maxAmount ?? this.maxAmount,
      bankLinked: bankLinked ?? this.bankLinked,
    );
  }
}
