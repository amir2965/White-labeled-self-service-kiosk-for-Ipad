import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../models/gradient_presets.dart';
import '../providers/branding_provider.dart';

/// Gradient presets selector widget
class GradientPresetsSelector extends ConsumerWidget {
  const GradientPresetsSelector({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [AppColors.gray50, Colors.white, AppColors.gray50],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.gray200, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Container(
                width: 4,
                height: 20,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppColors.blue, AppColors.info],
                  ),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Gradient Presets',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.black,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Professional gradient combinations designed for different restaurant types',
            style: TextStyle(
              fontSize: 13,
              color: AppColors.gray600,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 24),

          // Gradient Grid
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 5,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1.0,
            ),
            itemCount: GradientPresets.presets.length,
            itemBuilder: (context, index) {
              final preset = GradientPresets.presets[index];
              return _GradientPresetCard(
                preset: preset,
                onTap: () {
                  // Apply gradient colors to primary and secondary
                  final colors = preset.gradient.colors;
                  if (colors.length >= 2) {
                    ref
                        .read(brandingSettingsProvider.notifier)
                        .updatePrimaryColor(colors[0]);
                    ref
                        .read(brandingSettingsProvider.notifier)
                        .updateSecondaryColor(colors[1]);

                    // Show confirmation snackbar
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Applied "${preset.name}" gradient',
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                        backgroundColor: AppColors.success,
                        duration: const Duration(seconds: 2),
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    );
                  }
                },
              );
            },
          ),
        ],
      ),
    );
  }
}

class _GradientPresetCard extends StatefulWidget {
  final GradientPreset preset;
  final VoidCallback onTap;

  const _GradientPresetCard({required this.preset, required this.onTap});

  @override
  State<_GradientPresetCard> createState() => _GradientPresetCardState();
}

class _GradientPresetCardState extends State<_GradientPresetCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: Tooltip(
          message: '${widget.preset.name}\n${widget.preset.description}',
          preferBelow: false,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            decoration: BoxDecoration(
              gradient: widget.preset.gradient,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: _isHovered ? AppColors.blue : AppColors.gray300,
                width: _isHovered ? 3 : 2,
              ),
              boxShadow: [
                if (_isHovered)
                  BoxShadow(
                    color: AppColors.blue.withOpacity(0.3),
                    blurRadius: 16,
                    offset: const Offset(0, 4),
                  ),
              ],
            ),
            child: Stack(
              children: [
                // Hover overlay
                if (_isHovered)
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),

                // Category badge at bottom
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.7),
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(10),
                        bottomRight: Radius.circular(10),
                      ),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          widget.preset.name,
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          widget.preset.category,
                          style: TextStyle(
                            fontSize: 9,
                            color: Colors.white.withOpacity(0.8),
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ),

                // Checkmark for hover
                if (_isHovered)
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: AppColors.blue,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.check,
                        size: 14,
                        color: Colors.white,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
