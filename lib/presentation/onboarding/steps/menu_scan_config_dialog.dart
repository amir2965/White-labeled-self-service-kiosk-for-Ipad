import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_typography.dart';

class MenuScanConfig {
  final String menuType;
  final String layoutStyle;
  final bool extractSizes;
  final bool extractModifiers;
  final bool extractDescriptions;
  final String pricingFormat;
  final bool splitOrDelimitedOptions;
  final bool deduplicateItems;
  final bool addCoffeeExtras; // New: Add coffee shop extras

  MenuScanConfig({
    required this.menuType,
    required this.layoutStyle,
    required this.extractSizes,
    required this.extractModifiers,
    required this.extractDescriptions,
    required this.pricingFormat,
    required this.splitOrDelimitedOptions,
    required this.deduplicateItems,
    this.addCoffeeExtras = false,
  });

  static MenuScanConfig getDefault() {
    return MenuScanConfig(
      menuType: 'Restaurant',
      layoutStyle: 'Categorized Sections',
      extractSizes: true,
      extractModifiers: true,
      extractDescriptions: true,
      pricingFormat: 'Multiple Sizes (S/M/L)',
      splitOrDelimitedOptions: true,
      deduplicateItems: true,
      addCoffeeExtras: false,
    );
  }
}

class MenuScanConfigDialog extends StatefulWidget {
  const MenuScanConfigDialog({super.key});

  @override
  State<MenuScanConfigDialog> createState() => _MenuScanConfigDialogState();
}

class _MenuScanConfigDialogState extends State<MenuScanConfigDialog> {
  String _menuType = 'Restaurant';
  String _layoutStyle = 'Categorized Sections';
  bool _extractSizes = true;
  bool _extractModifiers = true;
  bool _extractDescriptions = true;
  String _pricingFormat = 'Multiple Sizes (S/M/L)';
  bool _splitOrDelimitedOptions = true;
  bool _deduplicateItems = true;
  bool _addCoffeeExtras = false; // New field

  final List<String> _menuTypes = [
    'Restaurant',
    'Coffee Shop',
    'Fast Food',
    'Fine Dining',
    'Cafe',
    'Bar/Pub',
    'Bakery',
    'Food Truck',
  ];

  final List<String> _layoutStyles = [
    'Categorized Sections',
    'Simple List',
    'Grid Layout',
    'Mixed Layout',
  ];

  final List<String> _pricingFormats = [
    'Single Price',
    'Multiple Sizes (S/M/L)',
    'Multiple Sizes (Cup/Mug)',
    'Price Ranges (4.5/5.0/5.5)',
    'Market Price',
  ];

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isTablet = screenWidth >= 768;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.zero,
      child: Container(
        width: screenWidth,
        height: screenHeight,
        color: Colors.black.withOpacity(0.75),
        child: Center(
          child: Container(
            width: isTablet ? 680 : screenWidth * 0.9,
            constraints: BoxConstraints(maxHeight: screenHeight * 0.85),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: AppColors.black,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.tune, color: Colors.white, size: 28),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Configure Menu Scan',
                              style: AppTypography.h2.copyWith(
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Help us understand your menu better',
                              style: AppTypography.bodySmall.copyWith(
                                color: Colors.white70,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // Content
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Menu Type
                        _buildSectionTitle('Menu Type'),
                        const SizedBox(height: 12),
                        _buildDropdown(
                          value: _menuType,
                          items: _menuTypes,
                          onChanged: (value) =>
                              setState(() => _menuType = value!),
                          hint: 'Select your business type',
                        ),
                        const SizedBox(height: 24),

                        // Layout Style
                        _buildSectionTitle('Menu Layout'),
                        const SizedBox(height: 12),
                        _buildDropdown(
                          value: _layoutStyle,
                          items: _layoutStyles,
                          onChanged: (value) =>
                              setState(() => _layoutStyle = value!),
                          hint: 'How items are organized',
                        ),
                        const SizedBox(height: 24),

                        // Pricing Format
                        _buildSectionTitle('Pricing Format'),
                        const SizedBox(height: 12),
                        _buildDropdown(
                          value: _pricingFormat,
                          items: _pricingFormats,
                          onChanged: (value) =>
                              setState(() => _pricingFormat = value!),
                          hint: 'How prices are displayed',
                        ),
                        const SizedBox(height: 24),

                        // Extraction Options
                        _buildSectionTitle('What to Extract'),
                        const SizedBox(height: 12),
                        _buildCheckbox(
                          'Size Variations (S/M/L, Cup/Mug)',
                          _extractSizes,
                          (value) => setState(() => _extractSizes = value!),
                          'Extract different sizes as modifier options',
                        ),
                        _buildCheckbox(
                          'Modifiers & Add-ons',
                          _extractModifiers,
                          (value) => setState(() => _extractModifiers = value!),
                          'Extract customization options (sauces, toppings, extras)',
                        ),
                        _buildCheckbox(
                          'Item Descriptions',
                          _extractDescriptions,
                          (value) =>
                              setState(() => _extractDescriptions = value!),
                          'Extract detailed descriptions and ingredients',
                        ),
                        const SizedBox(height: 24),

                        // Advanced Options
                        _buildSectionTitle('Advanced Options'),
                        const SizedBox(height: 12),
                        _buildCheckbox(
                          'Split OR/Slash Delimited Options',
                          _splitOrDelimitedOptions,
                          (value) =>
                              setState(() => _splitOrDelimitedOptions = value!),
                          'Split "Chicken/Beef/Lamb" or "A OR B OR C" into separate options',
                        ),
                        _buildCheckbox(
                          'Remove Duplicate Items',
                          _deduplicateItems,
                          (value) => setState(() => _deduplicateItems = value!),
                          'Automatically detect and merge duplicate entries',
                        ),
                        if (_menuType == 'Coffee Shop' || _menuType == 'Cafe')
                          _buildCheckbox(
                            'Add Coffee Extras to All Items',
                            _addCoffeeExtras,
                            (value) =>
                                setState(() => _addCoffeeExtras = value!),
                            'Add common extras (Extra shot, Milk alternatives, Syrups) to all coffee items',
                          ),
                        const SizedBox(height: 24),

                        // Info Box
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: AppColors.blue.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: AppColors.blue.withOpacity(0.3),
                            ),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.info_outline,
                                color: AppColors.blue,
                                size: 20,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  'These settings help our AI better understand your menu structure and extract items accurately. You can still edit everything afterwards.',
                                  style: AppTypography.bodySmall.copyWith(
                                    color: AppColors.textSecondary,
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

                // Footer Buttons
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(16),
                      bottomRight: Radius.circular(16),
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.of(context).pop(),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.textPrimary,
                            side: BorderSide(color: Colors.grey[300]!),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            'Cancel',
                            style: AppTypography.buttonMedium,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        flex: 2,
                        child: ElevatedButton(
                          onPressed: () {
                            final config = MenuScanConfig(
                              menuType: _menuType,
                              layoutStyle: _layoutStyle,
                              extractSizes: _extractSizes,
                              extractModifiers: _extractModifiers,
                              extractDescriptions: _extractDescriptions,
                              pricingFormat: _pricingFormat,
                              splitOrDelimitedOptions: _splitOrDelimitedOptions,
                              deduplicateItems: _deduplicateItems,
                              addCoffeeExtras: _addCoffeeExtras,
                            );
                            Navigator.of(context).pop(config);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.blue,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 0,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Continue to Upload',
                                style: AppTypography.buttonMedium,
                              ),
                              const SizedBox(width: 8),
                              const Icon(Icons.arrow_forward, size: 20),
                            ],
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
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: AppTypography.h3.copyWith(
        color: AppColors.textPrimary,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _buildDropdown({
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
    required String hint,
  }) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(12),
      ),
      child: DropdownButtonFormField<String>(
        value: value,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
          border: InputBorder.none,
          hintText: hint,
          hintStyle: TextStyle(color: Colors.grey[400]),
        ),
        items: items.map((item) {
          return DropdownMenuItem(
            value: item,
            child: Text(item, style: AppTypography.bodyMedium),
          );
        }).toList(),
        onChanged: onChanged,
        icon: Icon(Icons.arrow_drop_down, color: AppColors.textSecondary),
      ),
    );
  }

  Widget _buildCheckbox(
    String title,
    bool value,
    ValueChanged<bool?> onChanged,
    String subtitle,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () => onChanged(!value),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Checkbox(
                value: value,
                onChanged: onChanged,
                activeColor: AppColors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppTypography.bodyMedium.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
