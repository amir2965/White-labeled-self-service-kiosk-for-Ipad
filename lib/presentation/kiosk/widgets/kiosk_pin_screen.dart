import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_typography.dart';

/// Modern PIN entry screen for exiting kiosk mode
class KioskPinScreen extends StatefulWidget {
  final String correctPin;
  final VoidCallback onCorrectPin;

  const KioskPinScreen({
    super.key,
    this.correctPin = '1234',
    required this.onCorrectPin,
  });

  @override
  State<KioskPinScreen> createState() => _KioskPinScreenState();
}

class _KioskPinScreenState extends State<KioskPinScreen>
    with SingleTickerProviderStateMixin {
  String _enteredPin = '';
  bool _isError = false;
  late AnimationController _shakeController;
  late Animation<double> _shakeAnimation;

  @override
  void initState() {
    super.initState();
    _shakeController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _shakeAnimation = Tween<double>(begin: 0, end: 10).animate(
      CurvedAnimation(parent: _shakeController, curve: Curves.elasticIn),
    );
  }

  @override
  void dispose() {
    _shakeController.dispose();
    super.dispose();
  }

  void _onNumberTap(String number) {
    if (_enteredPin.length < 4) {
      HapticFeedback.lightImpact();
      setState(() {
        _enteredPin += number;
        _isError = false;
      });

      // Check PIN when 4 digits entered
      if (_enteredPin.length == 4) {
        _checkPin();
      }
    }
  }

  void _onBackspace() {
    if (_enteredPin.isNotEmpty) {
      HapticFeedback.lightImpact();
      setState(() {
        _enteredPin = _enteredPin.substring(0, _enteredPin.length - 1);
        _isError = false;
      });
    }
  }

  void _checkPin() {
    Future.delayed(const Duration(milliseconds: 200), () {
      if (_enteredPin == widget.correctPin) {
        HapticFeedback.heavyImpact();
        // Success - exit kiosk mode
        widget.onCorrectPin();
      } else {
        // Wrong PIN - shake and reset
        HapticFeedback.vibrate();
        _shakeController.forward().then((_) {
          _shakeController.reverse();
        });
        setState(() {
          _isError = true;
        });
        Future.delayed(const Duration(milliseconds: 800), () {
          if (mounted) {
            setState(() {
              _enteredPin = '';
              _isError = false;
            });
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.gray900.withOpacity(0.98),
            AppColors.black.withOpacity(0.98),
          ],
        ),
      ),
      child: Center(
        child: Container(
          width: 400,
          padding: EdgeInsets.all(AppSpacing.xl),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 30,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Title
              Text(
                'Exit Kiosk Mode',
                style: AppTypography.h2.copyWith(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: AppSpacing.xs),
              Text(
                'Enter 4-digit PIN',
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.gray600,
                  fontSize: 14,
                ),
              ),
              SizedBox(height: AppSpacing.xl),

              // PIN dots
              AnimatedBuilder(
                animation: _shakeAnimation,
                builder: (context, child) {
                  return Transform.translate(
                    offset: Offset(_shakeAnimation.value, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(4, (index) {
                        final isFilled = index < _enteredPin.length;
                        return Container(
                          margin: EdgeInsets.symmetric(horizontal: 12),
                          width: 16,
                          height: 16,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _isError
                                ? Colors.red.withOpacity(0.2)
                                : (isFilled
                                      ? AppColors.black
                                      : AppColors.gray300),
                            border: Border.all(
                              color: _isError
                                  ? Colors.red
                                  : (isFilled
                                        ? AppColors.black
                                        : AppColors.gray400),
                              width: 2,
                            ),
                          ),
                        );
                      }),
                    ),
                  );
                },
              ),

              if (_isError) ...[
                SizedBox(height: AppSpacing.sm),
                Text(
                  'Incorrect PIN',
                  style: AppTypography.bodySmall.copyWith(
                    color: Colors.red,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],

              SizedBox(height: AppSpacing.xl),

              // Number pad
              GridView.count(
                shrinkWrap: true,
                crossAxisCount: 3,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 1.3,
                children: [
                  _buildNumberButton('1'),
                  _buildNumberButton('2'),
                  _buildNumberButton('3'),
                  _buildNumberButton('4'),
                  _buildNumberButton('5'),
                  _buildNumberButton('6'),
                  _buildNumberButton('7'),
                  _buildNumberButton('8'),
                  _buildNumberButton('9'),
                  _buildIconButton(
                    Icons.close,
                    onTap: () => Navigator.pop(context),
                  ),
                  _buildNumberButton('0'),
                  _buildIconButton(
                    Icons.backspace_outlined,
                    onTap: _onBackspace,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNumberButton(String number) {
    return Material(
      color: AppColors.background,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: () => _onNumberTap(number),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.gray300),
          ),
          child: Center(
            child: Text(
              number,
              style: AppTypography.h2.copyWith(
                fontSize: 28,
                fontWeight: FontWeight.w600,
                color: AppColors.gray900,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildIconButton(IconData icon, {required VoidCallback onTap}) {
    return Material(
      color: AppColors.background,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.gray300),
          ),
          child: Center(child: Icon(icon, color: AppColors.gray700, size: 28)),
        ),
      ),
    );
  }
}
