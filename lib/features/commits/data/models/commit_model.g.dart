// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'commit_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CommitImpl _$$CommitImplFromJson(Map<String, dynamic> json) => _$CommitImpl(
  id: json['id'] as String?,
  title: json['title'] as String,
  description: json['description'] as String? ?? '',
  scheduledTime: json['scheduledTime'] as String?,
  streak: (json['streak'] as num?)?.toInt() ?? 0,
  longestStreak: (json['longestStreak'] as num?)?.toInt() ?? 0,
  lastCompleted: const TimestampConverter().fromJson(json['lastCompleted']),
  completedDates: json['completedDates'] == null
      ? const []
      : const TimestampListConverter().fromJson(json['completedDates'] as List),
  createdAt: const TimestampConverter().fromJson(json['createdAt']),
);

Map<String, dynamic> _$$CommitImplToJson(
  _$CommitImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'description': instance.description,
  'scheduledTime': instance.scheduledTime,
  'streak': instance.streak,
  'longestStreak': instance.longestStreak,
  'lastCompleted': const TimestampConverter().toJson(instance.lastCompleted),
  'completedDates': const TimestampListConverter().toJson(
    instance.completedDates,
  ),
  'createdAt': _$JsonConverterToJson<dynamic, DateTime>(
    instance.createdAt,
    const TimestampConverter().toJson,
  ),
};

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) => value == null ? null : toJson(value);
