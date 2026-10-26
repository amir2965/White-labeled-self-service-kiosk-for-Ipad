import 'money.dart';

/// Represents the current balance state
class BalanceSnapshot {
  final Money available;
  final Money pending;
  final Money inTransit;
  final DateTime asOf;

  const BalanceSnapshot({
    required this.available,
    required this.pending,
    required this.inTransit,
    required this.asOf,
  });

  BalanceSnapshot copyWith({
    Money? available,
    Money? pending,
    Money? inTransit,
    DateTime? asOf,
  }) {
    return BalanceSnapshot(
      available: available ?? this.available,
      pending: pending ?? this.pending,
      inTransit: inTransit ?? this.inTransit,
      asOf: asOf ?? this.asOf,
    );
  }
}
