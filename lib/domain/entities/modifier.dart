import 'package:freezed_annotation/freezed_annotation.dart';

part 'modifier.freezed.dart';
part 'modifier.g.dart';

@freezed
class ModifierGroup with _$ModifierGroup {
  const factory ModifierGroup({
    required String id,
    required String name,
    required bool isRequired,
    @Default(1) int minSelection,
    @Default(1) int maxSelection,
    required List<Modifier> modifiers,
  }) = _ModifierGroup;

  factory ModifierGroup.fromJson(Map<String, dynamic> json) =>
      _$ModifierGroupFromJson(json);
}

@freezed
class Modifier with _$Modifier {
  const factory Modifier({
    required String id,
    required String name,
    @Default(0.0) double priceAdjustment,
    @Default(true) bool isAvailable,
  }) = _Modifier;

  factory Modifier.fromJson(Map<String, dynamic> json) =>
      _$ModifierFromJson(json);
}
