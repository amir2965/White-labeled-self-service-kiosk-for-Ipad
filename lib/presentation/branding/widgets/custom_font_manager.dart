import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';

/// Custom font upload and management widget
class CustomFontManager extends ConsumerStatefulWidget {
  const CustomFontManager({Key? key}) : super(key: key);

  @override
  ConsumerState<CustomFontManager> createState() => _CustomFontManagerState();
}

class _CustomFontManagerState extends ConsumerState<CustomFontManager> {
  // Mock data - in production, this would be managed by a provider
  final List<CustomFontData> _uploadedFonts = [];
  final int _maxFonts = 5;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.blue.withOpacity(0.02),
            Colors.white,
            AppColors.blue.withOpacity(0.02),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.blue.withOpacity(0.2), width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppColors.blue, AppColors.blue.withOpacity(0.7)],
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.upload_file,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Custom Fonts',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.black,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Upload your own fonts (max 5) • Supported: TTF, OTF',
                      style: TextStyle(
                        fontSize: 13,
                        color: AppColors.gray600,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: _uploadedFonts.length >= _maxFonts
                      ? AppColors.error.withOpacity(0.1)
                      : AppColors.success.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${_uploadedFonts.length}/$_maxFonts',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: _uploadedFonts.length >= _maxFonts
                        ? AppColors.error
                        : AppColors.success,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Info Box
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.blue.withOpacity(0.05),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: AppColors.blue.withOpacity(0.2),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Icon(Icons.info_outline, size: 16, color: AppColors.blue),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Custom fonts will appear alongside curated fonts below. Remove existing fonts to add new ones if you reach the limit.',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.gray700,
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Uploaded Fonts List
          if (_uploadedFonts.isEmpty)
            _buildEmptyState()
          else
            ..._uploadedFonts.map((font) => _buildFontCard(font)).toList(),

          const SizedBox(height: 16),

          // Upload Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _uploadedFonts.length >= _maxFonts
                  ? null
                  : _handleFontUpload,
              icon: const Icon(Icons.add, size: 20),
              label: Text(
                _uploadedFonts.length >= _maxFonts
                    ? 'Maximum Fonts Reached'
                    : 'Upload Custom Font',
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.blue,
                foregroundColor: Colors.white,
                disabledBackgroundColor: AppColors.gray300,
                disabledForegroundColor: AppColors.gray600,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 0,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: AppColors.gray50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: AppColors.gray200,
          width: 1,
          style: BorderStyle.solid,
        ),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.gray200,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.font_download_outlined,
              size: 32,
              color: AppColors.gray500,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'No custom fonts uploaded',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.gray700,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Upload your brand fonts to use them in your kiosk',
            style: TextStyle(fontSize: 12, color: AppColors.gray600),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildFontCard(CustomFontData font) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.gray200, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Font Icon
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.blue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.text_fields,
              color: AppColors.blue,
              size: 20,
            ),
          ),
          const SizedBox(width: 16),

          // Font Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  font.name,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppColors.black,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${font.fileName} • ${_formatFileSize(font.fileSize)}',
                  style: TextStyle(fontSize: 12, color: AppColors.gray600),
                ),
              ],
            ),
          ),

          // Preview Text
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.gray50,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              'Aa',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.gray700,
                // In production: fontFamily: font.fontFamily
              ),
            ),
          ),
          const SizedBox(width: 12),

          // Delete Button
          IconButton(
            onPressed: () => _confirmDeleteFont(font),
            icon: const Icon(Icons.delete_outline),
            color: AppColors.error,
            iconSize: 20,
            padding: const EdgeInsets.all(8),
            constraints: const BoxConstraints(),
            style: IconButton.styleFrom(
              backgroundColor: AppColors.error.withOpacity(0.1),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _handleFontUpload() {
    // In production, this would open a file picker
    // For now, show a placeholder message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Font upload functionality will be integrated'),
        backgroundColor: AppColors.info,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        margin: const EdgeInsets.all(16),
      ),
    );

    // Mock adding a font for demonstration
    if (_uploadedFonts.length < _maxFonts) {
      setState(() {
        _uploadedFonts.add(
          CustomFontData(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            name: 'Custom Font ${_uploadedFonts.length + 1}',
            fileName: 'custom-font-${_uploadedFonts.length + 1}.ttf',
            fileSize: 245000,
            fontFamily: 'CustomFont${_uploadedFonts.length + 1}',
          ),
        );
      });
    }
  }

  void _confirmDeleteFont(CustomFontData font) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: const Text('Delete Font?'),
        content: Text(
          'Are you sure you want to delete "${font.name}"? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _uploadedFonts.removeWhere((f) => f.id == font.id);
              });
              Navigator.pop(ctx);
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  String _formatFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }
}

/// Custom font data model
class CustomFontData {
  final String id;
  final String name;
  final String fileName;
  final int fileSize;
  final String fontFamily;

  CustomFontData({
    required this.id,
    required this.name,
    required this.fileName,
    required this.fileSize,
    required this.fontFamily,
  });
}
