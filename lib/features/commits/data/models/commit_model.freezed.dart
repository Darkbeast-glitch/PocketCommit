// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'commit_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

Commit _$CommitFromJson(Map<String, dynamic> json) {
  return _Commit.fromJson(json);
}

/// @nodoc
mixin _$Commit {
  /// Unique identifier for the commit
  String? get id => throw _privateConstructorUsedError;

  /// Title of the commitment (e.g., "Daily Walk")
  String get title => throw _privateConstructorUsedError;

  /// Optional description (e.g., "20 minutes outdoors")
  String get description => throw _privateConstructorUsedError;

  /// Scheduled time of day for this commitment (e.g., 7:00 AM)
  /// Stored as "HH:mm" string format
  String? get scheduledTime => throw _privateConstructorUsedError;

  /// Current consecutive streak
  int get streak => throw _privateConstructorUsedError;

  /// Longest streak ever achieved
  int get longestStreak => throw _privateConstructorUsedError;

  /// Last time this commit was completed
  @TimestampConverter()
  DateTime get lastCompleted => throw _privateConstructorUsedError;

  /// List of all dates when this commit was completed
  /// Used for calendar tracking
  @TimestampListConverter()
  List<DateTime> get completedDates => throw _privateConstructorUsedError;

  /// When the commit was created
  @TimestampConverter()
  DateTime? get createdAt => throw _privateConstructorUsedError;

  /// Serializes this Commit to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Commit
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CommitCopyWith<Commit> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CommitCopyWith<$Res> {
  factory $CommitCopyWith(Commit value, $Res Function(Commit) then) =
      _$CommitCopyWithImpl<$Res, Commit>;
  @useResult
  $Res call({
    String? id,
    String title,
    String description,
    String? scheduledTime,
    int streak,
    int longestStreak,
    @TimestampConverter() DateTime lastCompleted,
    @TimestampListConverter() List<DateTime> completedDates,
    @TimestampConverter() DateTime? createdAt,
  });
}

/// @nodoc
class _$CommitCopyWithImpl<$Res, $Val extends Commit>
    implements $CommitCopyWith<$Res> {
  _$CommitCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Commit
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? title = null,
    Object? description = null,
    Object? scheduledTime = freezed,
    Object? streak = null,
    Object? longestStreak = null,
    Object? lastCompleted = null,
    Object? completedDates = null,
    Object? createdAt = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: freezed == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String?,
            title: null == title
                ? _value.title
                : title // ignore: cast_nullable_to_non_nullable
                      as String,
            description: null == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String,
            scheduledTime: freezed == scheduledTime
                ? _value.scheduledTime
                : scheduledTime // ignore: cast_nullable_to_non_nullable
                      as String?,
            streak: null == streak
                ? _value.streak
                : streak // ignore: cast_nullable_to_non_nullable
                      as int,
            longestStreak: null == longestStreak
                ? _value.longestStreak
                : longestStreak // ignore: cast_nullable_to_non_nullable
                      as int,
            lastCompleted: null == lastCompleted
                ? _value.lastCompleted
                : lastCompleted // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            completedDates: null == completedDates
                ? _value.completedDates
                : completedDates // ignore: cast_nullable_to_non_nullable
                      as List<DateTime>,
            createdAt: freezed == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$CommitImplCopyWith<$Res> implements $CommitCopyWith<$Res> {
  factory _$$CommitImplCopyWith(
    _$CommitImpl value,
    $Res Function(_$CommitImpl) then,
  ) = __$$CommitImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String? id,
    String title,
    String description,
    String? scheduledTime,
    int streak,
    int longestStreak,
    @TimestampConverter() DateTime lastCompleted,
    @TimestampListConverter() List<DateTime> completedDates,
    @TimestampConverter() DateTime? createdAt,
  });
}

/// @nodoc
class __$$CommitImplCopyWithImpl<$Res>
    extends _$CommitCopyWithImpl<$Res, _$CommitImpl>
    implements _$$CommitImplCopyWith<$Res> {
  __$$CommitImplCopyWithImpl(
    _$CommitImpl _value,
    $Res Function(_$CommitImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Commit
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? title = null,
    Object? description = null,
    Object? scheduledTime = freezed,
    Object? streak = null,
    Object? longestStreak = null,
    Object? lastCompleted = null,
    Object? completedDates = null,
    Object? createdAt = freezed,
  }) {
    return _then(
      _$CommitImpl(
        id: freezed == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String?,
        title: null == title
            ? _value.title
            : title // ignore: cast_nullable_to_non_nullable
                  as String,
        description: null == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String,
        scheduledTime: freezed == scheduledTime
            ? _value.scheduledTime
            : scheduledTime // ignore: cast_nullable_to_non_nullable
                  as String?,
        streak: null == streak
            ? _value.streak
            : streak // ignore: cast_nullable_to_non_nullable
                  as int,
        longestStreak: null == longestStreak
            ? _value.longestStreak
            : longestStreak // ignore: cast_nullable_to_non_nullable
                  as int,
        lastCompleted: null == lastCompleted
            ? _value.lastCompleted
            : lastCompleted // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        completedDates: null == completedDates
            ? _value._completedDates
            : completedDates // ignore: cast_nullable_to_non_nullable
                  as List<DateTime>,
        createdAt: freezed == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$CommitImpl extends _Commit {
  const _$CommitImpl({
    this.id,
    required this.title,
    this.description = '',
    this.scheduledTime,
    this.streak = 0,
    this.longestStreak = 0,
    @TimestampConverter() required this.lastCompleted,
    @TimestampListConverter() final List<DateTime> completedDates = const [],
    @TimestampConverter() this.createdAt,
  }) : _completedDates = completedDates,
       super._();

  factory _$CommitImpl.fromJson(Map<String, dynamic> json) =>
      _$$CommitImplFromJson(json);

  /// Unique identifier for the commit
  @override
  final String? id;

  /// Title of the commitment (e.g., "Daily Walk")
  @override
  final String title;

  /// Optional description (e.g., "20 minutes outdoors")
  @override
  @JsonKey()
  final String description;

  /// Scheduled time of day for this commitment (e.g., 7:00 AM)
  /// Stored as "HH:mm" string format
  @override
  final String? scheduledTime;

  /// Current consecutive streak
  @override
  @JsonKey()
  final int streak;

  /// Longest streak ever achieved
  @override
  @JsonKey()
  final int longestStreak;

  /// Last time this commit was completed
  @override
  @TimestampConverter()
  final DateTime lastCompleted;

  /// List of all dates when this commit was completed
  /// Used for calendar tracking
  final List<DateTime> _completedDates;

  /// List of all dates when this commit was completed
  /// Used for calendar tracking
  @override
  @JsonKey()
  @TimestampListConverter()
  List<DateTime> get completedDates {
    if (_completedDates is EqualUnmodifiableListView) return _completedDates;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_completedDates);
  }

  /// When the commit was created
  @override
  @TimestampConverter()
  final DateTime? createdAt;

  @override
  String toString() {
    return 'Commit(id: $id, title: $title, description: $description, scheduledTime: $scheduledTime, streak: $streak, longestStreak: $longestStreak, lastCompleted: $lastCompleted, completedDates: $completedDates, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CommitImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.scheduledTime, scheduledTime) ||
                other.scheduledTime == scheduledTime) &&
            (identical(other.streak, streak) || other.streak == streak) &&
            (identical(other.longestStreak, longestStreak) ||
                other.longestStreak == longestStreak) &&
            (identical(other.lastCompleted, lastCompleted) ||
                other.lastCompleted == lastCompleted) &&
            const DeepCollectionEquality().equals(
              other._completedDates,
              _completedDates,
            ) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    title,
    description,
    scheduledTime,
    streak,
    longestStreak,
    lastCompleted,
    const DeepCollectionEquality().hash(_completedDates),
    createdAt,
  );

  /// Create a copy of Commit
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CommitImplCopyWith<_$CommitImpl> get copyWith =>
      __$$CommitImplCopyWithImpl<_$CommitImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CommitImplToJson(this);
  }
}

abstract class _Commit extends Commit {
  const factory _Commit({
    final String? id,
    required final String title,
    final String description,
    final String? scheduledTime,
    final int streak,
    final int longestStreak,
    @TimestampConverter() required final DateTime lastCompleted,
    @TimestampListConverter() final List<DateTime> completedDates,
    @TimestampConverter() final DateTime? createdAt,
  }) = _$CommitImpl;
  const _Commit._() : super._();

  factory _Commit.fromJson(Map<String, dynamic> json) = _$CommitImpl.fromJson;

  /// Unique identifier for the commit
  @override
  String? get id;

  /// Title of the commitment (e.g., "Daily Walk")
  @override
  String get title;

  /// Optional description (e.g., "20 minutes outdoors")
  @override
  String get description;

  /// Scheduled time of day for this commitment (e.g., 7:00 AM)
  /// Stored as "HH:mm" string format
  @override
  String? get scheduledTime;

  /// Current consecutive streak
  @override
  int get streak;

  /// Longest streak ever achieved
  @override
  int get longestStreak;

  /// Last time this commit was completed
  @override
  @TimestampConverter()
  DateTime get lastCompleted;

  /// List of all dates when this commit was completed
  /// Used for calendar tracking
  @override
  @TimestampListConverter()
  List<DateTime> get completedDates;

  /// When the commit was created
  @override
  @TimestampConverter()
  DateTime? get createdAt;

  /// Create a copy of Commit
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CommitImplCopyWith<_$CommitImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
