import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:ui' show ImageFilter;
import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:html' as html;
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/widgets/app_button.dart';
import '../../../config/api_keys.dart';
import 'product_edit_dialog.dart';
import 'menu_order_manager.dart';
import 'menu_scan_config_dialog.dart';
import 'quick_add_product_dialog.dart';
import 'template_picker_dialog_clean.dart';

class ProductsSetupStep extends StatefulWidget {
  final List<Map<String, dynamic>> products;
  final Function(List<Map<String, dynamic>>) onProductsChanged;

  const ProductsSetupStep({
    super.key,
    required this.products,
    required this.onProductsChanged,
  });

  @override
  State<ProductsSetupStep> createState() => _ProductsSetupStepState();
}

class _ProductsSetupStepState extends State<ProductsSetupStep> {
  bool _isProcessing = false;
  String _statusMessage = '';
  String _processingStage = ''; // Current AI stage
  bool _showInstructions = false;
  bool _hasNetworkIssue = false;
  bool _hasError = false;
  String _errorMessage = '';
  List<Map<String, dynamic>> _scannedProducts = [];
  int _imagesProcessed = 0;
  int _totalImages = 0;
  int _currentImageProcessing = 0;
  DateTime? _stageStartTime;
  MenuScanConfig? _scanConfig; // Store scan configuration

  // Multi-pass analysis tracking
  int _currentPass = 0;
  int _totalPasses = 4; // 1: Extract, 2: Validate, 3: Modifiers, 4: Cleanup
  List<String> _passNames = [
    'Extracting Menu',
    'Validating Items',
    'Finding Modifiers',
    'Final Cleanup',
  ];
  List<bool> _passCompleted = [false, false, false, false];

  // Bulk selection and actions
  bool _isSelectionMode = false;
  Set<int> _selectedIndices = {};

  // Scroll indicator state
  final ScrollController _scrollController = ScrollController();
  double _scrollOffset = 0.0;
  double _maxScrollExtent = 1.0;
  bool _showScrollIndicator = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    // Delay to check if content is scrollable
    Future.delayed(Duration(milliseconds: 500), () {
      if (mounted && _scrollController.hasClients) {
        setState(() {
          _maxScrollExtent = _scrollController.position.maxScrollExtent;
          _showScrollIndicator = _maxScrollExtent > 50;
        });
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (mounted) {
      setState(() {
        _scrollOffset = _scrollController.offset;
        _maxScrollExtent = _scrollController.position.maxScrollExtent;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth >= 768;
    final maxWidth = isTablet ? 900.0 : screenWidth;

    return Stack(
      children: [
        SingleChildScrollView(
          controller: _scrollController,
          padding: EdgeInsets.symmetric(
            horizontal: isTablet ? 48.0 : AppSpacing.screenPadding,
            vertical: AppSpacing.lg,
          ),
          child: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: maxWidth),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Header with subtitle
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Add your products', style: AppTypography.h2),
                      SizedBox(height: 8),
                      Text(
                        'Scan menu photos or add items manually to get started',
                        style: AppTypography.bodyMedium.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: AppSpacing.xl),

                  // Photo tips card with animation
                  AnimatedContainer(
                    duration: Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            _showInstructions = !_showInstructions;
                          });
                        },
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          padding: EdgeInsets.all(AppSpacing.md),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                AppColors.blue.withOpacity(0.08),
                                AppColors.blue.withOpacity(0.03),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: AppColors.blue.withOpacity(0.2),
                              width: 1.5,
                            ),
                          ),
                          child: Row(
                            children: [
                              Container(
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: AppColors.blue.withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Icon(
                                  Icons.camera_alt_outlined,
                                  color: AppColors.blue,
                                  size: 24,
                                ),
                              ),
                              SizedBox(width: AppSpacing.md),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Photo scanning tips',
                                      style: AppTypography.bodyLarge.copyWith(
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.black,
                                      ),
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      'Learn how to get the best results from menu photos',
                                      style: AppTypography.bodySmall.copyWith(
                                        color: AppColors.textSecondary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              AnimatedRotation(
                                turns: _showInstructions ? 0.5 : 0,
                                duration: Duration(milliseconds: 300),
                                child: Icon(
                                  Icons.keyboard_arrow_down,
                                  color: AppColors.blue,
                                  size: 28,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Instructions panel with animation
                  AnimatedSize(
                    duration: Duration(milliseconds: 400),
                    curve: Curves.easeInOut,
                    child: _showInstructions
                        ? Padding(
                            padding: EdgeInsets.only(top: AppSpacing.md),
                            child: _buildInstructionsPanel(isTablet),
                          )
                        : SizedBox.shrink(),
                  ),

                  SizedBox(height: AppSpacing.xl),

                  // Action buttons - responsive grid
                  isTablet
                      ? Row(
                          children: [
                            Expanded(
                              flex: 3,
                              child: AppButton(
                                label: 'Scan Menu Photos',
                                onPressed: _isProcessing
                                    ? null
                                    : () => _showPhotoTipsDialog(),
                                variant: AppButtonVariant.filled,
                                fullWidth: true,
                                icon: Icons.add_photo_alternate,
                              ),
                            ),
                            SizedBox(width: AppSpacing.md),
                            Expanded(
                              flex: 2,
                              child: AppButton(
                                label: 'Add Manually',
                                onPressed: _isProcessing
                                    ? null
                                    : () => _addManualProduct(),
                                variant: AppButtonVariant.outline,
                                fullWidth: true,
                                icon: Icons.edit,
                              ),
                            ),
                            SizedBox(width: AppSpacing.md),
                            Expanded(
                              flex: 2,
                              child: AppButton(
                                label: 'Use Demo',
                                onPressed: () => _useDemoProducts(),
                                variant: AppButtonVariant.outline,
                                fullWidth: true,
                                icon: Icons.coffee,
                              ),
                            ),
                          ],
                        )
                      : Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: AppButton(
                                    label: 'Scan Menu Photos',
                                    onPressed: _isProcessing
                                        ? null
                                        : () => _showPhotoTipsDialog(),
                                    variant: AppButtonVariant.filled,
                                    fullWidth: true,
                                    icon: Icons.add_photo_alternate,
                                  ),
                                ),
                                SizedBox(width: AppSpacing.md),
                                Expanded(
                                  child: AppButton(
                                    label: 'Add Manually',
                                    onPressed: _isProcessing
                                        ? null
                                        : () => _addManualProduct(),
                                    variant: AppButtonVariant.outline,
                                    fullWidth: true,
                                    icon: Icons.edit,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: AppSpacing.sm),
                            AppButton(
                              label: 'Use Demo Products',
                              onPressed: () => _useDemoProducts(),
                              variant: AppButtonVariant.outline,
                              fullWidth: true,
                              icon: Icons.coffee,
                            ),
                          ],
                        ),

                  if (widget.products.isNotEmpty ||
                      _scannedProducts.isNotEmpty) ...[
                    SizedBox(height: AppSpacing.md),
                    Container(
                      padding: EdgeInsets.all(AppSpacing.md),
                      decoration: BoxDecoration(
                        color: AppColors.blue.withOpacity(0.03),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: AppColors.blue.withOpacity(0.1),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.check_circle_outline,
                            color: AppColors.blue,
                            size: 20,
                          ),
                          SizedBox(width: AppSpacing.sm),
                          Expanded(
                            child: Text(
                              '${widget.products.length} items added',
                              style: AppTypography.bodyMedium.copyWith(
                                fontWeight: FontWeight.w600,
                                color: AppColors.black,
                              ),
                            ),
                          ),
                          // Bulk Actions Toggle Button
                          if (widget.products.isNotEmpty)
                            Padding(
                              padding: EdgeInsets.only(right: AppSpacing.sm),
                              child: TextButton.icon(
                                onPressed: () {
                                  setState(() {
                                    _isSelectionMode = !_isSelectionMode;
                                    if (!_isSelectionMode) {
                                      _selectedIndices.clear();
                                    }
                                  });
                                },
                                icon: Icon(
                                  _isSelectionMode
                                      ? Icons.close
                                      : Icons.checklist_rtl,
                                  size: 18,
                                ),
                                label: Text(
                                  _isSelectionMode ? 'Cancel' : 'Select',
                                ),
                                style: TextButton.styleFrom(
                                  foregroundColor: AppColors.blue,
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 8,
                                  ),
                                ),
                              ),
                            ),
                          if (_scannedProducts.isNotEmpty)
                            Padding(
                              padding: EdgeInsets.only(right: AppSpacing.sm),
                              child: TextButton.icon(
                                onPressed: () =>
                                    _showReviewScreen(widget.products),
                                icon: Icon(Icons.rate_review, size: 18),
                                label: Text('Review'),
                                style: TextButton.styleFrom(
                                  foregroundColor: AppColors.blue,
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 8,
                                  ),
                                ),
                              ),
                            ),
                          if (widget.products.isNotEmpty)
                            TextButton.icon(
                              onPressed: () => _openMenuOrganizer(),
                              icon: Icon(Icons.reorder, size: 18),
                              label: Text('Organize'),
                              style: TextButton.styleFrom(
                                foregroundColor: AppColors.blue,
                                padding: EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 8,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],

                  if (_isProcessing) ...[
                    SizedBox(height: AppSpacing.xl),
                    _buildProcessingIndicator(),
                  ],

                  SizedBox(height: AppSpacing.xl),

                  if (widget.products.isEmpty && !_isProcessing)
                    Container(
                      padding: EdgeInsets.symmetric(
                        vertical: isTablet ? 64 : 48,
                      ),
                      child: Center(
                        child: Column(
                          children: [
                            Container(
                              padding: EdgeInsets.all(24),
                              decoration: BoxDecoration(
                                color: AppColors.gray200,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.inventory_2_outlined,
                                size: isTablet ? 72 : 56,
                                color: AppColors.gray400,
                              ),
                            ),
                            SizedBox(height: AppSpacing.lg),
                            Text(
                              'No products added yet',
                              style: AppTypography.h3.copyWith(
                                color: AppColors.textSecondary,
                              ),
                            ),
                            SizedBox(height: AppSpacing.xs),
                            Text(
                              'Start by scanning menu photos or adding items manually',
                              style: AppTypography.bodySmall.copyWith(
                                color: AppColors.gray600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  else ...[
                    // Bulk Action Toolbar - Shows in selection mode
                    if (_isSelectionMode) ...[
                      _buildBulkActionToolbar(),
                      SizedBox(height: AppSpacing.md),
                    ],

                    // Show duplicate warning banner if duplicates exist
                    if (widget.products.any(
                      (p) => p['isDuplicate'] == true,
                    )) ...[
                      Container(
                        padding: EdgeInsets.all(AppSpacing.md),
                        margin: EdgeInsets.only(bottom: AppSpacing.md),
                        decoration: BoxDecoration(
                          color: Color(0xFFFF3B30).withOpacity(0.08),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Color(0xFFFF3B30).withOpacity(0.3),
                            width: 1.5,
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Color(0xFFFF3B30).withOpacity(0.15),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(
                                Icons.warning_amber_rounded,
                                color: Color(0xFFFF3B30),
                                size: 24,
                              ),
                            ),
                            SizedBox(width: AppSpacing.md),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Duplicates detected',
                                    style: AppTypography.bodyLarge.copyWith(
                                      color: Color(0xFFFF3B30),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Text(
                                    '${widget.products.where((p) => p['isDuplicate'] == true).length} duplicate items found',
                                    style: AppTypography.bodySmall.copyWith(
                                      color: Color(0xFFFF3B30).withOpacity(0.8),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            TextButton(
                              onPressed: _removeAllDuplicates,
                              style: TextButton.styleFrom(
                                foregroundColor: Color(0xFFFF3B30),
                                backgroundColor: Color(
                                  0xFFFF3B30,
                                ).withOpacity(0.1),
                                padding: EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 10,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: Text(
                                'Remove All',
                                style: TextStyle(fontWeight: FontWeight.w600),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                    // Product list with responsive grid for tablets
                    isTablet && widget.products.length > 2
                        ? GridView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  crossAxisSpacing: AppSpacing.md,
                                  mainAxisSpacing: AppSpacing.md,
                                  childAspectRatio: 3.5,
                                ),
                            itemCount: widget.products.length,
                            itemBuilder: (context, index) {
                              final product = widget.products[index];
                              return _buildProductItem(product, index);
                            },
                          )
                        : ListView.separated(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: widget.products.length,
                            separatorBuilder: (_, __) =>
                                SizedBox(height: AppSpacing.md),
                            itemBuilder: (context, index) {
                              final product = widget.products[index];
                              return _buildProductItem(product, index);
                            },
                          ),
                  ],
                ],
              ),
            ),
          ),
        ),

        // Floating Side Navigation Bar (Selection Mode)
        if (_isSelectionMode) _buildFloatingSideNav(isTablet),

        // Luxury scroll indicator on the right
        if (_showScrollIndicator && _maxScrollExtent > 50)
          _buildScrollIndicator(isTablet),
      ],
    );
  }

  Future<void> _scanMenuPhotoWithDialog(BuildContext dialogContext) async {
    try {
      // Show configuration dialog first
      final config = await showDialog<MenuScanConfig>(
        context: context,
        barrierDismissible: false,
        builder: (context) => const MenuScanConfigDialog(),
      );

      // User cancelled - close tips dialog too
      if (config == null) {
        if (mounted && Navigator.canPop(dialogContext)) {
          Navigator.pop(dialogContext);
        }
        return;
      }

      // Store config for use in extraction
      setState(() {
        _scanConfig = config;
      });

      // Use HTML file input for web with multiple selection
      final html.FileUploadInputElement uploadInput =
          html.FileUploadInputElement();
      uploadInput.accept = 'image/*';
      uploadInput.multiple = true;

      // Style the input to position it properly (invisible but positioned)
      uploadInput.style.position = 'fixed';
      uploadInput.style.bottom =
          '250px'; // Position near dialog button (adjusted higher)
      uploadInput.style.left = '50%';
      uploadInput.style.transform = 'translateX(-50%)';
      uploadInput.style.opacity = '0';
      uploadInput.style.width = '1px';
      uploadInput.style.height = '1px';

      uploadInput.onChange.listen((e) async {
        // Close the tips dialog now that user has selected files
        if (mounted && Navigator.canPop(dialogContext)) {
          Navigator.pop(dialogContext);
        }

        // Process the selected files
        await _processSelectedFiles(uploadInput.files);

        // Remove the input element
        uploadInput.remove();
      });

      // Add to DOM temporarily
      html.document.body?.append(uploadInput);

      // Small delay to ensure DOM is updated
      await Future.delayed(Duration(milliseconds: 100));
      uploadInput.click();
    } catch (e) {
      print('Error in photo scanning: $e');
      setState(() {
        _isProcessing = false;
        _hasError = true;
        _errorMessage = 'Failed to open photo selector: $e';
      });
      // Close dialog on error
      if (mounted && Navigator.canPop(dialogContext)) {
        Navigator.pop(dialogContext);
      }
    }
  }

  Future<void> _scanMenuPhoto() async {
    try {
      // Show configuration dialog first
      final config = await showDialog<MenuScanConfig>(
        context: context,
        barrierDismissible: false,
        builder: (context) => const MenuScanConfigDialog(),
      );

      // User cancelled
      if (config == null) return;

      // Store config for use in extraction
      setState(() {
        _scanConfig = config;
      });

      // Use HTML file input for web with multiple selection
      final html.FileUploadInputElement uploadInput =
          html.FileUploadInputElement();
      uploadInput.accept = 'image/*';
      uploadInput.multiple = true;

      uploadInput.onChange.listen((e) async {
        await _processSelectedFiles(uploadInput.files);
      });

      uploadInput.click();
    } catch (e) {
      print('Error in photo scanning: $e');
      setState(() {
        _isProcessing = false;
        _hasError = true;
        _errorMessage = 'Failed to open photo selector: $e';
      });
    }
  }

  Future<void> _processSelectedFiles(List<html.File>? files) async {
    try {
      print('=== PROCESSING FILES START ===');
      print('Files selected: ${files?.length ?? 0}');

      if (files == null || files.isEmpty) {
        print('No files selected, returning...');
        return;
      }

      // Limit to 4 images
      final filesToProcess = files.length > 4 ? files.sublist(0, 4) : files;
      print('Processing ${filesToProcess.length} files');

      setState(() {
        _isProcessing = true;
        _imagesProcessed = 0;
        _totalImages = filesToProcess.length;
        _hasError = false;
        _hasNetworkIssue = false;
        _currentPass = 0;
        _passCompleted = [false, false, false, false];
        _updateStage(
          'Reading Images',
          'Loading ${filesToProcess.length} photo${filesToProcess.length > 1 ? 's' : ''}...',
        );
      });

      try {
        // Read all images first
        final readStartTime = DateTime.now();
        final base64Images = <String>[];

        for (var i = 0; i < filesToProcess.length; i++) {
          final file = filesToProcess[i];
          setState(() {
            _currentImageProcessing = i + 1;
            _updateStage(
              'Reading Images',
              'Loading photo ${i + 1}/${filesToProcess.length}...',
            );
          });

          final reader = html.FileReader();
          final completer = Completer<String>();

          reader.onLoadEnd.listen((e) {
            try {
              final dataUrl = reader.result as String;
              final base64Image = dataUrl.split(',')[1];
              completer.complete(base64Image);
            } catch (e) {
              completer.completeError(e);
            }
          });

          reader.readAsDataUrl(file);
          final base64 = await completer.future;
          base64Images.add(base64);

          setState(() {
            _imagesProcessed = i + 1;
          });
        }

        final readDuration = DateTime.now().difference(readStartTime);

        // Check for slow network
        if (readDuration.inSeconds > 5) {
          setState(() {
            _hasNetworkIssue = true;
          });
        }

        // Process images sequentially (one by one) to prevent issues
        List<List<Map<String, dynamic>>> results = [];
        final extractionStartTime = DateTime.now();

        for (var i = 0; i < base64Images.length; i++) {
          setState(() {
            _currentImageProcessing = i + 1;
          });

          final extractedItems = await _extractMenuFromImage(
            base64Images[i],
            i + 1,
          );

          // Tag each item with source image index for later analysis
          for (var item in extractedItems) {
            item['_sourceImageIndex'] = i; // Track which image this came from
          }

          results.add(extractedItems);

          setState(() {
            _imagesProcessed = i + 1;
          });
        }

        final extractionDuration = DateTime.now().difference(
          extractionStartTime,
        );

        // Check for slow AI processing
        if (extractionDuration.inSeconds > 20) {
          setState(() {
            _hasNetworkIssue = true;
          });
        }

        List<Map<String, dynamic>> allExtractedProducts = [];
        print('\n=== EXTRACTION RESULTS ===');
        for (var i = 0; i < results.length; i++) {
          final products = results[i];
          print('Image ${i + 1}: Extracted ${products.length} items');
          for (var p in products) {
            print('  - ${p['name']} (\$${p['price']}) [${p['category']}]');
          }
          allExtractedProducts.addAll(products);
        }
        print('Total extracted: ${allExtractedProducts.length} items\n');

        if (allExtractedProducts.isNotEmpty) {
          // PASS 1: Initial extraction complete
          setState(() {
            _passCompleted[0] = true;
            _currentPass = 1;
          });

          // PASS 2: Validate and find missing items
          setState(() {
            _updateStage(
              _passNames[1],
              'Checking for missing items at end of menu...',
            );
          });

          final validatedProducts = await _validateMenuItems(
            allExtractedProducts,
            base64Images,
          );

          setState(() {
            _passCompleted[1] = true;
            _currentPass = 2;
          });

          // PASS 3: Find missing modifiers
          setState(() {
            _updateStage(
              _passNames[2],
              'Analyzing descriptions and menu end for modifiers...',
            );
          });

          final productsWithModifiers = await _extractMissingModifiers(
            validatedProducts,
            base64Images,
          );

          setState(() {
            _passCompleted[2] = true;
            _currentPass = 3;
          });

          // PASS 4: Final cleanup and deduplication
          setState(() {
            _updateStage(_passNames[3], 'Cleaning and organizing menu...');
          });

          // Use AI to intelligently deduplicate all extracted products
          _updateStage('Cleaning Menu', 'AI removing duplicate items...');

          try {
            final cleanedProducts = await _deduplicateWithAI(
              productsWithModifiers,
            );

            setState(() {
              _passCompleted[3] = true;
            });

            // Merge cleaned products with existing scanned products
            final mergedProducts = _mergeProducts(
              _scannedProducts,
              cleanedProducts,
            );

            setState(() {
              _scannedProducts = mergedProducts;
              _statusMessage = '';
              _isProcessing = false; // Stop spinner
            });
            _showReviewScreen(mergedProducts);
          } catch (e) {
            print('AI deduplication failed, falling back to manual: $e');
            // Fallback to manual deduplication
            final batchWithDuplicates = _markDuplicatesInBatch(
              allExtractedProducts,
            );
            final mergedProducts = _mergeProducts(
              _scannedProducts,
              batchWithDuplicates,
            );
            setState(() {
              _scannedProducts = mergedProducts;
              _statusMessage = '';
              _isProcessing = false; // Stop spinner
            });
            _showReviewScreen(mergedProducts);
          }
        } else {
          _showError(
            'Extraction Failed',
            'Could not extract items. Try different photos or use demo products.',
          );
        }
      } catch (e, stackTrace) {
        print('ERROR in extraction: $e');
        print('Stack trace: $stackTrace');
        _showError('Error', 'Failed to read files: ${e.toString()}');
      }
    } catch (e, stackTrace) {
      print('ERROR in processing: $e');
      print('Stack trace: $stackTrace');
      _showError('Error', 'Failed to process files: ${e.toString()}');
    }
  }

  String _buildCustomPrompt() {
    // Use default config if none provided
    final config = _scanConfig ?? MenuScanConfig.getDefault();

    // Build context-specific instructions based on menu type
    String menuTypeContext = '';
    switch (config.menuType) {
      case 'Coffee Shop':
        menuTypeContext =
            'This is a COFFEE SHOP menu. Pay special attention to size variations (S/M/L, Cup/Mug), milk alternatives, and coffee-specific add-ons.';
        break;
      case 'Fast Food':
        menuTypeContext =
            'This is a FAST FOOD menu. Look for meal deals, combo options, and size variations (Small/Medium/Large).';
        break;
      case 'Fine Dining':
        menuTypeContext =
            'This is a FINE DINING menu. Expect detailed descriptions, ingredient lists, and fewer modifier options. Prices may be "Market Price".';
        break;
      case 'Bar/Pub':
        menuTypeContext =
            'This is a BAR/PUB menu. Look for drink sizes, alcohol content, and food pairings.';
        break;
      case 'Bakery':
        menuTypeContext =
            'This is a BAKERY menu. Items may have quantities (dozen, half-dozen) and dietary options (gluten-free).';
        break;
      default:
        menuTypeContext =
            'This is a RESTAURANT menu. Extract all food items with their prices, sizes, and customization options.';
    }

    // Build layout-specific instructions
    String layoutInstructions = '';
    switch (config.layoutStyle) {
      case 'Categorized Sections':
        layoutInstructions =
            'The menu is organized in CATEGORY SECTIONS (e.g., Appetizers, Mains, Desserts). Items under headers belong to that category.';
        break;
      case 'Grid Layout':
        layoutInstructions =
            'The menu uses a GRID LAYOUT. Items may be arranged in columns/rows without clear category headers.';
        break;
      case 'Simple List':
        layoutInstructions =
            'The menu is a SIMPLE LIST. Items are listed sequentially with minimal categorization.';
        break;
      default:
        layoutInstructions =
            'The menu has a MIXED LAYOUT. Adapt to the structure you see.';
    }

    // Build pricing-specific instructions
    String pricingInstructions = '';
    switch (config.pricingFormat) {
      case 'Multiple Sizes (S/M/L)':
        pricingInstructions =
            'Prices are shown for multiple sizes using S/M/L abbreviations. Create Size modifier groups with ABSOLUTE prices for each size.';
        break;
      case 'Multiple Sizes (Cup/Mug)':
        pricingInstructions =
            'Prices are shown as Cup/Mug variants. Create Size modifier groups with ABSOLUTE prices for each option.';
        break;
      case 'Price Ranges (4.5/5.0/5.5)':
        pricingInstructions =
            'Prices are shown as slash-separated ranges (e.g., 4.5/5.0/5.5). Match these to size options in order and create Size modifier groups.';
        break;
      case 'Market Price':
        pricingInstructions =
            'Some items may show "Market Price" or "MP". Use 0.00 as price and note in description.';
        break;
      default:
        pricingInstructions =
            'Most items have SINGLE PRICES. Only create Size modifiers if multiple prices are clearly shown for one item.';
    }

    // Build extraction priorities
    final priorityList = <String>[];
    if (config.extractSizes) {
      priorityList.add('- EXTRACT SIZE VARIATIONS as modifier groups');
    }
    if (config.extractModifiers) {
      priorityList.add(
        '- EXTRACT MODIFIERS/ADD-ONS (toppings, sauces, sides, extras)',
      );
    }
    if (config.extractDescriptions) {
      priorityList.add('- EXTRACT DETAILED DESCRIPTIONS and ingredients');
    }
    if (!config.extractSizes) {
      priorityList.add(
        '- DO NOT create Size modifier groups even if you see size info',
      );
    }
    if (!config.extractModifiers) {
      priorityList.add('- DO NOT extract modifier/add-on options');
    }
    if (!config.extractDescriptions) {
      priorityList.add('- SKIP descriptions, leave empty string');
    }

    final extractionPriorities = priorityList.isEmpty
        ? '- Extract all available information'
        : priorityList.join('\n');

    // Build delimiter handling
    final delimiterInstructions = config.splitOrDelimitedOptions
        ? '''
11. CRITICAL - SPLIT "OR" DELIMITED OPTIONS: If you see options like "Mushroom OR Green Peppercorn OR Diane Sauce", create SEPARATE options for each choice:
    * WRONG: {"name": "Mushroom OR Green Peppercorn OR Diane Sauce", "price": 0}
    * CORRECT: [{"name": "Mushroom", "price": 0}, {"name": "Green Peppercorn", "price": 0}, {"name": "Diane Sauce", "price": 0}]
    * Same applies to "/" delimiters: "Chicken/Beef/Lamb" → 3 separate options'''
        : '11. Keep option names as shown, do NOT split "OR" or "/" delimited text';

    // Build the complete prompt
    return '''
$menuTypeContext
$layoutInstructions
$pricingInstructions

🚨 CRITICAL: Extract EVERY SINGLE ITEM you can see in the image. Do not skip or truncate the list. If there are 50+ items, include all of them.

Analyze this menu image and extract all UNIQUE menu items in JSON format.

EXTRACTION PRIORITIES:
$extractionPriorities

🚨 CRITICAL PRICING RULES:

**ISSUE #1 - MODIFIER PRICING = RELATIVE (EXTRA COST), NOT ABSOLUTE:**
- Base price is LOWEST/DEFAULT option price
- Modifier option prices are EXTRA COST added to base
- Example: "Flat White S/M/L 4.5/5.0/5.5"
  ✅ CORRECT: base: 4.50, Size options: Small +0, Medium +0.50, Large +1.00
  ❌ WRONG: base: 4.50, Size options: Small 4.50, Medium 5.00, Large 5.50
- This applies to ALL modifier groups (Size, Cup/Mug, etc.)

**ISSUE #2 - INHERIT MISSING SIZE MODIFIERS:**
- If category header shows sizes but items have no prices, INHERIT the pattern
- Example: Header "Cup/Mug 4.5/5.5", then "Cappuccino" (no price) → Apply Cup/Mug 4.5/5.5
- Check if items are in same category group and apply consistent sizing

**ISSUE #3 - TITLE WITH OR/SLASH = MULTIPLE ITEMS:**
- "Orange or Apple 6.5/8.5" → TWO items: "Orange Juice" and "Apple Juice"
- "Iced Long Black / Iced Latte 5.5/6.5" → TWO items with respective prices
- Pattern: [Name1] or/and [Name2] [prices] → Split into separate products

**ISSUE #4 - DESCRIPTION AS OPTIONS (NOT TEXT):**
- If description lists choices with dashes, make them OPTIONS not text
- "Get Fresh 6.5/8.5\\nApple - Strawberry - Watermelon" → Create Flavor modifier with 3 options
- Multiple items on lines = options. Paragraph = description.

**ISSUE #5 - SINGLE ROW MULTIPLE ITEMS:**
- Items on SAME line with "/" and different prices = SEPARATE products
- "Iced Long Black / Iced Latte 5.5/6.5" → TWO distinct items

**ISSUE #6 - CATEGORY-BASED FLAVORS:**
- "MILKSHAKES: Chocolate / Banana / Strawberry" → "Chocolate Milkshake", "Banana Milkshake", etc.

IMPORTANT RULES:
1. Combine category + variant: "Spinach" under "Borek:" → "Spinach Borek"
2. Every item MUST have price > 0 (estimate if missing based on similar items)
3. NO DUPLICATES - same item appears only once
4. Ignore pure headers like "MEALS", "DRINKS"
$delimiterInstructions

For each UNIQUE item, extract:
- name: Full descriptive name (combine category + variant if listed under header)
- price: Base price as decimal (MUST be > 0, use reasonable estimate if not visible)
- category: Main category (e.g., ${_getCategoryExamples(config.menuType)})
- description: ${config.extractDescriptions ? 'Brief description if visible' : 'Leave as empty string ""'}
- tags: Empty array [] (tags will be added manually by user if needed)
- modifierGroups: ${config.extractModifiers || config.extractSizes ? 'Array of customization groups' : 'Empty array []'} with:
  * groupName: "Size", "Meat", "Add-ons", "Extras", etc.
  * required: true/false (true for Size if multiple prices shown, false for Add-ons)
  * minSelection: Minimum number of options (1 if required, 0 if optional)
  * maxSelection: Maximum number of options (1 for single-choice like Size, or more for multi-select like Add-ons)
  * options: Array of choices with name and price (EXTRA COST for modifiers, NOT absolute)

Return ONLY valid JSON array:
[
  {
    "name": "Flat White",
    "price": 4.50,
    "category": "Coffee",
    "description": "",
    "tags": [],
    "modifierGroups": [
      {
        "groupName": "Size",
        "required": true,
        "minSelection": 1,
        "maxSelection": 1,
        "options": [
          {"name": "Small", "price": 0},
          {"name": "Medium", "price": 0.50},
          {"name": "Large", "price": 1.00}
        ]
      }
    ]
  }
]

CRITICAL FINAL CHECK:
- Modifier prices = EXTRA COST (+price), NOT absolute
- Items with "or"/"/" in title = SEPARATE items unless clearly options
- Description with dashes = check if OPTIONS or just ingredients
- Apply missing sizes from category context
- ALL PRICES > 0
- Return valid JSON only, no markdown
''';
  }

  String _getCategoryExamples(String menuType) {
    switch (menuType) {
      case 'Coffee Shop':
        return 'Coffee, Tea, Juice, Frappe, Smoothies, Pastries';
      case 'Fast Food':
        return 'Burgers, Fries, Drinks, Desserts, Combos';
      case 'Fine Dining':
        return 'Appetizers, Entrees, Mains, Desserts, Wine';
      case 'Bar/Pub':
        return 'Beer, Wine, Cocktails, Appetizers, Pub Food';
      case 'Bakery':
        return 'Bread, Pastries, Cakes, Cookies, Sandwiches';
      default:
        return 'Appetizers, Mains, Sides, Desserts, Drinks';
    }
  }

  Future<List<Map<String, dynamic>>> _extractMenuFromImage(
    String base64Image,
    int imageNumber,
  ) async {
    setState(() {
      _updateStage(
        'AI Analysis - Image $imageNumber',
        'Analyzing photo $imageNumber of $_totalImages...',
      );
    });

    // Check if API key is configured
    if (!ApiKeys.isGeminiConfigured) {
      if (mounted) {
        _showApiKeyDialog();
      }
      return [];
    }

    final apiKey = ApiKeys.geminiApiKey;

    final url = Uri.parse(
      'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash-exp:generateContent?key=$apiKey',
    );

    // Build customized prompt based on configuration
    final prompt = _buildCustomPrompt();

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'contents': [
            {
              'parts': [
                {'text': prompt},
                {
                  'inline_data': {
                    'mime_type': 'image/jpeg',
                    'data': base64Image,
                  },
                },
              ],
            },
          ],
          'generationConfig': {'temperature': 0.2, 'maxOutputTokens': 8192},
        }),
      );

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        final text =
            jsonResponse['candidates'][0]['content']['parts'][0]['text'];

        // Clean up the response (remove markdown code blocks if present)
        String cleanText = text.trim();
        if (cleanText.startsWith('```json')) {
          cleanText = cleanText.substring(7);
        }
        if (cleanText.startsWith('```')) {
          cleanText = cleanText.substring(3);
        }
        if (cleanText.endsWith('```')) {
          cleanText = cleanText.substring(0, cleanText.length - 3);
        }
        cleanText = cleanText.trim();

        // Remove any trailing commas before closing brackets/braces
        cleanText = cleanText.replaceAll(RegExp(r',\s*}'), '}');
        cleanText = cleanText.replaceAll(RegExp(r',\s*]'), ']');

        // Try to fix common JSON issues
        try {
          final List<dynamic> items = jsonDecode(cleanText);
          return items.cast<Map<String, dynamic>>();
        } catch (e) {
          print('JSON parse error: $e');
          print(
            'Problematic JSON: ${cleanText.substring(0, cleanText.length > 500 ? 500 : cleanText.length)}...',
          );

          // Advanced JSON repair strategies
          try {
            // Strategy 1: Try to fix truncated JSON by closing unclosed brackets
            String repairedText = cleanText;

            // Count opening/closing brackets
            int openBrackets = '['.allMatches(repairedText).length;
            int closeBrackets = ']'.allMatches(repairedText).length;
            int openBraces = '{'.allMatches(repairedText).length;
            int closeBraces = '}'.allMatches(repairedText).length;

            // If truncated, try to close properly
            if (openBraces > closeBraces || openBrackets > closeBrackets) {
              print('Detected truncated JSON. Attempting repair...');

              // Remove any incomplete trailing content after last complete object
              final lastCompleteObject = repairedText.lastIndexOf('}');
              if (lastCompleteObject > 0) {
                repairedText = repairedText.substring(
                  0,
                  lastCompleteObject + 1,
                );

                // Remove trailing comma if exists
                repairedText = repairedText.replaceAll(RegExp(r',\s*$'), '');

                // Close the array
                if (!repairedText.trim().endsWith(']')) {
                  repairedText += '\n]';
                }
              }
            }

            // Strategy 2: Try parsing the repaired text
            try {
              final List<dynamic> items = jsonDecode(repairedText);
              print(
                'Successfully repaired and parsed JSON! Got ${items.length} items',
              );
              return items.cast<Map<String, dynamic>>();
            } catch (e2) {
              print('Repair attempt failed: $e2');
            }

            // Strategy 3: Extract complete objects one by one
            print('Attempting to extract individual valid objects...');
            final validItems = <Map<String, dynamic>>[];
            final objectRegex = RegExp(r'\{[^{}]*(?:\{[^{}]*\}[^{}]*)*\}');
            final matches = objectRegex.allMatches(cleanText);

            for (final match in matches) {
              try {
                final objStr = match.group(0)!;
                final obj = jsonDecode(objStr);
                if (obj is Map && obj['name'] != null && obj['price'] != null) {
                  validItems.add(obj.cast<String, dynamic>());
                }
              } catch (_) {
                // Skip invalid objects
              }
            }

            if (validItems.isNotEmpty) {
              print(
                'Extracted ${validItems.length} valid items from malformed JSON',
              );
              return validItems;
            }
          } catch (repairError) {
            print('All repair strategies failed: $repairError');
          }

          rethrow;
        }
      } else {
        // Detailed error message
        String errorDetails = 'Status ${response.statusCode}';
        try {
          final errorBody = jsonDecode(response.body);
          errorDetails += ': ${errorBody['error']['message'] ?? response.body}';
        } catch (_) {
          errorDetails += ': ${response.body}';
        }
        throw Exception('API request failed - $errorDetails');
      }
    } catch (e) {
      print('Error extracting menu: $e');
      rethrow;
    }
  }

  // PASS 2: Validate menu items - check for missing items
  Future<List<Map<String, dynamic>>> _validateMenuItems(
    List<Map<String, dynamic>> products,
    List<String> base64Images,
  ) async {
    print('\n=== PASS 2: VALIDATING MENU ITEMS ===');
    print('Input: ${products.length} products');

    if (!ApiKeys.isGeminiConfigured) {
      return products; // Skip if no API
    }

    final apiKey = ApiKeys.geminiApiKey;
    final url = Uri.parse(
      'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash-exp:generateContent?key=$apiKey',
    );

    // Create summary of extracted items
    final extractedSummary = products
        .map((p) => '${p['name']} (\$${p['price']}) - ${p['category']}')
        .join('\\n');

    final prompt =
        '''
🔍 VALIDATION TASK: Check if any items are MISSING from the extracted menu.

EXTRACTED ITEMS SO FAR:
$extractedSummary

FOCUS AREAS:
1. **End of Menu**: Look carefully at the BOTTOM/END of all images - items often get cut off
2. **Incomplete Sections**: Check if any category seems to have fewer items than shown in the image
3. **Small Text**: Look for items in small print that might have been missed
4. **Faded Areas**: Check corners and edges for items that might be less visible

TASK: 
- Review ALL images carefully, especially the ENDS/BOTTOMS
- Find any items that appear in the images but are NOT in the extracted list above
- Return ONLY the MISSING items in the same JSON format

If you find missing items, return them as JSON array:
[
  {
    "name": "Item Name",
    "price": 5.00,
    "category": "Category",
    "description": "Optional description",
    "modifiers": []
  }
]

If NO items are missing, return empty array: []

RETURN VALID JSON ONLY - no markdown, no explanations.
''';

    try {
      // Send all images for validation
      final imageParts = base64Images
          .map(
            (img) => {
              'inline_data': {'mime_type': 'image/jpeg', 'data': img},
            },
          )
          .toList();

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'contents': [
            {
              'parts': [
                {'text': prompt},
                ...imageParts,
              ],
            },
          ],
          'generationConfig': {'temperature': 0.2, 'maxOutputTokens': 8192},
        }),
      );

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        final text =
            jsonResponse['candidates'][0]['content']['parts'][0]['text'];

        String cleanText = text.trim();
        if (cleanText.startsWith('```json')) {
          cleanText = cleanText.substring(7);
        }
        if (cleanText.startsWith('```')) {
          cleanText = cleanText.substring(3);
        }
        if (cleanText.endsWith('```')) {
          cleanText = cleanText.substring(0, cleanText.length - 3);
        }
        cleanText = cleanText.trim();

        try {
          final List<dynamic> missingItems = jsonDecode(cleanText);
          final missing = missingItems.cast<Map<String, dynamic>>();

          if (missing.isNotEmpty) {
            print('✅ Found ${missing.length} missing items:');
            for (var item in missing) {
              print('  + ${item['name']} (\$${item['price']})');
            }
            return [...products, ...missing];
          } else {
            print('✅ No missing items found');
            return products;
          }
        } catch (e) {
          print('⚠️ Validation parse error: $e');
          return products; // Return original on error
        }
      } else {
        print('⚠️ Validation API error: ${response.statusCode}');
        return products;
      }
    } catch (e) {
      print('⚠️ Validation failed: $e');
      return products; // Return original on error
    }
  }

  // PASS 3: Extract missing modifiers - ENHANCED with image-specific analysis
  Future<List<Map<String, dynamic>>> _extractMissingModifiers(
    List<Map<String, dynamic>> products,
    List<String> base64Images,
  ) async {
    print('\n=== PASS 3: FINDING MISSING MODIFIERS (ENHANCED) ===');
    print('Input: ${products.length} products');

    if (!ApiKeys.isGeminiConfigured) {
      return products;
    }

    final apiKey = ApiKeys.geminiApiKey;
    final url = Uri.parse(
      'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash-exp:generateContent?key=$apiKey',
    );

    // Group products by source image for targeted analysis
    Map<int, List<Map<String, dynamic>>> productsByImage = {};
    for (var product in products) {
      final imageIndex = product['_sourceImageIndex'] as int? ?? 0;
      if (!productsByImage.containsKey(imageIndex)) {
        productsByImage[imageIndex] = [];
      }
      productsByImage[imageIndex]!.add(product);
    }

    print('Products grouped by ${productsByImage.length} images');

    List<Map<String, dynamic>> enhancedProducts = [];
    int totalModifiersAdded = 0;

    // Process each image with its specific items
    for (var imageIndex in productsByImage.keys) {
      final imageProducts = productsByImage[imageIndex]!;
      final base64Image = base64Images[imageIndex];

      print(
        '\n📸 Analyzing image ${imageIndex + 1} with ${imageProducts.length} items...',
      );

      // Create detailed item list for focused analysis
      final itemDetails = imageProducts
          .map((p) {
            final existingMods = (p['modifierGroups'] as List?)?.length ?? 0;
            return '• ${p['name']} (\$${p['price']}) - Category: ${p['category']} - Current modifiers: $existingMods';
          })
          .join('\n');

      final prompt =
          '''
🎯 LASER-FOCUSED MODIFIER EXTRACTION

You are analyzing IMAGE ${imageIndex + 1} which contains these SPECIFIC items:

$itemDetails

🔍 YOUR MISSION: Find EVERY modifier, option, and size variation for these items that exists in THIS image.

📋 CRITICAL SEARCH AREAS (in order of importance):

1. **ITEM DESCRIPTIONS** (Most Important!)
   - Look at the description/details text DIRECTLY under or next to each item
   - Find phrases like:
     * "Available in Small/Medium/Large" → SIZE modifiers
     * "Add extra shot \$1, Oat milk \$0.50" → ADD-ON modifiers
     * "Choice of: White/Wheat/Sourdough" → OPTION modifiers
     * "Gluten-free available" → DIETARY modifiers
   - Even if description seems like plain text, check if it lists CHOICES

2. **SIZE ROWS FOR SPECIFIC ITEMS**
   - If ONE item in a category shows "S/M/L 4.5/5.0/5.5"
   - But OTHER items in same category have NO sizes shown
   - Those other items likely have SAME size options (inherit from category pattern)
   - Example: If "Latte S/M/L" is shown, then "Cappuccino" below it probably also has S/M/L

3. **CATEGORY FOOTER TEXT**
   - Look at the END of each category section
   - Find text like:
     * "All coffees available with: Soy milk +\$0.50, Extra shot +\$1"
     * "Add-ons: Bacon +\$2, Avocado +\$1.50, Extra cheese +\$1"
   - Apply these to ALL items in that category

4. **EXTRAS VS ITEMS**
   ⚠️ CRITICAL DISTINCTION:
   - If extras are listed separately (e.g., "EXTRAS: Bacon \$2, Cheese \$1")
   - They are NOT separate menu items
   - They are MODIFIERS to add to existing items
   - Example: "Sides: Fries \$3, Salad \$4" for "Burger" → These are modifier options, not separate items

5. **MENU END / GLOBAL MODIFIERS**
   - Check BOTTOM of the image for general notes
   - "All drinks available iced or hot"
   - "Milk alternatives: Soy/Almond/Oat +\$0.50"

🎯 RESPONSE FORMAT:
Return the SAME items but with modifierGroups field ENHANCED/UPDATED.

For each item that needs modifiers added:
{
  "name": "Flat White",
  "price": 4.50,
  "category": "Coffee",
  "description": "...",
  "modifierGroups": [
    {
      "groupName": "Size",
      "required": true,
      "minSelection": 1,
      "maxSelection": 1,
      "options": [
        {"name": "Small", "price": 0.00},
        {"name": "Medium", "price": 0.50},
        {"name": "Large", "price": 1.00}
      ]
    },
    {
      "groupName": "Milk Options",
      "required": false,
      "minSelection": 0,
      "maxSelection": 1,
      "options": [
        {"name": "Regular Milk", "price": 0.00},
        {"name": "Oat Milk", "price": 0.50},
        {"name": "Almond Milk", "price": 0.50}
      ]
    }
  ]
}

🚨 CRITICAL RULES:
1. Modifier prices = EXTRA COST (+price), NOT absolute price
2. If description lists choices, they are OPTIONS not plain text
3. Size mentioned for one item in category → likely applies to similar items
4. Extras section for a category → modifiers for all items in that category
5. Preserve ALL existing modifierGroups, only ADD missing ones
6. Temperature (Hot/Iced), Size (S/M/L), Extras (shots, milk) are separate groups

Return ONLY valid JSON array with ALL items (even if no changes). No markdown, no explanations.
''';

      try {
        final response = await http.post(
          url,
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'contents': [
              {
                'parts': [
                  {'text': prompt},
                  {
                    'inline_data': {
                      'mime_type': 'image/jpeg',
                      'data': base64Image,
                    },
                  },
                ],
              },
            ],
            'generationConfig': {'temperature': 0.2, 'maxOutputTokens': 8192},
          }),
        );

        if (response.statusCode == 200) {
          final jsonResponse = jsonDecode(response.body);
          final text =
              jsonResponse['candidates'][0]['content']['parts'][0]['text'];

          String cleanText = text.trim();
          if (cleanText.startsWith('```json')) {
            cleanText = cleanText.substring(7);
          }
          if (cleanText.startsWith('```')) {
            cleanText = cleanText.substring(3);
          }
          if (cleanText.endsWith('```')) {
            cleanText = cleanText.substring(0, cleanText.length - 3);
          }
          cleanText = cleanText.trim();

          try {
            final List<dynamic> updatedItems = jsonDecode(cleanText);
            final updated = updatedItems.cast<Map<String, dynamic>>();

            // Count modifiers added for this image
            for (
              int i = 0;
              i < imageProducts.length && i < updated.length;
              i++
            ) {
              final oldMods =
                  (imageProducts[i]['modifierGroups'] as List?)?.length ?? 0;
              final newMods =
                  (updated[i]['modifierGroups'] as List?)?.length ?? 0;
              if (newMods > oldMods) {
                final added = newMods - oldMods;
                totalModifiersAdded += added;
                print('  ✨ ${updated[i]['name']}: +$added modifier group(s)');
              }
            }

            enhancedProducts.addAll(updated);
          } catch (e) {
            print('⚠️ Parse error for image ${imageIndex + 1}: $e');
            enhancedProducts.addAll(imageProducts); // Keep originals
          }
        } else {
          print(
            '⚠️ API error for image ${imageIndex + 1}: ${response.statusCode}',
          );
          enhancedProducts.addAll(imageProducts);
        }
      } catch (e) {
        print('⚠️ Failed to analyze image ${imageIndex + 1}: $e');
        enhancedProducts.addAll(imageProducts);
      }
    }

    // Clean up temporary tracking field
    for (var product in enhancedProducts) {
      product.remove('_sourceImageIndex');
    }

    if (totalModifiersAdded > 0) {
      print(
        '\n✅ PASS 3 COMPLETE: Added $totalModifiersAdded modifier groups across all items',
      );
    } else {
      print('\n✅ PASS 3 COMPLETE: No additional modifiers found');
    }

    return enhancedProducts;
  }

  Future<List<Map<String, dynamic>>> _deduplicateWithAI(
    List<Map<String, dynamic>> products,
  ) async {
    print('\n=== AI DEDUPLICATION START ===');
    print('Input: ${products.length} products');
    for (var p in products) {
      print('  - ${p['name']} (\$${p['price']}) [${p['category']}]');
    }

    // Check if API key is configured
    if (!ApiKeys.isGeminiConfigured) {
      throw Exception('API key not configured');
    }

    final apiKey = ApiKeys.geminiApiKey;

    final url = Uri.parse(
      'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash-exp:generateContent?key=$apiKey',
    );

    final prompt =
        '''
Remove only EXACT duplicates from this menu. You must be EXTREMELY conservative.

DUPLICATE RULES (ALL must match):
1. Names must be virtually IDENTICAL after basic normalization (lowercase + trim)
2. Same category
3. Prices within \$0.50 of each other

EXAMPLES OF DUPLICATES:
- "Chicken Burger" and "chicken burger" (same name, different case)
- "Coffee" and "Coffee " (same name with extra space)
- "Latte (\$4.50)" and "Latte (\$4.50)" (exact match)

EXAMPLES OF NOT DUPLICATES (keep both):
- "Chicken Burger" and "Beef Burger" (different protein)
- "Chicken Burger" and "Chicken Wrap" (different format)
- "Small Coffee" and "Large Coffee" (different sizes - unless they have modifiers)
- "Spinach Borek" and "Cheese Borek" (different filling)
- "Iced Coffee" and "Hot Coffee" (different preparation)
- Items from different categories (even if similar names)
- Items with different descriptions

CRITICAL RULES:
- When in doubt, KEEP BOTH items - it's better to have duplicates than lose menu items
- Only merge if names are 95%+ identical and same category
- If items have different descriptive words (adjectives, proteins, styles), they are NOT duplicates
- Different prices usually means different items

Input (${products.length} items):
${jsonEncode(products)}

Return complete JSON array (keep all unique items):
[{"name":"","price":0,"category":"","modifierGroups":[]}]
''';

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'contents': [
            {
              'parts': [
                {'text': prompt},
              ],
            },
          ],
          'generationConfig': {
            'temperature': 0.3, // Slightly higher for better judgment
            'maxOutputTokens': 8192,
          },
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final text = data['candidates'][0]['content']['parts'][0]['text'];

        // Clean the response
        String cleanedText = text
            .replaceAll('```json', '')
            .replaceAll('```', '')
            .trim();

        // Remove trailing commas before closing brackets
        cleanedText = cleanedText.replaceAll(RegExp(r',\s*]'), ']');
        cleanedText = cleanedText.replaceAll(RegExp(r',\s*}'), '}');

        // Try to extract just the array if there's extra text
        final arrayMatch = RegExp(
          r'\[.*\]',
          dotAll: true,
        ).firstMatch(cleanedText);
        if (arrayMatch != null) {
          cleanedText = arrayMatch.group(0)!;
        }

        final List<dynamic> decodedProducts = jsonDecode(cleanedText);
        final removedCount = products.length - decodedProducts.length;
        final reductionPercent = (removedCount / products.length * 100).toInt();

        print('=== AI DEDUPLICATION RESULT ===');
        print('Input: ${products.length} items');
        print('Output: ${decodedProducts.length} items');
        print('Removed: $removedCount items ($reductionPercent% reduction)');

        // Log what was kept
        for (var p in decodedProducts) {
          print('  ✓ Kept: ${p['name']} (\$${p['price']}) [${p['category']}]');
        }

        // Warning if too many items were removed (likely an AI error)
        if (removedCount > products.length * 0.6) {
          print(
            '⚠️ WARNING: AI removed ${removedCount} items (${reductionPercent}% reduction)',
          );
          print('⚠️ This seems excessive - falling back to original items');
          return products; // Return original list if AI was too aggressive
        }

        return decodedProducts.map((p) => p as Map<String, dynamic>).toList();
      } else {
        throw Exception('AI deduplication failed: ${response.statusCode}');
      }
    } catch (e) {
      print('Error in AI deduplication: $e');
      rethrow;
    }
  }

  String _normalizeProductName(String name) {
    // Normalize product names for better duplicate detection
    final normalized = name
        .toLowerCase()
        .trim()
        // Normalize Unicode characters (accents, diacritics)
        .replaceAll(RegExp(r'[àáâãäå]'), 'a')
        .replaceAll(RegExp(r'[èéêë]'), 'e')
        .replaceAll(RegExp(r'[ìíîï]'), 'i')
        .replaceAll(RegExp(r'[òóôõöø]'), 'o')
        .replaceAll(RegExp(r'[ùúûü]'), 'u')
        .replaceAll(RegExp(r'[ýÿ]'), 'y')
        .replaceAll(RegExp(r'[ñ]'), 'n')
        .replaceAll(RegExp(r'[ç]'), 'c')
        .replaceAll(RegExp(r'[ß]'), 'ss')
        .replaceAll(RegExp(r'[æ]'), 'ae')
        .replaceAll(RegExp(r'[œ]'), 'oe')
        .replaceAll(
          RegExp(r'\([^)]*\)'),
          '',
        ) // Remove content in parentheses (HSP), etc.
        .replaceAll(RegExp(r'\[[^\]]*\]'), '') // Remove content in brackets
        .replaceAll(RegExp(r'\{[^}]*\}'), '') // Remove content in braces
        .replaceAll(
          RegExp(r'[^\w\s]'),
          '',
        ) // Remove special chars (dashes, dots, etc.)
        .replaceAll(
          RegExp(r'\s+'),
          ' ',
        ) // Normalize multiple spaces to single space (keep spaces!)
        .trim();

    print('Normalized "$name" -> "$normalized"');
    return normalized;
  }

  List<Map<String, dynamic>> _markDuplicatesInBatch(
    List<Map<String, dynamic>> products,
  ) {
    print('=== Marking duplicates in batch of ${products.length} items ===');
    // Create a map to track which normalized names we've seen
    final seenNames = <String, int>{};

    for (var product in products) {
      final name = product['name']?.toString() ?? '';
      if (name.isEmpty) continue;

      final normalizedName = _normalizeProductName(name);
      if (normalizedName.length < 3) {
        print('Skipping "$name" - too short after normalization');
        continue;
      }

      if (seenNames.containsKey(normalizedName)) {
        // This is a duplicate
        print(
          'DUPLICATE FOUND: "$name" matches existing normalized name "$normalizedName"',
        );
        product['isDuplicate'] = true;
        seenNames[normalizedName] = seenNames[normalizedName]! + 1;
        product['duplicateCount'] = seenNames[normalizedName];
      } else {
        // First occurrence
        print('First occurrence: "$name" -> "$normalizedName"');
        seenNames[normalizedName] = 1;
        // Don't explicitly set to false - preserve any existing flag
        if (product['isDuplicate'] != true) {
          product['isDuplicate'] = false;
        }
      }
    }

    print(
      '=== Found ${products.where((p) => p['isDuplicate'] == true).length} duplicates ===',
    );
    return products;
  }

  List<Map<String, dynamic>> _mergeProducts(
    List<Map<String, dynamic>> existing,
    List<Map<String, dynamic>> newProducts,
  ) {
    final merged = List<Map<String, dynamic>>.from(existing);

    for (var newProduct in newProducts) {
      final name = newProduct['name']?.toString() ?? '';

      // Skip if name is empty
      if (name.isEmpty) continue;

      // Normalize name for comparison
      final normalizedName = _normalizeProductName(name);

      // Skip if normalized name is too short
      if (normalizedName.length < 3) continue;

      // Check if this product already exists in the merged list
      final existingMatch = merged.where((p) {
        final existingName = p['name']?.toString() ?? '';
        return _normalizeProductName(existingName) == normalizedName;
      }).length;

      if (existingMatch > 0 && newProduct['isDuplicate'] != true) {
        // This is a cross-batch duplicate (new item matches existing item)
        newProduct['isDuplicate'] = true;
        newProduct['duplicateCount'] = existingMatch + 1;
      }

      // Always add the product (duplicates are marked but included)
      merged.add(newProduct);
    }

    return merged;
  }

  void _addManualProduct() {
    // Get existing categories from current products
    final categories = widget.products
        .map((p) => p['category']?.toString() ?? 'Other')
        .toSet()
        .toList();

    // Show menu to choose: Quick Add, Template, or Full Details
    showDialog(
      context: context,
      barrierColor: Colors.black26,
      builder: (context) => BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
        child: Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            width: 450,
            padding: EdgeInsets.all(AppSpacing.xl),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.blue.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.add_circle_outline,
                        color: AppColors.blue,
                        size: 28,
                      ),
                    ),
                    SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Add Product', style: AppTypography.h3),
                          Text(
                            'Choose your entry method',
                            style: AppTypography.bodyMedium.copyWith(
                              color: AppColors.gray600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                SizedBox(height: AppSpacing.xl),

                // Quick Add Option
                _buildEntryOption(
                  context: context,
                  icon: Icons.bolt,
                  iconColor: Colors.orange,
                  title: 'Quick Add',
                  description: 'Fast entry with essentials only',
                  recommended: true,
                  onTap: () {
                    Navigator.pop(context);
                    _showQuickAddDialog(categories);
                  },
                ),
                SizedBox(height: AppSpacing.md),

                // Template Option
                _buildEntryOption(
                  context: context,
                  icon: Icons.auto_awesome,
                  iconColor: AppColors.blue,
                  title: 'Start from Template',
                  description: 'Choose from common items',
                  onTap: () {
                    Navigator.pop(context);
                    _showTemplatePickerDialog(categories);
                  },
                ),
                SizedBox(height: AppSpacing.md),

                // Full Details Option
                _buildEntryOption(
                  context: context,
                  icon: Icons.tune,
                  iconColor: Colors.purple,
                  title: 'Full Details',
                  description: 'Add customizations & modifiers',
                  onTap: () {
                    Navigator.pop(context);
                    _showFullEditDialog(categories);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEntryOption({
    required BuildContext context,
    required IconData icon,
    required Color iconColor,
    required String title,
    required String description,
    required VoidCallback onTap,
    bool recommended = false,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          border: Border.all(
            color: recommended ? AppColors.blue : AppColors.gray300,
            width: recommended ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(16),
          color: recommended ? AppColors.blue.withOpacity(0.05) : Colors.white,
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: iconColor, size: 24),
            ),
            SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        title,
                        style: AppTypography.bodyLarge.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      if (recommended) ...[
                        SizedBox(width: AppSpacing.xs),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.blue,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            'RECOMMENDED',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  Text(
                    description,
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.gray600,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios, size: 16, color: AppColors.gray400),
          ],
        ),
      ),
    );
  }

  void _showQuickAddDialog(List<String> categories) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => QuickAddProductDialog(
        onSave: (newProduct) {
          setState(() {
            final updatedProducts = List<Map<String, dynamic>>.from(
              widget.products,
            );
            updatedProducts.add(newProduct);
            widget.onProductsChanged(updatedProducts);
          });
        },
        onCancel: () {
          // Reopen the entry method dialog when user cancels
          _addManualProduct();
        },
        existingCategories: categories,
      ),
    );
  }

  void _showTemplatePickerDialog(List<String> categories) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => TemplatePickerDialogClean(
        onSelectTemplate: (newProduct) {
          setState(() {
            final updatedProducts = List<Map<String, dynamic>>.from(
              widget.products,
            );
            updatedProducts.add(newProduct);
            widget.onProductsChanged(updatedProducts);
          });
        },
        onCancel: () {
          // Reopen the entry method dialog when user cancels
          _addManualProduct();
        },
        existingCategories: categories,
      ),
    );
  }

  void _showFullEditDialog(List<String> categories) {
    showDialog(
      context: context,
      barrierColor: Colors.black26,
      builder: (context) => BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: ProductEditDialog(
          product: {
            'name': '',
            'price': 0.0,
            'category': categories.isNotEmpty ? categories.first : 'Other',
            'description': '',
            'available': true,
            'modifierGroups': [],
          },
          onSave: (newProduct) {
            setState(() {
              final updatedProducts = List<Map<String, dynamic>>.from(
                widget.products,
              );
              updatedProducts.add(newProduct);
              widget.onProductsChanged(updatedProducts);
            });
          },
          onDelete: () {}, // Not applicable for new products
        ),
      ),
    );
  }

  void _removeAllDuplicates() {
    setState(() {
      final cleaned = widget.products
          .where((p) => p['isDuplicate'] != true)
          .toList();
      widget.onProductsChanged(cleaned);
      // Also update scanned products
      _scannedProducts = cleaned;
    });
  }

  void _openMenuOrganizer() {
    showDialog(
      context: context,
      builder: (context) => MenuOrderManager(
        products: widget.products,
        onSave: (orderedProducts) {
          widget.onProductsChanged(orderedProducts);
        },
      ),
    );
  }

  void _showApiKeyDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('API Key Required', style: AppTypography.h3),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'To use AI menu scanning, you need a free Google Gemini API key.',
              style: AppTypography.bodyMedium,
            ),
            SizedBox(height: AppSpacing.md),
            Text(
              'Steps to get your free key:',
              style: AppTypography.bodyMedium.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: AppSpacing.sm),
            Text(
              '1. Visit: ai.google.dev\n'
              '2. Click "Get API Key"\n'
              '3. Sign in with Google\n'
              '4. Create new API key\n'
              '5. Add key to app configuration',
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.gray600,
                height: 1.5,
              ),
            ),
            SizedBox(height: AppSpacing.md),
            Container(
              padding: EdgeInsets.all(AppSpacing.sm),
              decoration: BoxDecoration(
                color: AppColors.blue.withOpacity(0.08),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'Free tier: 15 requests/min, 1500/day',
                style: AppTypography.bodySmall.copyWith(
                  color: AppColors.blue,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Got it'),
          ),
        ],
      ),
    );
  }

  void _showReviewScreen(
    List<Map<String, dynamic>> products, {
    bool shouldMerge = false,
  }) {
    // Only merge and detect duplicates when scanning new images
    final productsToShow = shouldMerge
        ? _mergeProducts(widget.products, products)
        : products;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => _ReviewProductsDialog(
        products: productsToShow,
        onConfirm: (finalProducts) {
          setState(() {
            _scannedProducts = finalProducts;
          });
          widget.onProductsChanged(finalProducts);
          // Don't call Navigator.pop - dialog already handles it
          _showSuccessDialog(finalProducts.length);
        },
      ),
    );
  }

  void _showSuccessDialog(int count) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.check_circle, color: AppColors.success, size: 28),
            SizedBox(width: AppSpacing.sm),
            Text('Success!', style: AppTypography.h3),
          ],
        ),
        content: Text(
          'Extracted $count menu items from your photo.\nReview and edit as needed.',
          style: AppTypography.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Error', style: AppTypography.h3),
        content: Text(message, style: AppTypography.bodyMedium),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  Widget _buildProductItem(Map<String, dynamic> product, int index) {
    final isAvailable = product['available'] ?? true;
    final isDuplicate = product['isDuplicate'] == true;
    final duplicateCount = product['duplicateCount'] ?? 0;
    final isSelected = _selectedIndices.contains(index);

    return GestureDetector(
      onTap: _isSelectionMode
          ? () {
              setState(() {
                if (isSelected) {
                  _selectedIndices.remove(index);
                } else {
                  _selectedIndices.add(index);
                }
              });
            }
          : null,
      child: Container(
        padding: EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.blue.withOpacity(0.08)
              : (isAvailable ? AppColors.surface : AppColors.gray100),
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          border: Border.all(
            color: isSelected
                ? AppColors.blue
                : (isDuplicate
                      ? Color(0xFFFF3B30)
                      : (isAvailable ? AppColors.border : AppColors.gray300)),
            width: isSelected || isDuplicate ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            // Selection Checkbox
            if (_isSelectionMode) ...[
              Checkbox(
                value: isSelected,
                onChanged: (value) {
                  setState(() {
                    if (value == true) {
                      _selectedIndices.add(index);
                    } else {
                      _selectedIndices.remove(index);
                    }
                  });
                },
                activeColor: AppColors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              SizedBox(width: AppSpacing.sm),
            ],
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      if (isDuplicate) ...[
                        Container(
                          width: 24,
                          height: 24,
                          margin: EdgeInsets.only(right: 8),
                          decoration: BoxDecoration(
                            color: Color(0xFFFF3B30),
                            shape: BoxShape.circle,
                          ),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Icon(Icons.error, color: Colors.white, size: 16),
                              if (duplicateCount > 1)
                                Positioned(
                                  top: 0,
                                  right: 0,
                                  child: Container(
                                    width: 12,
                                    height: 12,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: Color(0xFFFF3B30),
                                        width: 1,
                                      ),
                                    ),
                                    child: Center(
                                      child: Text(
                                        '$duplicateCount',
                                        style: TextStyle(
                                          fontSize: 8,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFFFF3B30),
                                          height: 1,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],
                      Text(
                        product['name'] ?? '',
                        style: AppTypography.h4.copyWith(
                          color: isAvailable
                              ? AppColors.black
                              : AppColors.gray600,
                          decoration: isAvailable
                              ? null
                              : TextDecoration.lineThrough,
                        ),
                      ),
                      if (!isAvailable) ...[
                        SizedBox(width: AppSpacing.xs),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.gray300,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            'Unavailable',
                            style: AppTypography.caption.copyWith(
                              fontSize: 10,
                              color: AppColors.gray600,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  if (isDuplicate)
                    Padding(
                      padding: EdgeInsets.only(top: 4),
                      child: Text(
                        'Duplicate detected',
                        style: AppTypography.caption.copyWith(
                          fontSize: 11,
                          color: Color(0xFFFF3B30),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  Text(
                    '\$${product['price']?.toStringAsFixed(2) ?? '0.00'}',
                    style: AppTypography.bodyLarge.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            if (isDuplicate) ...[
              SizedBox(width: AppSpacing.sm),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    final updatedProducts = List<Map<String, dynamic>>.from(
                      widget.products,
                    );
                    updatedProducts.removeAt(index);
                    widget.onProductsChanged(updatedProducts);
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFFF3B30),
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  minimumSize: Size(0, 0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.delete_outline, size: 16),
                    SizedBox(width: 4),
                    Text('Remove', style: TextStyle(fontSize: 13)),
                  ],
                ),
              ),
            ] else if (!_isSelectionMode) ...[
              Switch(
                value: isAvailable,
                onChanged: (value) {
                  setState(() {
                    final updatedProducts = List<Map<String, dynamic>>.from(
                      widget.products,
                    );
                    updatedProducts[index]['available'] = value;
                    widget.onProductsChanged(updatedProducts);
                  });
                },
                activeColor: AppColors.blue,
              ),
            ],
          ],
        ),
      ),
    );
  }

  // Bulk Action Toolbar
  Widget _buildBulkActionToolbar() {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: AppColors.black,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withOpacity(0.15),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.blue,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              _selectedIndices.isEmpty
                  ? '0 items selected'
                  : _selectedIndices.length == 1
                  ? '1 item selected'
                  : '${_selectedIndices.length} items selected',
              style: AppTypography.bodySmall.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          SizedBox(width: AppSpacing.md),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // Duplicate Button
                _buildActionButton(
                  icon: Icons.content_copy,
                  label: 'Duplicate',
                  onPressed: _duplicateSelected,
                ),
                SizedBox(width: AppSpacing.sm),
                // Delete Button
                _buildActionButton(
                  icon: Icons.delete_outline,
                  label: 'Delete',
                  onPressed: _deleteSelected,
                  isDestructive: true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
    bool isDestructive = false,
  }) {
    return TextButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 18),
      label: Text(label),
      style: TextButton.styleFrom(
        foregroundColor: isDestructive ? Color(0xFFFF3B30) : Colors.white,
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  void _duplicateSelected() async {
    final count = _selectedIndices.length;

    // Show confirmation dialog
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(Icons.content_copy, color: AppColors.blue, size: 28),
            SizedBox(width: 12),
            Text('Duplicate Items?', style: AppTypography.h3),
          ],
        ),
        content: Text(
          'Create copies of $count selected ${count == 1 ? "item" : "items"}?',
          style: AppTypography.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('Cancel', style: TextStyle(color: AppColors.gray600)),
          ),
          ElevatedButton.icon(
            onPressed: () => Navigator.pop(context, true),
            icon: Icon(Icons.content_copy, size: 18),
            label: Text('Duplicate'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.blue,
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            ),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    setState(() {
      final updatedProducts = List<Map<String, dynamic>>.from(widget.products);
      final selectedProducts = _selectedIndices
          .map((i) => Map<String, dynamic>.from(widget.products[i]))
          .toList();

      // Add duplicates
      updatedProducts.addAll(selectedProducts);
      widget.onProductsChanged(updatedProducts);

      // Clear selection
      _selectedIndices.clear();
      _isSelectionMode = false;
    });

    // Show feedback
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$count ${count == 1 ? "item" : "items"} duplicated'),
        backgroundColor: AppColors.blue,
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _deleteSelected() async {
    final count = _selectedIndices.length;

    // Show confirmation dialog
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(Icons.warning, color: Color(0xFFFF3B30), size: 28),
            SizedBox(width: 12),
            Text('Delete Items?', style: AppTypography.h3),
          ],
        ),
        content: Text(
          'Permanently delete $count selected ${count == 1 ? "item" : "items"}? This action cannot be undone.',
          style: AppTypography.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('Cancel', style: TextStyle(color: AppColors.gray600)),
          ),
          ElevatedButton.icon(
            onPressed: () => Navigator.pop(context, true),
            icon: Icon(Icons.delete_outline, size: 18),
            label: Text('Delete'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFFFF3B30),
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            ),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    setState(() {
      final updatedProducts = List<Map<String, dynamic>>.from(widget.products);
      // Remove in reverse order to maintain correct indices
      final sortedIndices = _selectedIndices.toList()
        ..sort((a, b) => b.compareTo(a));
      for (final index in sortedIndices) {
        updatedProducts.removeAt(index);
      }
      widget.onProductsChanged(updatedProducts);

      // Clear selection
      _selectedIndices.clear();
      _isSelectionMode = false;
    });

    // Show feedback
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$count ${count == 1 ? "item" : "items"} deleted'),
        backgroundColor: Color(0xFFFF3B30),
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: 2),
      ),
    );
  }

  // Floating Side Navigation Bar for bulk actions
  Widget _buildFloatingSideNav(bool isTablet) {
    return Positioned(
      right: isTablet ? 48.0 : AppSpacing.md,
      top: 120,
      child: Material(
        elevation: 8,
        borderRadius: BorderRadius.circular(16),
        color: Colors.transparent,
        child: Container(
          width: 64,
          decoration: BoxDecoration(
            color: AppColors.black,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: AppColors.black.withOpacity(0.3),
                blurRadius: 20,
                offset: Offset(0, 8),
                spreadRadius: 2,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Cancel Button
              _buildSideNavButton(
                icon: Icons.close,
                label: 'Cancel',
                onPressed: () {
                  setState(() {
                    _isSelectionMode = false;
                    _selectedIndices.clear();
                  });
                },
                isTop: true,
              ),

              // Divider
              Container(
                height: 1,
                margin: EdgeInsets.symmetric(horizontal: 12),
                color: Colors.white.withOpacity(0.1),
              ),

              // Select All Button
              _buildSideNavButton(
                icon: Icons.select_all,
                label: 'Select All',
                onPressed: () {
                  setState(() {
                    _selectedIndices = Set.from(
                      List.generate(widget.products.length, (i) => i),
                    );
                  });
                },
              ),

              // Divider
              Container(
                height: 1,
                margin: EdgeInsets.symmetric(horizontal: 12),
                color: Colors.white.withOpacity(0.1),
              ),

              // Count Badge
              Padding(
                padding: EdgeInsets.symmetric(vertical: AppSpacing.md),
                child: Column(
                  children: [
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: AppColors.blue,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          '${_selectedIndices.length}',
                          style: AppTypography.bodySmall.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'selected',
                      style: AppTypography.caption.copyWith(
                        color: Colors.white.withOpacity(0.7),
                        fontSize: 9,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),

              // Divider
              Container(
                height: 1,
                margin: EdgeInsets.symmetric(horizontal: 12),
                color: Colors.white.withOpacity(0.1),
              ),

              // Duplicate Button
              _buildSideNavButton(
                icon: Icons.content_copy,
                label: 'Duplicate',
                onPressed: _duplicateSelected,
              ),

              // Divider
              Container(
                height: 1,
                margin: EdgeInsets.symmetric(horizontal: 12),
                color: Colors.white.withOpacity(0.1),
              ),

              // Delete Button
              _buildSideNavButton(
                icon: Icons.delete_outline,
                label: 'Delete',
                onPressed: _deleteSelected,
                isDestructive: true,
                isBottom: true,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSideNavButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
    bool isDestructive = false,
    bool isTop = false,
    bool isBottom = false,
  }) {
    return Tooltip(
      message: label,
      preferBelow: false,
      verticalOffset: 10,
      decoration: BoxDecoration(
        color: AppColors.black.withOpacity(0.9),
        borderRadius: BorderRadius.circular(8),
      ),
      textStyle: AppTypography.bodySmall.copyWith(
        color: Colors.white,
        fontWeight: FontWeight.w500,
      ),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.vertical(
          top: isTop ? Radius.circular(16) : Radius.zero,
          bottom: isBottom ? Radius.circular(16) : Radius.zero,
        ),
        child: Container(
          width: 64,
          height: 56,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.vertical(
              top: isTop ? Radius.circular(16) : Radius.zero,
              bottom: isBottom ? Radius.circular(16) : Radius.zero,
            ),
          ),
          child: Icon(
            icon,
            color: isDestructive ? Color(0xFFFF3B30) : Colors.white,
            size: 24,
          ),
        ),
      ),
    );
  }

  void _useDemoProducts() {
    widget.onProductsChanged([
      // Coffee (11 items)
      {
        'name': 'Latte',
        'price': 4.50,
        'category': 'Coffee',
        'description':
            'Smooth espresso with steamed milk and velvety microfoam',
      },
      {
        'name': 'Cappuccino',
        'price': 4.50,
        'category': 'Coffee',
        'description': 'Bold espresso topped with airy steamed milk foam',
      },
      {
        'name': 'Americano',
        'price': 3.75,
        'category': 'Coffee',
        'description':
            'Rich espresso diluted with hot water for a smooth finish',
      },
      {
        'name': 'Espresso',
        'price': 3.50,
        'category': 'Coffee',
        'description': '',
      },
      {
        'name': 'Cold Brew',
        'price': 4.75,
        'category': 'Coffee',
        'description': 'Slow-steeped for 18 hours, smooth and naturally sweet',
      },
      {
        'name': 'Mocha',
        'price': 5.00,
        'category': 'Coffee',
        'description': 'Rich chocolate blended with espresso and steamed milk',
      },
      {
        'name': 'Flat White',
        'price': 4.25,
        'category': 'Coffee',
        'description': '',
      },
      {
        'name': 'Macchiato',
        'price': 3.75,
        'category': 'Coffee',
        'description': 'Espresso "marked" with a dollop of foamed milk',
      },
      {
        'name': 'Iced Latte',
        'price': 4.75,
        'category': 'Coffee',
        'description': 'Chilled espresso with cold milk over ice',
      },
      {
        'name': 'Cortado',
        'price': 4.00,
        'category': 'Coffee',
        'description': '',
      },
      {
        'name': 'Affogato',
        'price': 5.50,
        'category': 'Coffee',
        'description': 'Vanilla gelato drowned in a shot of hot espresso',
      },

      // Tea (5 items)
      {
        'name': 'English Breakfast',
        'price': 3.50,
        'category': 'Tea',
        'description': 'Bold, full-bodied black tea blend perfect for mornings',
      },
      {
        'name': 'Chai Latte',
        'price': 4.25,
        'category': 'Tea',
        'description': 'Spiced black tea with steamed milk and aromatic spices',
      },
      {
        'name': 'Matcha Latte',
        'price': 4.75,
        'category': 'Tea',
        'description':
            'Premium ceremonial-grade matcha whisked with steamed milk',
      },
      {
        'name': 'Earl Grey',
        'price': 3.50,
        'category': 'Tea',
        'description': '',
      },
      {
        'name': 'Chamomile',
        'price': 3.25,
        'category': 'Tea',
        'description': 'Soothing floral herbal tea, naturally caffeine-free',
      },

      // Food (8 items)
      {
        'name': 'Croissant',
        'price': 4.00,
        'category': 'Food',
        'description': 'Buttery, flaky French pastry baked fresh daily',
      },
      {
        'name': 'Blueberry Muffin',
        'price': 3.50,
        'category': 'Food',
        'description': '',
      },
      {
        'name': 'Everything Bagel',
        'price': 3.75,
        'category': 'Food',
        'description':
            'Classic New York-style bagel with sesame, poppy, garlic, onion',
      },
      {
        'name': 'Cheese Danish',
        'price': 4.25,
        'category': 'Food',
        'description': 'Flaky pastry filled with sweet cream cheese',
      },
      {
        'name': 'Avocado Toast',
        'price': 8.50,
        'category': 'Food',
        'description':
            'Smashed avocado on sourdough with chili flakes and lemon',
      },
      {
        'name': 'Turkey & Swiss Sandwich',
        'price': 9.50,
        'category': 'Food',
        'description':
            'Sliced turkey, Swiss cheese, lettuce, tomato on fresh bread',
      },
      {
        'name': 'Greek Yogurt Bowl',
        'price': 6.50,
        'category': 'Food',
        'description': '',
      },
      {
        'name': 'Quiche Lorraine',
        'price': 7.50,
        'category': 'Food',
        'description':
            'Classic French quiche with bacon, Gruyère, and caramelized onions',
      },

      // Pastries (5 items)
      {
        'name': 'Chocolate Croissant',
        'price': 4.50,
        'category': 'Pastries',
        'description': 'Buttery croissant filled with rich dark chocolate',
      },
      {
        'name': 'Cinnamon Roll',
        'price': 4.75,
        'category': 'Pastries',
        'description':
            'Soft, gooey roll swirled with cinnamon and topped with cream cheese frosting',
      },
      {
        'name': 'Almond Biscotti',
        'price': 3.25,
        'category': 'Pastries',
        'description': '',
      },
      {
        'name': 'Fruit Tart',
        'price': 5.50,
        'category': 'Pastries',
        'description':
            'Crisp pastry shell with vanilla custard and fresh seasonal fruit',
      },
      {
        'name': 'Lemon Scone',
        'price': 3.75,
        'category': 'Pastries',
        'description':
            'Tender scone infused with fresh lemon zest and drizzled with glaze',
      },

      // Smoothies (4 items)
      {
        'name': 'Berry Blast',
        'price': 6.50,
        'category': 'Smoothies',
        'description': 'Mixed berries, banana, Greek yogurt, and honey',
      },
      {
        'name': 'Tropical Paradise',
        'price': 6.75,
        'category': 'Smoothies',
        'description': '',
      },
      {
        'name': 'Green Machine',
        'price': 7.00,
        'category': 'Smoothies',
        'description': 'Spinach, kale, pineapple, mango, coconut water',
      },
      {
        'name': 'Peanut Butter Power',
        'price': 7.25,
        'category': 'Smoothies',
        'description':
            'Peanut butter, banana, oats, almond milk, protein powder',
      },
    ]);
  }

  Widget _buildInstructionsPanel(bool isTablet) {
    return Container(
      padding: EdgeInsets.all(isTablet ? AppSpacing.lg : AppSpacing.md),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.white, AppColors.blue.withOpacity(0.02)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.blue.withOpacity(0.15), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: AppColors.blue.withOpacity(0.08),
            blurRadius: 16,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppColors.blue, AppColors.blue.withOpacity(0.8)],
                  ),
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.blue.withOpacity(0.3),
                      blurRadius: 8,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Icon(Icons.auto_awesome, color: Colors.white, size: 20),
              ),
              SizedBox(width: AppSpacing.sm),
              Text(
                'Photo Scanning Tips',
                style: AppTypography.h3.copyWith(color: AppColors.black),
              ),
            ],
          ),
          SizedBox(height: AppSpacing.md),
          Text(
            'Follow these guidelines for optimal AI recognition',
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          SizedBox(height: AppSpacing.lg),
          isTablet
              ? Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          _buildTipItem(
                            Icons.wb_sunny_outlined,
                            'Good lighting',
                            'Well-lit environment with minimal shadows',
                          ),
                          SizedBox(height: AppSpacing.md),
                          _buildTipItem(
                            Icons.center_focus_strong,
                            'Clear & straight',
                            'Hold device directly above, avoid angles',
                          ),
                          SizedBox(height: AppSpacing.md),
                          _buildTipItem(
                            Icons.zoom_in_map,
                            'Fill the frame',
                            'Get close - text should be clearly readable',
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: AppSpacing.lg),
                    Expanded(
                      child: Column(
                        children: [
                          _buildTipItem(
                            Icons.collections_outlined,
                            'Multiple angles',
                            'Upload 2-4 photos for complete coverage',
                          ),
                          SizedBox(height: AppSpacing.md),
                          _buildTipItem(
                            Icons.no_photography_outlined,
                            'Avoid glare',
                            'No reflections from lights or glass',
                          ),
                          SizedBox(height: AppSpacing.md),
                          _buildTipItem(
                            Icons.hd_outlined,
                            'High quality',
                            'Use highest resolution camera setting',
                          ),
                        ],
                      ),
                    ),
                  ],
                )
              : Column(
                  children: [
                    _buildTipItem(
                      Icons.wb_sunny_outlined,
                      'Good lighting',
                      'Well-lit environment with minimal shadows',
                    ),
                    _buildTipItem(
                      Icons.center_focus_strong,
                      'Clear & straight',
                      'Hold device directly above, avoid angles',
                    ),
                    _buildTipItem(
                      Icons.zoom_in_map,
                      'Fill the frame',
                      'Get close - text should be clearly readable',
                    ),
                    _buildTipItem(
                      Icons.collections_outlined,
                      'Multiple angles',
                      'Upload 2-4 photos for complete coverage',
                    ),
                    _buildTipItem(
                      Icons.no_photography_outlined,
                      'Avoid glare',
                      'No reflections from lights or glass',
                    ),
                  ],
                ),
        ],
      ),
    );
  }

  void _showPhotoTipsDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0.5),
      useRootNavigator: false,
      builder: (dialogContext) => WillPopScope(
        onWillPop: () async => false, // Prevent back button from closing
        child: _PhotoTipsDialog(
          onContinue: () {
            // Keep dialog open - file picker will appear over it
            _scanMenuPhotoWithDialog(dialogContext);
          },
          onCancel: () => Navigator.pop(dialogContext),
        ),
      ),
    );
  }

  Widget _buildTipItem(IconData icon, String title, String description) {
    return Padding(
      padding: EdgeInsets.only(bottom: AppSpacing.sm),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: AppColors.blue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Icon(icon, size: 16, color: AppColors.blue),
          ),
          SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTypography.bodyMedium.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.black,
                  ),
                ),
                Text(
                  description,
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProcessingIndicator() {
    final stageDuration = _stageStartTime != null
        ? DateTime.now().difference(_stageStartTime!).inSeconds
        : 0;
    final isSlow = stageDuration > 10;

    return Container(
      padding: EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: _hasError
            ? Color(0xFFFF3B30).withOpacity(0.05)
            : AppColors.blue.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _hasError
              ? Color(0xFFFF3B30).withOpacity(0.3)
              : AppColors.blue.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          // Main progress indicator
          if (!_hasError) ...[
            Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 56,
                  height: 56,
                  child: CircularProgressIndicator(
                    strokeWidth: 3,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      isSlow ? AppColors.blue.withOpacity(0.5) : AppColors.blue,
                    ),
                  ),
                ),
                if (_totalImages > 0)
                  Text(
                    '$_currentImageProcessing/$_totalImages',
                    style: AppTypography.bodySmall.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppColors.blue,
                    ),
                  ),
              ],
            ),
          ] else ...[
            Icon(Icons.error_outline, size: 56, color: Color(0xFFFF3B30)),
          ],

          SizedBox(height: AppSpacing.md),

          // Stage indicator
          Text(
            _processingStage,
            style: AppTypography.bodyLarge.copyWith(
              color: _hasError ? Color(0xFFFF3B30) : AppColors.black,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),

          SizedBox(height: AppSpacing.xs),

          // Status message
          Text(
            _statusMessage,
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),

          // Individual image progress bars (if processing multiple images)
          if (_totalImages > 1 && !_hasError) ...[
            SizedBox(height: AppSpacing.lg),
            _buildImageProgressBars(),
          ],

          // Multi-Pass Analysis Progress (NEW)
          if (_currentPass > 0 && !_hasError) ...[
            SizedBox(height: AppSpacing.lg),
            _buildMultiPassProgress(),
          ],

          // Network warning
          if (_hasNetworkIssue && !_hasError) ...[
            SizedBox(height: AppSpacing.sm),
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: AppSpacing.sm,
                vertical: AppSpacing.xs,
              ),
              decoration: BoxDecoration(
                color: Colors.orange.withOpacity(0.1),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.wifi_off, size: 14, color: Colors.orange),
                  SizedBox(width: AppSpacing.xs),
                  Text(
                    'Slow connection detected',
                    style: AppTypography.bodySmall.copyWith(
                      color: Colors.orange.shade700,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],

          // Processing time warning
          if (isSlow && !_hasError && !_hasNetworkIssue) ...[
            SizedBox(height: AppSpacing.sm),
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: AppSpacing.sm,
                vertical: AppSpacing.xs,
              ),
              decoration: BoxDecoration(
                color: Colors.orange.withOpacity(0.1),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: 12,
                    height: 12,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Colors.orange.shade700,
                      ),
                    ),
                  ),
                  SizedBox(width: AppSpacing.xs),
                  Text(
                    'Processing... ${stageDuration}s',
                    style: AppTypography.bodySmall.copyWith(
                      color: Colors.orange.shade700,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],

          // Error message
          if (_hasError && _errorMessage.isNotEmpty) ...[
            SizedBox(height: AppSpacing.sm),
            Container(
              padding: EdgeInsets.all(AppSpacing.sm),
              decoration: BoxDecoration(
                color: Color(0xFFFF3B30).withOpacity(0.1),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                _errorMessage,
                style: AppTypography.bodySmall.copyWith(
                  color: Color(0xFFFF3B30),
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],

          // Stage progress dots (UPDATED - remove if multi-pass is showing)
          if (!_hasError && _currentPass == 0) ...[
            SizedBox(height: AppSpacing.md),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildStageDot('Reading', _processingStage.contains('Reading')),
                _buildStageLine(),
                _buildStageDot('Analyzing', _processingStage.contains('AI')),
                _buildStageLine(),
                _buildStageDot(
                  'Cleaning',
                  _processingStage.contains('deduplicate') ||
                      _processingStage.contains('Cleaning'),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  // NEW: Professional multi-pass progress indicator
  Widget _buildMultiPassProgress() {
    return Container(
      padding: EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.blue.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: AppColors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Icon(
                  Icons.auto_fix_high,
                  size: 16,
                  color: AppColors.blue,
                ),
              ),
              SizedBox(width: AppSpacing.sm),
              Text(
                'AI Analysis Passes',
                style: AppTypography.bodyMedium.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.black,
                ),
              ),
              Spacer(),
              Text(
                '${_currentPass + 1}/$_totalPasses',
                style: AppTypography.bodySmall.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.blue,
                ),
              ),
            ],
          ),
          SizedBox(height: AppSpacing.md),
          ...List.generate(_totalPasses, (index) {
            final passName = _passNames[index];
            final isCompleted = _passCompleted[index];
            final isActive = _currentPass == index;
            final isPending = _currentPass < index;

            return Padding(
              padding: EdgeInsets.only(
                bottom: index < _totalPasses - 1 ? AppSpacing.sm : 0,
              ),
              child: AnimatedContainer(
                duration: Duration(milliseconds: 400),
                curve: Curves.easeOutCubic,
                padding: EdgeInsets.symmetric(
                  horizontal: AppSpacing.sm,
                  vertical: AppSpacing.xs,
                ),
                decoration: BoxDecoration(
                  color: isActive
                      ? AppColors.blue.withOpacity(0.1)
                      : isCompleted
                      ? Colors.green.withOpacity(0.08)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: isActive
                        ? AppColors.blue.withOpacity(0.3)
                        : isCompleted
                        ? Colors.green.withOpacity(0.3)
                        : Colors.transparent,
                    width: 1.5,
                  ),
                ),
                child: Row(
                  children: [
                    AnimatedContainer(
                      duration: Duration(milliseconds: 300),
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        color: isCompleted
                            ? Colors.green
                            : isActive
                            ? AppColors.blue
                            : AppColors.gray300,
                        shape: BoxShape.circle,
                      ),
                      child: isCompleted
                          ? Icon(Icons.check, size: 14, color: Colors.white)
                          : isActive
                          ? SizedBox(
                              width: 12,
                              height: 12,
                              child: Padding(
                                padding: EdgeInsets.all(4),
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.white,
                                  ),
                                ),
                              ),
                            )
                          : null,
                    ),
                    SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: Text(
                        passName,
                        style: AppTypography.bodySmall.copyWith(
                          fontWeight: isActive || isCompleted
                              ? FontWeight.w600
                              : FontWeight.normal,
                          color: isCompleted
                              ? Colors.green.shade700
                              : isActive
                              ? AppColors.blue
                              : AppColors.gray500,
                        ),
                      ),
                    ),
                    if (isActive)
                      Icon(Icons.trending_flat, size: 16, color: AppColors.blue)
                    else if (isCompleted)
                      Icon(Icons.check_circle, size: 16, color: Colors.green)
                    else
                      Icon(
                        Icons.circle_outlined,
                        size: 16,
                        color: AppColors.gray400,
                      ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildStageDot(String label, bool isActive) {
    return Column(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: isActive ? AppColors.blue : AppColors.gray300,
            shape: BoxShape.circle,
          ),
        ),
        SizedBox(height: 4),
        Text(
          label,
          style: AppTypography.bodySmall.copyWith(
            fontSize: 10,
            color: isActive ? AppColors.blue : AppColors.gray400,
            fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ],
    );
  }

  Widget _buildStageLine() {
    return Container(
      width: 24,
      height: 2,
      margin: EdgeInsets.only(bottom: 16),
      color: AppColors.gray300,
    );
  }

  Widget _buildImageProgressBars() {
    return Container(
      padding: EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.gray200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Processing images...',
            style: AppTypography.bodySmall.copyWith(
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
            ),
          ),
          SizedBox(height: AppSpacing.sm),
          ...List.generate(_totalImages, (index) {
            final imageNum = index + 1;
            final isCompleted = _imagesProcessed >= imageNum;
            final isProcessing = _currentImageProcessing == imageNum;
            final isPending = _currentImageProcessing < imageNum;

            return Padding(
              padding: EdgeInsets.only(
                bottom: index < _totalImages - 1 ? AppSpacing.xs : 0,
              ),
              child: Row(
                children: [
                  // Status icon
                  Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isCompleted
                          ? AppColors.blue
                          : isProcessing
                          ? AppColors.blue.withOpacity(0.2)
                          : AppColors.gray200,
                    ),
                    child: isCompleted
                        ? Icon(Icons.check, size: 12, color: Colors.white)
                        : isProcessing
                        ? SizedBox(
                            width: 12,
                            height: 12,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                AppColors.blue,
                              ),
                            ),
                          )
                        : null,
                  ),
                  SizedBox(width: AppSpacing.sm),
                  // Image label
                  Expanded(
                    child: Text(
                      'Image $imageNum',
                      style: AppTypography.bodySmall.copyWith(
                        color: isCompleted || isProcessing
                            ? AppColors.black
                            : AppColors.textSecondary,
                        fontWeight: isProcessing
                            ? FontWeight.w600
                            : FontWeight.normal,
                      ),
                    ),
                  ),
                  // Status text
                  Text(
                    isCompleted
                        ? 'Done'
                        : isProcessing
                        ? 'Processing...'
                        : 'Waiting',
                    style: AppTypography.bodySmall.copyWith(
                      fontSize: 11,
                      color: isCompleted
                          ? AppColors.blue
                          : isProcessing
                          ? AppColors.blue
                          : AppColors.textSecondary,
                      fontWeight: isCompleted || isProcessing
                          ? FontWeight.w600
                          : FontWeight.normal,
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  void _updateStage(String stage, String message) {
    setState(() {
      _processingStage = stage;
      _statusMessage = message;
      _stageStartTime = DateTime.now();
      _hasError = false;
    });
  }

  void _showError(String stage, String message) {
    setState(() {
      _processingStage = stage;
      _errorMessage = message;
      _hasError = true;
      _isProcessing = false;
    });
  }

  Widget _buildScrollIndicator(bool isTablet) {
    final screenHeight = MediaQuery.of(context).size.height;
    final indicatorHeight = isTablet ? 120.0 : 80.0;
    final trackHeight = screenHeight * 0.6;

    // Calculate thumb position
    double thumbPosition = 0.0;
    if (_maxScrollExtent > 0) {
      thumbPosition =
          (_scrollOffset / _maxScrollExtent) * (trackHeight - indicatorHeight);
      thumbPosition = thumbPosition.clamp(0.0, trackHeight - indicatorHeight);
    }

    return Positioned(
      right: isTablet ? 16 : 8,
      top: screenHeight * 0.2,
      child: AnimatedOpacity(
        opacity: _scrollOffset > 20 ? 1.0 : 0.3,
        duration: Duration(milliseconds: 200),
        child: Container(
          width: isTablet ? 6 : 4,
          height: trackHeight,
          decoration: BoxDecoration(
            color: AppColors.gray200.withOpacity(0.3),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Stack(
            children: [
              AnimatedPositioned(
                duration: Duration(milliseconds: 100),
                curve: Curves.easeOut,
                top: thumbPosition,
                left: 0,
                right: 0,
                child: Container(
                  height: indicatorHeight,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColors.blue.withOpacity(0.8),
                        AppColors.blue.withOpacity(0.4),
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.blue.withOpacity(0.3),
                        blurRadius: 8,
                        offset: Offset(0, 2),
                      ),
                    ],
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

// Photo Tips Dialog Widget
class _PhotoTipsDialog extends StatelessWidget {
  final VoidCallback onContinue;
  final VoidCallback onCancel;

  const _PhotoTipsDialog({required this.onContinue, required this.onCancel});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth >= 768;

    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        constraints: BoxConstraints(maxWidth: isTablet ? 700 : 500),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 40,
              offset: Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header with gradient
            Container(
              padding: EdgeInsets.all(isTablet ? 32 : 24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.blue, AppColors.blue.withOpacity(0.8)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.camera_enhance_outlined,
                      color: Colors.white,
                      size: 32,
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Ready to scan?',
                          style: AppTypography.h2.copyWith(color: Colors.white),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Quick tips for best results',
                          style: AppTypography.bodyMedium.copyWith(
                            color: Colors.white.withOpacity(0.9),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Content
            Padding(
              padding: EdgeInsets.all(isTablet ? 32 : 24),
              child: Column(
                children: [
                  _buildDialogTip(
                    Icons.wb_sunny_outlined,
                    'Bright & Clear',
                    'Good lighting, no shadows',
                    AppColors.blue,
                  ),
                  SizedBox(height: 20),
                  _buildDialogTip(
                    Icons.center_focus_strong,
                    'Straight View',
                    'Hold device directly above menu',
                    AppColors.blue,
                  ),
                  SizedBox(height: 20),
                  _buildDialogTip(
                    Icons.collections_outlined,
                    'Multiple Photos',
                    '2-4 images work best (max 4)',
                    AppColors.blue,
                  ),
                  SizedBox(height: 20),
                  _buildDialogTip(
                    Icons.no_photography_outlined,
                    'No Glare',
                    'Avoid reflections from lights',
                    AppColors.blue,
                  ),

                  SizedBox(height: 32),

                  Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.blue.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppColors.blue.withOpacity(0.1),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.auto_awesome,
                          color: AppColors.blue,
                          size: 20,
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'AI will extract all menu items automatically',
                            style: AppTypography.bodySmall.copyWith(
                              color: AppColors.textSecondary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Actions
            Container(
              padding: EdgeInsets.all(isTablet ? 24 : 20),
              decoration: BoxDecoration(
                color: AppColors.gray100,
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(24),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: onCancel,
                      style: OutlinedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 16),
                        side: BorderSide(color: AppColors.gray400),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        'Cancel',
                        style: AppTypography.bodyLarge.copyWith(
                          fontWeight: FontWeight.w600,
                          color: AppColors.gray600,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton.icon(
                      onPressed: onContinue,
                      icon: Icon(Icons.add_photo_alternate, size: 20),
                      label: Text(
                        'Select Photos',
                        style: AppTypography.bodyLarge.copyWith(
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.blue,
                        padding: EdgeInsets.symmetric(vertical: 16),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDialogTip(
    IconData icon,
    String title,
    String subtitle,
    Color color,
  ) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTypography.bodyLarge.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.black,
                ),
              ),
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
    );
  }
}

// Review Products Dialog
class _ReviewProductsDialog extends StatefulWidget {
  final List<Map<String, dynamic>> products;
  final Function(List<Map<String, dynamic>>) onConfirm;

  const _ReviewProductsDialog({
    required this.products,
    required this.onConfirm,
  });

  @override
  State<_ReviewProductsDialog> createState() => _ReviewProductsDialogState();
}

class _ReviewProductsDialogState extends State<_ReviewProductsDialog> {
  late List<Map<String, dynamic>> _products;
  bool _isSelectionMode = false;
  Set<int> _selectedIndices = {};

  @override
  void initState() {
    super.initState();
    _products = List<Map<String, dynamic>>.from(widget.products);
  }

  void _addProduct() {
    // Get existing categories
    final categories = _products
        .map((p) => p['category']?.toString() ?? 'Other')
        .toSet()
        .toList();

    showDialog(
      context: context,
      barrierColor: Colors.black26,
      builder: (context) => BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: ProductEditDialog(
          product: {
            'name': '',
            'price': 0.0,
            'category': categories.isNotEmpty ? categories.first : 'Other',
            'description': '',
            'available': true,
            'modifierGroups': [],
          },
          onSave: (newProduct) {
            setState(() {
              _products.add(newProduct);
            });
          },
          onDelete: () {}, // Not applicable for new products
        ),
      ),
    );
  }

  void _addCategory() {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Add Category', style: AppTypography.h3),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: InputDecoration(
            labelText: 'Category Name',
            hintText: 'e.g., Desserts, Drinks',
            border: OutlineInputBorder(),
          ),
          onSubmitted: (value) {
            if (value.trim().isNotEmpty) {
              Navigator.pop(context);
              // Create first product in new category
              showDialog(
                context: context,
                barrierColor: Colors.black26,
                builder: (context) => BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                  child: ProductEditDialog(
                    product: {
                      'name': '',
                      'price': 0.0,
                      'category': value.trim(),
                      'description': '',
                      'available': true,
                      'modifierGroups': [],
                    },
                    onSave: (newProduct) {
                      setState(() {
                        _products.add(newProduct);
                      });
                    },
                    onDelete: () {},
                  ),
                ),
              );
            }
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final value = controller.text.trim();
              if (value.isNotEmpty) {
                Navigator.pop(context);
                // Create first product in new category
                showDialog(
                  context: context,
                  barrierColor: Colors.black26,
                  builder: (context) => BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                    child: ProductEditDialog(
                      product: {
                        'name': '',
                        'price': 0.0,
                        'category': value,
                        'description': '',
                        'available': true,
                        'modifierGroups': [],
                      },
                      onSave: (newProduct) {
                        setState(() {
                          _products.add(newProduct);
                        });
                      },
                      onDelete: () {},
                    ),
                  ),
                );
              }
            },
            child: Text('Add Product'),
          ),
        ],
      ),
    );
  }

  void _editProduct(int index) {
    showDialog(
      context: context,
      barrierColor: Colors.black26,
      builder: (context) => BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: ProductEditDialog(
          product: _products[index],
          onSave: (updated) {
            setState(() {
              _products[index] = updated;
            });
          },
          onDelete: () {
            setState(() {
              _products.removeAt(index);
            });
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Container(
            width: 800,
            constraints: BoxConstraints(maxHeight: 700),
            child: Column(
              children: [
                // Header
                Container(
                  padding: EdgeInsets.all(AppSpacing.lg),
                  decoration: BoxDecoration(
                    color: AppColors.black,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(16),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.checklist, color: Colors.white, size: 28),
                      SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Review Extracted Menu',
                              style: AppTypography.h3.copyWith(
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              '${_products.length} items found - Edit or confirm',
                              style: AppTypography.bodySmall.copyWith(
                                color: Colors.white70,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: AppSpacing.md),
                      // Selection Mode Toggle
                      OutlinedButton.icon(
                        icon: Icon(
                          _isSelectionMode ? Icons.close : Icons.checklist,
                          size: 18,
                        ),
                        label: Text(_isSelectionMode ? 'Cancel' : 'Select'),
                        onPressed: () {
                          setState(() {
                            _isSelectionMode = !_isSelectionMode;
                            if (!_isSelectionMode) {
                              _selectedIndices.clear();
                            }
                          });
                        },
                        style: OutlinedButton.styleFrom(
                          foregroundColor: _isSelectionMode
                              ? Color(0xFFFF3B30)
                              : Colors.white,
                          side: BorderSide(
                            color: _isSelectionMode
                                ? Color(0xFFFF3B30)
                                : Colors.white.withOpacity(0.5),
                          ),
                          padding: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                        ),
                      ),
                      // Select All Button (only visible in selection mode)
                      if (_isSelectionMode) ...[
                        SizedBox(width: AppSpacing.sm),
                        OutlinedButton.icon(
                          icon: Icon(Icons.select_all, size: 18),
                          label: Text('Select All'),
                          onPressed: () {
                            setState(() {
                              _selectedIndices = Set.from(
                                List.generate(_products.length, (i) => i),
                              );
                            });
                          },
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.white,
                            side: BorderSide(
                              color: Colors.white.withOpacity(0.5),
                            ),
                            padding: EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                          ),
                        ),
                      ],
                      if (!_isSelectionMode) ...[
                        SizedBox(width: AppSpacing.sm),
                        OutlinedButton.icon(
                          icon: Icon(Icons.add, size: 18),
                          label: Text('Add Product'),
                          onPressed: _addProduct,
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.white,
                            side: BorderSide(
                              color: Colors.white.withOpacity(0.5),
                            ),
                            padding: EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                          ),
                        ),
                        SizedBox(width: AppSpacing.sm),
                        OutlinedButton.icon(
                          icon: Icon(Icons.create_new_folder, size: 18),
                          label: Text('Add Category'),
                          onPressed: _addCategory,
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.white,
                            side: BorderSide(
                              color: Colors.white.withOpacity(0.5),
                            ),
                            padding: EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),

                // Duplicate warning banner
                if (_products.any((p) => p['isDuplicate'] == true)) ...[
                  Container(
                    padding: EdgeInsets.all(AppSpacing.md),
                    margin: EdgeInsets.all(AppSpacing.lg),
                    decoration: BoxDecoration(
                      color: Color(0xFFFF3B30).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Color(0xFFFF3B30), width: 1),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.warning, color: Color(0xFFFF3B30), size: 24),
                        SizedBox(width: AppSpacing.sm),
                        Expanded(
                          child: Text(
                            '${_products.where((p) => p['isDuplicate'] == true).length} duplicate(s) detected - Review before confirming',
                            style: AppTypography.bodyMedium.copyWith(
                              color: Color(0xFFFF3B30),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            setState(() {
                              _products = _products
                                  .where((p) => p['isDuplicate'] != true)
                                  .toList();
                            });
                          },
                          style: TextButton.styleFrom(
                            foregroundColor: Color(0xFFFF3B30),
                            padding: EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                          ),
                          child: Text(
                            'Remove All',
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],

                // Product List
                Expanded(
                  child: ListView.separated(
                    padding: EdgeInsets.all(AppSpacing.lg),
                    itemCount: _products.length,
                    separatorBuilder: (_, __) => Divider(height: 1),
                    itemBuilder: (context, index) {
                      final product = _products[index];
                      final isDuplicate = product['isDuplicate'] == true;
                      final duplicateCount = product['duplicateCount'] ?? 0;

                      return Container(
                        decoration: BoxDecoration(
                          border: isDuplicate
                              ? Border.all(color: Color(0xFFFF3B30), width: 2)
                              : null,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: ListTile(
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: AppSpacing.md,
                            vertical: AppSpacing.sm,
                          ),
                          onTap: _isSelectionMode
                              ? () {
                                  setState(() {
                                    if (_selectedIndices.contains(index)) {
                                      _selectedIndices.remove(index);
                                    } else {
                                      _selectedIndices.add(index);
                                    }
                                  });
                                }
                              : null,
                          selected:
                              _isSelectionMode &&
                              _selectedIndices.contains(index),
                          selectedTileColor: AppColors.blue.withOpacity(0.05),
                          leading: _isSelectionMode
                              ? Checkbox(
                                  value: _selectedIndices.contains(index),
                                  onChanged: (value) {
                                    setState(() {
                                      if (value == true) {
                                        _selectedIndices.add(index);
                                      } else {
                                        _selectedIndices.remove(index);
                                      }
                                    });
                                  },
                                  activeColor: AppColors.blue,
                                )
                              : Stack(
                                  clipBehavior: Clip.none,
                                  children: [
                                    CircleAvatar(
                                      backgroundColor: isDuplicate
                                          ? Color(0xFFFF3B30).withOpacity(0.1)
                                          : AppColors.blue.withOpacity(0.1),
                                      child: Icon(
                                        isDuplicate
                                            ? Icons.warning
                                            : Icons.restaurant_menu,
                                        color: isDuplicate
                                            ? Color(0xFFFF3B30)
                                            : AppColors.blue,
                                      ),
                                    ),
                                    if (isDuplicate && duplicateCount > 0)
                                      Positioned(
                                        right: -4,
                                        top: -4,
                                        child: Container(
                                          padding: EdgeInsets.all(4),
                                          decoration: BoxDecoration(
                                            color: Color(0xFFFF3B30),
                                            shape: BoxShape.circle,
                                          ),
                                          child: Text(
                                            '$duplicateCount',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 10,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                          title: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  product['name'] ?? '',
                                  style: AppTypography.bodyLarge.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              if (isDuplicate)
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Color(0xFFFF3B30).withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    'DUPLICATE',
                                    style: TextStyle(
                                      color: Color(0xFFFF3B30),
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '\$${product['price']?.toStringAsFixed(2) ?? '0.00'} • ${product['category'] ?? 'No category'}',
                                style: AppTypography.bodySmall,
                              ),
                              if (product['modifierGroups'] != null &&
                                  (product['modifierGroups'] as List)
                                      .isNotEmpty)
                                Text(
                                  'Groups: ${(product['modifierGroups'] as List).map((g) => g['groupName']).join(', ')}',
                                  style: AppTypography.bodySmall.copyWith(
                                    color: AppColors.gray600,
                                  ),
                                ),
                            ],
                          ),
                          trailing: _isSelectionMode
                              ? null
                              : Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    // Always visible delete button for single item
                                    IconButton(
                                      icon: Icon(
                                        Icons.delete_outline,
                                        color: Color(0xFFFF3B30),
                                        size: 20,
                                      ),
                                      tooltip: 'Delete',
                                      onPressed: () {
                                        setState(() {
                                          _products.removeAt(index);
                                        });
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          SnackBar(
                                            content: Text('Item removed'),
                                            duration: Duration(seconds: 1),
                                            behavior: SnackBarBehavior.floating,
                                          ),
                                        );
                                      },
                                    ),
                                    IconButton(
                                      icon: Icon(
                                        Icons.edit,
                                        color: AppColors.blue,
                                        size: 20,
                                      ),
                                      tooltip: 'Edit',
                                      onPressed: () => _editProduct(index),
                                    ),
                                  ],
                                ),
                        ),
                      );
                    },
                  ),
                ),

                // Footer
                Container(
                  padding: EdgeInsets.all(AppSpacing.lg),
                  decoration: BoxDecoration(
                    border: Border(top: BorderSide(color: AppColors.gray200)),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: AppButton(
                          label: 'Cancel',
                          onPressed: () => Navigator.pop(context),
                          variant: AppButtonVariant.outline,
                        ),
                      ),
                      SizedBox(width: AppSpacing.md),
                      Expanded(
                        flex: 2,
                        child: AppButton(
                          label: 'Confirm Menu (${_products.length} items)',
                          onPressed: () {
                            Navigator.pop(context);
                            widget.onConfirm(_products);
                          },
                          variant: AppButtonVariant.filled,
                          icon: Icons.check_circle,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),

        // Floating Action Button for Bulk Delete
        if (_isSelectionMode && _selectedIndices.isNotEmpty)
          Positioned(
            bottom: 100,
            right: MediaQuery.of(context).size.width / 2 - 400 + 50,
            child: Material(
              elevation: 8,
              borderRadius: BorderRadius.circular(28),
              color: Color(0xFFFF3B30),
              child: InkWell(
                onTap: () async {
                  final count = _selectedIndices.length;

                  // Show confirmation dialog
                  final confirm = await showDialog<bool>(
                    context: context,
                    builder: (context) => AlertDialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      title: Row(
                        children: [
                          Icon(
                            Icons.warning,
                            color: Color(0xFFFF3B30),
                            size: 28,
                          ),
                          SizedBox(width: 12),
                          Text('Delete Items?', style: AppTypography.h3),
                        ],
                      ),
                      content: Text(
                        'Permanently delete $count selected ${count == 1 ? "item" : "items"}? This action cannot be undone.',
                        style: AppTypography.bodyMedium,
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context, false),
                          child: Text(
                            'Cancel',
                            style: TextStyle(color: AppColors.gray600),
                          ),
                        ),
                        ElevatedButton.icon(
                          onPressed: () => Navigator.pop(context, true),
                          icon: Icon(Icons.delete_outline, size: 18),
                          label: Text('Delete'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFFFF3B30),
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );

                  if (confirm != true) return;

                  setState(() {
                    final sortedIndices = _selectedIndices.toList()
                      ..sort((a, b) => b.compareTo(a));
                    for (final index in sortedIndices) {
                      _products.removeAt(index);
                    }
                    _selectedIndices.clear();
                    _isSelectionMode = false;
                  });

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        '$count ${count == 1 ? "item" : "items"} deleted',
                      ),
                      backgroundColor: Color(0xFFFF3B30),
                      behavior: SnackBarBehavior.floating,
                      duration: Duration(seconds: 2),
                    ),
                  );
                },
                borderRadius: BorderRadius.circular(28),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          '${_selectedIndices.length}',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      SizedBox(width: 12),
                      Icon(Icons.delete_outline, color: Colors.white, size: 22),
                      SizedBox(width: 8),
                      Text(
                        'Delete Selected',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
