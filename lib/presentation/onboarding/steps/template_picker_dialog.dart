import 'package:flutter/material.dart';

import 'template_picker_dialog_clean.dart';

/// Template Picker Dialog - Browse and select common product templates
///
/// Note: the full implementation lives in `TemplatePickerDialogClean`.
/// This wrapper exists to keep older imports working.
class TemplatePickerDialog extends StatelessWidget {
  const TemplatePickerDialog({
    super.key,
    required this.onSelectTemplate,
    this.onCancel,
    this.existingCategories = const [],
  });

  final void Function(Map<String, dynamic> template) onSelectTemplate;
  final VoidCallback? onCancel;
  final List<String> existingCategories;

  @override
  Widget build(BuildContext context) {
    return TemplatePickerDialogClean(
      onSelectTemplate: onSelectTemplate,
      onCancel: onCancel,
      existingCategories: existingCategories,
    );
  }
}

/*

                                  @override
                                  Widget build(BuildContext context) {
                                    final screenSize = MediaQuery.of(context).size;
                                    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
                                    final isLandscape = screenSize.width > screenSize.height;

                                    // Responsive sizing for iPad
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
                                                  offset: Offset(0, 10),
                                                ),
                                              ],
                                            ),
                                            child: Column(
                                              children: [
                                                // Header with search and close
                                                Container(
                                                  padding: EdgeInsets.fromLTRB(
                                                    24,
                                                    isKeyboardOpen ? 12 : 24,
                                                    24,
                                                    isKeyboardOpen ? 12 : 24,
                                                  ),
                                                  decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius: BorderRadius.vertical(
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
                                                      // Title and close button (kept in tree; fade out to avoid layout shift)
                                                      AnimatedOpacity(
                                                        duration: const Duration(milliseconds: 180),
                                                        opacity: _hideTitle ? 0.0 : 1.0,
                                                        curve: Curves.easeOut,
                                                        child: IgnorePointer(
                                                          ignoring: _hideTitle,
                                                          child: Column(
                                                            children: [
                                                              Row(
                                                                children: [
                                                                  Icon(
                                                                    Icons.grid_view_rounded,
                                                                    size: 28,
                                                                    color: Colors.black,
                                                                  ),
                                                                  SizedBox(width: 12),
                                                                  Text(
                                                                    'Start from Template',
                                                                    style: TextStyle(
                                                                      fontSize: 24,
                                                                      fontWeight: FontWeight.w600,
                                                                      color: Colors.black,
                                                                      letterSpacing: -0.5,
                                                                    ),
                                                                  ),
                                                                  Spacer(),
                                                                  IconButton(
                                                                    onPressed: () {
                                                                      Navigator.pop(context);
                                                                      widget.onCancel?.call();
                                                                    },
                                                                    icon: Icon(
                                                                      Icons.close,
                                                                      color: Colors.black,
                                                                    ),
                                                                    iconSize: 28,
                                                                    padding: EdgeInsets.all(8),
                                                                  ),
                                                                ],
                                                              ),
                                                              SizedBox(height: 8),
                                                              Text(
                                                                'Choose from popular templates to get started quickly',
                                                                style: TextStyle(
                                                                  fontSize: 15,
                                                                  color: Colors.black.withOpacity(0.5),
                                                                  fontWeight: FontWeight.w400,
                                                                ),
                                                              ),
                                                              SizedBox(height: 20),
                                                            ],
                                                          ),
                                                        ),
                                                      ),

                                                      // Search field
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
                                                                // Ensure iPad keyboard appears on first tap
                                                                SystemChannels.textInput.invokeMethod(
                                                                  'TextInput.show',
                                                                );
                                                              },
                                                              style: TextStyle(
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
                                                                        icon: Icon(Icons.close, size: 20),
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
                                                                  borderSide: BorderSide(
                                                                    color: Colors.black,
                                                                    width: 2,
                                                                  ),
                                                                ),
                                                                contentPadding: EdgeInsets.all(16),
                                                              ),
                                                              onChanged: (value) {
                                                                setState(() {
                                                                  _searchQuery = value;
                                                                });
                                                              },
                                                            ),
                                                          ),
                                                          if (_isSearchFocused) ...[
                                                            SizedBox(width: 12),
                                                            IconButton(
                                                              onPressed: () {
                                                                Navigator.pop(context);
                                                                widget.onCancel?.call();
                                                              },
                                                              icon: Icon(Icons.close, color: Colors.black),
                                                              iconSize: 28,
                                                              padding: EdgeInsets.all(8),
                                                            ),
                                                          ],
                                                        ],
                                                      ),
                                                      SizedBox(height: 16),

                                                      // Category filters
                                                      SizedBox(
                                                        height: 42,
                                                        child: ListView(
                                                          scrollDirection: Axis.horizontal,
                                                          children: ProductTemplates.categoryGroups.keys.map((
                                                            category,
                                                          ) {
                                                            final isSelected = _selectedCategory == category;
                                                            return Padding(
                                                              padding: EdgeInsets.only(right: 10),
                                                              child: GestureDetector(
                                                                onTap: () {
                                                                  setState(() {
                                                                    _selectedCategory = category;
                                                                  });
                                                                },
                                                                child: Container(
                                                                  padding: EdgeInsets.symmetric(
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

                                                // Template grid
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
                                                              SizedBox(height: 16),
                                                              Text(
                                                                'No templates found',
                                                                style: TextStyle(
                                                                  fontSize: 18,
                                                                  color: Colors.black.withOpacity(0.4),
                                                                  fontWeight: FontWeight.w500,
                                                                ),
                                                              ),
                                                              SizedBox(height: 8),
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
                                                            24,
                                                            24,
                                                            24 + keyboardHeight,
                                                          ),
                                                          gridDelegate:
                                                              SliverGridDelegateWithFixedCrossAxisCount(
                                                                crossAxisCount: isLandscape ? 3 : 2,
                                                                childAspectRatio: 1.1,
                                                                crossAxisSpacing: 16,
                                                                mainAxisSpacing: 16,
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
                                    );
                                  }

*/
