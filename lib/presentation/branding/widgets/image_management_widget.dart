import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';

/// Image management widget for logo and background uploads
class ImageManagementWidget extends ConsumerStatefulWidget {
  final String title;
  final String description;
  final List<String> instructions;
  final String sampleImageUrl;
  final List<String> uploadedImages;
  final String? selectedImage;
  final Function(String) onImageSelected;
  final Function(String) onImageDeleted;
  final Function() onImageUpload;
  final bool isLogo;

  const ImageManagementWidget({
    Key? key,
    required this.title,
    required this.description,
    required this.instructions,
    required this.sampleImageUrl,
    required this.uploadedImages,
    this.selectedImage,
    required this.onImageSelected,
    required this.onImageDeleted,
    required this.onImageUpload,
    this.isLogo = false,
  }) : super(key: key);

  @override
  ConsumerState<ImageManagementWidget> createState() =>
      _ImageManagementWidgetState();
}

class _ImageManagementWidgetState extends ConsumerState<ImageManagementWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.gray200, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Icon(
                widget.isLogo ? Icons.image : Icons.wallpaper,
                color: AppColors.blue,
                size: 24,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.black,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.description,
                      style: TextStyle(fontSize: 13, color: AppColors.gray600),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Instructions
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.blue.withOpacity(0.05),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: AppColors.blue.withOpacity(0.2),
                width: 1,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.lightbulb_outline,
                      size: 16,
                      color: AppColors.blue,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Image Guidelines',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.blue,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                ...widget.instructions
                    .map(
                      (instruction) => Padding(
                        padding: const EdgeInsets.only(bottom: 6),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '• ',
                              style: TextStyle(
                                fontSize: 13,
                                color: AppColors.gray700,
                              ),
                            ),
                            Expanded(
                              child: Text(
                                instruction,
                                style: TextStyle(
                                  fontSize: 13,
                                  color: AppColors.gray700,
                                  height: 1.4,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                    .toList(),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Image Grid
          Text(
            'Available Images',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.gray700,
            ),
          ),
          const SizedBox(height: 12),

          GridView.count(
            crossAxisCount: 3,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            children: [
              // Sample Image (not deletable)
              _buildImageCard(
                imageUrl: widget.sampleImageUrl,
                label: 'Sample',
                isSelected: widget.selectedImage == widget.sampleImageUrl,
                isSample: true,
              ),

              // Uploaded Images
              ...widget.uploadedImages
                  .map(
                    (url) => _buildImageCard(
                      imageUrl: url,
                      label: 'Uploaded',
                      isSelected: widget.selectedImage == url,
                      isSample: false,
                      onDelete: () => widget.onImageDeleted(url),
                    ),
                  )
                  .toList(),

              // Upload Button
              _buildUploadCard(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildImageCard({
    required String imageUrl,
    required String label,
    required bool isSelected,
    required bool isSample,
    VoidCallback? onDelete,
  }) {
    return GestureDetector(
      onTap: () => widget.onImageSelected(imageUrl),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? AppColors.blue : AppColors.gray300,
            width: isSelected ? 3 : 1,
          ),
        ),
        child: Stack(
          children: [
            // Image
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: Stack(
                children: [
                  Image.network(
                    imageUrl,
                    width: double.infinity,
                    height: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: AppColors.gray100,
                        child: Center(
                          child: Icon(
                            widget.isLogo ? Icons.image : Icons.wallpaper,
                            color: AppColors.gray400,
                            size: 32,
                          ),
                        ),
                      );
                    },
                  ),
                  if (isSelected)
                    Container(color: AppColors.blue.withOpacity(0.2)),
                ],
              ),
            ),

            // Label Badge
            Positioned(
              bottom: 8,
              left: 8,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: isSample
                      ? AppColors.info.withOpacity(0.9)
                      : AppColors.success.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  label,
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),

            // Selected Checkmark
            if (isSelected)
              const Positioned(
                top: 8,
                right: 8,
                child: CircleAvatar(
                  radius: 12,
                  backgroundColor: AppColors.blue,
                  child: Icon(Icons.check, size: 16, color: Colors.white),
                ),
              ),

            // Delete Button (only for uploaded images)
            if (!isSample && onDelete != null)
              Positioned(
                top: 8,
                left: 8,
                child: GestureDetector(
                  onTap: onDelete,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: AppColors.error,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.close,
                      size: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildUploadCard() {
    return GestureDetector(
      onTap: widget.onImageUpload,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: AppColors.gray300,
            width: 1,
            style: BorderStyle.solid,
          ),
          color: AppColors.gray50,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.blue.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.cloud_upload_outlined,
                size: 32,
                color: AppColors.blue,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Upload',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.blue,
              ),
            ),
            Text(
              'Max 5 images',
              style: TextStyle(fontSize: 11, color: AppColors.gray600),
            ),
          ],
        ),
      ),
    );
  }
}
