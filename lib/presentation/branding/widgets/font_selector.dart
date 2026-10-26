import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_colors.dart';
import '../models/font_config.dart';
import '../providers/branding_provider.dart';

/// Professional font selector with 25 curated fonts
class FontSelector extends ConsumerWidget {
  const FontSelector({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentFont = ref.watch(brandingSettingsProvider).customFont;
    final fontsByCategory = FontConfig.getFontsByCategory();
    final businessName = ref.watch(brandingSettingsProvider).businessName;

    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
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
                height: 32,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [AppColors.blue, AppColors.blue.withOpacity(0.6)],
                  ),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Typography Selection',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: AppColors.black,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '25 professional fonts curated for enterprise kiosks',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.gray600,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 32),

          // Font Categories
          ...fontsByCategory.entries.map((entry) {
            final category = entry.key;
            final fonts = entry.value;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Category Label
                Padding(
                  padding: const EdgeInsets.only(bottom: 16, top: 8),
                  child: Row(
                    children: [
                      Text(
                        category,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: AppColors.gray700,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Container(
                          height: 1,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [AppColors.gray300, Colors.transparent],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Font Cards
                Wrap(
                  spacing: 16,
                  runSpacing: 16,
                  children: fonts.map((font) {
                    final isSelected = currentFont == font.fontFamily;

                    return _FontCard(
                      font: font,
                      isSelected: isSelected,
                      sampleText: businessName,
                      onTap: () {
                        ref
                            .read(brandingSettingsProvider.notifier)
                            .updateCustomFont(font.fontFamily);
                      },
                    );
                  }).toList(),
                ),

                const SizedBox(height: 24),
              ],
            );
          }).toList(),

          // Reset Button
          Center(
            child: TextButton.icon(
              onPressed: () {
                ref
                    .read(brandingSettingsProvider.notifier)
                    .updateCustomFont(null);
              },
              icon: Icon(
                Icons.refresh,
                size: 18,
                color: currentFont != null ? AppColors.blue : AppColors.gray400,
              ),
              label: Text(
                'Reset to Default Font',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: currentFont != null
                      ? AppColors.blue
                      : AppColors.gray400,
                ),
              ),
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FontCard extends StatefulWidget {
  final FontConfig font;
  final bool isSelected;
  final String sampleText;
  final VoidCallback onTap;

  const _FontCard({
    required this.font,
    required this.isSelected,
    required this.sampleText,
    required this.onTap,
  });

  @override
  State<_FontCard> createState() => _FontCardState();
}

class _FontCardState extends State<_FontCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: 280,
          height: 140,
          decoration: BoxDecoration(
            color: widget.isSelected
                ? AppColors.blue.withOpacity(0.05)
                : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: widget.isSelected
                  ? AppColors.blue
                  : (_isHovered ? AppColors.gray400 : AppColors.gray300),
              width: widget.isSelected ? 3 : (_isHovered ? 2 : 1.5),
            ),
            boxShadow: [
              if (_isHovered || widget.isSelected)
                BoxShadow(
                  color: widget.isSelected
                      ? AppColors.blue.withOpacity(0.2)
                      : Colors.black.withOpacity(0.08),
                  blurRadius: widget.isSelected ? 12 : 8,
                  offset: Offset(0, widget.isSelected ? 4 : 2),
                ),
            ],
          ),
          child: Stack(
            children: [
              // Content
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Font Preview
                    Expanded(
                      child: Center(
                        child: Text(
                          widget.sampleText.isEmpty ? 'Aa' : widget.sampleText,
                          style: GoogleFonts.getFont(
                            widget.font.fontFamily,
                            fontSize: widget.sampleText.isEmpty ? 48 : 28,
                            fontWeight: FontWeight.w600,
                            color: AppColors.black,
                            letterSpacing: -0.5,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),

                    const SizedBox(height: 8),

                    // Font Info
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.font.name,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: widget.isSelected
                                ? AppColors.blue
                                : AppColors.gray900,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          widget.font.description,
                          style: TextStyle(
                            fontSize: 11,
                            color: AppColors.gray600,
                            height: 1.2,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Selection Indicator
              if (widget.isSelected)
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: AppColors.blue,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.blue.withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
                ),

              // Hover Overlay
              if (_isHovered && !widget.isSelected)
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: AppColors.blue.withOpacity(0.03),
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
