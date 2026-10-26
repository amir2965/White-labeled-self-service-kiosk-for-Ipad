import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/mock_payouts_repository.dart';
import '../../domain/models/balance_snapshot.dart';
import '../../domain/models/bank_account.dart';
import '../../domain/models/instant_transfer_config.dart';
import '../../domain/models/settlement.dart';
import '../../domain/repositories/payouts_repository.dart';

/// Provider for the payouts repository
/// Replace with real API implementation in production
final payoutsRepositoryProvider = Provider<PayoutsRepository>((ref) {
  return MockPayoutsRepository();
});

/// Provider for current balance
final balanceProvider = FutureProvider<BalanceSnapshot>((ref) {
  final repository = ref.watch(payoutsRepositoryProvider);
  return repository.getBalance();
});

/// State notifier for date range selection
class DateRangeState {
  final DateTime startDate;
  final DateTime endDate;

  DateRangeState({required this.startDate, required this.endDate});

  DateRangeState copyWith({DateTime? startDate, DateTime? endDate}) {
    return DateRangeState(
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
    );
  }
}

class DateRangeNotifier extends StateNotifier<DateRangeState> {
  DateRangeNotifier()
    : super(
        DateRangeState(
          startDate: DateTime.now().subtract(const Duration(days: 30)),
          endDate: DateTime.now(),
        ),
      );

  void setDateRange(DateTime start, DateTime end) {
    state = DateRangeState(startDate: start, endDate: end);
  }

  void stepBackward() {
    final duration = state.endDate.difference(state.startDate);
    state = DateRangeState(
      startDate: state.startDate.subtract(duration),
      endDate: state.startDate,
    );
  }

  void stepForward() {
    final duration = state.endDate.difference(state.startDate);
    final newEndDate = state.endDate.add(duration);
    if (newEndDate.isAfter(DateTime.now())) {
      return; // Don't go into the future
    }
    state = DateRangeState(startDate: state.endDate, endDate: newEndDate);
  }

  void setLast30Days() {
    state = DateRangeState(
      startDate: DateTime.now().subtract(const Duration(days: 30)),
      endDate: DateTime.now(),
    );
  }

  void setLast90Days() {
    state = DateRangeState(
      startDate: DateTime.now().subtract(const Duration(days: 90)),
      endDate: DateTime.now(),
    );
  }

  void setThisMonth() {
    final now = DateTime.now();
    state = DateRangeState(
      startDate: DateTime(now.year, now.month, 1),
      endDate: now,
    );
  }

  void setLastMonth() {
    final now = DateTime.now();
    final lastMonth = DateTime(now.year, now.month - 1, 1);
    final lastMonthEnd = DateTime(
      now.year,
      now.month,
      1,
    ).subtract(const Duration(days: 1));
    state = DateRangeState(startDate: lastMonth, endDate: lastMonthEnd);
  }
}

final dateRangeProvider =
    StateNotifierProvider<DateRangeNotifier, DateRangeState>((ref) {
      return DateRangeNotifier();
    });

/// Provider for settlements based on date range
final settlementsProvider = FutureProvider<List<Settlement>>((ref) {
  final repository = ref.watch(payoutsRepositoryProvider);
  final dateRange = ref.watch(dateRangeProvider);

  return repository.getSettlements(
    startDate: dateRange.startDate,
    endDate: dateRange.endDate,
  );
});

/// Provider for a single settlement by ID
final settlementByIdProvider = FutureProvider.family<Settlement, String>((
  ref,
  id,
) {
  final repository = ref.watch(payoutsRepositoryProvider);
  return repository.getSettlementById(id);
});

/// Provider for linked bank account
final linkedBankAccountProvider = FutureProvider<BankAccount?>((ref) {
  final repository = ref.watch(payoutsRepositoryProvider);
  return repository.getLinkedBankAccount();
});

/// Provider for instant transfer config
final instantTransferConfigProvider = FutureProvider<InstantTransferConfig>((
  ref,
) {
  final repository = ref.watch(payoutsRepositoryProvider);
  return repository.getInstantTransferConfig();
});

/// State notifier for bank account form
class BankAccountFormState {
  final String bankName;
  final String accountName;
  final String bsb;
  final String accountNumber;
  final bool isSubmitting;
  final String? error;

  BankAccountFormState({
    this.bankName = '',
    this.accountName = '',
    this.bsb = '',
    this.accountNumber = '',
    this.isSubmitting = false,
    this.error,
  });

  BankAccountFormState copyWith({
    String? bankName,
    String? accountName,
    String? bsb,
    String? accountNumber,
    bool? isSubmitting,
    String? error,
  }) {
    return BankAccountFormState(
      bankName: bankName ?? this.bankName,
      accountName: accountName ?? this.accountName,
      bsb: bsb ?? this.bsb,
      accountNumber: accountNumber ?? this.accountNumber,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      error: error,
    );
  }

  bool get isValid {
    return bankName.isNotEmpty &&
        accountName.isNotEmpty &&
        bsb.replaceAll(RegExp(r'[^0-9]'), '').length == 6 &&
        accountNumber.replaceAll(RegExp(r'[^0-9]'), '').length >= 6;
  }
}

class BankAccountFormNotifier extends StateNotifier<BankAccountFormState> {
  BankAccountFormNotifier(this.ref) : super(BankAccountFormState());

  final Ref ref;

  void setBankName(String value) {
    state = state.copyWith(bankName: value);
  }

  void setAccountName(String value) {
    state = state.copyWith(accountName: value);
  }

  void setBsb(String value) {
    state = state.copyWith(bsb: value);
  }

  void setAccountNumber(String value) {
    state = state.copyWith(accountNumber: value);
  }

  Future<bool> submit() async {
    if (!state.isValid) {
      state = state.copyWith(error: 'Please fill all required fields');
      return false;
    }

    state = state.copyWith(isSubmitting: true, error: null);

    try {
      final repository = ref.read(payoutsRepositoryProvider);
      await repository.linkBankAccount(
        bankName: state.bankName,
        accountName: state.accountName,
        bsb: state.bsb,
        accountNumber: state.accountNumber,
      );

      // Refresh providers
      ref.invalidate(linkedBankAccountProvider);
      ref.invalidate(instantTransferConfigProvider);

      state = BankAccountFormState(); // Reset form
      return true;
    } catch (e) {
      state = state.copyWith(isSubmitting: false, error: e.toString());
      return false;
    }
  }

  void reset() {
    state = BankAccountFormState();
  }
}

final bankAccountFormProvider =
    StateNotifierProvider<BankAccountFormNotifier, BankAccountFormState>((ref) {
      return BankAccountFormNotifier(ref);
    });
