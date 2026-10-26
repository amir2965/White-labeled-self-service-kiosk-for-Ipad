import 'package:freezed_annotation/freezed_annotation.dart';
import 'modifier.dart';

part 'product.freezed.dart';
part 'product.g.dart';

@freezed
class Product with _$Product {
  const factory Product({
    required String id,
    required String name,
    required String description,
    required double price,
    required String categoryId,
    String? imageUrl,
    @Default([]) List<ModifierGroup> modifierGroups,
    @Default([]) List<String> tags,
    @Default(true) bool isAvailable,
    @Default(false) bool isFeatured,
    int? sortOrder,
  }) = _Product;

  factory Product.fromJson(Map<String, dynamic> json) =>
      _$ProductFromJson(json);
}

@freezed
class Category with _$Category {
  const factory Category({
    required String id,
    required String name,
    String? description,
    String? iconName,
    @Default(0) int sortOrder,
    @Default(true) bool isActive,
  }) = _Category;

  factory Category.fromJson(Map<String, dynamic> json) =>
      _$CategoryFromJson(json);
}
