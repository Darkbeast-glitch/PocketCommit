// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_streak_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

UserStreak _$UserStreakFromJson(Map<String, dynamic> json) {
  return _UserStreak.fromJson(json);
}

/// @nodoc
mixin _$UserStreak {
  /// Current consecutive streak (days in a row)
  int get currentStreak => throw _privateConstructorUsedError;

  /// Longest streak ever achieved
  int get longestStreak => throw _privateConstructorUsedError;

  /// Last date the user was active
  @NullableTimestampConverter()
  DateTime? get lastActiveDate => throw _privateConstructorUsedError;

  /// All dates the user was active (for calendar/heat map)
  @StreakTimestampListConverter()
  List<DateTime> get activeDates => throw _privateConstructorUsedError;

  /// Serializes this UserStreak to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of UserStreak
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UserStreakCopyWith<UserStreak> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserStreakCopyWith<$Res> {
  factory $UserStreakCopyWith(
    UserStreak value,
    $Res Function(UserStreak) then,
  ) = _$UserStreakCopyWithImpl<$Res, UserStreak>;
  @useResult
  $Res call({
    int currentStreak,
    int longestStreak,
    @NullableTimestampConverter() DateTime? lastActiveDate,
    @StreakTimestampListConverter() List<DateTime> activeDates,
  });
}

/// @nodoc
class _$UserStreakCopyWithImpl<$Res, $Val extends UserStreak>
    implements $UserStreakCopyWith<$Res> {
  _$UserStreakCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UserStreak
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? currentStreak = null,
    Object? longestStreak = null,
    Object? lastActiveDate = freezed,
    Object? activeDates = null,
  }) {
    return _then(
      _value.copyWith(
            currentStreak: null == currentStreak
                ? _value.currentStreak
                : currentStreak // ignore: cast_nullable_to_non_nullable
                      as int,
            longestStreak: null == longestStreak
                ? _value.longestStreak
                : longestStreak // ignore: cast_nullable_to_non_nullable
                      as int,
            lastActiveDate: freezed == lastActiveDate
                ? _value.lastActiveDate
                : lastActiveDate // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            activeDates: null == activeDates
                ? _value.activeDates
                : activeDates // ignore: cast_nullable_to_non_nullable
                      as List<DateTime>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$UserStreakImplCopyWith<$Res>
    implements $UserStreakCopyWith<$Res> {
  factory _$$UserStreakImplCopyWith(
    _$UserStreakImpl value,
    $Res Function(_$UserStreakImpl) then,
  ) = __$$UserStreakImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int currentStreak,
    int longestStreak,
    @NullableTimestampConverter() DateTime? lastActiveDate,
    @StreakTimestampListConverter() List<DateTime> activeDates,
  });
}

/// @nodoc
class __$$UserStreakImplCopyWithImpl<$Res>
    extends _$UserStreakCopyWithImpl<$Res, _$UserStreakImpl>
    implements _$$UserStreakImplCopyWith<$Res> {
  __$$UserStreakImplCopyWithImpl(
    _$UserStreakImpl _value,
    $Res Function(_$UserStreakImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of UserStreak
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? currentStreak = null,
    Object? longestStreak = null,
    Object? lastActiveDate = freezed,
    Object? activeDates = null,
  }) {
    return _then(
      _$UserStreakImpl(
        currentStreak: null == currentStreak
            ? _value.currentStreak
            : currentStreak // ignore: cast_nullable_to_non_nullable
                  as int,
        longestStreak: null == longestStreak
            ? _value.longestStreak
            : longestStreak // ignore: cast_nullable_to_non_nullable
                  as int,
        lastActiveDate: freezed == lastActiveDate
            ? _value.lastActiveDate
            : lastActiveDate // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        activeDates: null == activeDates
            ? _value._activeDates
            : activeDates // ignore: cast_nullable_to_non_nullable
                  as List<DateTime>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$UserStreakImpl extends _UserStreak {
  const _$UserStreakImpl({
    this.currentStreak = 0,
    this.longestStreak = 0,
    @NullableTimestampConverter() this.lastActiveDate,
    @StreakTimestampListConverter() final List<DateTime> activeDates = const [],
  }) : _activeDates = activeDates,
       super._();

  factory _$UserStreakImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserStreakImplFromJson(json);

  /// Current consecutive streak (days in a row)
  @override
  @JsonKey()
  final int currentStreak;

  /// Longest streak ever achieved
  @override
  @JsonKey()
  final int longestStreak;

  /// Last date the user was active
  @override
  @NullableTimestampConverter()
  final DateTime? lastActiveDate;

  /// All dates the user was active (for calendar/heat map)
  final List<DateTime> _activeDates;

  /// All dates the user was active (for calendar/heat map)
  @override
  @JsonKey()
  @StreakTimestampListConverter()
  List<DateTime> get activeDates {
    if (_activeDates is EqualUnmodifiableListView) return _activeDates;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_activeDates);
  }

  @override
  String toString() {
    return 'UserStreak(currentStreak: $currentStreak, longestStreak: $longestStreak, lastActiveDate: $lastActiveDate, activeDates: $activeDates)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserStreakImpl &&
            (identical(other.currentStreak, currentStreak) ||
                other.currentStreak == currentStreak) &&
            (identical(other.longestStreak, longestStreak) ||
                other.longestStreak == longestStreak) &&
            (identical(other.lastActiveDate, lastActiveDate) ||
                other.lastActiveDate == lastActiveDate) &&
            const DeepCollectionEquality().equals(
              other._activeDates,
              _activeDates,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    currentStreak,
    longestStreak,
    lastActiveDate,
    const DeepCollectionEquality().hash(_activeDates),
  );

  /// Create a copy of UserStreak
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UserStreakImplCopyWith<_$UserStreakImpl> get copyWith =>
      __$$UserStreakImplCopyWithImpl<_$UserStreakImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UserStreakImplToJson(this);
  }
}

abstract class _UserStreak extends UserStreak {
  const factory _UserStreak({
    final int currentStreak,
    final int longestStreak,
    @NullableTimestampConverter() final DateTime? lastActiveDate,
    @StreakTimestampListConverter() final List<DateTime> activeDates,
  }) = _$UserStreakImpl;
  const _UserStreak._() : super._();

  factory _UserStreak.fromJson(Map<String, dynamic> json) =
      _$UserStreakImpl.fromJson;

  /// Current consecutive streak (days in a row)
  @override
  int get currentStreak;

  /// Longest streak ever achieved
  @override
  int get longestStreak;

  /// Last date the user was active
  @override
  @NullableTimestampConverter()
  DateTime? get lastActiveDate;

  /// All dates the user was active (for calendar/heat map)
  @override
  @StreakTimestampListConverter()
  List<DateTime> get activeDates;

  /// Create a copy of UserStreak
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UserStreakImplCopyWith<_$UserStreakImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
