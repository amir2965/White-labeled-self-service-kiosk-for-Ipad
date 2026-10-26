// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'reporting_timeframe.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ReportingTimeframe _$ReportingTimeframeFromJson(Map<String, dynamic> json) {
  return _ReportingTimeframe.fromJson(json);
}

/// @nodoc
mixin _$ReportingTimeframe {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get timezone =>
      throw _privateConstructorUsedError; // IANA timezone (e.g., 'Australia/Sydney')
  String get startLocalTime =>
      throw _privateConstructorUsedError; // 12-hour format: "12:00 AM"
  String get endLocalTime => throw _privateConstructorUsedError;

  /// Serializes this ReportingTimeframe to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ReportingTimeframe
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ReportingTimeframeCopyWith<ReportingTimeframe> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ReportingTimeframeCopyWith<$Res> {
  factory $ReportingTimeframeCopyWith(
          ReportingTimeframe value, $Res Function(ReportingTimeframe) then) =
      _$ReportingTimeframeCopyWithImpl<$Res, ReportingTimeframe>;
  @useResult
  $Res call(
      {String id,
      String name,
      String timezone,
      String startLocalTime,
      String endLocalTime});
}

/// @nodoc
class _$ReportingTimeframeCopyWithImpl<$Res, $Val extends ReportingTimeframe>
    implements $ReportingTimeframeCopyWith<$Res> {
  _$ReportingTimeframeCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ReportingTimeframe
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? timezone = null,
    Object? startLocalTime = null,
    Object? endLocalTime = null,
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
      timezone: null == timezone
          ? _value.timezone
          : timezone // ignore: cast_nullable_to_non_nullable
              as String,
      startLocalTime: null == startLocalTime
          ? _value.startLocalTime
          : startLocalTime // ignore: cast_nullable_to_non_nullable
              as String,
      endLocalTime: null == endLocalTime
          ? _value.endLocalTime
          : endLocalTime // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ReportingTimeframeImplCopyWith<$Res>
    implements $ReportingTimeframeCopyWith<$Res> {
  factory _$$ReportingTimeframeImplCopyWith(_$ReportingTimeframeImpl value,
          $Res Function(_$ReportingTimeframeImpl) then) =
      __$$ReportingTimeframeImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      String timezone,
      String startLocalTime,
      String endLocalTime});
}

/// @nodoc
class __$$ReportingTimeframeImplCopyWithImpl<$Res>
    extends _$ReportingTimeframeCopyWithImpl<$Res, _$ReportingTimeframeImpl>
    implements _$$ReportingTimeframeImplCopyWith<$Res> {
  __$$ReportingTimeframeImplCopyWithImpl(_$ReportingTimeframeImpl _value,
      $Res Function(_$ReportingTimeframeImpl) _then)
      : super(_value, _then);

  /// Create a copy of ReportingTimeframe
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? timezone = null,
    Object? startLocalTime = null,
    Object? endLocalTime = null,
  }) {
    return _then(_$ReportingTimeframeImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      timezone: null == timezone
          ? _value.timezone
          : timezone // ignore: cast_nullable_to_non_nullable
              as String,
      startLocalTime: null == startLocalTime
          ? _value.startLocalTime
          : startLocalTime // ignore: cast_nullable_to_non_nullable
              as String,
      endLocalTime: null == endLocalTime
          ? _value.endLocalTime
          : endLocalTime // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ReportingTimeframeImpl implements _ReportingTimeframe {
  const _$ReportingTimeframeImpl(
      {required this.id,
      required this.name,
      required this.timezone,
      required this.startLocalTime,
      required this.endLocalTime});

  factory _$ReportingTimeframeImpl.fromJson(Map<String, dynamic> json) =>
      _$$ReportingTimeframeImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String timezone;
// IANA timezone (e.g., 'Australia/Sydney')
  @override
  final String startLocalTime;
// 12-hour format: "12:00 AM"
  @override
  final String endLocalTime;

  @override
  String toString() {
    return 'ReportingTimeframe(id: $id, name: $name, timezone: $timezone, startLocalTime: $startLocalTime, endLocalTime: $endLocalTime)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ReportingTimeframeImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.timezone, timezone) ||
                other.timezone == timezone) &&
            (identical(other.startLocalTime, startLocalTime) ||
                other.startLocalTime == startLocalTime) &&
            (identical(other.endLocalTime, endLocalTime) ||
                other.endLocalTime == endLocalTime));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, id, name, timezone, startLocalTime, endLocalTime);

  /// Create a copy of ReportingTimeframe
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ReportingTimeframeImplCopyWith<_$ReportingTimeframeImpl> get copyWith =>
      __$$ReportingTimeframeImplCopyWithImpl<_$ReportingTimeframeImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ReportingTimeframeImplToJson(
      this,
    );
  }
}

abstract class _ReportingTimeframe implements ReportingTimeframe {
  const factory _ReportingTimeframe(
      {required final String id,
      required final String name,
      required final String timezone,
      required final String startLocalTime,
      required final String endLocalTime}) = _$ReportingTimeframeImpl;

  factory _ReportingTimeframe.fromJson(Map<String, dynamic> json) =
      _$ReportingTimeframeImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String get timezone; // IANA timezone (e.g., 'Australia/Sydney')
  @override
  String get startLocalTime; // 12-hour format: "12:00 AM"
  @override
  String get endLocalTime;

  /// Create a copy of ReportingTimeframe
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ReportingTimeframeImplCopyWith<_$ReportingTimeframeImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ReportingTimeframeSelection _$ReportingTimeframeSelectionFromJson(
    Map<String, dynamic> json) {
  return _ReportingTimeframeSelection.fromJson(json);
}

/// @nodoc
mixin _$ReportingTimeframeSelection {
  ReportingTimeframeType get type => throw _privateConstructorUsedError;
  String get startTime => throw _privateConstructorUsedError; // 12-hour format
  String get endTime => throw _privateConstructorUsedError; // 12-hour format
  String get timezone => throw _privateConstructorUsedError;
  String? get presetId =>
      throw _privateConstructorUsedError; // For saved preset type
  String? get presetName => throw _privateConstructorUsedError;

  /// Serializes this ReportingTimeframeSelection to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ReportingTimeframeSelection
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ReportingTimeframeSelectionCopyWith<ReportingTimeframeSelection>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ReportingTimeframeSelectionCopyWith<$Res> {
  factory $ReportingTimeframeSelectionCopyWith(
          ReportingTimeframeSelection value,
          $Res Function(ReportingTimeframeSelection) then) =
      _$ReportingTimeframeSelectionCopyWithImpl<$Res,
          ReportingTimeframeSelection>;
  @useResult
  $Res call(
      {ReportingTimeframeType type,
      String startTime,
      String endTime,
      String timezone,
      String? presetId,
      String? presetName});
}

/// @nodoc
class _$ReportingTimeframeSelectionCopyWithImpl<$Res,
        $Val extends ReportingTimeframeSelection>
    implements $ReportingTimeframeSelectionCopyWith<$Res> {
  _$ReportingTimeframeSelectionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ReportingTimeframeSelection
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = null,
    Object? startTime = null,
    Object? endTime = null,
    Object? timezone = null,
    Object? presetId = freezed,
    Object? presetName = freezed,
  }) {
    return _then(_value.copyWith(
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as ReportingTimeframeType,
      startTime: null == startTime
          ? _value.startTime
          : startTime // ignore: cast_nullable_to_non_nullable
              as String,
      endTime: null == endTime
          ? _value.endTime
          : endTime // ignore: cast_nullable_to_non_nullable
              as String,
      timezone: null == timezone
          ? _value.timezone
          : timezone // ignore: cast_nullable_to_non_nullable
              as String,
      presetId: freezed == presetId
          ? _value.presetId
          : presetId // ignore: cast_nullable_to_non_nullable
              as String?,
      presetName: freezed == presetName
          ? _value.presetName
          : presetName // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ReportingTimeframeSelectionImplCopyWith<$Res>
    implements $ReportingTimeframeSelectionCopyWith<$Res> {
  factory _$$ReportingTimeframeSelectionImplCopyWith(
          _$ReportingTimeframeSelectionImpl value,
          $Res Function(_$ReportingTimeframeSelectionImpl) then) =
      __$$ReportingTimeframeSelectionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {ReportingTimeframeType type,
      String startTime,
      String endTime,
      String timezone,
      String? presetId,
      String? presetName});
}

/// @nodoc
class __$$ReportingTimeframeSelectionImplCopyWithImpl<$Res>
    extends _$ReportingTimeframeSelectionCopyWithImpl<$Res,
        _$ReportingTimeframeSelectionImpl>
    implements _$$ReportingTimeframeSelectionImplCopyWith<$Res> {
  __$$ReportingTimeframeSelectionImplCopyWithImpl(
      _$ReportingTimeframeSelectionImpl _value,
      $Res Function(_$ReportingTimeframeSelectionImpl) _then)
      : super(_value, _then);

  /// Create a copy of ReportingTimeframeSelection
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = null,
    Object? startTime = null,
    Object? endTime = null,
    Object? timezone = null,
    Object? presetId = freezed,
    Object? presetName = freezed,
  }) {
    return _then(_$ReportingTimeframeSelectionImpl(
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as ReportingTimeframeType,
      startTime: null == startTime
          ? _value.startTime
          : startTime // ignore: cast_nullable_to_non_nullable
              as String,
      endTime: null == endTime
          ? _value.endTime
          : endTime // ignore: cast_nullable_to_non_nullable
              as String,
      timezone: null == timezone
          ? _value.timezone
          : timezone // ignore: cast_nullable_to_non_nullable
              as String,
      presetId: freezed == presetId
          ? _value.presetId
          : presetId // ignore: cast_nullable_to_non_nullable
              as String?,
      presetName: freezed == presetName
          ? _value.presetName
          : presetName // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ReportingTimeframeSelectionImpl
    implements _ReportingTimeframeSelection {
  const _$ReportingTimeframeSelectionImpl(
      {required this.type,
      required this.startTime,
      required this.endTime,
      required this.timezone,
      this.presetId,
      this.presetName});

  factory _$ReportingTimeframeSelectionImpl.fromJson(
          Map<String, dynamic> json) =>
      _$$ReportingTimeframeSelectionImplFromJson(json);

  @override
  final ReportingTimeframeType type;
  @override
  final String startTime;
// 12-hour format
  @override
  final String endTime;
// 12-hour format
  @override
  final String timezone;
  @override
  final String? presetId;
// For saved preset type
  @override
  final String? presetName;

  @override
  String toString() {
    return 'ReportingTimeframeSelection(type: $type, startTime: $startTime, endTime: $endTime, timezone: $timezone, presetId: $presetId, presetName: $presetName)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ReportingTimeframeSelectionImpl &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.startTime, startTime) ||
                other.startTime == startTime) &&
            (identical(other.endTime, endTime) || other.endTime == endTime) &&
            (identical(other.timezone, timezone) ||
                other.timezone == timezone) &&
            (identical(other.presetId, presetId) ||
                other.presetId == presetId) &&
            (identical(other.presetName, presetName) ||
                other.presetName == presetName));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, type, startTime, endTime, timezone, presetId, presetName);

  /// Create a copy of ReportingTimeframeSelection
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ReportingTimeframeSelectionImplCopyWith<_$ReportingTimeframeSelectionImpl>
      get copyWith => __$$ReportingTimeframeSelectionImplCopyWithImpl<
          _$ReportingTimeframeSelectionImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ReportingTimeframeSelectionImplToJson(
      this,
    );
  }
}

abstract class _ReportingTimeframeSelection
    implements ReportingTimeframeSelection {
  const factory _ReportingTimeframeSelection(
      {required final ReportingTimeframeType type,
      required final String startTime,
      required final String endTime,
      required final String timezone,
      final String? presetId,
      final String? presetName}) = _$ReportingTimeframeSelectionImpl;

  factory _ReportingTimeframeSelection.fromJson(Map<String, dynamic> json) =
      _$ReportingTimeframeSelectionImpl.fromJson;

  @override
  ReportingTimeframeType get type;
  @override
  String get startTime; // 12-hour format
  @override
  String get endTime; // 12-hour format
  @override
  String get timezone;
  @override
  String? get presetId; // For saved preset type
  @override
  String? get presetName;

  /// Create a copy of ReportingTimeframeSelection
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ReportingTimeframeSelectionImplCopyWith<_$ReportingTimeframeSelectionImpl>
      get copyWith => throw _privateConstructorUsedError;
}
