import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:ui' show ImageFilter;
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_spacing.dart';
import '../../core/constants/app_typography.dart';
import '../../core/widgets/app_button.dart';
import '../../domain/entities/merchant.dart';
import '../kiosk/kiosk_welcome_screen.dart';
import '../kiosk/menu_template_config.dart';
import '../providers/menu_provider.dart';
import '../providers/template_provider.dart';
import '../providers/merchant_provider.dart';
import 'steps/business_info_step.dart';
import 'steps/business_type_step.dart';
import 'steps/template_selection_step.dart';
import 'steps/products_setup_step.dart';
import 'steps/payment_config_step.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  int _currentStep = 0;
  final _pageController = PageController();

  // Onboarding data
  String _businessName = '';
  String? _abn;
  String _contactEmail = '';
  BusinessType _businessType = BusinessType.cafe;
  String? _selectedTemplateId;
  MenuDisplayTemplate? _selectedTemplate;
  List<Map<String, dynamic>> _products = [];
  bool _payAtCounterEnabled = true;
  bool _qrPayEnabled = true;
  double _serviceFeePercent = 2.0;

  final List<String> _stepTitles = [
    'Business Info',
    'Business Type',
    'Add Products',
    'Choose Template',
    'Payment Settings',
  ];

  @override
  void initState() {
    super.initState();
    // Autofill demo data in debug mode to speed up testing
    if (kDebugMode) {
      _businessName = 'Demo Cafe';
      _abn = '12 345 678 901';
      _contactEmail = 'demo@cafe.com';
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextStep() {
    if (_currentStep < _stepTitles.length - 1) {
      // If moving from Add Products (step 2) to Choose Template (step 3),
      // import products into menu provider so templates can preview them
      if (_currentStep == 2 && _products.isNotEmpty) {
        final container = ProviderScope.containerOf(context);
        container.read(menuProvider.notifier).importUserProducts(_products);
      }

      setState(() {
        _currentStep++;
      });
      _pageController.animateToPage(
        _currentStep,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _completeOnboarding();
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
      });
      _pageController.animateToPage(
        _currentStep,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _completeOnboarding() {
    // Import user products to menu provider if any
    if (_products.isNotEmpty) {
      // Get the ref from context
      final container = ProviderScope.containerOf(context);
      container.read(menuProvider.notifier).importUserProducts(_products);
    }

    // Navigate to merchant dashboard
    context.go('/dashboard');
  }

  @override
  Widget build(BuildContext context) {
    final viewInsets = MediaQuery.of(context).viewInsets;
    final screenHeight = MediaQuery.of(context).size.height;
    final isKeyboardOpen = viewInsets.bottom > 50;

    // When keyboard is open, reduce header size
    final headerHeight = isKeyboardOpen ? 80.0 : 160.0;
    // Only step 0 (business info) has inline buttons, others use shared nav bar
    final hasInlineButtons = _currentStep == 0;
    final navHeight = hasInlineButtons ? 0.0 : (isKeyboardOpen ? 60.0 : 80.0);
    // Reduce available height more to ensure nav bar stays visible
    final availableHeight =
        screenHeight - viewInsets.bottom - headerHeight - navHeight - 20;

    return Scaffold(
      backgroundColor: AppColors.background,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Stack(
          children: [
            // Main content
            Positioned.fill(
              top: headerHeight,
              bottom: navHeight,
              child: PageView(
                controller: _pageController,
                physics: NeverScrollableScrollPhysics(),
                children: [
                  BusinessInfoStep(
                    businessName: _businessName,
                    abn: _abn,
                    contactEmail: _contactEmail,
                    onChanged: (name, abn, email) {
                      setState(() {
                        _businessName = name;
                        _abn = abn;
                        _contactEmail = email;
                      });
                    },
                    onBack: null,
                    onContinue: _canContinue() ? _nextStep : null,
                  ),
                  BusinessTypeStep(
                    selectedType: _businessType,
                    onSelected: (type) {
                      setState(() {
                        _businessType = type;
                      });
                    },
                  ),
                  ProductsSetupStep(
                    products: _products,
                    onProductsChanged: (products) {
                      setState(() {
                        _products = products;
                      });
                    },
                  ),
                  TemplateSelectionStep(
                    selectedTemplateId: _selectedTemplateId,
                    onSelected: (templateId, template) {
                      setState(() {
                        _selectedTemplateId = templateId;
                        _selectedTemplate = template;
                      });

                      final container = ProviderScope.containerOf(context);
                      // Save to both providers
                      container
                          .read(selectedTemplateProvider.notifier)
                          .selectTemplate(template);
                      container
                          .read(merchantProvider.notifier)
                          .updateTemplate(template);
                    },
                  ),
                  PaymentConfigStep(
                    payAtCounterEnabled: _payAtCounterEnabled,
                    qrPayEnabled: _qrPayEnabled,
                    serviceFeePercent: _serviceFeePercent,
                    onChanged: (payAtCounter, qrPay, feePercent) {
                      setState(() {
                        _payAtCounterEnabled = payAtCounter;
                        _qrPayEnabled = qrPay;
                        _serviceFeePercent = feePercent;
                      });
                    },
                  ),
                ],
              ),
            ),

            // Enhanced floating navigation bar with glass-morphism
            _buildEnhancedHeader(),

            // Bottom navigation bar (for stages without inline buttons)
            if (!hasInlineButtons)
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: _buildNavigationButtons(),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.all(AppSpacing.screenPadding),
      decoration: BoxDecoration(
        color: AppColors.white,
        border: Border(bottom: BorderSide(color: AppColors.divider)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Setup Your Kiosk', style: AppTypography.display2),
          SizedBox(height: AppSpacing.xs),
          Text(
            'Get started in under 10 minutes',
            style: AppTypography.bodyLarge.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressIndicator() {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.screenPadding,
        vertical: AppSpacing.lg,
      ),
      child: Row(
        children: List.generate(_stepTitles.length, (index) {
          final isActive = index == _currentStep;
          final isCompleted = index < _currentStep;

          return Expanded(
            child: Column(
              children: [
                Row(
                  children: [
                    if (index > 0)
                      Expanded(
                        child: Container(
                          height: 2,
                          color: isCompleted
                              ? AppColors.blue
                              : AppColors.gray300,
                        ),
                      ),
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isActive
                            ? AppColors.blue
                            : isCompleted
                            ? AppColors.blue
                            : AppColors.gray300,
                      ),
                      child: Center(
                        child: Text(
                          '${index + 1}',
                          style: AppTypography.label.copyWith(
                            color: isActive || isCompleted
                                ? AppColors.white
                                : AppColors.textSecondary,
                          ),
                        ),
                      ),
                    ),
                    if (index < _stepTitles.length - 1)
                      Expanded(
                        child: Container(
                          height: 2,
                          color: isCompleted
                              ? AppColors.blue
                              : AppColors.gray300,
                        ),
                      ),
                  ],
                ),
                SizedBox(height: AppSpacing.sm),
                Text(
                  _stepTitles[index],
                  style: AppTypography.caption.copyWith(
                    color: isActive
                        ? AppColors.textPrimary
                        : AppColors.textTertiary,
                    fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _buildNavigationButtons() {
    final viewInsets = MediaQuery.of(context).viewInsets;
    final isKeyboardOpen = viewInsets.bottom > 50;

    return Container(
      margin: EdgeInsets.only(top: AppSpacing.lg),
      padding: EdgeInsets.symmetric(
        horizontal: isKeyboardOpen ? 8.0 : AppSpacing.screenPadding,
        vertical: isKeyboardOpen ? 12.0 : AppSpacing.md,
      ),
      decoration: BoxDecoration(
        color: AppColors.white,
        border: Border(top: BorderSide(color: AppColors.divider)),
      ),
      child: Row(
        children: [
          if (_currentStep > 0)
            AppButton(
              label: 'Back',
              onPressed: _previousStep,
              variant: AppButtonVariant.outline,
            ),
          Spacer(),
          AppButton(
            label: _currentStep == _stepTitles.length - 1
                ? 'Complete Setup'
                : 'Continue',
            onPressed: _canContinue() ? _nextStep : null,
            size: AppButtonSize.large,
            fullWidth: false,
          ),
        ],
      ),
    );
  }

  bool _canContinue() {
    switch (_currentStep) {
      case 0:
        return _businessName.isNotEmpty && _contactEmail.isNotEmpty;
      case 1:
        return true; // Business type has default
      case 2:
        return _products.isNotEmpty;
      case 3:
        return _selectedTemplateId != null;
      case 4:
        return _payAtCounterEnabled || _qrPayEnabled;
      default:
        return false;
    }
  }

  Widget _buildEnhancedHeader() {
    final viewInsets = MediaQuery.of(context).viewInsets;
    final isKeyboardOpen = viewInsets.bottom > 50;

    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppColors.white.withOpacity(0.9),
                  AppColors.white.withOpacity(0.7),
                ],
              ),
              border: Border(
                bottom: BorderSide(
                  color: AppColors.blue.withOpacity(0.1),
                  width: 1,
                ),
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.black.withOpacity(0.03),
                  blurRadius: 20,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                // Header text - hide when keyboard is open
                if (!isKeyboardOpen)
                  Padding(
                    padding: EdgeInsets.fromLTRB(
                      AppSpacing.screenPadding,
                      AppSpacing.md,
                      AppSpacing.screenPadding,
                      AppSpacing.sm,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    AppColors.blue,
                                    AppColors.blue.withOpacity(0.8),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(8),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.blue.withOpacity(0.3),
                                    blurRadius: 8,
                                    offset: Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Icon(
                                Icons.storefront_rounded,
                                color: AppColors.white,
                                size: 20,
                              ),
                            ),
                            SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Setup Your Kiosk',
                                    style: AppTypography.h2,
                                  ),
                                  Text(
                                    'Get started in under 10 minutes',
                                    style: AppTypography.bodySmall.copyWith(
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                // Enhanced progress indicator
                _buildEnhancedProgressIndicator(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEnhancedProgressIndicator() {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.screenPadding,
        vertical: AppSpacing.md,
      ),
      child: Row(
        children: List.generate(_stepTitles.length, (index) {
          final isActive = index == _currentStep;
          final isCompleted = index < _currentStep;

          return Expanded(
            child: Column(
              children: [
                Row(
                  children: [
                    if (index > 0)
                      Expanded(
                        child: AnimatedContainer(
                          duration: Duration(milliseconds: 400),
                          height: 3,
                          decoration: BoxDecoration(
                            gradient: isCompleted
                                ? LinearGradient(
                                    colors: [
                                      AppColors.blue.withOpacity(0.6),
                                      AppColors.blue,
                                    ],
                                  )
                                : null,
                            color: isCompleted ? null : AppColors.gray300,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                    AnimatedContainer(
                      duration: Duration(milliseconds: 300),
                      width: isActive ? 40 : 32,
                      height: isActive ? 40 : 32,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: isActive || isCompleted
                            ? LinearGradient(
                                colors: [
                                  AppColors.blue,
                                  AppColors.blue.withOpacity(0.8),
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              )
                            : null,
                        color: isActive || isCompleted
                            ? null
                            : AppColors.gray300,
                        boxShadow: isActive
                            ? [
                                BoxShadow(
                                  color: AppColors.blue.withOpacity(0.4),
                                  blurRadius: 12,
                                  offset: Offset(0, 4),
                                ),
                              ]
                            : null,
                      ),
                      child: Center(
                        child: isCompleted
                            ? Icon(
                                Icons.check_rounded,
                                color: AppColors.white,
                                size: isActive ? 20 : 16,
                              )
                            : Text(
                                '${index + 1}',
                                style: AppTypography.label.copyWith(
                                  color: isActive || isCompleted
                                      ? AppColors.white
                                      : AppColors.textSecondary,
                                  fontWeight: isActive
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                ),
                              ),
                      ),
                    ),
                    if (index < _stepTitles.length - 1)
                      Expanded(
                        child: AnimatedContainer(
                          duration: Duration(milliseconds: 400),
                          height: 3,
                          decoration: BoxDecoration(
                            gradient: isCompleted
                                ? LinearGradient(
                                    colors: [
                                      AppColors.blue,
                                      AppColors.blue.withOpacity(0.6),
                                    ],
                                  )
                                : null,
                            color: isCompleted ? null : AppColors.gray300,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                  ],
                ),
                SizedBox(height: 8),
                Text(
                  _stepTitles[index],
                  style: AppTypography.caption.copyWith(
                    color: isActive
                        ? AppColors.blue
                        : isCompleted
                        ? AppColors.black
                        : AppColors.textSecondary,
                    fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
