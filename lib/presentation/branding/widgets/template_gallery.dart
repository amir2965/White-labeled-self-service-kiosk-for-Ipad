import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../models/welcome_template_config.dart';
import '../providers/branding_provider.dart';

/// Gallery widget showing all available welcome page templates
class TemplateGallery extends ConsumerWidget {
  const TemplateGallery({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedTemplate = ref
        .watch(brandingSettingsProvider)
        .welcomeTemplate;
    final templatesByCategory = WelcomeTemplateConfig.getTemplatesByCategory();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: templatesByCategory.entries.map((entry) {
        final category = entry.key;
        final templates = entry.value;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Category Header
            Padding(
              padding: const EdgeInsets.only(bottom: 16, top: 24),
              child: Text(
                category,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: AppColors.black,
                ),
              ),
            ),

            // Templates Grid
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                crossAxisSpacing: 20,
                mainAxisSpacing: 20,
                childAspectRatio: 1.2,
              ),
              itemCount: templates.length,
              itemBuilder: (context, index) {
                final template = templates[index];
                final metadata = WelcomeTemplateConfig.getMetadata(template)!;
                final isSelected = template == selectedTemplate;

                return _TemplateCard(
                  template: template,
                  metadata: metadata,
                  isSelected: isSelected,
                  onTap: () {
                    ref
                        .read(brandingSettingsProvider.notifier)
                        .updateTemplate(template);
                  },
                );
              },
            ),
          ],
        );
      }).toList(),
    );
  }
}

class _TemplateCard extends StatefulWidget {
  final WelcomePageTemplate template;
  final WelcomeTemplateMetadata metadata;
  final bool isSelected;
  final VoidCallback onTap;

  const _TemplateCard({
    required this.template,
    required this.metadata,
    required this.isSelected,
    required this.onTap,
  });

  @override
  State<_TemplateCard> createState() => _TemplateCardState();
}

class _TemplateCardState extends State<_TemplateCard> {
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
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: widget.isSelected
                  ? AppColors.blue
                  : (_isHovered ? AppColors.gray400 : AppColors.gray300),
              width: widget.isSelected ? 3 : 2,
            ),
            boxShadow: [
              if (_isHovered || widget.isSelected)
                BoxShadow(
                  color: (widget.isSelected ? AppColors.blue : Colors.black)
                      .withOpacity(0.15),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Template Preview
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color:
                        widget.metadata.primaryColor?.withOpacity(0.1) ??
                        AppColors.gray100,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                    ),
                  ),
                  child: Stack(
                    children: [
                      // Simplified template preview
                      Center(child: _buildTemplatePreview()),

                      // Selected Indicator
                      if (widget.isSelected)
                        Positioned(
                          top: 8,
                          right: 8,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: AppColors.blue,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.check,
                              size: 16,
                              color: Colors.white,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),

              // Template Info
              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.metadata.name,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: widget.isSelected
                            ? AppColors.blue
                            : AppColors.black,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.metadata.description,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.gray600,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
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

  Widget _buildTemplatePreview() {
    // Simplified visual representation of each template
    switch (widget.template) {
      case WelcomePageTemplate.fullScreenImage:
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.gray800, AppColors.gray600],
            ),
          ),
          child: Center(
            child: Icon(Icons.image, size: 32, color: Colors.white54),
          ),
        );

      case WelcomePageTemplate.splitScreenImage:
        return Row(
          children: [
            Expanded(
              child: Container(
                color: AppColors.gray300,
                child: const Icon(
                  Icons.image,
                  size: 24,
                  color: AppColors.gray500,
                ),
              ),
            ),
            Expanded(
              child: Container(
                color: AppColors.white,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(width: 30, height: 30, color: AppColors.black),
                    const SizedBox(height: 8),
                    Container(width: 40, height: 12, color: AppColors.blue),
                  ],
                ),
              ),
            ),
          ],
        );

      case WelcomePageTemplate.largeLogo:
        return Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: AppColors.black,
            borderRadius: BorderRadius.circular(12),
          ),
        );

      case WelcomePageTemplate.gradientBackground:
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                widget.metadata.primaryColor ?? AppColors.blue,
                widget.metadata.secondaryColor ?? AppColors.info,
              ],
            ),
          ),
        );

      default:
        return Icon(
          Icons.dashboard,
          size: 32,
          color: widget.metadata.primaryColor ?? AppColors.gray400,
        );
    }
  }
}
