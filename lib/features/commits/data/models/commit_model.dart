import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'commit_model.freezed.dart';
part 'commit_model.g.dart';

/// Custom converter for Firestore Timestamps to DateTime list
class TimestampListConverter
    implements JsonConverter<List<DateTime>, List<dynamic>> {
  const TimestampListConverter();

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
    // Store as ISO strings for portability
    return dates.map((d) => d.toIso8601String()).toList();
  }
}

/// Custom converter for single Timestamp/DateTime
class TimestampConverter implements JsonConverter<DateTime, dynamic> {
  const TimestampConverter();

  @override
  DateTime fromJson(dynamic json) {
    if (json is Timestamp) {
      return json.toDate();
    } else if (json is String) {
      return DateTime.parse(json);
    } else if (json is int) {
      return DateTime.fromMillisecondsSinceEpoch(json);
    }
    return DateTime.now();
  }

  @override
  dynamic toJson(DateTime date) {
    return date.toIso8601String();
  }
}

@freezed
class Commit with _$Commit {
  const Commit._(); // Private constructor for custom methods

  const factory Commit({
    /// Unique identifier for the commit
    String? id,

    /// Title of the commitment (e.g., "Daily Walk")
    required String title,

    /// Optional description (e.g., "20 minutes outdoors")
    @Default('') String description,

    /// Scheduled time of day for this commitment (e.g., 7:00 AM)
    /// Stored as "HH:mm" string format
    String? scheduledTime,

    /// Current consecutive streak
    @Default(0) int streak,

    /// Longest streak ever achieved
    @Default(0) int longestStreak,

    /// Last time this commit was completed
    @TimestampConverter() required DateTime lastCompleted,

    /// List of all dates when this commit was completed
    /// Used for calendar tracking
    @TimestampListConverter() @Default([]) List<DateTime> completedDates,

    /// When the commit was created
    @TimestampConverter() DateTime? createdAt,
  }) = _Commit;

  factory Commit.fromJson(Map<String, dynamic> json) => _$CommitFromJson(json);

  // ═══════════════════════════════════════════════════════════════
  // HELPER METHODS
  // ═══════════════════════════════════════════════════════════════

  /// Check if the commit was completed today
  bool get isCompletedToday {
    final now = DateTime.now();
    return lastCompleted.year == now.year &&
        lastCompleted.month == now.month &&
        lastCompleted.day == now.day;
  }

  /// Check if a specific date was completed
  bool wasCompletedOn(DateTime date) {
    return completedDates.any(
      (d) => d.year == date.year && d.month == date.month && d.day == date.day,
    );
  }

  /// Get completion status for a month (for calendar display)
  /// Returns a map of day number to completion status
  Map<int, bool> getMonthCompletionStatus(int year, int month) {
    final Map<int, bool> status = {};
    final daysInMonth = DateTime(year, month + 1, 0).day;

    for (int day = 1; day <= daysInMonth; day++) {
      final date = DateTime(year, month, day);
      status[day] = wasCompletedOn(date);
    }

    return status;
  }
}
