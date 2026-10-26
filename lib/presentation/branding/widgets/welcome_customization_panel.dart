import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../models/branding_settings.dart';
import '../models/welcome_template_config.dart';
import '../providers/branding_provider.dart';
import 'advanced_color_picker_dialog.dart';
import 'gradient_presets_selector.dart';

/// Customization panel for welcome page settings
class WelcomeCustomizationPanel extends ConsumerWidget {
  final BrandingSettings settings;

  const WelcomeCustomizationPanel({Key? key, required this.settings})
    : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Show gradient/secondary color options only for gradientBackground template
    final showGradientOptions =
        settings.welcomeTemplate == WelcomePageTemplate.gradientBackground;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Business Name
        _SectionTitle('Business Information'),
        Row(
          children: [
            Expanded(
              child: _buildTextField(
                label: 'Business Name',
                value: settings.businessName,
                onChanged: (value) {
                  ref
                      .read(brandingSettingsProvider.notifier)
                      .updateBusinessName(value);
                },
              ),
            ),
            const SizedBox(width: 16),
            SizedBox(
              width: 120,
              child: _SwitchTile('Show Name', settings.showBusinessName, (
                value,
              ) {
                ref
                    .read(brandingSettingsProvider.notifier)
                    .toggleBusinessName();
              }),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildTextField(
                label: 'Tagline (Optional)',
                value: settings.tagline ?? '',
                onChanged: (value) {
                  ref
                      .read(brandingSettingsProvider.notifier)
                      .updateTagline(value.isEmpty ? null : value);
                },
                required: false, // Tagline is optional
                minLength: 0,
              ),
            ),
            const SizedBox(width: 16),
            SizedBox(
              width: 120,
              child: _SwitchTile('Show Tagline', settings.showTagline, (value) {
                ref.read(brandingSettingsProvider.notifier).toggleTagline();
              }),
            ),
          ],
        ),

        const SizedBox(height: 32),

        // Logo Settings
        _SectionTitle('Logo Settings'),
        Row(
          children: [
            Expanded(
              child: _buildTextField(
                label: 'Logo URL',
                value: settings.logoUrl ?? '',
                onChanged: (value) {
                  ref
                      .read(brandingSettingsProvider.notifier)
                      .updateLogoUrl(value.isEmpty ? null : value);
                },
              ),
            ),
            const SizedBox(width: 16),
            SizedBox(
              width: 120,
              child: _SwitchTile('Show Logo', settings.showLogo, (value) {
                ref.read(brandingSettingsProvider.notifier).toggleLogo();
              }),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Logo Scale Slider
        _buildSlider(
          label: 'Logo Scale',
          value: settings.logoScale,
          min: 0.5,
          max: 1.2,
          divisions: 7,
          onChanged: (value) {
            ref.read(brandingSettingsProvider.notifier).updateLogoScale(value);
          },
        ),
        const SizedBox(height: 16),

        // Logo Fit Dropdown
        _buildDropdown<BoxFit>(
          label: 'Logo Fit',
          value: settings.logoFit,
          items: [
            DropdownMenuItem(value: BoxFit.contain, child: Text('Contain')),
            DropdownMenuItem(value: BoxFit.cover, child: Text('Cover')),
            DropdownMenuItem(value: BoxFit.fill, child: Text('Fill')),
            DropdownMenuItem(value: BoxFit.fitWidth, child: Text('Fit Width')),
            DropdownMenuItem(
              value: BoxFit.fitHeight,
              child: Text('Fit Height'),
            ),
          ],
          onChanged: (value) {
            if (value != null) {
              ref.read(brandingSettingsProvider.notifier).updateLogoFit(value);
            }
          },
        ),

        const SizedBox(height: 32),

        // Background Image
        _SectionTitle('Background Image'),
        _buildTextField(
          label: 'Image URL',
          value: settings.backgroundImageUrl ?? '',
          onChanged: (value) {
            ref
                .read(brandingSettingsProvider.notifier)
                .updateBackgroundImageUrl(value.isEmpty ? null : value);
          },
        ),
        const SizedBox(height: 16),

        // Background Image Fit
        _buildDropdown<BoxFit>(
          label: 'Image Scaling',
          value: settings.backgroundImageFit,
          items: [
            DropdownMenuItem(value: BoxFit.cover, child: Text('Cover')),
            DropdownMenuItem(value: BoxFit.contain, child: Text('Contain')),
            DropdownMenuItem(value: BoxFit.fill, child: Text('Fill')),
            DropdownMenuItem(value: BoxFit.fitWidth, child: Text('Fit Width')),
            DropdownMenuItem(
              value: BoxFit.fitHeight,
              child: Text('Fit Height'),
            ),
          ],
          onChanged: (value) {
            if (value != null) {
              ref
                  .read(brandingSettingsProvider.notifier)
                  .updateBackgroundImageFit(value);
            }
          },
        ),

        const SizedBox(height: 32),

        // Tagline Customization
        _SectionTitle('Tagline Settings'),
        _buildSlider(
          label: 'Font Size',
          value: settings.taglineFontSize,
          min: 12.0,
          max: 21.0,
          divisions: 9,
          onChanged: (value) {
            ref
                .read(brandingSettingsProvider.notifier)
                .updateTaglineFontSize(value);
          },
        ),
        const SizedBox(height: 16),

        Row(
          children: [
            Expanded(
              child: _ColorPicker(
                label: 'Tagline Color',
                color: settings.taglineColor,
                onChanged: (color) {
                  ref
                      .read(brandingSettingsProvider.notifier)
                      .updateTaglineColor(color);
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        _buildDropdown<FontWeight>(
          label: 'Font Weight',
          value: settings.taglineFontWeight,
          items: [
            DropdownMenuItem(value: FontWeight.w300, child: Text('Light')),
            DropdownMenuItem(value: FontWeight.normal, child: Text('Normal')),
            DropdownMenuItem(value: FontWeight.w500, child: Text('Medium')),
            DropdownMenuItem(value: FontWeight.w600, child: Text('Semi Bold')),
            DropdownMenuItem(value: FontWeight.bold, child: Text('Bold')),
          ],
          onChanged: (value) {
            if (value != null) {
              ref
                  .read(brandingSettingsProvider.notifier)
                  .updateTaglineFontWeight(value);
            }
          },
        ),
        const SizedBox(height: 16),

        _buildSlider(
          label: 'Letter Spacing',
          value: settings.taglineLetterSpacing,
          min: -2.0,
          max: 4.0,
          divisions: 60,
          onChanged: (value) {
            ref
                .read(brandingSettingsProvider.notifier)
                .updateTaglineLetterSpacing(value);
          },
        ),

        const SizedBox(height: 32),

        // Colors
        _SectionTitle('Color Theme'),
        Row(
          children: [
            Expanded(
              child: _ColorPicker(
                label: 'Primary Color',
                color: settings.primaryColor,
                onChanged: (color) {
                  ref
                      .read(brandingSettingsProvider.notifier)
                      .updatePrimaryColor(color);
                },
              ),
            ),
            // Only show Secondary Color for gradient background template
            if (showGradientOptions) ...[
              const SizedBox(width: 16),
              Expanded(
                child: _ColorPicker(
                  label: 'Secondary Color',
                  color: settings.secondaryColor,
                  onChanged: (color) {
                    ref
                        .read(brandingSettingsProvider.notifier)
                        .updateSecondaryColor(color);
                  },
                ),
              ),
            ],
          ],
        ),

        const SizedBox(height: 24),

        // Gradient Presets - Only show for gradient background template
        if (showGradientOptions) ...[
          const GradientPresetsSelector(),
          const SizedBox(height: 32),
        ] else ...[
          const SizedBox(height: 8),
        ],

        // Button Settings - Enhanced
        _SectionTitle('Button Settings'),
        _buildTextField(
          label: 'Button Text',
          value: settings.buttonText,
          onChanged: (value) {
            ref.read(brandingSettingsProvider.notifier).updateButtonText(value);
          },
        ),
        const SizedBox(height: 16),

        // Button Size
        Row(
          children: [
            Expanded(
              child: _buildSlider(
                label: 'Button Width',
                value: settings.buttonWidth,
                min: 150.0,
                max: 400.0,
                divisions: 25,
                onChanged: (value) {
                  ref
                      .read(brandingSettingsProvider.notifier)
                      .updateButtonWidth(value);
                },
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildSlider(
                label: 'Button Height',
                value: settings.buttonHeight,
                min: 40.0,
                max: 80.0,
                divisions: 20,
                onChanged: (value) {
                  ref
                      .read(brandingSettingsProvider.notifier)
                      .updateButtonHeight(value);
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        _buildSlider(
          label: 'Border Radius',
          value: settings.buttonBorderRadius,
          min: 0.0,
          max: 40.0,
          divisions: 40,
          onChanged: (value) {
            ref
                .read(brandingSettingsProvider.notifier)
                .updateButtonBorderRadius(value);
          },
        ),
        const SizedBox(height: 16),

        _buildSlider(
          label: 'Text Size',
          value: settings.buttonTextSize,
          min: 14.0,
          max: 28.0,
          divisions: 14,
          onChanged: (value) {
            ref
                .read(brandingSettingsProvider.notifier)
                .updateButtonTextSize(value);
          },
        ),
        const SizedBox(height: 16),

        // Button Colors
        Row(
          children: [
            Expanded(
              child: _ColorPicker(
                label: 'Button Color',
                color: settings.buttonColor,
                onChanged: (color) {
                  ref
                      .read(brandingSettingsProvider.notifier)
                      .updateButtonColor(color);
                },
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _ColorPicker(
                label: 'Text Color',
                color: settings.buttonTextColor,
                onChanged: (color) {
                  ref
                      .read(brandingSettingsProvider.notifier)
                      .updateButtonTextColor(color);
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),

        // Button Stroke
        Row(
          children: [
            Expanded(
              child: _SwitchTile('Stroke/Border', settings.buttonHasStroke, (
                value,
              ) {
                ref
                    .read(brandingSettingsProvider.notifier)
                    .toggleButtonStroke();
              }),
            ),
          ],
        ),
        if (settings.buttonHasStroke) ...[
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _ColorPicker(
                  label: 'Stroke Color',
                  color: settings.buttonStrokeColor,
                  onChanged: (color) {
                    ref
                        .read(brandingSettingsProvider.notifier)
                        .updateButtonStrokeColor(color);
                  },
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildSlider(
                  label: 'Stroke Width',
                  value: settings.buttonStrokeWidth,
                  min: 1.0,
                  max: 10.0,
                  divisions: 9,
                  onChanged: (value) {
                    ref
                        .read(brandingSettingsProvider.notifier)
                        .updateButtonStrokeWidth(value);
                  },
                ),
              ),
            ],
          ),
        ],
        const SizedBox(height: 24),

        // Button Outer Glow
        Row(
          children: [
            Expanded(
              child: _SwitchTile('Outer Glow', settings.buttonHasOuterGlow, (
                value,
              ) {
                ref.read(brandingSettingsProvider.notifier).toggleButtonGlow();
              }),
            ),
          ],
        ),
        if (settings.buttonHasOuterGlow) ...[
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _ColorPicker(
                  label: 'Glow Color',
                  color: settings.buttonGlowColor,
                  onChanged: (color) {
                    ref
                        .read(brandingSettingsProvider.notifier)
                        .updateButtonGlowColor(color);
                  },
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildSlider(
                  label: 'Glow Radius',
                  value: settings.buttonGlowRadius,
                  min: 2.0,
                  max: 30.0,
                  divisions: 28,
                  onChanged: (value) {
                    ref
                        .read(brandingSettingsProvider.notifier)
                        .updateButtonGlowRadius(value);
                  },
                ),
              ),
            ],
          ),
        ],
        const SizedBox(height: 24),

        // Button Shadow
        Row(
          children: [
            Expanded(
              child: _SwitchTile('Shadow', settings.buttonHasShadow, (value) {
                ref
                    .read(brandingSettingsProvider.notifier)
                    .toggleButtonShadow();
              }),
            ),
            if (settings.buttonHasShadow) ...[
              const SizedBox(width: 16),
              Expanded(
                child: _SwitchTile('Inner Shadow', settings.buttonShadowInner, (
                  value,
                ) {
                  ref
                      .read(brandingSettingsProvider.notifier)
                      .toggleButtonShadowInner();
                }),
              ),
            ],
          ],
        ),
        if (settings.buttonHasShadow) ...[
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _ColorPicker(
                  label: 'Shadow Color',
                  color: settings.buttonShadowColor,
                  onChanged: (color) {
                    ref
                        .read(brandingSettingsProvider.notifier)
                        .updateButtonShadowColor(color);
                  },
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildSlider(
                  label: 'Shadow Blur',
                  value: settings.buttonShadowBlur,
                  min: 0.0,
                  max: 30.0,
                  divisions: 30,
                  onChanged: (value) {
                    ref
                        .read(brandingSettingsProvider.notifier)
                        .updateButtonShadowBlur(value);
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildSlider(
                  label: 'Shadow Offset X',
                  value: settings.buttonShadowOffsetX,
                  min: -20.0,
                  max: 20.0,
                  divisions: 40,
                  onChanged: (value) {
                    ref
                        .read(brandingSettingsProvider.notifier)
                        .updateButtonShadowOffsetX(value);
                  },
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildSlider(
                  label: 'Shadow Offset Y',
                  value: settings.buttonShadowOffsetY,
                  min: -20.0,
                  max: 20.0,
                  divisions: 40,
                  onChanged: (value) {
                    ref
                        .read(brandingSettingsProvider.notifier)
                        .updateButtonShadowOffsetY(value);
                  },
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }

  Widget _SectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: AppColors.black,
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required String value,
    required ValueChanged<String> onChanged,
    bool required = true,
    int minLength = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppColors.gray700,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: TextEditingController(text: value)
            ..selection = TextSelection.fromPosition(
              TextPosition(offset: value.length),
            ),
          onChanged: (newValue) {
            // Prevent removing characters if it would make the field too short
            if (required && newValue.length < minLength) {
              return;
            }
            onChanged(newValue);
          },
          decoration: InputDecoration(
            filled: true,
            fillColor: AppColors.gray50,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppColors.gray300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppColors.gray300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppColors.blue, width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
          ),
        ),
      ],
    );
  }

  Widget _SwitchTile(String label, bool value, ValueChanged<bool> onChanged) {
    return Row(
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppColors.gray700,
          ),
        ),
        const Spacer(),
        Switch(value: value, onChanged: onChanged, activeColor: AppColors.blue),
      ],
    );
  }

  Widget _buildSlider({
    required String label,
    required double value,
    required double min,
    required double max,
    required int divisions,
    required ValueChanged<double> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppColors.gray700,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.blue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                value.toStringAsFixed(1),
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.blue,
                ),
              ),
            ),
          ],
        ),
        Slider(
          value: value,
          min: min,
          max: max,
          divisions: divisions,
          activeColor: AppColors.blue,
          inactiveColor: AppColors.gray300,
          onChanged: onChanged,
        ),
      ],
    );
  }

  Widget _buildDropdown<T>({
    required String label,
    required T value,
    required List<DropdownMenuItem<T>> items,
    required ValueChanged<T?> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppColors.gray700,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: AppColors.gray50,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.gray300),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<T>(
              value: value,
              isExpanded: true,
              icon: Icon(Icons.arrow_drop_down, color: AppColors.gray600),
              style: TextStyle(fontSize: 14, color: AppColors.gray800),
              items: items,
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }
}

class _ColorPicker extends StatelessWidget {
  final String label;
  final Color? color;
  final ValueChanged<Color?> onChanged;

  const _ColorPicker({
    required this.label,
    required this.color,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppColors.gray700,
          ),
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: () async {
            // Quick preset colors
            final presets = [
              AppColors.black,
              AppColors.blue,
              AppColors.success,
              AppColors.warning,
              AppColors.error,
              const Color(0xFF6F4E37), // Brown
              const Color(0xFFD4AF37), // Gold
              const Color(0xFF8B4513), // Saddle Brown
              const Color(0xFF667eea), // Purple
              const Color(0xFFFF6B35), // Orange
            ];

            final result = await showDialog<Color?>(
              context: context,
              builder: (context) => AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                title: Row(
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
                      'Select $label',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                contentPadding: const EdgeInsets.all(24),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Quick Colors',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.gray700,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: presets.map((c) {
                        return GestureDetector(
                          onTap: () => Navigator.pop(context, c),
                          child: Container(
                            width: 56,
                            height: 56,
                            decoration: BoxDecoration(
                              color: c,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: AppColors.gray300,
                                width: 2,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: c.withOpacity(0.3),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 24),

                    // More Colors Button
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: () async {
                          // Close current dialog
                          Navigator.pop(context);

                          // Open advanced picker
                          final advancedColor = await showDialog<Color>(
                            context: context,
                            builder: (context) => AdvancedColorPickerDialog(
                              initialColor: color,
                              label: label,
                            ),
                          );

                          if (advancedColor != null) {
                            onChanged(advancedColor);
                          }
                        },
                        icon: Icon(Icons.palette, size: 20),
                        label: Text(
                          'More Colors (Advanced)',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          padding: EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 14,
                          ),
                          side: BorderSide(color: AppColors.blue, width: 2),
                          foregroundColor: AppColors.blue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                    ),
                    child: Text(
                      'Cancel',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.gray600,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(context, null),
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                    ),
                    child: Text(
                      'Clear',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.error,
                      ),
                    ),
                  ),
                ],
              ),
            );

            if (result != null || result == null) {
              onChanged(result);
            }
          },
          child: Container(
            height: 48,
            decoration: BoxDecoration(
              color: color ?? AppColors.gray200,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.gray300, width: 2),
            ),
            child: color == null
                ? const Center(
                    child: Text(
                      'Select Color',
                      style: TextStyle(color: AppColors.gray600),
                    ),
                  )
                : null,
          ),
        ),
      ],
    );
  }
}
