/// Represents a monetary amount in the smallest currency unit (e.g., cents for AUD)
class Money {
  final int minorUnits;
  final String currency;

  const Money({required this.minorUnits, this.currency = 'AUD'});

  /// Creates a Money instance from a decimal amount
  factory Money.fromDecimal(double amount, {String currency = 'AUD'}) {
    return Money(minorUnits: (amount * 100).round(), currency: currency);
  }

  /// Returns the decimal representation of the amount
  double get asDecimal => minorUnits / 100.0;

  /// Returns formatted string with currency symbol
  String get formatted {
    final amount = asDecimal;
    final isNegative = amount < 0;
    final absoluteAmount = amount.abs();
    final formatted = absoluteAmount.toStringAsFixed(2);
    return '${isNegative ? '-' : ''}\$$formatted';
  }

  Money operator +(Money other) {
    if (other.currency != currency) {
      throw ArgumentError('Cannot add different currencies');
    }
    return Money(minorUnits: minorUnits + other.minorUnits, currency: currency);
  }

  Money operator -(Money other) {
    if (other.currency != currency) {
      throw ArgumentError('Cannot subtract different currencies');
    }
    return Money(minorUnits: minorUnits - other.minorUnits, currency: currency);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Money &&
          runtimeType == other.runtimeType &&
          minorUnits == other.minorUnits &&
          currency == other.currency;

  @override
  int get hashCode => minorUnits.hashCode ^ currency.hashCode;

  @override
  String toString() => formatted;

  Money copyWith({int? minorUnits, String? currency}) {
    return Money(
      minorUnits: minorUnits ?? this.minorUnits,
      currency: currency ?? this.currency,
    );
  }
}
