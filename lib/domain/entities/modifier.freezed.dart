// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'modifier.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ModifierGroup _$ModifierGroupFromJson(Map<String, dynamic> json) {
  return _ModifierGroup.fromJson(json);
}

/// @nodoc
mixin _$ModifierGroup {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  bool get isRequired => throw _privateConstructorUsedError;
  int get minSelection => throw _privateConstructorUsedError;
  int get maxSelection => throw _privateConstructorUsedError;
  List<Modifier> get modifiers => throw _privateConstructorUsedError;

  /// Serializes this ModifierGroup to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ModifierGroup
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ModifierGroupCopyWith<ModifierGroup> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ModifierGroupCopyWith<$Res> {
  factory $ModifierGroupCopyWith(
          ModifierGroup value, $Res Function(ModifierGroup) then) =
      _$ModifierGroupCopyWithImpl<$Res, ModifierGroup>;
  @useResult
  $Res call(
      {String id,
      String name,
      bool isRequired,
      int minSelection,
      int maxSelection,
      List<Modifier> modifiers});
}

/// @nodoc
class _$ModifierGroupCopyWithImpl<$Res, $Val extends ModifierGroup>
    implements $ModifierGroupCopyWith<$Res> {
  _$ModifierGroupCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ModifierGroup
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? isRequired = null,
    Object? minSelection = null,
    Object? maxSelection = null,
    Object? modifiers = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      isRequired: null == isRequired
          ? _value.isRequired
          : isRequired // ignore: cast_nullable_to_non_nullable
              as bool,
      minSelection: null == minSelection
          ? _value.minSelection
          : minSelection // ignore: cast_nullable_to_non_nullable
              as int,
      maxSelection: null == maxSelection
          ? _value.maxSelection
          : maxSelection // ignore: cast_nullable_to_non_nullable
              as int,
      modifiers: null == modifiers
          ? _value.modifiers
          : modifiers // ignore: cast_nullable_to_non_nullable
              as List<Modifier>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ModifierGroupImplCopyWith<$Res>
    implements $ModifierGroupCopyWith<$Res> {
  factory _$$ModifierGroupImplCopyWith(
          _$ModifierGroupImpl value, $Res Function(_$ModifierGroupImpl) then) =
      __$$ModifierGroupImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      bool isRequired,
      int minSelection,
      int maxSelection,
      List<Modifier> modifiers});
}

/// @nodoc
class __$$ModifierGroupImplCopyWithImpl<$Res>
    extends _$ModifierGroupCopyWithImpl<$Res, _$ModifierGroupImpl>
    implements _$$ModifierGroupImplCopyWith<$Res> {
  __$$ModifierGroupImplCopyWithImpl(
      _$ModifierGroupImpl _value, $Res Function(_$ModifierGroupImpl) _then)
      : super(_value, _then);

  /// Create a copy of ModifierGroup
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? isRequired = null,
    Object? minSelection = null,
    Object? maxSelection = null,
    Object? modifiers = null,
  }) {
    return _then(_$ModifierGroupImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      isRequired: null == isRequired
          ? _value.isRequired
          : isRequired // ignore: cast_nullable_to_non_nullable
              as bool,
      minSelection: null == minSelection
          ? _value.minSelection
          : minSelection // ignore: cast_nullable_to_non_nullable
              as int,
      maxSelection: null == maxSelection
          ? _value.maxSelection
          : maxSelection // ignore: cast_nullable_to_non_nullable
              as int,
      modifiers: null == modifiers
          ? _value._modifiers
          : modifiers // ignore: cast_nullable_to_non_nullable
              as List<Modifier>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ModifierGroupImpl implements _ModifierGroup {
  const _$ModifierGroupImpl(
      {required this.id,
      required this.name,
      required this.isRequired,
      this.minSelection = 1,
      this.maxSelection = 1,
      required final List<Modifier> modifiers})
      : _modifiers = modifiers;

  factory _$ModifierGroupImpl.fromJson(Map<String, dynamic> json) =>
      _$$ModifierGroupImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final bool isRequired;
  @override
  @JsonKey()
  final int minSelection;
  @override
  @JsonKey()
  final int maxSelection;
  final List<Modifier> _modifiers;
  @override
  List<Modifier> get modifiers {
    if (_modifiers is EqualUnmodifiableListView) return _modifiers;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_modifiers);
  }

  @override
  String toString() {
    return 'ModifierGroup(id: $id, name: $name, isRequired: $isRequired, minSelection: $minSelection, maxSelection: $maxSelection, modifiers: $modifiers)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ModifierGroupImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.isRequired, isRequired) ||
                other.isRequired == isRequired) &&
            (identical(other.minSelection, minSelection) ||
                other.minSelection == minSelection) &&
            (identical(other.maxSelection, maxSelection) ||
                other.maxSelection == maxSelection) &&
            const DeepCollectionEquality()
                .equals(other._modifiers, _modifiers));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      name,
      isRequired,
      minSelection,
      maxSelection,
      const DeepCollectionEquality().hash(_modifiers));

  /// Create a copy of ModifierGroup
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ModifierGroupImplCopyWith<_$ModifierGroupImpl> get copyWith =>
      __$$ModifierGroupImplCopyWithImpl<_$ModifierGroupImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ModifierGroupImplToJson(
      this,
    );
  }
}

abstract class _ModifierGroup implements ModifierGroup {
  const factory _ModifierGroup(
      {required final String id,
      required final String name,
      required final bool isRequired,
      final int minSelection,
      final int maxSelection,
      required final List<Modifier> modifiers}) = _$ModifierGroupImpl;

  factory _ModifierGroup.fromJson(Map<String, dynamic> json) =
      _$ModifierGroupImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  bool get isRequired;
  @override
  int get minSelection;
  @override
  int get maxSelection;
  @override
  List<Modifier> get modifiers;

  /// Create a copy of ModifierGroup
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ModifierGroupImplCopyWith<_$ModifierGroupImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Modifier _$ModifierFromJson(Map<String, dynamic> json) {
  return _Modifier.fromJson(json);
}

/// @nodoc
mixin _$Modifier {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  double get priceAdjustment => throw _privateConstructorUsedError;
  bool get isAvailable => throw _privateConstructorUsedError;

  /// Serializes this Modifier to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Modifier
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ModifierCopyWith<Modifier> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ModifierCopyWith<$Res> {
  factory $ModifierCopyWith(Modifier value, $Res Function(Modifier) then) =
      _$ModifierCopyWithImpl<$Res, Modifier>;
  @useResult
  $Res call({String id, String name, double priceAdjustment, bool isAvailable});
}

/// @nodoc
class _$ModifierCopyWithImpl<$Res, $Val extends Modifier>
    implements $ModifierCopyWith<$Res> {
  _$ModifierCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Modifier
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? priceAdjustment = null,
    Object? isAvailable = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      priceAdjustment: null == priceAdjustment
          ? _value.priceAdjustment
          : priceAdjustment // ignore: cast_nullable_to_non_nullable
              as double,
      isAvailable: null == isAvailable
          ? _value.isAvailable
          : isAvailable // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ModifierImplCopyWith<$Res>
    implements $ModifierCopyWith<$Res> {
  factory _$$ModifierImplCopyWith(
          _$ModifierImpl value, $Res Function(_$ModifierImpl) then) =
      __$$ModifierImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String id, String name, double priceAdjustment, bool isAvailable});
}

/// @nodoc
class __$$ModifierImplCopyWithImpl<$Res>
    extends _$ModifierCopyWithImpl<$Res, _$ModifierImpl>
    implements _$$ModifierImplCopyWith<$Res> {
  __$$ModifierImplCopyWithImpl(
      _$ModifierImpl _value, $Res Function(_$ModifierImpl) _then)
      : super(_value, _then);

  /// Create a copy of Modifier
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? priceAdjustment = null,
    Object? isAvailable = null,
  }) {
    return _then(_$ModifierImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      priceAdjustment: null == priceAdjustment
          ? _value.priceAdjustment
          : priceAdjustment // ignore: cast_nullable_to_non_nullable
              as double,
      isAvailable: null == isAvailable
          ? _value.isAvailable
          : isAvailable // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ModifierImpl implements _Modifier {
  const _$ModifierImpl(
      {required this.id,
      required this.name,
      this.priceAdjustment = 0.0,
      this.isAvailable = true});

  factory _$ModifierImpl.fromJson(Map<String, dynamic> json) =>
      _$$ModifierImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  @JsonKey()
  final double priceAdjustment;
  @override
  @JsonKey()
  final bool isAvailable;

  @override
  String toString() {
    return 'Modifier(id: $id, name: $name, priceAdjustment: $priceAdjustment, isAvailable: $isAvailable)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ModifierImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.priceAdjustment, priceAdjustment) ||
                other.priceAdjustment == priceAdjustment) &&
            (identical(other.isAvailable, isAvailable) ||
                other.isAvailable == isAvailable));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, name, priceAdjustment, isAvailable);

  /// Create a copy of Modifier
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ModifierImplCopyWith<_$ModifierImpl> get copyWith =>
      __$$ModifierImplCopyWithImpl<_$ModifierImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ModifierImplToJson(
      this,
    );
  }
}

abstract class _Modifier implements Modifier {
  const factory _Modifier(
      {required final String id,
      required final String name,
      final double priceAdjustment,
      final bool isAvailable}) = _$ModifierImpl;

  factory _Modifier.fromJson(Map<String, dynamic> json) =
      _$ModifierImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  double get priceAdjustment;
  @override
  bool get isAvailable;

  /// Create a copy of Modifier
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ModifierImplCopyWith<_$ModifierImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
