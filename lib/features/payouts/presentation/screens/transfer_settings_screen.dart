import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/payouts_providers.dart';
import '../widgets/bank_account_card.dart';
import '../widgets/pill_buttons.dart';
import '../../../../presentation/analytics/theme_provider.dart';

/// Transfer settings screen for instant transfers and bank account linking
class TransferSettingsScreen extends ConsumerStatefulWidget {
  const TransferSettingsScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<TransferSettingsScreen> createState() =>
      _TransferSettingsScreenState();
}

class _TransferSettingsScreenState
    extends ConsumerState<TransferSettingsScreen> {
  int _selectedTabIndex = 0;
  bool _hasChanges = false;
  final ScrollController _scrollController = ScrollController();
  final GlobalKey _tabsKey = GlobalKey();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToTabs() {
    if (_tabsKey.currentContext != null) {
      final RenderBox renderBox =
          _tabsKey.currentContext!.findRenderObject() as RenderBox;
      final position = renderBox.localToGlobal(Offset.zero);
      final scrollOffset = _scrollController.offset + position.dy - 100;

      _scrollController.animateTo(
        scrollOffset,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final configAsync = ref.watch(instantTransferConfigProvider);
    final linkedAccountAsync = ref.watch(linkedBankAccountProvider);
    final balanceAsync = ref.watch(balanceProvider);
    final isDarkMode = ref.watch(themeModeProvider);

    return Scaffold(
      backgroundColor: isDarkMode ? Color(0xFF1A1A1A) : Colors.grey.shade50,
      body: Stack(
        children: [
          SingleChildScrollView(
            controller: _scrollController,
            padding: const EdgeInsets.fromLTRB(0, 40, 0, 24),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 900),
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 16),

                      // Instant transfer card
                      Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: isDarkMode ? Color(0xFF2A2A2A) : Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: isDarkMode
                                ? Colors.white.withOpacity(0.15)
                                : Colors.grey.shade300,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(
                                isDarkMode ? 0.4 : 0.04,
                              ),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Instant transfer',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: isDarkMode
                                    ? Colors.white
                                    : Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 12),
                            configAsync.when(
                              data: (config) => Text(
                                'Instantly transfer your balance to your linked bank account for a ${config.feeRateFormatted} fee.',
                                style: TextStyle(
                                  fontSize: 15,
                                  color: isDarkMode
                                      ? Colors.white.withOpacity(0.7)
                                      : Colors.grey.shade700,
                                  height: 1.5,
                                ),
                              ),
                              loading: () => const SizedBox(),
                              error: (_, __) => const SizedBox(),
                            ),
                            const SizedBox(height: 24),

                            // Bank not linked callout
                            linkedAccountAsync.when(
                              data: (account) {
                                if (account == null) {
                                  return Container(
                                    padding: const EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      color: isDarkMode
                                          ? Color(0xFFFFB74D).withOpacity(0.15)
                                          : const Color(0xFFFFF4E5),
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                        color: const Color(0xFFFFB74D),
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        const Icon(
                                          Icons.info_outline,
                                          color: Color(0xFFF57C00),
                                          size: 20,
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: Text(
                                            'Please link a bank account before using instant transfers',
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: isDarkMode
                                                  ? Colors.white.withOpacity(
                                                      0.9,
                                                    )
                                                  : Colors.grey.shade800,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }
                                return const SizedBox();
                              },
                              loading: () => const SizedBox(),
                              error: (_, __) => const SizedBox(),
                            ),

                            linkedAccountAsync.when(
                              data: (account) {
                                if (account == null) {
                                  return Padding(
                                    padding: const EdgeInsets.only(top: 16),
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: TextButton(
                                        onPressed: () {
                                          setState(() {
                                            _selectedTabIndex = 1;
                                          });
                                          // Smooth scroll to tabs section
                                          Future.delayed(
                                            const Duration(milliseconds: 50),
                                            _scrollToTabs,
                                          );
                                        },
                                        child: const Text(
                                          'Link Bank Account',
                                          style: TextStyle(
                                            decoration:
                                                TextDecoration.underline,
                                            fontSize: 15,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                }
                                return const SizedBox();
                              },
                              loading: () => const SizedBox(),
                              error: (_, __) => const SizedBox(),
                            ),

                            const SizedBox(height: 24),

                            // Available amount display
                            balanceAsync.when(
                              data: (balance) => Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    balance.available.formatted,
                                    style: TextStyle(
                                      fontSize: 32,
                                      fontWeight: FontWeight.bold,
                                      color: isDarkMode
                                          ? Colors.white
                                          : Colors.black87,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    linkedAccountAsync.value == null
                                        ? 'INSTANT TRANSFER UNAVAILABLE'
                                        : 'AVAILABLE FOR INSTANT TRANSFER',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: isDarkMode
                                          ? Colors.white.withOpacity(0.6)
                                          : Colors.grey.shade600,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                ],
                              ),
                              loading: () => const SizedBox(),
                              error: (_, __) => const SizedBox(),
                            ),

                            const SizedBox(height: 24),

                            // Transfer now button
                            PrimaryPillButton(
                              label: balanceAsync.value != null
                                  ? 'Transfer ${balanceAsync.value!.available.formatted} now'
                                  : 'Transfer now',
                              onPressed:
                                  linkedAccountAsync.value != null &&
                                      balanceAsync.value != null &&
                                      balanceAsync.value!.available.minorUnits >
                                          0
                                  ? () {
                                      _showTransferConfirmation(
                                        context,
                                        isDarkMode,
                                      );
                                    }
                                  : null,
                            ),

                            const SizedBox(height: 32),
                            Divider(
                              color: isDarkMode
                                  ? Colors.white.withOpacity(0.15)
                                  : Colors.grey.shade300,
                              height: 1,
                            ),
                            const SizedBox(height: 24),

                            // Tabs
                            _TabBar(
                              key: _tabsKey,
                              selectedIndex: _selectedTabIndex,
                              onTabSelected: (index) {
                                setState(() {
                                  _selectedTabIndex = index;
                                });
                              },
                            ),

                            const SizedBox(height: 24),

                            // Tab content
                            if (_selectedTabIndex == 0)
                              _LinkedAccountTab(
                                linkedAccountAsync: linkedAccountAsync,
                                onRemove: () async {
                                  final confirmed = await _showRemoveDialog(
                                    context,
                                    isDarkMode,
                                  );
                                  if (confirmed == true && mounted) {
                                    try {
                                      final repository = ref.read(
                                        payoutsRepositoryProvider,
                                      );
                                      await repository.removeBankAccount();
                                      ref.invalidate(linkedBankAccountProvider);
                                      setState(() {
                                        _hasChanges = true;
                                      });
                                      if (mounted) {
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                              'Bank account removed successfully',
                                            ),
                                            backgroundColor: Color(0xFF4CAF50),
                                          ),
                                        );
                                      }
                                    } catch (e) {
                                      if (mounted) {
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              'Error removing account: $e',
                                            ),
                                            backgroundColor: Colors.red,
                                          ),
                                        );
                                      }
                                    }
                                  }
                                },
                              )
                            else
                              _LinkAccountTab(
                                onSuccess: () {
                                  _showVerificationDialog(context, isDarkMode);
                                  setState(() {
                                    _selectedTabIndex = 0;
                                    _hasChanges = true;
                                  });
                                },
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showTransferConfirmation(BuildContext context, bool isDarkMode) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: isDarkMode ? Color(0xFF2A2A2A) : Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: isDarkMode
              ? BorderSide(color: Colors.white.withOpacity(0.15))
              : BorderSide.none,
        ),
        title: Text(
          'Confirm Instant Transfer',
          style: TextStyle(color: isDarkMode ? Colors.white : Colors.black87),
        ),
        content: Text(
          'This feature is simulated in demo mode. In production, this would initiate an instant transfer to your linked bank account.',
          style: TextStyle(
            color: isDarkMode ? Colors.white.withOpacity(0.7) : Colors.black87,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            style: TextButton.styleFrom(
              foregroundColor: isDarkMode
                  ? Colors.white.withOpacity(0.7)
                  : Colors.black87,
            ),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Instant transfer initiated (demo)'),
                ),
              );
            },
            style: TextButton.styleFrom(
              foregroundColor: const Color(0xFF007AFF),
            ),
            child: const Text('Confirm'),
          ),
        ],
      ),
    );
  }

  void _showVerificationDialog(BuildContext context, bool isDarkMode) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        backgroundColor: isDarkMode ? Color(0xFF2A2A2A) : Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: isDarkMode
              ? BorderSide(color: Colors.white.withOpacity(0.15))
              : BorderSide.none,
        ),
        child: Container(
          constraints: const BoxConstraints(maxWidth: 400),
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: const Color(0xFF007AFF).withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.schedule,
                  size: 32,
                  color: Color(0xFF007AFF),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Under Review',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: isDarkMode ? Colors.white : Colors.black87,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Your card information will be reviewed shortly in the next couple of minutes. You\'ll be notified once verification is complete.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15,
                  color: isDarkMode
                      ? Colors.white.withOpacity(0.7)
                      : Colors.grey.shade700,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF007AFF),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Got it',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<bool?> _showRemoveDialog(BuildContext context, bool isDarkMode) {
    return showDialog<bool>(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: isDarkMode ? Color(0xFF2A2A2A) : Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: isDarkMode
              ? BorderSide(color: Colors.white.withOpacity(0.15))
              : BorderSide.none,
        ),
        child: Container(
          constraints: const BoxConstraints(maxWidth: 400),
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: Colors.red.shade50.withOpacity(isDarkMode ? 0.2 : 1.0),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.warning_rounded,
                  size: 32,
                  color: Colors.red.shade600,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Remove Account',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: isDarkMode ? Colors.white : Colors.black87,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Are you sure you want to remove this bank account? You won\'t be able to receive instant transfers until you link another account.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15,
                  color: isDarkMode
                      ? Colors.white.withOpacity(0.7)
                      : Colors.grey.shade700,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 32),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context, false),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: isDarkMode
                            ? Colors.white.withOpacity(0.9)
                            : Colors.black87,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        side: BorderSide(
                          color: isDarkMode
                              ? Colors.white.withOpacity(0.15)
                              : Colors.grey.shade300,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Cancel',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context, true),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red.shade600,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        'Remove',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TabBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onTabSelected;

  const _TabBar({
    Key? key,
    required this.selectedIndex,
    required this.onTabSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _TabButton(
            label: 'Linked account',
            isSelected: selectedIndex == 0,
            onTap: () => onTabSelected(0),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _TabButton(
            label: 'Link an account',
            isSelected: selectedIndex == 1,
            onTap: () => onTabSelected(1),
          ),
        ),
      ],
    );
  }
}

class _TabButton extends ConsumerWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _TabButton({
    Key? key,
    required this.label,
    required this.isSelected,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkMode = ref.watch(themeModeProvider);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: isSelected ? const Color(0xFF007AFF) : Colors.transparent,
              width: 2,
            ),
          ),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: isSelected
                ? const Color(0xFF007AFF)
                : (isDarkMode
                      ? Colors.white.withOpacity(0.6)
                      : Colors.grey.shade600),
          ),
        ),
      ),
    );
  }
}

class _LinkedAccountTab extends ConsumerWidget {
  final AsyncValue linkedAccountAsync;
  final VoidCallback? onRemove;

  const _LinkedAccountTab({
    Key? key,
    required this.linkedAccountAsync,
    this.onRemove,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkMode = ref.watch(themeModeProvider);

    return linkedAccountAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Text(
        'Error loading account: $error',
        style: TextStyle(color: isDarkMode ? Colors.red.shade400 : Colors.red),
      ),
      data: (account) {
        if (account == null) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Text(
                'No bank account linked',
                style: TextStyle(
                  fontSize: 15,
                  color: isDarkMode
                      ? Colors.white.withOpacity(0.6)
                      : Colors.grey.shade600,
                ),
              ),
            ),
          );
        }

        return BankAccountCard(account: account, onRemove: onRemove);
      },
    );
  }
}

class _LinkAccountTab extends ConsumerWidget {
  final VoidCallback onSuccess;

  const _LinkAccountTab({Key? key, required this.onSuccess}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formState = ref.watch(bankAccountFormProvider);
    final isDarkMode = ref.watch(themeModeProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (formState.error != null)
          Container(
            padding: const EdgeInsets.all(12),
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: isDarkMode
                  ? Colors.red.shade900.withOpacity(0.3)
                  : Colors.red.shade50,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: isDarkMode ? Colors.red.shade700 : Colors.red.shade300,
              ),
            ),
            child: Text(
              formState.error!,
              style: TextStyle(
                color: isDarkMode ? Colors.red.shade300 : Colors.red.shade700,
                fontSize: 14,
              ),
            ),
          ),

        _FormField(
          label: 'Bank Name',
          value: formState.bankName,
          onChanged: (value) {
            ref.read(bankAccountFormProvider.notifier).setBankName(value);
          },
          placeholder: 'e.g., Commonwealth Bank',
        ),
        const SizedBox(height: 16),

        _FormField(
          label: 'Account Name',
          value: formState.accountName,
          onChanged: (value) {
            ref.read(bankAccountFormProvider.notifier).setAccountName(value);
          },
          placeholder: 'e.g., John Smith',
        ),
        const SizedBox(height: 16),

        _FormField(
          label: 'BSB',
          value: formState.bsb,
          onChanged: (value) {
            ref.read(bankAccountFormProvider.notifier).setBsb(value);
          },
          placeholder: '123-456',
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'[0-9-]')),
            LengthLimitingTextInputFormatter(7),
          ],
        ),
        const SizedBox(height: 16),

        _FormField(
          label: 'Account Number',
          value: formState.accountNumber,
          onChanged: (value) {
            ref.read(bankAccountFormProvider.notifier).setAccountNumber(value);
          },
          placeholder: '12345678',
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(10),
          ],
        ),
        const SizedBox(height: 24),

        PrimaryPillButton(
          label: 'Link Account',
          isLoading: formState.isSubmitting,
          onPressed: formState.isValid && !formState.isSubmitting
              ? () async {
                  final success = await ref
                      .read(bankAccountFormProvider.notifier)
                      .submit();
                  if (success && context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Bank account linked successfully'),
                      ),
                    );
                    onSuccess();
                  }
                }
              : null,
        ),
      ],
    );
  }
}

class _FormField extends ConsumerWidget {
  final String label;
  final String value;
  final Function(String) onChanged;
  final String placeholder;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;

  const _FormField({
    Key? key,
    required this.label,
    required this.value,
    required this.onChanged,
    required this.placeholder,
    this.keyboardType,
    this.inputFormatters,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkMode = ref.watch(themeModeProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: isDarkMode ? Colors.white : Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: TextEditingController(text: value)
            ..selection = TextSelection.collapsed(offset: value.length),
          onChanged: onChanged,
          keyboardType: keyboardType,
          inputFormatters: inputFormatters,
          style: TextStyle(color: isDarkMode ? Colors.white : Colors.black87),
          decoration: InputDecoration(
            hintText: placeholder,
            hintStyle: TextStyle(
              color: isDarkMode
                  ? Colors.white.withOpacity(0.3)
                  : Colors.grey.shade400,
            ),
            filled: true,
            fillColor: isDarkMode
                ? Colors.white.withOpacity(0.05)
                : Colors.grey.shade50,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: isDarkMode
                    ? Colors.white.withOpacity(0.15)
                    : Colors.grey.shade300,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: isDarkMode
                    ? Colors.white.withOpacity(0.15)
                    : Colors.grey.shade300,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFF007AFF), width: 2),
            ),
            contentPadding: const EdgeInsets.all(16),
          ),
        ),
      ],
    );
  }
}
