import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_spacing.dart';
import '../../core/constants/app_typography.dart';
import '../../core/widgets/app_button.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late AnimationController _scrollIndicatorController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _scrollIndicatorAnimation;
  final ScrollController _scrollController = ScrollController();
  bool _showScrollIndicator = true;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(0.0, 0.6, curve: Curves.easeOut),
      ),
    );

    _slideAnimation = Tween<Offset>(begin: Offset(0, 0.3), end: Offset.zero)
        .animate(
          CurvedAnimation(
            parent: _controller,
            curve: Interval(0.2, 0.8, curve: Curves.easeOutCubic),
          ),
        );

    _controller.forward();

    // Scroll indicator animation (bounce effect)
    _scrollIndicatorController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);

    _scrollIndicatorAnimation = Tween<double>(begin: 0.0, end: 10.0).animate(
      CurvedAnimation(
        parent: _scrollIndicatorController,
        curve: Curves.easeInOut,
      ),
    );

    // Listen to scroll to hide indicator
    _scrollController.addListener(() {
      if (_scrollController.offset > 50 && _showScrollIndicator) {
        setState(() {
          _showScrollIndicator = false;
        });
      } else if (_scrollController.offset <= 50 && !_showScrollIndicator) {
        setState(() {
          _showScrollIndicator = true;
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollIndicatorController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isTablet = screenWidth >= 768;

    return Scaffold(
      backgroundColor: AppColors.black,
      body: Stack(
        children: [
          // Subtle gradient overlay
          Container(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: Alignment(0.3, -0.5),
                radius: 1.5,
                colors: [
                  AppColors.blue.withOpacity(0.08),
                  AppColors.black,
                  AppColors.black,
                ],
              ),
            ),
          ),

          // Main content - fully scrollable
          SingleChildScrollView(
            controller: _scrollController,
            physics: AlwaysScrollableScrollPhysics(),
            child: Container(
              constraints: BoxConstraints(
                minHeight: screenHeight,
                maxWidth: 600,
              ),
              padding: EdgeInsets.symmetric(horizontal: isTablet ? 80.0 : 32.0),
              margin: EdgeInsets.symmetric(
                horizontal: screenWidth > 600 ? (screenWidth - 600) / 2 : 0,
              ),
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: SlideTransition(
                  position: _slideAnimation,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: 80),
                      // Logo/Icon
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.blue.withOpacity(0.3),
                              blurRadius: 40,
                              spreadRadius: 5,
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.storefront_rounded,
                          size: 48,
                          color: AppColors.black,
                        ),
                      ),

                      SizedBox(height: AppSpacing.xxl * 1.5),

                      // Headline
                      Text(
                        'Self-Service,\nSimplified',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: isTablet ? 56 : 42,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          height: 1.1,
                          letterSpacing: -1.5,
                        ),
                      ),

                      SizedBox(height: AppSpacing.lg),

                      // Subheadline
                      Text(
                        'Turn any tablet into a powerful kiosk.\nNo hardware. No complexity. Just results.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: isTablet ? 20 : 17,
                          fontWeight: FontWeight.w400,
                          color: Colors.white.withOpacity(0.7),
                          height: 1.5,
                          letterSpacing: 0.2,
                        ),
                      ),

                      SizedBox(height: AppSpacing.xxl * 2),

                      // Feature highlights
                      _buildFeature(
                        icon: Icons.qr_code_rounded,
                        text: 'Scan to pay with any phone',
                        isTablet: isTablet,
                      ),
                      SizedBox(height: AppSpacing.lg),
                      _buildFeature(
                        icon: Icons.auto_awesome_rounded,
                        text: 'AI-powered menu setup in minutes',
                        isTablet: isTablet,
                      ),
                      SizedBox(height: AppSpacing.lg),
                      _buildFeature(
                        icon: Icons.palette_rounded,
                        text: 'Beautiful templates, zero design work',
                        isTablet: isTablet,
                      ),

                      SizedBox(height: AppSpacing.xxl * 2),

                      // CTA Button
                      AppButton(
                        label: 'Get Started',
                        onPressed: () {
                          context.push('/signup');
                        },
                        variant: AppButtonVariant.filled,
                        fullWidth: true,
                        icon: Icons.arrow_forward_rounded,
                      ),

                      SizedBox(height: AppSpacing.lg),

                      // Sign in link
                      TextButton(
                        onPressed: () {
                          // TODO: Navigate to sign in
                          context.push('/signup');
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

                      SizedBox(height: 80),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Scroll indicator (right side, enlarged)
          if (_showScrollIndicator)
            Positioned(
              right: screenWidth > 600 ? ((screenWidth - 600) / 2) + 620 : 620,
              top: screenHeight * 0.5 - 90,
              child: AnimatedBuilder(
                animation: _scrollIndicatorAnimation,
                builder: (context, child) {
                  return FadeTransition(
                    opacity: _fadeAnimation,
                    child: Transform.translate(
                      offset: Offset(0, _scrollIndicatorAnimation.value),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.keyboard_arrow_down_rounded,
                            color: Colors.white.withOpacity(0.25),
                            size: 84,
                          ),
                          SizedBox(height: 6),
                          Icon(
                            Icons.keyboard_arrow_down_rounded,
                            color: Colors.white.withOpacity(0.35),
                            size: 84,
                          ),
                          SizedBox(height: 6),
                          Icon(
                            Icons.keyboard_arrow_down_rounded,
                            color: Colors.white.withOpacity(0.45),
                            size: 84,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

          // Minimal branding
          Positioned(
            bottom: 30,
            left: 0,
            right: 0,
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: Text(
                'POWERED BY YOU',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.2),
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 3,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeature({
    required IconData icon,
    required String text,
    required bool isTablet,
  }) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: AppColors.blue.withOpacity(0.12),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, size: 20, color: AppColors.blue),
        ),
        SizedBox(width: AppSpacing.md),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: isTablet ? 17 : 15,
              fontWeight: FontWeight.w500,
              color: Colors.white.withOpacity(0.85),
              letterSpacing: 0.2,
            ),
          ),
        ),
      ],
    );
  }
}
