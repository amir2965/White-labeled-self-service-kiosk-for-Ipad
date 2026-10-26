import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:ui' show ImageFilter;
import '../../../core/constants/app_colors.dart';
import '../providers/recent_colors_provider.dart';

/// Advanced color picker dialog with HSV sliders and hex input
class AdvancedColorPickerDialog extends ConsumerStatefulWidget {
  final Color? initialColor;
  final String label;

  const AdvancedColorPickerDialog({
    Key? key,
    this.initialColor,
    required this.label,
  }) : super(key: key);

  @override
  ConsumerState<AdvancedColorPickerDialog> createState() =>
      _AdvancedColorPickerDialogState();
}

class _AdvancedColorPickerDialogState
    extends ConsumerState<AdvancedColorPickerDialog> {
  late HSVColor _currentColor;
  late TextEditingController _hexController;
  late ScrollController _scrollController;
  late FocusNode _hexFocusNode;

  // Store initial screen dimensions to prevent dialog resize when keyboard appears
  double? _initialScreenHeight;
  double? _initialScreenWidth;

  @override
  void initState() {
    super.initState();
    _currentColor = HSVColor.fromColor(widget.initialColor ?? AppColors.blue);
    _hexController = TextEditingController(
      text: _colorToHex(_currentColor.toColor()),
    );
    _scrollController = ScrollController();
    _hexFocusNode = FocusNode();

    // Scroll to hex input when focused
    _hexFocusNode.addListener(() {
      if (_hexFocusNode.hasFocus) {
        Future.delayed(Duration(milliseconds: 300), () {
          if (_scrollController.hasClients) {
            _scrollController.animateTo(
              _scrollController.position.minScrollExtent + 100,
              duration: Duration(milliseconds: 300),
              curve: Curves.easeOut,
            );
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _hexController.dispose();
    _scrollController.dispose();
    _hexFocusNode.dispose();
    super.dispose();
  }

  String _colorToHex(Color color) {
    return color.value.toRadixString(16).substring(2).toUpperCase();
  }

  Color? _hexToColor(String hex) {
    try {
      final hexClean = hex.replaceAll('#', '');
      if (hexClean.length == 6) {
        return Color(int.parse('FF$hexClean', radix: 16));
      }
    } catch (_) {}
    return null;
  }

  void _updateFromHex(String hex) {
    final color = _hexToColor(hex);
    if (color != null) {
      setState(() {
        _currentColor = HSVColor.fromColor(color);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final Color displayColor = _currentColor.toColor();
    final recentColors = ref.watch(recentColorsProvider);

    final currentScreenHeight = MediaQuery.of(context).size.height;
    final currentScreenWidth = MediaQuery.of(context).size.width;
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;

    // Capture initial dimensions on first build (before keyboard)
    _initialScreenHeight ??= currentScreenHeight;
    _initialScreenWidth ??= currentScreenWidth;

    // Use initial dimensions ONLY - completely ignore viewport changes
    final isLandscape = _initialScreenWidth! > _initialScreenHeight!;

    // Fixed dimensions based on initial screen size
    final dialogWidth = 500.0;
    final dialogHeight = isLandscape
        ? _initialScreenHeight! * 0.75
        : _initialScreenHeight! * 0.85;

    // Calculate absolute positioning to center the dialog
    final left = (_initialScreenWidth! - dialogWidth) / 2;
    // Move dialog up slightly when keyboard appears to improve field visibility
    final top = keyboardHeight > 0
        ? ((_initialScreenHeight! - dialogHeight) / 2) - (keyboardHeight * 0.15)
        : (_initialScreenHeight! - dialogHeight) / 2;

    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      insetPadding: EdgeInsets.zero,
      child: SizedBox(
        width: _initialScreenWidth,
        height: _initialScreenHeight,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            // Backdrop
            Positioned.fill(
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                  child: Container(color: Colors.black54),
                ),
              ),
            ),
            // Dialog content with ABSOLUTE positioning
            Positioned(
              left: left,
              top: top,
              width: dialogWidth,
              height: dialogHeight,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 20,
                      offset: Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    // Header
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: AppColors.gray50,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(16),
                          topRight: Radius.circular(16),
                        ),
                        border: Border(
                          bottom: BorderSide(
                            color: AppColors.gray200,
                            width: 1,
                          ),
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 4,
                            height: 24,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [AppColors.blue, AppColors.info],
                              ),
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Advanced Color Picker',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.black,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  'Select ${widget.label}',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: AppColors.gray600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Close button
                          IconButton(
                            onPressed: () => Navigator.pop(context),
                            icon: Icon(Icons.close, color: AppColors.gray600),
                            tooltip: 'Close',
                          ),
                        ],
                      ),
                    ),

                    // Scrollable Content
                    Flexible(
                      child: SingleChildScrollView(
                        controller: _scrollController,
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Color Preview
                            Center(
                              child: Container(
                                width: 120,
                                height: 120,
                                decoration: BoxDecoration(
                                  color: displayColor,
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: AppColors.gray300,
                                    width: 3,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: displayColor.withOpacity(0.4),
                                      blurRadius: 24,
                                      offset: const Offset(0, 8),
                                    ),
                                  ],
                                ),
                                child: Center(
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 6,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.black.withOpacity(0.6),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      '#${_colorToHex(displayColor)}',
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                        letterSpacing: 1,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 24),

                            // Recent Colors Section
                            if (recentColors.isNotEmpty) ...[
                              Row(
                                children: [
                                  Icon(
                                    Icons.history,
                                    size: 16,
                                    color: AppColors.gray600,
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    'Recent Custom Colors',
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.gray700,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Row(
                                children: recentColors.map((color) {
                                  final isSelected =
                                      color.value == displayColor.value;
                                  return Padding(
                                    padding: const EdgeInsets.only(right: 12),
                                    child: GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          _currentColor = HSVColor.fromColor(
                                            color,
                                          );
                                          _hexController.text = _colorToHex(
                                            color,
                                          );
                                        });
                                      },
                                      child: Container(
                                        width: 56,
                                        height: 56,
                                        decoration: BoxDecoration(
                                          color: color,
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                          border: Border.all(
                                            color: isSelected
                                                ? AppColors.blue
                                                : AppColors.gray300,
                                            width: isSelected ? 3 : 2,
                                          ),
                                          boxShadow: [
                                            if (isSelected)
                                              BoxShadow(
                                                color: AppColors.blue
                                                    .withOpacity(0.3),
                                                blurRadius: 8,
                                                offset: const Offset(0, 2),
                                              ),
                                          ],
                                        ),
                                        child: isSelected
                                            ? Icon(
                                                Icons.check,
                                                color: _getContrastColor(color),
                                                size: 24,
                                              )
                                            : null,
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                              const SizedBox(height: 24),
                              Divider(height: 1, color: AppColors.gray200),
                              const SizedBox(height: 24),
                            ],

                            // Hex Input
                            Text(
                              'Hex Color Code',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: AppColors.gray800,
                              ),
                            ),
                            const SizedBox(height: 8),
                            TextField(
                              controller: _hexController,
                              focusNode: _hexFocusNode,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: AppColors.gray50,
                                prefixIcon: Icon(
                                  Icons.tag,
                                  color: AppColors.gray600,
                                ),
                                hintText: 'e.g., 007AFF',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(
                                    color: AppColors.gray300,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(
                                    color: AppColors.gray300,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(
                                    color: AppColors.blue,
                                    width: 2,
                                  ),
                                ),
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 14,
                                ),
                              ),
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                  RegExp(r'[0-9A-Fa-f#]'),
                                ),
                                LengthLimitingTextInputFormatter(7),
                              ],
                              onChanged: (value) {
                                _updateFromHex(value);
                              },
                            ),
                            const SizedBox(height: 24),

                            // Hue Slider
                            _buildSlider(
                              label: 'Hue',
                              value: _currentColor.hue,
                              max: 360,
                              gradient: LinearGradient(
                                colors: [
                                  Colors.red,
                                  Colors.yellow,
                                  Colors.green,
                                  Colors.cyan,
                                  Colors.blue,
                                  Color(0xFFFF00FF), // Magenta
                                  Colors.red,
                                ],
                              ),
                              onChanged: (value) {
                                setState(() {
                                  _currentColor = _currentColor.withHue(value);
                                  _hexController.text = _colorToHex(
                                    displayColor,
                                  );
                                });
                              },
                            ),
                            const SizedBox(height: 20),

                            // Saturation Slider
                            _buildSlider(
                              label: 'Saturation',
                              value: _currentColor.saturation * 100,
                              max: 100,
                              gradient: LinearGradient(
                                colors: [
                                  HSVColor.fromAHSV(
                                    1,
                                    _currentColor.hue,
                                    0,
                                    _currentColor.value,
                                  ).toColor(),
                                  HSVColor.fromAHSV(
                                    1,
                                    _currentColor.hue,
                                    1,
                                    _currentColor.value,
                                  ).toColor(),
                                ],
                              ),
                              onChanged: (value) {
                                setState(() {
                                  _currentColor = _currentColor.withSaturation(
                                    value / 100,
                                  );
                                  _hexController.text = _colorToHex(
                                    displayColor,
                                  );
                                });
                              },
                            ),
                            const SizedBox(height: 20),

                            // Value/Brightness Slider
                            _buildSlider(
                              label: 'Brightness',
                              value: _currentColor.value * 100,
                              max: 100,
                              gradient: LinearGradient(
                                colors: [
                                  HSVColor.fromAHSV(
                                    1,
                                    _currentColor.hue,
                                    _currentColor.saturation,
                                    0,
                                  ).toColor(),
                                  HSVColor.fromAHSV(
                                    1,
                                    _currentColor.hue,
                                    _currentColor.saturation,
                                    1,
                                  ).toColor(),
                                ],
                              ),
                              onChanged: (value) {
                                setState(() {
                                  _currentColor = _currentColor.withValue(
                                    value / 100,
                                  );
                                  _hexController.text = _colorToHex(
                                    displayColor,
                                  );
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Footer with Action Buttons
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: AppColors.gray50,
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(16),
                          bottomRight: Radius.circular(16),
                        ),
                        border: Border(
                          top: BorderSide(color: AppColors.gray200, width: 1),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          OutlinedButton(
                            onPressed: () => Navigator.pop(context),
                            style: OutlinedButton.styleFrom(
                              padding: EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 14,
                              ),
                              side: BorderSide(
                                color: AppColors.gray300,
                                width: 2,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: Text(
                              'Cancel',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: AppColors.gray700,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          ElevatedButton.icon(
                            onPressed: () {
                              // Save color to recent colors
                              ref
                                  .read(recentColorsProvider.notifier)
                                  .addColor(displayColor);
                              // Return color
                              Navigator.pop(context, displayColor);
                            },
                            icon: Icon(Icons.check, size: 18),
                            label: Text(
                              'Apply Color',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.blue,
                              foregroundColor: Colors.white,
                              padding: EdgeInsets.symmetric(
                                horizontal: 28,
                                vertical: 14,
                              ),
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getContrastColor(Color background) {
    // Calculate luminance
    final luminance =
        (0.299 * background.red +
            0.587 * background.green +
            0.114 * background.blue) /
        255;
    return luminance > 0.5 ? Colors.black87 : Colors.white;
  }

  Widget _buildSlider({
    required String label,
    required double value,
    required double max,
    required Gradient gradient,
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
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.gray800,
              ),
            ),
            Text(
              value.round().toString(),
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppColors.gray600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Stack(
          children: [
            // Gradient background
            Container(
              height: 32,
              decoration: BoxDecoration(
                gradient: gradient,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.gray300, width: 2),
              ),
            ),
            // Slider
            SliderTheme(
              data: SliderThemeData(
                trackHeight: 32,
                thumbShape: RoundSliderThumbShape(enabledThumbRadius: 12),
                overlayShape: RoundSliderOverlayShape(overlayRadius: 20),
                trackShape: RoundedRectSliderTrackShape(),
                activeTrackColor: Colors.transparent,
                inactiveTrackColor: Colors.transparent,
                thumbColor: Colors.white,
                overlayColor: Colors.white.withOpacity(0.2),
              ),
              child: Slider(value: value, max: max, onChanged: onChanged),
            ),
          ],
        ),
      ],
    );
  }
}
