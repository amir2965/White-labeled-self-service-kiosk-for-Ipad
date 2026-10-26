import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'product_templates.dart';
import 'quick_add_product_dialog.dart';

class TemplatePickerDialogClean extends ConsumerStatefulWidget {
  const TemplatePickerDialogClean({
    super.key,
    required this.onSelectTemplate,
    this.onCancel,
    this.existingCategories = const [],
  });

  final void Function(Map<String, dynamic> template) onSelectTemplate;
  final VoidCallback? onCancel;
  final List<String> existingCategories;

  @override
  ConsumerState<TemplatePickerDialogClean> createState() =>
      _TemplatePickerDialogCleanState();
}

class _TemplatePickerDialogCleanState
    extends ConsumerState<TemplatePickerDialogClean> {
  String _selectedCategory = 'All';
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  final FocusNode _searchFocus = FocusNode();
  bool _isSearchFocused = false;
  bool _hideTitle = false;

  @override
  void initState() {
    super.initState();
    _searchFocus.addListener(() {
      final hasFocus = _searchFocus.hasFocus;
      if (!mounted) return;
      setState(() {
        _isSearchFocused = hasFocus;
        if (!hasFocus) _hideTitle = false;
      });
      if (hasFocus) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          SystemChannels.textInput.invokeMethod('TextInput.show');
          Future.delayed(const Duration(milliseconds: 80), () {
            if (mounted && _searchFocus.hasFocus) {
              setState(() {
                _hideTitle = true;
              });
            }
          });
        });
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocus.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> get _filteredTemplates {
    var templates = ProductTemplates.getTemplatesByCategory(_selectedCategory);
    if (_searchQuery.isNotEmpty) {
      final q = _searchQuery.toLowerCase();
      templates = templates.where((t) {
        final name = t['name']?.toString().toLowerCase() ?? '';
        final category = t['category']?.toString().toLowerCase() ?? '';
        final tags =
            (t['tags'] as List?)
                ?.map((e) => e.toString().toLowerCase())
                .toList() ??
            const [];
        return name.contains(q) ||
            category.contains(q) ||
            tags.any((tag) => tag.contains(q));
      }).toList();
    }
    return templates;
  }

  void _showQuickAddDialog(Map<String, dynamic> template) {
    Navigator.pop(context);
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => QuickAddProductDialog(
        onSave: widget.onSelectTemplate,
        onCancel: () {
          showDialog(
            context: context,
            barrierDismissible: true,
            builder: (ctx) => TemplatePickerDialogClean(
              onSelectTemplate: widget.onSelectTemplate,
              onCancel: widget.onCancel,
              existingCategories: widget.existingCategories,
            ),
          );
        },
        existingCategories: widget.existingCategories,
        template: template,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
    final isLandscape = screenSize.width > screenSize.height;

    final dialogWidth = isLandscape
        ? screenSize.width * 0.70
        : screenSize.width * 0.85;
    final dialogHeight = screenSize.height * 0.82;
    final isKeyboardOpen = keyboardHeight > 0 || _isSearchFocused;

    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      insetPadding: EdgeInsets.zero,
      child: Container(
        width: screenSize.width,
        height: screenSize.height,
        color: Colors.black.withOpacity(0.6),
        child: AnimatedAlign(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOut,
          alignment: isKeyboardOpen ? Alignment.topCenter : Alignment.center,
          child: Padding(
            padding: EdgeInsets.only(top: isKeyboardOpen ? 12 : 0),
            child: Container(
              width: dialogWidth,
              height: dialogHeight,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 40,
                    spreadRadius: 0,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.fromLTRB(
                      24,
                      isKeyboardOpen ? 8 : 24,
                      24,
                      isKeyboardOpen ? 8 : 24,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(20),
                      ),
                      border: Border(
                        bottom: BorderSide(
                          color: Colors.black.withOpacity(0.08),
                          width: 1,
                        ),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 180),
                          switchInCurve: Curves.easeOut,
                          switchOutCurve: Curves.easeOut,
                          child: _hideTitle
                              ? const SizedBox.shrink()
                              : Column(
                                  children: [
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.grid_view_rounded,
                                          size: 28,
                                          color: Colors.black,
                                        ),
                                        const SizedBox(width: 12),
                                        const Text(
                                          'Start from Template',
                                          style: TextStyle(
                                            fontSize: 24,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.black,
                                            letterSpacing: -0.5,
                                          ),
                                        ),
                                        const Spacer(),
                                        IconButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                            widget.onCancel?.call();
                                          },
                                          icon: const Icon(
                                            Icons.close,
                                            color: Colors.black,
                                          ),
                                          iconSize: 28,
                                          padding: const EdgeInsets.all(8),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      'Choose from popular templates to get started quickly',
                                      style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.black.withOpacity(0.5),
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                  ],
                                ),
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: _searchController,
                                focusNode: _searchFocus,
                                keyboardType: TextInputType.text,
                                textInputAction: TextInputAction.search,
                                onTap: () {
                                  if (!_searchFocus.hasFocus) {
                                    _searchFocus.requestFocus();
                                  }
                                  SystemChannels.textInput.invokeMethod(
                                    'TextInput.show',
                                  );
                                },
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500,
                                ),
                                decoration: InputDecoration(
                                  hintText: 'Search templates...',
                                  hintStyle: TextStyle(
                                    color: Colors.black.withOpacity(0.35),
                                    fontSize: 16,
                                  ),
                                  prefixIcon: Icon(
                                    Icons.search,
                                    color: Colors.black.withOpacity(0.4),
                                    size: 24,
                                  ),
                                  suffixIcon: _searchQuery.isNotEmpty
                                      ? IconButton(
                                          icon: const Icon(
                                            Icons.close,
                                            size: 20,
                                          ),
                                          color: Colors.black.withOpacity(0.4),
                                          onPressed: () {
                                            _searchController.clear();
                                            setState(() {
                                              _searchQuery = '';
                                            });
                                          },
                                        )
                                      : null,
                                  filled: true,
                                  fillColor: Colors.black.withOpacity(0.04),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide.none,
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: const BorderSide(
                                      color: Colors.black,
                                      width: 2,
                                    ),
                                  ),
                                  contentPadding: const EdgeInsets.all(16),
                                ),
                                onChanged: (value) {
                                  setState(() {
                                    _searchQuery = value;
                                  });
                                },
                              ),
                            ),
                            if (_isSearchFocused) ...[
                              const SizedBox(width: 12),
                              IconButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                  widget.onCancel?.call();
                                },
                                icon: const Icon(
                                  Icons.close,
                                  color: Colors.black,
                                ),
                                iconSize: 28,
                                padding: const EdgeInsets.all(8),
                              ),
                            ],
                          ],
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          height: 42,
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            children: ProductTemplates.categoryGroups.keys.map((
                              category,
                            ) {
                              final isSelected = _selectedCategory == category;
                              return Padding(
                                padding: const EdgeInsets.only(right: 10),
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _selectedCategory = category;
                                    });
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 20,
                                      vertical: 10,
                                    ),
                                    decoration: BoxDecoration(
                                      color: isSelected
                                          ? Colors.black
                                          : Colors.transparent,
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                        color: isSelected
                                            ? Colors.black
                                            : Colors.black.withOpacity(0.15),
                                        width: 1.5,
                                      ),
                                    ),
                                    child: Text(
                                      category,
                                      style: TextStyle(
                                        color: isSelected
                                            ? Colors.white
                                            : Colors.black.withOpacity(0.7),
                                        fontSize: 15,
                                        fontWeight: isSelected
                                            ? FontWeight.w600
                                            : FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: _filteredTemplates.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.search_off,
                                  size: 64,
                                  color: Colors.black.withOpacity(0.2),
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'No templates found',
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.black.withOpacity(0.4),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Try adjusting your search or filters',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.black.withOpacity(0.3),
                                  ),
                                ),
                              ],
                            ),
                          )
                        : GridView.builder(
                            padding: EdgeInsets.fromLTRB(
                              24,
                              isKeyboardOpen ? 12 : 24,
                              24,
                              24 + keyboardHeight,
                            ),
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: isLandscape ? 3 : 2,
                                  childAspectRatio: 2.2,
                                  crossAxisSpacing: 10,
                                  mainAxisSpacing: 10,
                                ),
                            itemCount: _filteredTemplates.length,
                            itemBuilder: (context, index) {
                              final template = _filteredTemplates[index];
                              return _buildTemplateCard(template);
                            },
                          ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTemplateCard(Map<String, dynamic> template) {
    return GestureDetector(
      onTap: () => _showQuickAddDialog(template),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.black.withOpacity(0.08)),
        ),
        padding: EdgeInsets.all(8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              template['name']?.toString() ?? 'Template',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black,
                height: 1.15,
                letterSpacing: -0.1,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 4),
            Text(
              template['category']?.toString() ?? '',
              style: TextStyle(
                fontSize: 14,
                color: Colors.black.withOpacity(0.55),
                height: 1.15,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
