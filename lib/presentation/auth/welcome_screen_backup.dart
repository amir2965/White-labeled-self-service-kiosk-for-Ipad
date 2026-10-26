import 'package:flutter/material.dart';

/// Deprecated file kept as a backup placeholder.
///
/// The real implementation lives in `welcome_screen.dart`.
class WelcomeScreenBackup extends StatelessWidget {
  const WelcomeScreenBackup({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox.shrink();
  }
}

/*

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
      ),
    ];

    return Scaffold(
      backgroundColor: AppColors.black,
      body: Stack(
        children: stackChildren,
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

*/
