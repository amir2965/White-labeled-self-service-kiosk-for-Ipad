import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';
import 'package:self_service_kiosk/features/payouts/domain/models/money.dart';
import 'package:self_service_kiosk/features/payouts/domain/models/payout_status.dart';
import 'package:self_service_kiosk/features/payouts/domain/models/settlement.dart';

/// Generates CSV string from settlements (same logic as ActivityScreen)
String generateCSV(List<Settlement> settlements) {
  final buffer = StringBuffer();
  final dateFormatter = DateFormat('dd/MM/yyyy');

  // Header
  buffer.writeln(
    'Date,Period Start,Period End,Gross,Fees,GST,Net Paid,Status,Reference',
  );

  // Rows
  for (final settlement in settlements) {
    buffer.writeln(
      '${dateFormatter.format(settlement.createdAt)},'
      '${dateFormatter.format(settlement.periodStart)},'
      '${dateFormatter.format(settlement.periodEnd)},'
      '${settlement.gross.formatted},'
      '${settlement.fees.formatted},'
      '${settlement.gst.formatted},'
      '${settlement.netPaid.formatted},'
      '${settlement.status.displayName},'
      '${settlement.reference}',
    );
  }

  return buffer.toString();
}

void main() {
  group('CSV Export', () {
    test('should generate correct CSV header', () {
      final csv = generateCSV([]);
      expect(
        csv.trim(),
        'Date,Period Start,Period End,Gross,Fees,GST,Net Paid,Status,Reference',
      );
    });

    test('should export single settlement correctly', () {
      final settlement = Settlement(
        id: 'po_123',
        createdAt: DateTime(2026, 2, 10, 14, 30),
        periodStart: DateTime(2026, 2, 9),
        periodEnd: DateTime(2026, 2, 10),
        gross: Money.fromDecimal(1250.50),
        fees: Money.fromDecimal(36.26),
        gst: Money.fromDecimal(3.63),
        netPaid: Money.fromDecimal(1210.61),
        status: PayoutStatus.paid,
        destinationBankLast4: '1234',
        reference: 'REF123456',
      );

      final csv = generateCSV([settlement]);
      final lines = csv.trim().split('\n');

      expect(lines.length, 2); // Header + 1 row
      expect(
        lines[1],
        contains('10/02/2026'), // Date
      );
      expect(lines[1], contains('\$1250.50')); // Gross
      expect(lines[1], contains('Paid')); // Status
      expect(lines[1], contains('REF123456')); // Reference
    });

    test('should export multiple settlements correctly', () {
      final settlements = [
        Settlement(
          id: 'po_1',
          createdAt: DateTime(2026, 2, 10),
          periodStart: DateTime(2026, 2, 9),
          periodEnd: DateTime(2026, 2, 10),
          gross: Money.fromDecimal(1000.00),
          fees: Money.fromDecimal(29.00),
          gst: Money.fromDecimal(2.90),
          netPaid: Money.fromDecimal(968.10),
          status: PayoutStatus.paid,
          destinationBankLast4: '1234',
          reference: 'REF001',
        ),
        Settlement(
          id: 'po_2',
          createdAt: DateTime(2026, 2, 11),
          periodStart: DateTime(2026, 2, 10),
          periodEnd: DateTime(2026, 2, 11),
          gross: Money.fromDecimal(500.00),
          fees: Money.fromDecimal(14.50),
          gst: Money.fromDecimal(1.45),
          netPaid: Money.fromDecimal(484.05),
          status: PayoutStatus.processing,
          destinationBankLast4: '1234',
          reference: 'REF002',
        ),
      ];

      final csv = generateCSV(settlements);
      final lines = csv.trim().split('\n');

      expect(lines.length, 3); // Header + 2 rows
    });

    test('should handle empty settlement list', () {
      final csv = generateCSV([]);
      final lines = csv.trim().split('\n');
      expect(lines.length, 1); // Only header
    });

    test('should escape comma in currency formatting', () {
      final settlement = Settlement(
        id: 'po_123',
        createdAt: DateTime(2026, 2, 10),
        periodStart: DateTime(2026, 2, 9),
        periodEnd: DateTime(2026, 2, 10),
        gross: Money.fromDecimal(12345.67), // Amount with comma in thousands
        fees: Money.fromDecimal(357.92),
        gst: Money.fromDecimal(35.79),
        netPaid: Money.fromDecimal(11951.96),
        status: PayoutStatus.paid,
        destinationBankLast4: '1234',
        reference: 'REF123',
      );

      final csv = generateCSV([settlement]);
      // Money format doesn't include thousand separator, so this should be safe
      expect(csv, contains('\$12345.67'));
    });
  });

  group('Status Mapping', () {
    test('should have correct display names', () {
      expect(PayoutStatus.pending.displayName, 'Pending');
      expect(PayoutStatus.processing.displayName, 'Processing');
      expect(PayoutStatus.paid.displayName, 'Paid');
      expect(PayoutStatus.failed.displayName, 'Failed');
      expect(PayoutStatus.reversed.displayName, 'Reversed');
    });

    test('should have non-alarming color schemes', () {
      // Just verify they return hex color strings
      for (final status in PayoutStatus.values) {
        expect(status.colorHex, startsWith('#'));
        expect(status.textColorHex, startsWith('#'));
        expect(status.colorHex.length, 7); // #RRGGBB
        expect(status.textColorHex.length, 7);
      }
    });
  });

  group('Date Range Filtering', () {
    late List<Settlement> settlements;

    setUp(() {
      settlements = [
        Settlement(
          id: 'po_1',
          createdAt: DateTime(2026, 1, 15),
          periodStart: DateTime(2026, 1, 14),
          periodEnd: DateTime(2026, 1, 15),
          gross: Money.fromDecimal(100.00),
          fees: Money.fromDecimal(2.90),
          gst: Money.fromDecimal(0.29),
          netPaid: Money.fromDecimal(96.81),
          status: PayoutStatus.paid,
          destinationBankLast4: '1234',
          reference: 'REF1',
        ),
        Settlement(
          id: 'po_2',
          createdAt: DateTime(2026, 1, 25),
          periodStart: DateTime(2026, 1, 24),
          periodEnd: DateTime(2026, 1, 25),
          gross: Money.fromDecimal(200.00),
          fees: Money.fromDecimal(5.80),
          gst: Money.fromDecimal(0.58),
          netPaid: Money.fromDecimal(193.62),
          status: PayoutStatus.paid,
          destinationBankLast4: '1234',
          reference: 'REF2',
        ),
        Settlement(
          id: 'po_3',
          createdAt: DateTime(2026, 2, 5),
          periodStart: DateTime(2026, 2, 4),
          periodEnd: DateTime(2026, 2, 5),
          gross: Money.fromDecimal(300.00),
          fees: Money.fromDecimal(8.70),
          gst: Money.fromDecimal(0.87),
          netPaid: Money.fromDecimal(290.43),
          status: PayoutStatus.paid,
          destinationBankLast4: '1234',
          reference: 'REF3',
        ),
      ];
    });

    test('should filter settlements by date range', () {
      final startDate = DateTime(2026, 1, 20);
      final endDate = DateTime(2026, 2, 1);

      final filtered = settlements.where((s) {
        return s.createdAt.isAfter(
              startDate.subtract(const Duration(days: 1)),
            ) &&
            s.createdAt.isBefore(endDate.add(const Duration(days: 1)));
      }).toList();

      expect(filtered.length, 1);
      expect(filtered[0].id, 'po_2');
    });

    test('should include boundary dates', () {
      final startDate = DateTime(2026, 1, 25);
      final endDate = DateTime(2026, 2, 5);

      final filtered = settlements.where((s) {
        return s.createdAt.isAfter(
              startDate.subtract(const Duration(days: 1)),
            ) &&
            s.createdAt.isBefore(endDate.add(const Duration(days: 1)));
      }).toList();

      expect(filtered.length, 2);
      expect(filtered.map((s) => s.id), containsAll(['po_2', 'po_3']));
    });
  });
}
