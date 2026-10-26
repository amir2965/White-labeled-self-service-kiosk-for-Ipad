import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_spacing.dart';
import '../../core/constants/app_typography.dart';
import '../../core/widgets/app_button.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _confirmEmailController = TextEditingController();
  final _passwordController = TextEditingController();

  final _emailFocus = FocusNode();
  final _confirmEmailFocus = FocusNode();
  final _passwordFocus = FocusNode();

  bool _agreedToTerms = false;
  bool _obscurePassword = true;
  bool _isLoading = false;

  // Store initial screen dimensions for consistent gradient
  double? _initialScreenHeight;
  double? _initialScreenWidth;

  // Scroll controller and GlobalKeys for auto-scroll
  final ScrollController _scrollController = ScrollController();
  final GlobalKey _emailKey = GlobalKey();
  final GlobalKey _confirmEmailKey = GlobalKey();
  final GlobalKey _passwordKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    // Add focus listeners for auto-scroll
    _emailFocus.addListener(() => _onFocusChange(_emailKey));
    _confirmEmailFocus.addListener(() => _onFocusChange(_confirmEmailKey));
    _passwordFocus.addListener(() => _onFocusChange(_passwordKey));
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _emailController.dispose();
    _confirmEmailController.dispose();
    _passwordController.dispose();
    _emailFocus.dispose();
    _confirmEmailFocus.dispose();
    _passwordFocus.dispose();
    super.dispose();
  }

  // Auto-scroll to field when focused, positioning it above keyboard
  void _onFocusChange(GlobalKey fieldKey) {
    Future.delayed(Duration(milliseconds: 100), () {
      if (!mounted || !_scrollController.hasClients) return;

      final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;

      final RenderBox? renderBox =
          fieldKey.currentContext?.findRenderObject() as RenderBox?;
      if (renderBox == null) return;

      // Get field position relative to screen
      final position = renderBox.localToGlobal(Offset.zero);
      final fieldHeight = renderBox.size.height;

      // Calculate visible area
      final screenHeight =
          _initialScreenHeight ?? MediaQuery.of(context).size.height;

      // Label height: includes the label text and spacing
      final labelHeight = 50.0;

      // Calculate target position
      final double targetY;
      if (keyboardHeight > 0) {
        // When keyboard is visible: position in upper half
        final visibleArea = screenHeight - keyboardHeight;
        targetY = visibleArea * 0.30;
      } else {
        // When no keyboard: position comfortably
        targetY = screenHeight * 0.25;
      }

      // Calculate scroll amount accounting for label
      final scrollAmount = (position.dy - labelHeight) - targetY;

      final currentScroll = _scrollController.offset;
      final targetScroll = (currentScroll + scrollAmount).clamp(
        _scrollController.position.minScrollExtent,
        _scrollController.position.maxScrollExtent,
      );

      if (scrollAmount.abs() > 15) {
        _scrollController.animateTo(
          targetScroll,
          duration: Duration(milliseconds: 350),
          curve: Curves.easeOutCubic,
        );
      }
    });
  }

  void _handleSignup() async {
    if (!_formKey.currentState!.validate()) return;
    if (!_agreedToTerms) {
      _showError('Please agree to the terms and conditions');
      return;
    }

    setState(() => _isLoading = true);

    // Simulate API call
    await Future.delayed(Duration(milliseconds: 1500));

    setState(() => _isLoading = false);

    // Navigate to onboarding
    if (mounted) {
      context.go('/onboarding');
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red.shade700,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentScreenWidth = MediaQuery.of(context).size.width;
    final currentScreenHeight = MediaQuery.of(context).size.height;

    // Capture initial dimensions on first build
    _initialScreenHeight ??= currentScreenHeight;
    _initialScreenWidth ??= currentScreenWidth;

    final isTablet = currentScreenWidth >= 768;

    return Scaffold(
      backgroundColor: AppColors.black,
      resizeToAvoidBottomInset: false,
      body: SizedBox(
        width: _initialScreenWidth,
        height: _initialScreenHeight,
        child: Stack(
          children: [
            // Subtle gradient with fixed dimensions
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    center: Alignment(-0.3, -0.7),
                    radius: 1.2,
                    colors: [AppColors.blue.withOpacity(0.06), AppColors.black],
                  ),
                ),
              ),
            ),

            // Back button
            SafeArea(
              child: Padding(
                padding: EdgeInsets.all(AppSpacing.md),
                child: IconButton(
                  icon: Icon(Icons.arrow_back_rounded, color: Colors.white),
                  onPressed: () => context.pop(),
                ),
              ),
            ),

            // Main content
            Center(
              child: SingleChildScrollView(
                controller: _scrollController,
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom + 200,
                ),
                child: Container(
                  constraints: BoxConstraints(maxWidth: 480),
                  padding: EdgeInsets.symmetric(
                    horizontal: isTablet ? 60.0 : 32.0,
                    vertical: 40.0,
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Header
                        Text(
                          'Create Account',
                          style: TextStyle(
                            fontSize: isTablet ? 42 : 36,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                            letterSpacing: -1,
                          ),
                        ),

                        SizedBox(height: AppSpacing.sm),

                        Text(
                          'Start your journey to effortless self-service',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white.withOpacity(0.6),
                            letterSpacing: 0.2,
                          ),
                        ),

                        SizedBox(height: AppSpacing.xxl * 1.5),

                        // Email field
                        Column(
                          key: _emailKey,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            _buildLabel('Email Address'),
                            SizedBox(height: AppSpacing.xs),
                            _buildTextField(
                              controller: _emailController,
                              focusNode: _emailFocus,
                              hintText: 'you@company.com',
                              keyboardType: TextInputType.emailAddress,
                              validator: _validateEmail,
                              onFieldSubmitted: (_) {
                                _confirmEmailFocus.requestFocus();
                              },
                            ),
                          ],
                        ),

                        SizedBox(height: AppSpacing.lg),

                        // Confirm email field
                        Column(
                          key: _confirmEmailKey,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            _buildLabel('Confirm Email'),
                            SizedBox(height: AppSpacing.xs),
                            _buildTextField(
                              controller: _confirmEmailController,
                              focusNode: _confirmEmailFocus,
                              hintText: 'Confirm your email',
                              keyboardType: TextInputType.emailAddress,
                              validator: _validateConfirmEmail,
                              onFieldSubmitted: (_) {
                                _passwordFocus.requestFocus();
                              },
                            ),
                          ],
                        ),

                        SizedBox(height: AppSpacing.lg),

                        // Password field
                        Column(
                          key: _passwordKey,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            _buildLabel('Create Password'),
                            SizedBox(height: AppSpacing.xs),
                            _buildTextField(
                              controller: _passwordController,
                              focusNode: _passwordFocus,
                              hintText: 'At least 8 characters',
                              obscureText: _obscurePassword,
                              validator: _validatePassword,
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscurePassword
                                      ? Icons.visibility_off_rounded
                                      : Icons.visibility_rounded,
                                  color: Colors.white.withOpacity(0.4),
                                  size: 20,
                                ),
                                onPressed: () {
                                  setState(
                                    () => _obscurePassword = !_obscurePassword,
                                  );
                                },
                              ),
                              onFieldSubmitted: (_) {
                                if (_agreedToTerms) _handleSignup();
                              },
                            ),
                          ],
                        ),

                        SizedBox(height: AppSpacing.xl),

                        // Terms checkbox
                        Container(
                          padding: EdgeInsets.all(AppSpacing.md),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.03),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.08),
                              width: 1,
                            ),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: 24,
                                height: 24,
                                child: Checkbox(
                                  value: _agreedToTerms,
                                  onChanged: (value) {
                                    setState(
                                      () => _agreedToTerms = value ?? false,
                                    );
                                  },
                                  activeColor: AppColors.blue,
                                  checkColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  side: BorderSide(
                                    color: Colors.white.withOpacity(0.3),
                                    width: 1.5,
                                  ),
                                ),
                              ),
                              SizedBox(width: AppSpacing.sm),
                              Expanded(
                                child: RichText(
                                  text: TextSpan(
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.white.withOpacity(0.7),
                                      height: 1.5,
                                    ),
                                    children: [
                                      TextSpan(
                                        text:
                                            'I/We have read and are authorized to agree to the ',
                                      ),
                                      TextSpan(
                                        text: 'Seller Agreement',
                                        style: TextStyle(
                                          color: AppColors.blue,
                                          fontWeight: FontWeight.w600,
                                          decoration: TextDecoration.underline,
                                        ),
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = () {
                                            // TODO: Show seller agreement
                                          },
                                      ),
                                      TextSpan(text: ' and '),
                                      TextSpan(
                                        text: 'Privacy Policy',
                                        style: TextStyle(
                                          color: AppColors.blue,
                                          fontWeight: FontWeight.w600,
                                          decoration: TextDecoration.underline,
                                        ),
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = () {
                                            // TODO: Show privacy policy
                                          },
                                      ),
                                      TextSpan(text: '.'),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        SizedBox(height: AppSpacing.xxl),

                        // Sign up button
                        AppButton(
                          label: _isLoading ? 'Creating Account...' : 'Sign Up',
                          onPressed: _isLoading ? null : _handleSignup,
                          variant: AppButtonVariant.filled,
                          fullWidth: true,
                          icon: _isLoading ? null : Icons.arrow_forward_rounded,
                        ),

                        SizedBox(height: AppSpacing.lg),

                        // Sign in link
                        Center(
                          child: TextButton(
                            onPressed: () {
                              // TODO: Navigate to sign in
                              context.pop();
                            },
                            child: Text(
                              'Already have an account? Sign in',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.6),
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
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
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: Colors.white.withOpacity(0.9),
        letterSpacing: 0.3,
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required FocusNode focusNode,
    required String hintText,
    TextInputType? keyboardType,
    bool obscureText = false,
    String? Function(String?)? validator,
    Widget? suffixIcon,
    void Function(String)? onFieldSubmitted,
  }) {
    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      keyboardType: keyboardType,
      obscureText: obscureText,
      validator: validator,
      onFieldSubmitted: onFieldSubmitted,
      style: TextStyle(
        color: Colors.white,
        fontSize: 16,
        fontWeight: FontWeight.w500,
      ),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(
          color: Colors.white.withOpacity(0.3),
          fontWeight: FontWeight.w400,
        ),
        filled: true,
        fillColor: Colors.white.withOpacity(0.05),
        suffixIcon: suffixIcon,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: Colors.white.withOpacity(0.12),
            width: 1.5,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: Colors.white.withOpacity(0.12),
            width: 1.5,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.blue, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.red.shade400, width: 1.5),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.red.shade400, width: 2),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      ),
    );
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return 'Please enter a valid email';
    }
    return null;
  }

  String? _validateConfirmEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your email';
    }
    if (value != _emailController.text) {
      return 'Emails do not match';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 8) {
      return 'Password must be at least 8 characters';
    }
    return null;
  }
}
