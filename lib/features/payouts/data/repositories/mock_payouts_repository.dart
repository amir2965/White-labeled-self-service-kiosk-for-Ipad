import 'dart:math';
import '../../domain/models/balance_snapshot.dart';
import '../../domain/models/bank_account.dart';
import '../../domain/models/instant_transfer_config.dart';
import '../../domain/models/money.dart';
import '../../domain/models/payout_status.dart';
import '../../domain/models/settlement.dart';
import '../../domain/repositories/payouts_repository.dart';

/// Mock implementation of PayoutsRepository with realistic sample data
class MockPayoutsRepository implements PayoutsRepository {
  final Random _random = Random();
  BankAccount? _linkedAccount;
  InstantTransferConfig _instantTransferConfig = InstantTransferConfig(
    enabled: true,
    feeRate: 0.015,
    minAmount: Money.fromDecimal(1.00),
    maxAmount: Money.fromDecimal(10000.00),
    bankLinked: false,
  );

  /// Simulates network latency
  Future<void> _simulateDelay() async {
    await Future.delayed(Duration(milliseconds: 300 + _random.nextInt(700)));
  }

  @override
  Future<BalanceSnapshot> getBalance() async {
    await _simulateDelay();
    return BalanceSnapshot(
      available: Money.fromDecimal(0.00),
      pending: Money.fromDecimal(0.00),
      inTransit: Money.fromDecimal(0.00),
      asOf: DateTime.now(),
    );
  }

  @override
  Future<List<Settlement>> getSettlements({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    await _simulateDelay();

    // Generate mock settlements for the date range
    final settlements = <Settlement>[];
    final now = DateTime.now();
    final daysDiff = endDate.difference(startDate).inDays;

    // Generate 0-3 settlements per week in the range
    final numSettlements = (daysDiff / 7 * _random.nextInt(4)).round();

    for (var i = 0; i < numSettlements; i++) {
      final settledDate = startDate.add(
        Duration(days: _random.nextInt(daysDiff + 1)),
      );

      final gross = Money.fromDecimal(100.0 + _random.nextDouble() * 2000.0);
      final fees = Money.fromDecimal(gross.asDecimal * 0.029);
      final gst = Money.fromDecimal(fees.asDecimal * 0.1);
      final netPaid = gross - fees - gst;

      final statuses = [
        PayoutStatus.paid,
        PayoutStatus.paid,
        PayoutStatus.paid,
        PayoutStatus.processing,
        PayoutStatus.pending,
      ];

      settlements.add(
        Settlement(
          id: 'po_${settledDate.millisecondsSinceEpoch}_$i',
          createdAt: settledDate,
          periodStart: settledDate.subtract(const Duration(days: 1)),
          periodEnd: settledDate,
          gross: gross,
          fees: fees,
          gst: gst,
          netPaid: netPaid,
          status: statuses[_random.nextInt(statuses.length)],
          destinationBankLast4: _linkedAccount?.accountLast4 ?? '1234',
          reference:
              'REF${settledDate.millisecondsSinceEpoch.toString().substring(5)}',
          failureReason: null,
        ),
      );
    }

    // Sort by createdAt descending
    settlements.sort((a, b) => b.createdAt.compareTo(a.createdAt));

    return settlements;
  }

  @override
  Future<Settlement> getSettlementById(String id) async {
    await _simulateDelay();

    // Return a mock settlement
    final now = DateTime.now();
    final gross = Money.fromDecimal(1250.50);
    final fees = Money.fromDecimal(36.26);
    final gst = Money.fromDecimal(3.63);
    final netPaid = gross - fees - gst;

    return Settlement(
      id: id,
      createdAt: now.subtract(const Duration(days: 2)),
      periodStart: now.subtract(const Duration(days: 3)),
      periodEnd: now.subtract(const Duration(days: 2)),
      gross: gross,
      fees: fees,
      gst: gst,
      netPaid: netPaid,
      status: PayoutStatus.paid,
      destinationBankLast4: _linkedAccount?.accountLast4 ?? '1234',
      reference: 'REF${now.millisecondsSinceEpoch.toString().substring(5)}',
      failureReason: null,
    );
  }

  @override
  Future<BankAccount?> getLinkedBankAccount() async {
    await _simulateDelay();
    return _linkedAccount;
  }

  @override
  Future<BankAccount> linkBankAccount({
    required String bankName,
    required String accountName,
    required String bsb,
    required String accountNumber,
  }) async {
    await _simulateDelay();

    final cardType = BankAccount.detectCardType(accountNumber);

    final account = BankAccount(
      id: 'ba_${DateTime.now().millisecondsSinceEpoch}',
      bankName: bankName,
      accountName: accountName,
      bsbMasked: BankAccount.maskBsb(),
      accountLast4: accountNumber.substring(accountNumber.length - 4),
      isVerified: false,
      verificationStatus: VerificationStatus.pending,
      cardType: cardType,
    );

    _linkedAccount = account;
    _instantTransferConfig = _instantTransferConfig.copyWith(bankLinked: true);

    return account;
  }

  @override
  Future<BankAccount> updateBankAccount(BankAccount account) async {
    await _simulateDelay();
    _linkedAccount = account;
    return account;
  }

  @override
  Future<void> removeBankAccount() async {
    await _simulateDelay();
    _linkedAccount = null;
    _instantTransferConfig = _instantTransferConfig.copyWith(bankLinked: false);
  }

  @override
  Future<InstantTransferConfig> getInstantTransferConfig() async {
    await _simulateDelay();
    return _instantTransferConfig.copyWith(bankLinked: _linkedAccount != null);
  }

  @override
  Future<InstantTransferConfig> updateInstantTransferConfig(
    InstantTransferConfig config,
  ) async {
    await _simulateDelay();
    _instantTransferConfig = config;
    return config;
  }

  @override
  Future<Settlement> initiateInstantTransfer() async {
    await _simulateDelay();

    if (_linkedAccount == null) {
      throw Exception('No bank account linked');
    }

    final balance = await getBalance();
    if (balance.available.minorUnits <= 0) {
      throw Exception('Insufficient balance');
    }

    final now = DateTime.now();
    final fee = _instantTransferConfig.calculateFee(balance.available);
    final netPaid = balance.available - fee;

    return Settlement(
      id: 'po_instant_${now.millisecondsSinceEpoch}',
      createdAt: now,
      periodStart: now,
      periodEnd: now,
      gross: balance.available,
      fees: fee,
      gst: Money.fromDecimal(0),
      netPaid: netPaid,
      status: PayoutStatus.processing,
      destinationBankLast4: _linkedAccount!.accountLast4,
      reference: 'INSTANT${now.millisecondsSinceEpoch.toString().substring(5)}',
      failureReason: null,
    );
  }
}
