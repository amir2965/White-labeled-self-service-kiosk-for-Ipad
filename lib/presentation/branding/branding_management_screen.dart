import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_spacing.dart';
import '../../core/constants/app_typography.dart';
import '../analytics/theme_provider.dart';
import 'models/welcome_template_config.dart';
import 'models/branding_settings.dart';
import 'providers/branding_provider.dart';
import 'widgets/template_gallery.dart';
import 'widgets/welcome_customization_panel.dart';
import 'widgets/welcome_preview.dart';
import 'widgets/font_selector.dart';
import 'widgets/confirmation_dialog.dart';
import 'widgets/custom_font_manager.dart';
import 'widgets/image_management_widget.dart';
import '../../demo/demo_config.dart';

/// Branding management screen - Configure kiosk welcome page and branding
class BrandingManagementScreen extends ConsumerStatefulWidget {
  const BrandingManagementScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<BrandingManagementScreen> createState() =>
      _BrandingManagementScreenState();
}

class _BrandingManagementScreenState
    extends ConsumerState<BrandingManagementScreen> {
  String _activeSection =
      'Templates'; // Templates, Typography, Customization, Preview

  // Scroll controllers for each section to persist scroll positions
  final Map<String, ScrollController> _scrollControllers = {
    'Templates': ScrollController(),
    'Typography': ScrollController(),
    'Customization': ScrollController(),
    'Preview': ScrollController(),
  };

  // Mock data for uploaded images (in production, use a provider)
  final List<String> _uploadedLogos = [];
  final List<String> _uploadedBackgrounds = [];
  bool _hasUnsavedChanges = false;

  @override
  void dispose() {
    // Dispose all scroll controllers
    for (var controller in _scrollControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  void _markAsChanged() {
    if (!_hasUnsavedChanges) {
      setState(() {
        _hasUnsavedChanges = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = ref.watch(themeModeProvider);
    final brandingSettings = ref.watch(brandingSettingsProvider);

    return Scaffold(
      backgroundColor: isDarkMode ? const Color(0xFF1A1A1A) : AppColors.gray50,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: isDarkMode ? const Color(0xFF2A2A2A) : AppColors.white,
        leading: DemoConfig.enabled
            ? const SizedBox.shrink()
            : IconButton(
                icon: Icon(
                  Icons.arrow_back,
                  color: isDarkMode ? Colors.white : AppColors.black,
                ),
                onPressed: () async {
                  if (_hasUnsavedChanges) {
                    final shouldLeave =
                        await ConfirmationDialog.showDiscardConfirmation(
                          context,
                        );
                    if (shouldLeave && context.mounted) {
                      context.go('/dashboard');
                    }
                  } else {
                    context.go('/dashboard');
                  }
                },
              ),
        automaticallyImplyLeading: false,
        leadingWidth: DemoConfig.enabled ? 24 : null,
        title: Text(
          'Branding & Welcome Page',
          style: AppTypography.h2.copyWith(
            fontSize: 22,
            color: isDarkMode ? Colors.white : AppColors.black,
          ),
        ),
        actions: [
          // Save Button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ElevatedButton.icon(
              onPressed: () {
                ConfirmationDialog.showSaveConfirmation(
                  context,
                  onConfirm: () {
                    _saveBranding();
                    setState(() {
                      _hasUnsavedChanges = false;
                    });
                  },
                );
              },
              icon: const Icon(Icons.check, size: 18),
              label: Text(
                _hasUnsavedChanges ? 'Save Changes*' : 'Save Changes',
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: _hasUnsavedChanges
                    ? AppColors.warning
                    : AppColors.blue,
                foregroundColor: Colors.white,
                elevation: 0,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
            height: 1,
            color: isDarkMode
                ? Colors.white.withOpacity(0.08)
                : AppColors.gray200,
          ),
        ),
      ),
      body: Row(
        children: [
          // Left Sidebar Navigation
          _buildSidebar(isDarkMode),

          // Main Content Area
          Expanded(child: _buildMainContent(isDarkMode, brandingSettings)),
        ],
      ),
    );
  }

  Widget _buildSidebar(bool isDarkMode) {
    return Container(
      width: 280,
      decoration: BoxDecoration(
        color: isDarkMode ? const Color(0xFF2A2A2A) : AppColors.white,
        border: Border(
          right: BorderSide(
            color: isDarkMode
                ? Colors.white.withOpacity(0.08)
                : AppColors.gray200,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Header
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColors.blue.withOpacity(0.1),
                        AppColors.info.withOpacity(0.1),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(Icons.palette, size: 32, color: AppColors.blue),
                ),
                const SizedBox(height: 16),
                Text(
                  'Branding Workflow',
                  style: AppTypography.h3.copyWith(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: isDarkMode ? Colors.white : AppColors.black,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Mix and match any font with any template',
                  style: AppTypography.bodySmall.copyWith(
                    fontSize: 13,
                    color: isDarkMode
                        ? Colors.white.withOpacity(0.7)
                        : AppColors.gray600,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),

          const Divider(height: 1),

          // Navigation Items
          _buildNavItem(
            'Templates',
            Icons.view_module,
            _activeSection == 'Templates',
            isDarkMode,
          ),
          _buildNavItem(
            'Typography',
            Icons.text_fields,
            _activeSection == 'Typography',
            isDarkMode,
          ),
          _buildNavItem(
            'Customization',
            Icons.tune,
            _activeSection == 'Customization',
            isDarkMode,
          ),
          _buildNavItem(
            'Preview',
            Icons.visibility,
            _activeSection == 'Preview',
            isDarkMode,
          ),

          const Spacer(),

          // Footer Actions
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                OutlinedButton.icon(
                  onPressed: () {
                    ref
                        .read(brandingSettingsProvider.notifier)
                        .resetToDefaults();
                    _showSnackBar('Reset to default settings');
                  },
                  icon: const Icon(Icons.refresh, size: 18),
                  label: const Text('Reset to Default'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: isDarkMode
                        ? Colors.white
                        : AppColors.gray700,
                    side: BorderSide(
                      color: isDarkMode
                          ? Colors.white.withOpacity(0.3)
                          : AppColors.gray300,
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(
    String title,
    IconData icon,
    bool isActive,
    bool isDarkMode,
  ) {
    return Material(
      color: isActive
          ? (isDarkMode
                ? AppColors.blue.withOpacity(0.15)
                : AppColors.blue.withOpacity(0.08))
          : Colors.transparent,
      child: InkWell(
        onTap: () {
          setState(() {
            _activeSection = title;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          decoration: BoxDecoration(
            border: Border(
              left: BorderSide(
                color: isActive ? AppColors.blue : Colors.transparent,
                width: 3,
              ),
            ),
          ),
          child: Row(
            children: [
              Icon(
                icon,
                size: 20,
                color: isActive
                    ? AppColors.blue
                    : (isDarkMode
                          ? Colors.white.withOpacity(0.7)
                          : AppColors.gray600),
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                  color: isActive
                      ? AppColors.blue
                      : (isDarkMode
                            ? Colors.white.withOpacity(0.9)
                            : AppColors.gray800),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMainContent(bool isDarkMode, BrandingSettings settings) {
    switch (_activeSection) {
      case 'Templates':
        return _buildTemplatesSection(isDarkMode);
      case 'Typography':
        return _buildTypographySection(isDarkMode);
      case 'Customization':
        return _buildCustomizationSection(isDarkMode, settings);
      case 'Preview':
        return _buildPreviewSection(isDarkMode, settings);
      default:
        return const SizedBox();
    }
  }

  Widget _buildTypographySection(bool isDarkMode) {
    return SingleChildScrollView(
      controller: _scrollControllers['Typography'],
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppColors.info, AppColors.info.withOpacity(0.7)],
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.text_fields, size: 16, color: Colors.white),
                    const SizedBox(width: 6),
                    Text(
                      'STEP 2',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  'Typography Selection',
                  style: AppTypography.h1.copyWith(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: isDarkMode ? Colors.white : AppColors.black,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.blue.withOpacity(0.05),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppColors.blue.withOpacity(0.2),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Icon(Icons.info_outline, size: 20, color: AppColors.blue),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Select your brand typography from 25 professionally curated fonts. Your selected font will work with any layout template you choose in the next step.',
                    style: AppTypography.bodyMedium.copyWith(
                      color: isDarkMode
                          ? Colors.white.withOpacity(0.7)
                          : AppColors.gray700,
                      height: 1.5,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),

          // Font Selector
          const FontSelector(),

          const SizedBox(height: 48),

          // Custom Font Manager
          const CustomFontManager(),
        ],
      ),
    );
  }

  Widget _buildTemplatesSection(bool isDarkMode) {
    final selectedFont = ref.watch(brandingSettingsProvider).customFont;

    return SingleChildScrollView(
      controller: _scrollControllers['Templates'],
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppColors.blue, AppColors.blue.withOpacity(0.7)],
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.view_module, size: 16, color: Colors.white),
                    const SizedBox(width: 6),
                    Text(
                      'STEP 1',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  'Layout Templates',
                  style: AppTypography.h1.copyWith(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: isDarkMode ? Colors.white : AppColors.black,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.info.withOpacity(0.05),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppColors.info.withOpacity(0.2),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Icon(Icons.info_outline, size: 20, color: AppColors.info),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Choose a layout structure that best represents your brand style. Each template is optimized for different restaurant types and presentations.',
                        style: AppTypography.bodyMedium.copyWith(
                          color: isDarkMode
                              ? Colors.white.withOpacity(0.7)
                              : AppColors.gray700,
                          height: 1.5,
                        ),
                      ),
                      if (selectedFont != null) ...[
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(
                              Icons.check_circle,
                              size: 16,
                              color: AppColors.success,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              'Your selected typography will be applied to all templates',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: AppColors.success,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),

          // Template Gallery
          const TemplateGallery(),
        ],
      ),
    );
  }

  Widget _buildCustomizationSection(
    bool isDarkMode,
    BrandingSettings settings,
  ) {
    return SingleChildScrollView(
      controller: _scrollControllers['Customization'],
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.success,
                      AppColors.success.withOpacity(0.7),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.tune, size: 16, color: Colors.white),
                    const SizedBox(width: 6),
                    Text(
                      'STEP 3',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  'Customize Welcome Page',
                  style: AppTypography.h1.copyWith(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: isDarkMode ? Colors.white : AppColors.black,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.success.withOpacity(0.05),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppColors.success.withOpacity(0.2),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Icon(Icons.info_outline, size: 20, color: AppColors.success),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Personalize your welcome page with your logo, colors, gradient presets, and branding elements. All changes work together with your selected font and template.',
                    style: AppTypography.bodyMedium.copyWith(
                      color: isDarkMode
                          ? Colors.white.withOpacity(0.7)
                          : AppColors.gray700,
                      height: 1.5,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),

          // Customization Panel
          WelcomeCustomizationPanel(settings: settings),

          const SizedBox(height: 48),

          // Logo Management
          ImageManagementWidget(
            title: 'Logo Images',
            description: 'Upload your brand logo to personalize your kiosk',
            instructions: const [
              'PNG or SVG format recommended for best quality',
              'Transparent background works best',
              '1:1 aspect ratio preferred',
              'Minimum 512x512 pixels',
              'Keep file size under 2MB for fast loading',
            ],
            sampleImageUrl:
                'https://via.placeholder.com/200x200/007AFF/FFFFFF?text=Logo',
            uploadedImages: _uploadedLogos,
            selectedImage: _uploadedLogos.isNotEmpty
                ? _uploadedLogos.first
                : null,
            isLogo: true,
            onImageSelected: (url) {
              setState(() {
                // Update selected logo
                _markAsChanged();
              });
            },
            onImageDeleted: (url) {
              setState(() {
                _uploadedLogos.remove(url);
                _markAsChanged();
              });
            },
            onImageUpload: () {
              // TODO: Implement image upload
              setState(() {
                _uploadedLogos.add('https://via.placeholder.com/200x200');
                _markAsChanged();
              });
            },
          ),

          const SizedBox(height: 32),

          // Background Management
          ImageManagementWidget(
            title: 'Background Images',
            description: 'Upload background images for your welcome screen',
            instructions: const [
              'JPG or PNG format, landscape orientation',
              '16:9 aspect ratio (1920x1080) recommended',
              'High resolution for tablet displays (min 1280x720)',
              'Not too busy - text needs to be readable',
              'Keep file size under 5MB',
            ],
            sampleImageUrl:
                'https://via.placeholder.com/400x225/000000/FFFFFF?text=Background',
            uploadedImages: _uploadedBackgrounds,
            selectedImage: _uploadedBackgrounds.isNotEmpty
                ? _uploadedBackgrounds.first
                : null,
            isLogo: false,
            onImageSelected: (url) {
              setState(() {
                // Update selected background
                _markAsChanged();
              });
            },
            onImageDeleted: (url) {
              setState(() {
                _uploadedBackgrounds.remove(url);
                _markAsChanged();
              });
            },
            onImageUpload: () {
              // TODO: Implement image upload
              setState(() {
                _uploadedBackgrounds.add('https://via.placeholder.com/400x225');
                _markAsChanged();
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildPreviewSection(bool isDarkMode, BrandingSettings settings) {
    return Container(
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Preview Container
          Expanded(
            child: Center(
              child: Container(
                constraints: const BoxConstraints(
                  maxWidth: 1200,
                  maxHeight: 900,
                ),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: isDarkMode
                        ? Colors.white.withOpacity(0.15)
                        : AppColors.gray300,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 24,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: WelcomePreview(settings: settings),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSelectionChip(IconData icon, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.3), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  void _saveBranding() {
    // TODO: Persist branding settings
    _showSnackBar('Branding settings saved successfully');
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.success,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }
}
