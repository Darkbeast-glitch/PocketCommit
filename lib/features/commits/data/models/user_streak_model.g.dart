// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_streak_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserStreakImpl _$$UserStreakImplFromJson(Map<String, dynamic> json) =>
    _$UserStreakImpl(
      currentStreak: (json['currentStreak'] as num?)?.toInt() ?? 0,
      longestStreak: (json['longestStreak'] as num?)?.toInt() ?? 0,
      lastActiveDate: const NullableTimestampConverter().fromJson(
        json['lastActiveDate'],
      ),
      activeDates: json['activeDates'] == null
          ? const []
          : const StreakTimestampListConverter().fromJson(
              json['activeDates'] as List,
            ),
    );

Map<String, dynamic> _$$UserStreakImplToJson(_$UserStreakImpl instance) =>
    <String, dynamic>{
      'currentStreak': instance.currentStreak,
      'longestStreak': instance.longestStreak,
      'lastActiveDate': const NullableTimestampConverter().toJson(
        instance.lastActiveDate,
      ),
      'activeDates': const StreakTimestampListConverter().toJson(
        instance.activeDates,
      ),
    };
