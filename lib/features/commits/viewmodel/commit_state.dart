import 'package:pocket_commit/features/commits/data/models/commit_model.dart';

class CommitState {
  /// List of all user's commitments
  final List<Commit> commits;

  /// Index of currently selected commit (for swipe navigation)
  final int currentIndex;

  /// Is the app currently fetching data?
  final bool isLoading;

  /// Is there an error message to show?
  final String? error;

  // ═══════════════════════════════════════════════════════════════
  // GLOBAL STREAK (Duolingo-style)
  // ═══════════════════════════════════════════════════════════════

  /// Current consecutive streak (days in a row using the app)
  final int globalStreak;

  /// Longest streak ever achieved
  final int longestStreak;

  /// Last date the user completed any commit (for streak calculation)
  final DateTime? lastActiveDate;

  /// All dates the user was active (for calendar heat map)
  final List<DateTime> streakDates;

  CommitState({
    this.commits = const [],
    this.currentIndex = 0,
    this.isLoading = false,
    this.error,
    this.globalStreak = 0,
    this.longestStreak = 0,
    this.lastActiveDate,
    this.streakDates = const [],
  });

  /// Get the currently selected commit
  Commit? get currentCommit {
    if (commits.isEmpty || currentIndex >= commits.length) return null;
    return commits[currentIndex];
  }

  /// Check if there are any commits
  bool get hasCommits => commits.isNotEmpty;

  /// Get total number of commits
  int get commitCount => commits.length;

  /// Check if user has already been active today
  bool get isActiveToday {
    if (lastActiveDate == null) return false;
    final now = DateTime.now();
    return lastActiveDate!.year == now.year &&
        lastActiveDate!.month == now.month &&
        lastActiveDate!.day == now.day;
  }

  /// Check if streak is still alive (was active yesterday or today)
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
    return difference <= 1; // Active today or yesterday
  }

  /// Check if a specific date was active
  bool wasActiveOn(DateTime date) {
    return streakDates.any(
      (d) => d.year == date.year && d.month == date.month && d.day == date.day,
    );
  }

  /// INITIAL STATE: When the app first opens
  factory CommitState.initial() => CommitState(isLoading: true);

  /// HELPER: copyWith allows us to change one part of the state
  /// without manually rewriting the whole object.
  CommitState copyWith({
    List<Commit>? commits,
    int? currentIndex,
    bool? isLoading,
    String? error,
    int? globalStreak,
    int? longestStreak,
    DateTime? lastActiveDate,
    List<DateTime>? streakDates,
  }) {
    return CommitState(
      commits: commits ?? this.commits,
      currentIndex: currentIndex ?? this.currentIndex,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      globalStreak: globalStreak ?? this.globalStreak,
      longestStreak: longestStreak ?? this.longestStreak,
      lastActiveDate: lastActiveDate ?? this.lastActiveDate,
      streakDates: streakDates ?? this.streakDates,
    );
  }
}
