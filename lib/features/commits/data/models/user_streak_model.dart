import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_streak_model.freezed.dart';
part 'user_streak_model.g.dart';

/// Custom converter for Firestore Timestamps to DateTime list
class StreakTimestampListConverter
    implements JsonConverter<List<DateTime>, List<dynamic>> {
  const StreakTimestampListConverter();

  @override
  List<DateTime> fromJson(List<dynamic> json) {
    return json.map((item) {
      if (item is Timestamp) {
        return item.toDate();
      } else if (item is String) {
        return DateTime.parse(item);
      } else if (item is int) {
        return DateTime.fromMillisecondsSinceEpoch(item);
      }
      return DateTime.now();
    }).toList();
  }

  @override
  List<dynamic> toJson(List<DateTime> dates) {
    return dates.map((d) => d.toIso8601String()).toList();
  }
}

/// Custom converter for single Timestamp/DateTime (nullable)
class NullableTimestampConverter implements JsonConverter<DateTime?, dynamic> {
  const NullableTimestampConverter();

  @override
  DateTime? fromJson(dynamic json) {
    if (json == null) return null;
    if (json is Timestamp) {
      return json.toDate();
    } else if (json is String) {
      return DateTime.parse(json);
    } else if (json is int) {
      return DateTime.fromMillisecondsSinceEpoch(json);
    }
    return null;
  }

  @override
  dynamic toJson(DateTime? date) {
    return date?.toIso8601String();
  }
}

/// User's global streak data - stored at users/{uid}/profile
@freezed
class UserStreak with _$UserStreak {
  const UserStreak._();

  const factory UserStreak({
    /// Current consecutive streak (days in a row)
    @Default(0) int currentStreak,

    /// Longest streak ever achieved
    @Default(0) int longestStreak,

    /// Last date the user was active
    @NullableTimestampConverter() DateTime? lastActiveDate,

    /// All dates the user was active (for calendar/heat map)
    @StreakTimestampListConverter() @Default([]) List<DateTime> activeDates,
  }) = _UserStreak;

  factory UserStreak.fromJson(Map<String, dynamic> json) =>
      _$UserStreakFromJson(json);

  // ═══════════════════════════════════════════════════════════════
  // HELPER METHODS
  // ═══════════════════════════════════════════════════════════════

  /// Check if active today
  bool get isActiveToday {
    if (lastActiveDate == null) return false;
    final now = DateTime.now();
    return lastActiveDate!.year == now.year &&
        lastActiveDate!.month == now.month &&
        lastActiveDate!.day == now.day;
  }

  /// Check if streak is still valid (was active yesterday or today)
  bool get isStreakAlive {
    if (lastActiveDate == null) return false;
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final lastActive = DateTime(
      lastActiveDate!.year,
      lastActiveDate!.month,
      lastActiveDate!.day,
    );
    final difference = today.difference(lastActive).inDays;
    return difference <= 1;
  }

  /// Get the actual current streak (accounting for missed days)
  int get effectiveStreak {
    if (!isStreakAlive) return 0;
    return currentStreak;
  }

  /// Check if a specific date was active
  bool wasActiveOn(DateTime date) {
    return activeDates.any(
      (d) => d.year == date.year && d.month == date.month && d.day == date.day,
    );
  }

  /// Record activity for today and return updated streak
  UserStreak recordActivity() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    // Already active today, no change needed
    if (isActiveToday) return this;

    // Calculate new streak
    int newStreak;
    if (lastActiveDate == null) {
      // First activity ever
      newStreak = 1;
    } else {
      final lastActive = DateTime(
        lastActiveDate!.year,
        lastActiveDate!.month,
        lastActiveDate!.day,
      );
      final difference = today.difference(lastActive).inDays;

      if (difference == 1) {
        // Yesterday was active, continue streak
        newStreak = currentStreak + 1;
      } else if (difference == 0) {
        // Same day, keep streak
        newStreak = currentStreak;
      } else {
        // Streak broken, start fresh
        newStreak = 1;
      }
    }

    // Update longest streak if needed
    final newLongestStreak = newStreak > longestStreak
        ? newStreak
        : longestStreak;

    // Add today to active dates
    final newActiveDates = [...activeDates, today];

    return copyWith(
      currentStreak: newStreak,
      longestStreak: newLongestStreak,
      lastActiveDate: now,
      activeDates: newActiveDates,
    );
  }
}
