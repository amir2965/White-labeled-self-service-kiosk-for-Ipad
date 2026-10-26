import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/product.dart';
import '../../domain/entities/modifier.dart';
import '../../data/datasources/mock_api_datasource.dart';

/// Menu state with categories and products
class MenuState {
  final List<Category> categories;
  final List<Product> products;
  final bool isLoading;
  final String? error;

  MenuState({
    this.categories = const [],
    this.products = const [],
    this.isLoading = false,
    this.error,
  });

  MenuState copyWith({
    List<Category>? categories,
    List<Product>? products,
    bool? isLoading,
    String? error,
  }) {
    return MenuState(
      categories: categories ?? this.categories,
      products: products ?? this.products,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }

  List<Category> get sortedCategories {
    final sorted = [...categories];
    sorted.sort((a, b) => (a.sortOrder ?? 0).compareTo(b.sortOrder ?? 0));
    return sorted;
  }

  List<Product> getProductsByCategory(
    String categoryId, {
    bool excludeFeatured = false,
  }) {
    final categoryProducts = products
        .where(
          (p) =>
              p.categoryId == categoryId && (!excludeFeatured || !p.isFeatured),
        )
        .toList();
    categoryProducts.sort(
      (a, b) => (a.sortOrder ?? 0).compareTo(b.sortOrder ?? 0),
    );
    return categoryProducts;
  }

  List<Product> get featuredProducts {
    final featured = products.where((p) => p.isFeatured).toList();
    // Sort by sortOrder to respect the order set in customization
    featured.sort(
      (a, b) => (a.sortOrder ?? 9999).compareTo(b.sortOrder ?? 9999),
    );
    return featured;
  }

  List<Product> getFeaturedProductsByCategory(String categoryId) {
    final featured = products
        .where((p) => p.categoryId == categoryId && p.isFeatured)
        .toList();
    // Sort by sortOrder to respect the order set in customization
    featured.sort(
      (a, b) => (a.sortOrder ?? 9999).compareTo(b.sortOrder ?? 9999),
    );
    return featured;
  }
}

/// Menu notifier
class MenuNotifier extends StateNotifier<MenuState> {
  final MockApiDataSource _dataSource;

  MenuNotifier(this._dataSource) : super(MenuState());

  Future<void> loadMenu(String merchantId) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final categories = await _dataSource.getCategories(merchantId);
      final products = await _dataSource.getProducts(merchantId);
      state = state.copyWith(
        categories: categories,
        products: products,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> seedDemoMenu(String businessType) async {
    state = state.copyWith(isLoading: true);
    try {
      if (businessType == 'cafe') {
        // Load cafe data with demo products
        final categories = [
          Category(id: 'coffee', name: 'Coffee', sortOrder: 1),
          Category(id: 'tea', name: 'Tea', sortOrder: 2),
          Category(id: 'food', name: 'Food', sortOrder: 3),
          Category(id: 'pastries', name: 'Pastries', sortOrder: 4),
          Category(id: 'smoothies', name: 'Smoothies', sortOrder: 5),
        ];

        final products = [
          Product(
            id: '1',
            categoryId: 'coffee',
            name: 'Latte',
            description: 'Espresso with steamed milk',
            price: 4.50,
            isAvailable: true,
            imageUrl:
                'https://images.unsplash.com/photo-1561882468-9110e03e0f78?w=400',
            modifierGroups: [
              ModifierGroup(
                id: 'size',
                name: 'Size',
                isRequired: true,
                minSelection: 1,
                maxSelection: 1,
                modifiers: [
                  Modifier(id: 'small', name: 'Small', priceAdjustment: 0),
                  Modifier(id: 'medium', name: 'Medium', priceAdjustment: 0.5),
                  Modifier(id: 'large', name: 'Large', priceAdjustment: 1.0),
                ],
              ),
              ModifierGroup(
                id: 'milk',
                name: 'Milk Type',
                isRequired: false,
                minSelection: 0,
                maxSelection: 1,
                modifiers: [
                  Modifier(id: 'whole', name: 'Whole Milk', priceAdjustment: 0),
                  Modifier(id: 'oat', name: 'Oat Milk', priceAdjustment: 0.5),
                  Modifier(
                    id: 'almond',
                    name: 'Almond Milk',
                    priceAdjustment: 0.5,
                  ),
                ],
              ),
            ],
          ),
          Product(
            id: '2',
            categoryId: 'coffee',
            name: 'Cappuccino',
            description: 'Espresso with foamed milk',
            price: 4.50,
            isAvailable: true,
            imageUrl:
                'https://images.unsplash.com/photo-1572442388796-11668a67e53d?w=400',
            modifierGroups: [
              ModifierGroup(
                id: 'size',
                name: 'Size',
                isRequired: true,
                minSelection: 1,
                maxSelection: 1,
                modifiers: [
                  Modifier(id: 'small', name: 'Small', priceAdjustment: 0),
                  Modifier(id: 'medium', name: 'Medium', priceAdjustment: 0.5),
                  Modifier(id: 'large', name: 'Large', priceAdjustment: 1.0),
                ],
              ),
            ],
          ),
          Product(
            id: '3',
            categoryId: 'coffee',
            name: 'Americano',
            description: 'Espresso with hot water',
            price: 3.50,
            isAvailable: true,
            imageUrl:
                'https://images.unsplash.com/photo-1514432324607-a09d9b4aefdd?w=400',
            modifierGroups: [],
          ),
          Product(
            id: '3b',
            categoryId: 'coffee',
            name: 'Espresso',
            description: 'Rich and bold',
            price: 3.50,
            isAvailable: true,
            imageUrl:
                'https://images.unsplash.com/photo-1510591509098-f4fdc6d0ff04?w=400',
            modifierGroups: [],
          ),
          Product(
            id: '3c',
            categoryId: 'coffee',
            name: 'Cold Brew',
            description: 'Smooth cold brewed coffee',
            price: 4.75,
            isAvailable: true,
            imageUrl:
                'https://images.unsplash.com/photo-1517487881594-2787fef5ebf7?w=400',
            modifierGroups: [],
          ),
          Product(
            id: '3d',
            categoryId: 'coffee',
            name: 'Mocha',
            description: 'Espresso with chocolate and steamed milk',
            price: 5.00,
            isAvailable: true,
            imageUrl:
                'https://images.unsplash.com/photo-1578374173705-30a322f2c4f6?w=400',
            modifierGroups: [],
          ),
          Product(
            id: '3e',
            categoryId: 'coffee',
            name: 'Flat White',
            description: 'Velvety microfoam with espresso',
            price: 4.25,
            isAvailable: true,
            imageUrl:
                'https://images.unsplash.com/photo-1542990253-0d0f5be5f0ed?w=400',
            modifierGroups: [],
          ),
          Product(
            id: '3f',
            categoryId: 'coffee',
            name: 'Macchiato',
            description: 'Espresso marked with milk foam',
            price: 3.75,
            isAvailable: true,
            imageUrl:
                'https://images.unsplash.com/photo-1557006021-b85faa2bc5e2?w=400',
            modifierGroups: [],
          ),
          Product(
            id: '3g',
            categoryId: 'coffee',
            name: 'Iced Latte',
            description: 'Chilled espresso with cold milk',
            price: 4.75,
            isAvailable: true,
            imageUrl:
                'https://images.unsplash.com/photo-1517487881594-2787fef5ebf7?w=400',
            modifierGroups: [],
          ),
          Product(
            id: '3h',
            categoryId: 'coffee',
            name: 'Cortado',
            description: 'Equal parts espresso and steamed milk',
            price: 3.95,
            isAvailable: true,
            imageUrl:
                'https://images.unsplash.com/photo-1514432324607-a09d9b4aefdd?w=400',
            modifierGroups: [],
          ),
          Product(
            id: '3i',
            categoryId: 'coffee',
            name: 'Affogato',
            description: 'Espresso poured over vanilla ice cream',
            price: 5.50,
            isAvailable: true,
            imageUrl:
                'https://images.unsplash.com/photo-1612201142855-184b67c21f8d?w=400',
            modifierGroups: [],
          ),
          Product(
            id: '3j',
            categoryId: 'coffee',
            name: 'Nitro Cold Brew',
            description: 'Cold brew infused with nitrogen',
            price: 5.25,
            isAvailable: true,
            imageUrl:
                'https://images.unsplash.com/photo-1461023058943-07fcbe16d735?w=400',
            modifierGroups: [],
          ),
          Product(
            id: '3k',
            categoryId: 'coffee',
            name: 'Pour Over',
            description: 'Hand-crafted single origin',
            price: 4.50,
            isAvailable: true,
            imageUrl:
                'https://images.unsplash.com/photo-1495474472287-4d71bcdd2085?w=400',
            modifierGroups: [],
          ),
          Product(
            id: '4',
            categoryId: 'food',
            name: 'Croissant',
            description: 'Fresh baked daily',
            price: 4.00,
            isAvailable: true,
            imageUrl:
                'https://images.unsplash.com/photo-1555507036-ab1f4038808a?w=400',
            modifierGroups: [],
          ),
          Product(
            id: '5',
            categoryId: 'food',
            name: 'Blueberry Muffin',
            description: 'Homemade with fresh blueberries',
            price: 4.50,
            isAvailable: true,
            imageUrl:
                'https://images.unsplash.com/photo-1607958996333-41aef7caefaa?w=400',
            modifierGroups: [],
          ),
          Product(
            id: '5b',
            categoryId: 'food',
            name: 'Everything Bagel',
            description: 'Toasted with cream cheese',
            price: 3.75,
            isAvailable: true,
            imageUrl:
                'https://images.unsplash.com/photo-1612182062681-d811e19d4685?w=400',
            modifierGroups: [],
          ),
          Product(
            id: '5c',
            categoryId: 'food',
            name: 'Cheese Danish',
            description: 'Sweet pastry with cream cheese filling',
            price: 4.25,
            isAvailable: true,
            imageUrl:
                'https://images.unsplash.com/photo-1509440159596-0249088772ff?w=400',
            modifierGroups: [],
          ),
          Product(
            id: '6',
            categoryId: 'tea',
            name: 'English Breakfast',
            description: 'Classic black tea',
            price: 3.00,
            isAvailable: true,
            imageUrl:
                'https://images.unsplash.com/photo-1564890369478-c89ca6d9cde9?w=400',
            modifierGroups: [],
          ),
          Product(
            id: '6b',
            categoryId: 'tea',
            name: 'Chai Latte',
            description: 'Spiced tea with steamed milk',
            price: 4.25,
            isAvailable: true,
            imageUrl:
                'https://images.unsplash.com/photo-1578899952107-9d0fa0d6b011?w=400',
            modifierGroups: [],
          ),
          Product(
            id: '6c',
            categoryId: 'tea',
            name: 'Matcha Latte',
            description: 'Premium Japanese green tea with milk',
            price: 4.75,
            isAvailable: true,
            imageUrl:
                'https://images.unsplash.com/photo-1515823064-d6e0c04616a7?w=400',
            modifierGroups: [],
          ),
          Product(
            id: '6d',
            categoryId: 'tea',
            name: 'Earl Grey',
            description: 'Aromatic black tea with bergamot',
            price: 3.25,
            isAvailable: true,
            imageUrl:
                'https://images.unsplash.com/photo-1576092768241-dec231879fc3?w=400',
            modifierGroups: [],
          ),
          Product(
            id: '6e',
            categoryId: 'tea',
            name: 'Chamomile',
            description: '',
            price: 3.00,
            isAvailable: true,
            imageUrl:
                'https://images.unsplash.com/photo-1597318133431-86c3df0e2249?w=400',
            modifierGroups: [],
          ),
          Product(
            id: '5d',
            categoryId: 'food',
            name: 'Avocado Toast',
            description: 'Smashed avocado on sourdough with chili flakes',
            price: 8.50,
            isAvailable: true,
            imageUrl:
                'https://images.unsplash.com/photo-1588137378633-dea1336ce1e2?w=400',
            modifierGroups: [],
          ),
          Product(
            id: '5e',
            categoryId: 'food',
            name: 'Turkey & Swiss Sandwich',
            description: 'Fresh turkey, swiss cheese, lettuce on whole grain',
            price: 9.75,
            isAvailable: true,
            imageUrl:
                'https://images.unsplash.com/photo-1553909489-cd47e0907980?w=400',
            modifierGroups: [],
          ),
          Product(
            id: '5f',
            categoryId: 'food',
            name: 'Greek Yogurt Bowl',
            description: 'Greek yogurt topped with granola, berries and honey',
            price: 7.25,
            isAvailable: true,
            imageUrl:
                'https://images.unsplash.com/photo-1488477181946-6428a0291777?w=400',
            modifierGroups: [],
          ),
          Product(
            id: '5g',
            categoryId: 'food',
            name: 'Quiche Lorraine',
            description: '',
            price: 6.50,
            isAvailable: true,
            imageUrl:
                'https://images.unsplash.com/photo-1606491956689-2ea866880c84?w=400',
            modifierGroups: [],
          ),
          Product(
            id: '7a',
            categoryId: 'pastries',
            name: 'Chocolate Croissant',
            description: 'Flaky pastry filled with rich dark chocolate',
            price: 4.50,
            isAvailable: true,
            imageUrl:
                'https://images.unsplash.com/photo-1623334044303-241021148842?w=400',
            modifierGroups: [],
          ),
          Product(
            id: '7b',
            categoryId: 'pastries',
            name: 'Cinnamon Roll',
            description: 'Warm cinnamon roll with cream cheese frosting',
            price: 5.00,
            isAvailable: true,
            imageUrl:
                'https://images.unsplash.com/photo-1626197031507-c17099753214?w=400',
            modifierGroups: [],
          ),
          Product(
            id: '7c',
            categoryId: 'pastries',
            name: 'Almond Biscotti',
            description: 'Twice-baked Italian cookie perfect for dipping',
            price: 3.50,
            isAvailable: true,
            imageUrl:
                'https://images.unsplash.com/photo-1599785209796-786432b228bc?w=400',
            modifierGroups: [],
          ),
          Product(
            id: '7d',
            categoryId: 'pastries',
            name: 'Fruit Tart',
            description: '',
            price: 5.50,
            isAvailable: true,
            imageUrl:
                'https://images.unsplash.com/photo-1488477181946-6428a0291777?w=400',
            modifierGroups: [],
          ),
          Product(
            id: '7e',
            categoryId: 'pastries',
            name: 'Lemon Scone',
            description: 'Buttery scone with lemon zest and glaze',
            price: 4.00,
            isAvailable: true,
            imageUrl:
                'https://images.unsplash.com/photo-1605681867753-44945c2b2c9e?w=400',
            modifierGroups: [],
          ),
          Product(
            id: '8a',
            categoryId: 'smoothies',
            name: 'Berry Blast',
            description: 'Mixed berries, banana, and Greek yogurt',
            price: 6.50,
            isAvailable: true,
            imageUrl:
                'https://images.unsplash.com/photo-1505252585461-04db1eb84625?w=400',
            modifierGroups: [],
          ),
          Product(
            id: '8b',
            categoryId: 'smoothies',
            name: 'Tropical Paradise',
            description: 'Mango, pineapple, coconut milk blend',
            price: 6.75,
            isAvailable: true,
            imageUrl:
                'https://images.unsplash.com/photo-1546548970-71785318a17b?w=400',
            modifierGroups: [],
          ),
          Product(
            id: '8c',
            categoryId: 'smoothies',
            name: 'Green Machine',
            description: 'Spinach, kale, apple, ginger and lemon',
            price: 7.00,
            isAvailable: true,
            imageUrl:
                'https://images.unsplash.com/photo-1610970881699-44a5587cabec?w=400',
            modifierGroups: [],
          ),
          Product(
            id: '8d',
            categoryId: 'smoothies',
            name: 'Peanut Butter Power',
            description: '',
            price: 7.25,
            isAvailable: true,
            imageUrl:
                'https://images.unsplash.com/photo-1638176066666-ffb2f013c7dd?w=400',
            modifierGroups: [],
          ),
        ];

        state = state.copyWith(
          categories: categories,
          products: products,
          isLoading: false,
        );
      } else {
        // Load restaurant data
        final categories = [
          Category(id: 'appetizers', name: 'Appetizers', sortOrder: 1),
          Category(id: 'mains', name: 'Mains', sortOrder: 2),
          Category(id: 'desserts', name: 'Desserts', sortOrder: 3),
        ];

        final products = [
          Product(
            id: 'r1',
            categoryId: 'appetizers',
            name: 'Caesar Salad',
            description: 'Romaine lettuce, parmesan, croutons',
            price: 8.50,
            isAvailable: true,
            modifierGroups: [],
          ),
          Product(
            id: 'r2',
            categoryId: 'mains',
            name: 'Cheeseburger',
            description: 'Beef patty, cheese, lettuce, tomato',
            price: 12.00,
            isAvailable: true,
            modifierGroups: [],
          ),
        ];

        state = state.copyWith(
          categories: categories,
          products: products,
          isLoading: false,
        );
      }
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  // Import user-added products from onboarding
  void importUserProducts(List<Map<String, dynamic>> productsData) {
    try {
      // Extract categories in order (preserving the order from drag-and-drop)
      final categoryNamesInOrder = <String>[];
      final seenCategories = <String>{};
      for (var p in productsData) {
        final categoryName = p['category'] as String?;
        if (categoryName != null && !seenCategories.contains(categoryName)) {
          categoryNamesInOrder.add(categoryName);
          seenCategories.add(categoryName);
        }
      }

      // Create categories with sortOrder matching their position
      final categoriesList = categoryNamesInOrder.asMap().entries.map((e) {
        return Category(
          id: e.value.toLowerCase().replaceAll(' ', '-'),
          name: e.value,
          sortOrder: e.key,
        );
      }).toList();

      // Convert to Product entities with placeholder images
      final products = productsData.asMap().entries.map((entry) {
        final data = entry.value;
        final categoryId =
            (data['category'] as String?)?.toLowerCase().replaceAll(' ', '-') ??
            'other';

        // Parse modifiers if they exist
        List<ModifierGroup> modifierGroups = [];
        if (data['modifierGroups'] != null && data['modifierGroups'] is List) {
          final groups = data['modifierGroups'] as List;
          modifierGroups = groups.asMap().entries.map((groupEntry) {
            final group = groupEntry.value as Map<String, dynamic>;
            final options = group['options'] as List? ?? [];

            return ModifierGroup(
              id: 'group-${entry.key}-${groupEntry.key}',
              name: group['groupName'] ?? 'Options',
              isRequired: group['required'] == true,
              minSelection: group['minSelection'] is int
                  ? group['minSelection']
                  : (group['required'] == true ? 1 : 0),
              maxSelection: group['maxSelection'] is int
                  ? group['maxSelection']
                  : options.length,
              modifiers: options.asMap().entries.map((optEntry) {
                final opt = optEntry.value as Map<String, dynamic>;
                return Modifier(
                  id: 'mod-${entry.key}-${groupEntry.key}-${optEntry.key}',
                  name: opt['name'] ?? '',
                  priceAdjustment: (opt['price'] is num)
                      ? (opt['price'] as num).toDouble()
                      : 0.0,
                );
              }).toList(),
            );
          }).toList();
        }

        return Product(
          id: 'user-${entry.key}',
          categoryId: categoryId,
          name: data['name'] ?? 'Unnamed Product',
          description: data['description'] ?? '',
          price: (data['price'] is num)
              ? (data['price'] as num).toDouble()
              : 0.0,
          isAvailable: true,
          imageUrl:
              (data['imageUrl'] as String?) ?? _getPlaceholderImage(categoryId),
          modifierGroups: modifierGroups,
          sortOrder: entry.key,
        );
      }).toList();

      state = state.copyWith(
        categories: categoriesList,
        products: products,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  // Get placeholder image based on category
  String _getPlaceholderImage(String categoryId) {
    const imageMap = {
      'coffee':
          'https://images.unsplash.com/photo-1495474472287-4d71bcdd2085?w=400',
      'tea':
          'https://images.unsplash.com/photo-1564890369478-c89ca6d9cde9?w=400',
      'food': 'https://images.unsplash.com/photo-1555507036-ab1f4038808a?w=400',
      'borek':
          'https://images.unsplash.com/photo-1509042239860-f550ce710b93?w=400',
      'drinks':
          'https://images.unsplash.com/photo-1437418747212-8d9709afab22?w=400',
      'desserts':
          'https://images.unsplash.com/photo-1488477181946-6428a0291777?w=400',
      'meals':
          'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=400',
    };
    return imageMap[categoryId] ??
        'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=400';
  }

  // ===== CRUD Operations for Menu Management =====

  /// Add new category
  void addCategory(String name) {
    final newCategory = Category(
      id: name.toLowerCase().replaceAll(' ', '-'),
      name: name,
      sortOrder: state.categories.length,
    );
    state = state.copyWith(categories: [...state.categories, newCategory]);
  }

  /// Update category
  void updateCategory(String categoryId, String newName) {
    final updatedCategories = state.categories.map((cat) {
      if (cat.id == categoryId) {
        return Category(id: cat.id, name: newName, sortOrder: cat.sortOrder);
      }
      return cat;
    }).toList();
    state = state.copyWith(categories: updatedCategories);
  }

  /// Delete category and all its products
  void deleteCategory(String categoryId) {
    state = state.copyWith(
      categories: state.categories.where((c) => c.id != categoryId).toList(),
      products: state.products
          .where((p) => p.categoryId != categoryId)
          .toList(),
    );
  }

  /// Reorder categories
  void reorderCategories(int oldIndex, int newIndex) {
    if (oldIndex < newIndex) {
      newIndex--;
    }
    final categories = [...state.categories];
    final item = categories.removeAt(oldIndex);
    categories.insert(newIndex, item);

    // Update sort orders
    final updatedCategories = categories.asMap().entries.map((entry) {
      return Category(
        id: entry.value.id,
        name: entry.value.name,
        sortOrder: entry.key,
      );
    }).toList();

    state = state.copyWith(categories: updatedCategories);
  }

  /// Add new product
  void addProduct({
    required String categoryId,
    required String name,
    required double price,
  }) {
    final products = state.products
        .where((p) => p.categoryId == categoryId)
        .toList();
    final newSortOrder = products.isEmpty
        ? 0
        : products
                  .map((p) => p.sortOrder ?? 0)
                  .reduce((a, b) => a > b ? a : b) +
              1;

    final newProduct = Product(
      id: 'prod-${DateTime.now().millisecondsSinceEpoch}',
      categoryId: categoryId,
      name: name,
      description: '',
      price: price,
      isAvailable: true,
      imageUrl: null,
      modifierGroups: [],
      sortOrder: newSortOrder,
    );

    state = state.copyWith(products: [...state.products, newProduct]);
  }

  /// Update product
  void updateProduct(Product updatedProduct) {
    final updatedProducts = state.products.map((product) {
      if (product.id == updatedProduct.id) {
        return updatedProduct;
      }
      return product;
    }).toList();
    state = state.copyWith(products: updatedProducts);
  }

  /// Delete product
  void deleteProduct(String productId) {
    state = state.copyWith(
      products: state.products.where((p) => p.id != productId).toList(),
    );
  }

  /// Reorder products within a category
  void reorderProducts(String categoryId, int oldIndex, int newIndex) {
    final categoryProducts =
        state.products.where((p) => p.categoryId == categoryId).toList()
          ..sort((a, b) => (a.sortOrder ?? 0).compareTo(b.sortOrder ?? 0));

    final otherProducts = state.products
        .where((p) => p.categoryId != categoryId)
        .toList();

    final item = categoryProducts.removeAt(oldIndex);
    categoryProducts.insert(newIndex, item);

    // Update sort orders for all products in this category
    final updatedCategoryProducts = categoryProducts.asMap().entries.map((
      entry,
    ) {
      final originalProduct = entry.value;
      // All items (featured and non-featured) get sequential sortOrder based on position
      final newSortOrder = entry.key;

      return Product(
        id: originalProduct.id,
        categoryId: originalProduct.categoryId,
        name: originalProduct.name,
        description: originalProduct.description,
        price: originalProduct.price,
        isAvailable: originalProduct.isAvailable,
        imageUrl: originalProduct.imageUrl,
        modifierGroups: originalProduct.modifierGroups,
        isFeatured: originalProduct.isFeatured,
        sortOrder: newSortOrder,
      );
    }).toList();

    state = state.copyWith(
      products: [...otherProducts, ...updatedCategoryProducts],
    );
  }
}

/// Menu provider
final menuProvider = StateNotifierProvider<MenuNotifier, MenuState>((ref) {
  return MenuNotifier(MockApiDataSource());
});
