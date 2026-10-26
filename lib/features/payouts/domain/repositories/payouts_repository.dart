import '../models/balance_snapshot.dart';
import '../models/bank_account.dart';
import '../models/instant_transfer_config.dart';
import '../models/settlement.dart';

/// Repository interface for payout-related data
abstract class PayoutsRepository {
  /// Fetches the current balance snapshot
  Future<BalanceSnapshot> getBalance();

  /// Fetches settlements within a date range
  /// Returns settlements sorted by createdAt descending (newest first)
  Future<List<Settlement>> getSettlements({
    required DateTime startDate,
    required DateTime endDate,
  });

  /// Fetches a single settlement by ID
  Future<Settlement> getSettlementById(String id);

  /// Fetches the linked bank account (if any)
  Future<BankAccount?> getLinkedBankAccount();

  /// Links a new bank account
  Future<BankAccount> linkBankAccount({
    required String bankName,
    required String accountName,
    required String bsb,
    required String accountNumber,
  });

  /// Updates the linked bank account
  Future<BankAccount> updateBankAccount(BankAccount account);

  /// Removes the linked bank account
  Future<void> removeBankAccount();

  /// Fetches instant transfer configuration
  Future<InstantTransferConfig> getInstantTransferConfig();

  /// Updates instant transfer configuration
  Future<InstantTransferConfig> updateInstantTransferConfig(
    InstantTransferConfig config,
  );

  /// Initiates an instant transfer
  Future<Settlement> initiateInstantTransfer();
}
