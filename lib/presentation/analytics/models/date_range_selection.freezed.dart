// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'date_range_selection.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$DateRangeSelection {
  DateTime get start => throw _privateConstructorUsedError;
  DateTime get end => throw _privateConstructorUsedError;
  bool get isSingleDay => throw _privateConstructorUsedError;
  RangePreset? get preset => throw _privateConstructorUsedError;

  /// Create a copy of DateRangeSelection
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DateRangeSelectionCopyWith<DateRangeSelection> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DateRangeSelectionCopyWith<$Res> {
  factory $DateRangeSelectionCopyWith(
          DateRangeSelection value, $Res Function(DateRangeSelection) then) =
      _$DateRangeSelectionCopyWithImpl<$Res, DateRangeSelection>;
  @useResult
  $Res call(
      {DateTime start, DateTime end, bool isSingleDay, RangePreset? preset});
}

/// @nodoc
class _$DateRangeSelectionCopyWithImpl<$Res, $Val extends DateRangeSelection>
    implements $DateRangeSelectionCopyWith<$Res> {
  _$DateRangeSelectionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DateRangeSelection
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? start = null,
    Object? end = null,
    Object? isSingleDay = null,
    Object? preset = freezed,
  }) {
    return _then(_value.copyWith(
      start: null == start
          ? _value.start
          : start // ignore: cast_nullable_to_non_nullable
              as DateTime,
      end: null == end
          ? _value.end
          : end // ignore: cast_nullable_to_non_nullable
              as DateTime,
      isSingleDay: null == isSingleDay
          ? _value.isSingleDay
          : isSingleDay // ignore: cast_nullable_to_non_nullable
              as bool,
      preset: freezed == preset
          ? _value.preset
          : preset // ignore: cast_nullable_to_non_nullable
              as RangePreset?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$DateRangeSelectionImplCopyWith<$Res>
    implements $DateRangeSelectionCopyWith<$Res> {
  factory _$$DateRangeSelectionImplCopyWith(_$DateRangeSelectionImpl value,
          $Res Function(_$DateRangeSelectionImpl) then) =
      __$$DateRangeSelectionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {DateTime start, DateTime end, bool isSingleDay, RangePreset? preset});
}

/// @nodoc
class __$$DateRangeSelectionImplCopyWithImpl<$Res>
    extends _$DateRangeSelectionCopyWithImpl<$Res, _$DateRangeSelectionImpl>
    implements _$$DateRangeSelectionImplCopyWith<$Res> {
  __$$DateRangeSelectionImplCopyWithImpl(_$DateRangeSelectionImpl _value,
      $Res Function(_$DateRangeSelectionImpl) _then)
      : super(_value, _then);

  /// Create a copy of DateRangeSelection
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? start = null,
    Object? end = null,
    Object? isSingleDay = null,
    Object? preset = freezed,
  }) {
    return _then(_$DateRangeSelectionImpl(
      start: null == start
          ? _value.start
          : start // ignore: cast_nullable_to_non_nullable
              as DateTime,
      end: null == end
          ? _value.end
          : end // ignore: cast_nullable_to_non_nullable
              as DateTime,
      isSingleDay: null == isSingleDay
          ? _value.isSingleDay
          : isSingleDay // ignore: cast_nullable_to_non_nullable
              as bool,
      preset: freezed == preset
          ? _value.preset
          : preset // ignore: cast_nullable_to_non_nullable
              as RangePreset?,
    ));
  }
}

/// @nodoc

class _$DateRangeSelectionImpl implements _DateRangeSelection {
  const _$DateRangeSelectionImpl(
      {required this.start,
      required this.end,
      required this.isSingleDay,
      this.preset});

  @override
  final DateTime start;
  @override
  final DateTime end;
  @override
  final bool isSingleDay;
  @override
  final RangePreset? preset;

  @override
  String toString() {
    return 'DateRangeSelection(start: $start, end: $end, isSingleDay: $isSingleDay, preset: $preset)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DateRangeSelectionImpl &&
            (identical(other.start, start) || other.start == start) &&
            (identical(other.end, end) || other.end == end) &&
            (identical(other.isSingleDay, isSingleDay) ||
                other.isSingleDay == isSingleDay) &&
            (identical(other.preset, preset) || other.preset == preset));
  }

  @override
  int get hashCode => Object.hash(runtimeType, start, end, isSingleDay, preset);

  /// Create a copy of DateRangeSelection
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DateRangeSelectionImplCopyWith<_$DateRangeSelectionImpl> get copyWith =>
      __$$DateRangeSelectionImplCopyWithImpl<_$DateRangeSelectionImpl>(
          this, _$identity);
}

abstract class _DateRangeSelection implements DateRangeSelection {
  const factory _DateRangeSelection(
      {required final DateTime start,
      required final DateTime end,
      required final bool isSingleDay,
      final RangePreset? preset}) = _$DateRangeSelectionImpl;

  @override
  DateTime get start;
  @override
  DateTime get end;
  @override
  bool get isSingleDay;
  @override
  RangePreset? get preset;

  /// Create a copy of DateRangeSelection
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DateRangeSelectionImplCopyWith<_$DateRangeSelectionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
