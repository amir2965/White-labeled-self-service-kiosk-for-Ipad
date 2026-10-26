import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/widgets/app_button.dart';

class BusinessInfoStep extends StatefulWidget {
  final String businessName;
  final String? abn;
  final String contactEmail;
  final Function(String name, String? abn, String email) onChanged;
  final VoidCallback? onBack;
  final VoidCallback? onContinue;

  const BusinessInfoStep({
    super.key,
    required this.businessName,
    this.abn,
    required this.contactEmail,
    required this.onChanged,
    this.onBack,
    this.onContinue,
  });

  @override
  State<BusinessInfoStep> createState() => _BusinessInfoStepState();
}

class _BusinessInfoStepState extends State<BusinessInfoStep> {
  late TextEditingController _businessNameController;
  late TextEditingController _abnController;
  late TextEditingController _emailController;
  final ScrollController _scrollController = ScrollController();
  final FocusNode _businessNameFocus = FocusNode();
  final FocusNode _abnFocus = FocusNode();
  final FocusNode _emailFocus = FocusNode();
  double _scrollOffset = 0.0;
  double _maxScrollExtent = 1.0;
  bool _showScrollIndicator = false;

  final GlobalKey _businessNameKey = GlobalKey();
  final GlobalKey _abnKey = GlobalKey();
  final GlobalKey _emailKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _businessNameController = TextEditingController(text: widget.businessName);
    _abnController = TextEditingController(text: widget.abn ?? '');
    _emailController = TextEditingController(text: widget.contactEmail);
    _scrollController.addListener(_onScroll);

    // Add focus listeners to scroll to field when focused
    _businessNameFocus.addListener(() => _onFocusChange(_businessNameKey));
    _abnFocus.addListener(() => _onFocusChange(_abnKey));
    _emailFocus.addListener(() => _onFocusChange(_emailKey));

    Future.delayed(Duration(milliseconds: 500), () {
      if (mounted && _scrollController.hasClients) {
        setState(() {
          _maxScrollExtent = _scrollController.position.maxScrollExtent;
          _showScrollIndicator = _maxScrollExtent > 50;
        });
      }
    });
  }

  @override
  void dispose() {
    _businessNameController.dispose();
    _abnController.dispose();
    _emailController.dispose();
    _scrollController.dispose();
    _businessNameFocus.dispose();
    _abnFocus.dispose();
    _emailFocus.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (mounted) {
      setState(() {
        _scrollOffset = _scrollController.offset;
        _maxScrollExtent = _scrollController.position.maxScrollExtent;
      });
    }
  }

  void _notifyChange() {
    widget.onChanged(
      _businessNameController.text,
      _abnController.text.isEmpty ? null : _abnController.text,
      _emailController.text,
    );
  }

  void _onFocusChange(GlobalKey fieldKey) {
    if (!_scrollController.hasClients) return;

    // Wait for keyboard to start appearing
    Future.delayed(Duration(milliseconds: 50), () {
      if (!mounted) return;

      final RenderBox? renderBox =
          fieldKey.currentContext?.findRenderObject() as RenderBox?;
      if (renderBox == null) return;

      final position = renderBox.localToGlobal(Offset.zero);
      final fieldHeight = renderBox.size.height;
      final screenHeight = MediaQuery.of(context).size.height;
      final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;

      // If keyboard is visible
      if (keyboardHeight > 0) {
        // Calculate visible area above keyboard
        final visibleHeight = screenHeight - keyboardHeight;

        // Position field at 40% from top of visible area (upper third)
        final targetY = visibleHeight * 0.4;

        // Calculate how much to scroll
        final currentScroll = _scrollController.offset;
        final scrollAmount = position.dy - targetY;
        final targetScroll = currentScroll + scrollAmount;

        // Ensure within bounds
        final maxScroll = _scrollController.position.maxScrollExtent;
        final finalScroll = targetScroll.clamp(0.0, maxScroll);

        _scrollController.animateTo(
          finalScroll,
          duration: Duration(milliseconds: 250),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth >= 768;
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;

    return Listener(
      behavior: HitTestBehavior.translucent,
      onPointerSignal: (event) {
        if (event is PointerScrollEvent && _scrollController.hasClients) {
          final maxScroll = _scrollController.position.maxScrollExtent;
          final target = (_scrollController.offset + event.scrollDelta.dy)
              .clamp(0.0, maxScroll);
          _scrollController.jumpTo(target);
        }
      },
      child: Stack(
        children: [
          SingleChildScrollView(
            controller: _scrollController,
            physics: AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.only(
              left: isTablet ? 48.0 : AppSpacing.screenPadding,
              right: isTablet ? 48.0 : AppSpacing.screenPadding,
              top: AppSpacing.lg,
              bottom: AppSpacing.lg + keyboardHeight,
            ),
            child: Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: isTablet ? 600.0 : screenWidth,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Tell us about your business',
                      style: AppTypography.h2,
                    ),
                    SizedBox(height: 8),
                    Text(
                      'We\'ll use this information for your receipts',
                      style: AppTypography.bodyMedium.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    SizedBox(height: AppSpacing.xl),

                    TextField(
                      key: _businessNameKey,
                      controller: _businessNameController,
                      focusNode: _businessNameFocus,
                      decoration: InputDecoration(
                        labelText: 'Business Name',
                        hintText: 'e.g., Blue Bottle Coffee',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      style: AppTypography.bodyLarge,
                      onChanged: (_) => _notifyChange(),
                    ),

                    SizedBox(height: AppSpacing.lg),

                    TextField(
                      key: _abnKey,
                      controller: _abnController,
                      focusNode: _abnFocus,
                      decoration: InputDecoration(
                        labelText: 'ABN (Optional)',
                        hintText: '12 345 678 901',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      style: AppTypography.bodyLarge,
                      onChanged: (_) => _notifyChange(),
                    ),

                    SizedBox(height: AppSpacing.lg),

                    TextField(
                      key: _emailKey,
                      controller: _emailController,
                      focusNode: _emailFocus,
                      decoration: InputDecoration(
                        labelText: 'Contact Email',
                        hintText: 'contact@business.com',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      style: AppTypography.bodyLarge,
                      keyboardType: TextInputType.emailAddress,
                      onChanged: (_) => _notifyChange(),
                    ),

                    SizedBox(height: AppSpacing.md),

                    // Inline navigation button
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        AppButton(
                          label: 'Continue',
                          onPressed: widget.onContinue,
                          size: AppButtonSize.large,
                        ),
                      ],
                    ),

                    SizedBox(height: AppSpacing.xs),
                  ],
                ),
              ),
            ),
          ),

          if (_showScrollIndicator && _maxScrollExtent > 50)
            _buildScrollIndicator(isTablet),
        ],
      ),
    );
  }

  Widget _buildScrollIndicator(bool isTablet) {
    final screenHeight = MediaQuery.of(context).size.height;
    final indicatorHeight = isTablet ? 120.0 : 80.0;
    final trackHeight = screenHeight * 0.6;

    double thumbPosition = 0.0;
    if (_maxScrollExtent > 0) {
      thumbPosition =
          (_scrollOffset / _maxScrollExtent) * (trackHeight - indicatorHeight);
      thumbPosition = thumbPosition.clamp(0.0, trackHeight - indicatorHeight);
    }

    return Positioned(
      right: isTablet ? 16 : 8,
      top: screenHeight * 0.2,
      child: AnimatedOpacity(
        opacity: _scrollOffset > 20 ? 1.0 : 0.3,
        duration: Duration(milliseconds: 200),
        child: Container(
          width: isTablet ? 6 : 4,
          height: trackHeight,
          decoration: BoxDecoration(
            color: AppColors.gray200.withOpacity(0.3),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Stack(
            children: [
              AnimatedPositioned(
                duration: Duration(milliseconds: 100),
                curve: Curves.easeOut,
                top: thumbPosition,
                left: 0,
                right: 0,
                child: Container(
                  height: indicatorHeight,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColors.blue.withOpacity(0.8),
                        AppColors.blue.withOpacity(0.4),
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.blue.withOpacity(0.3),
                        blurRadius: 8,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
