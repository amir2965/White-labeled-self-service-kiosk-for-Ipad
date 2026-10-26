import 'package:flutter_test/flutter_test.dart';
import 'package:self_service_kiosk/features/payouts/domain/models/money.dart';

void main() {
  group('Money', () {
    test('should create from minor units', () {
      final money = Money(minorUnits: 12345, currency: 'AUD');
      expect(money.minorUnits, 12345);
      expect(money.currency, 'AUD');
      expect(money.asDecimal, 123.45);
    });

    test('should create from decimal amount', () {
      final money = Money.fromDecimal(123.45, currency: 'AUD');
      expect(money.minorUnits, 12345);
      expect(money.asDecimal, 123.45);
    });

    test('should format correctly with currency symbol', () {
      final money = Money.fromDecimal(1234.56);
      expect(money.formatted, '\$1234.56');
    });

    test('should format negative amounts correctly', () {
      final money = Money(minorUnits: -12345);
      expect(money.formatted, '-\$123.45');
    });

    test('should format zero correctly', () {
      final money = Money.fromDecimal(0);
      expect(money.formatted, '\$0.00');
    });

    test('should add money amounts', () {
      final money1 = Money.fromDecimal(100.00);
      final money2 = Money.fromDecimal(50.50);
      final result = money1 + money2;
      expect(result.asDecimal, 150.50);
    });

    test('should subtract money amounts', () {
      final money1 = Money.fromDecimal(100.00);
      final money2 = Money.fromDecimal(30.00);
      final result = money1 - money2;
      expect(result.asDecimal, 70.00);
    });

    test('should throw when adding different currencies', () {
      final money1 = Money.fromDecimal(100.00, currency: 'AUD');
      final money2 = Money.fromDecimal(50.00, currency: 'USD');
      expect(() => money1 + money2, throwsArgumentError);
    });

    test('should support equality comparison', () {
      final money1 = Money.fromDecimal(100.00);
      final money2 = Money.fromDecimal(100.00);
      final money3 = Money.fromDecimal(50.00);
      expect(money1, equals(money2));
      expect(money1, isNot(equals(money3)));
    });

    test('should round correctly to minor units', () {
      final money = Money.fromDecimal(12.345);
      expect(money.minorUnits, 1235); // Rounds to nearest cent
    });
  });
}
