import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_typography.dart';

/// Dialog for adjusting image position and zoom
class ImageEditorDialog extends StatefulWidget {
  final String imageUrl;
  final Function(String) onSave;

  const ImageEditorDialog({
    super.key,
    required this.imageUrl,
    required this.onSave,
  });

  @override
  State<ImageEditorDialog> createState() => _ImageEditorDialogState();
}

class _ImageEditorDialogState extends State<ImageEditorDialog> {
  double _scale = 1.0;
  Offset _offset = Offset.zero;
  Offset _initialFocalPoint = Offset.zero;
  Offset _sessionOffset = Offset.zero;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.all(AppSpacing.xl),
      child: Container(
        constraints: BoxConstraints(maxWidth: 800, maxHeight: 700),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          children: [
            // Header
            Container(
              padding: EdgeInsets.all(AppSpacing.lg),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: AppColors.textSecondary.withOpacity(0.1),
                  ),
                ),
              ),
              child: Row(
                children: [
                  Icon(Icons.crop, color: AppColors.blue),
                  SizedBox(width: AppSpacing.sm),
                  Text(
                    'Adjust Image',
                    style: AppTypography.h3.copyWith(
                      color: AppColors.black,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Spacer(),
                  IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),

            // Image editor area
            Expanded(
              child: Container(
                margin: EdgeInsets.all(AppSpacing.lg),
                decoration: BoxDecoration(
                  color: AppColors.textSecondary.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: AppColors.textSecondary.withOpacity(0.15),
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: GestureDetector(
                    onScaleStart: (details) {
                      _initialFocalPoint = details.focalPoint;
                      _sessionOffset = _offset;
                    },
                    onScaleUpdate: (details) {
                      setState(() {
                        _scale = (_scale * details.scale).clamp(1.0, 4.0);

                        // Calculate new offset based on drag
                        final delta = details.focalPoint - _initialFocalPoint;
                        _offset = _sessionOffset + delta;
                      });
                    },
                    child: Transform.scale(
                      scale: _scale,
                      child: Transform.translate(
                        offset: _offset,
                        child: Image.network(
                          widget.imageUrl,
                          fit: BoxFit.contain,
                          errorBuilder: (_, __, ___) => Center(
                            child: Icon(
                              Icons.broken_image_outlined,
                              size: 64,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // Controls
            Container(
              padding: EdgeInsets.all(AppSpacing.lg),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: AppColors.textSecondary.withOpacity(0.1),
                  ),
                ),
              ),
              child: Column(
                children: [
                  // Zoom slider
                  Row(
                    children: [
                      Icon(
                        Icons.zoom_out,
                        color: AppColors.textSecondary,
                        size: 20,
                      ),
                      Expanded(
                        child: Slider(
                          value: _scale,
                          min: 1.0,
                          max: 4.0,
                          activeColor: AppColors.blue,
                          onChanged: (value) {
                            setState(() {
                              _scale = value;
                            });
                          },
                        ),
                      ),
                      Icon(
                        Icons.zoom_in,
                        color: AppColors.textSecondary,
                        size: 20,
                      ),
                    ],
                  ),

                  SizedBox(height: AppSpacing.sm),

                  // Instructions
                  Text(
                    'Pinch to zoom • Drag to reposition',
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),

                  SizedBox(height: AppSpacing.md),

                  // Action buttons
                  Row(
                    children: [
                      // Reset button
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            setState(() {
                              _scale = 1.0;
                              _offset = Offset.zero;
                            });
                          },
                          style: OutlinedButton.styleFrom(
                            padding: EdgeInsets.symmetric(
                              vertical: AppSpacing.md,
                            ),
                            side: BorderSide(
                              color: AppColors.textSecondary.withOpacity(0.2),
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            'Reset',
                            style: AppTypography.bodyMedium.copyWith(
                              color: AppColors.textSecondary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),

                      SizedBox(width: AppSpacing.md),

                      // Save button
                      Expanded(
                        flex: 2,
                        child: ElevatedButton(
                          onPressed: () {
                            // In production, save adjusted image parameters
                            // For now, just return original URL
                            widget.onSave(widget.imageUrl);
                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.blue,
                            padding: EdgeInsets.symmetric(
                              vertical: AppSpacing.md,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 0,
                          ),
                          child: Text(
                            'Save Changes',
                            style: AppTypography.bodyMedium.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
