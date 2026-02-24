import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pocket_commit/features/commits/data/models/commit_model.dart';
import 'package:pocket_commit/features/commits/data/models/user_streak_model.dart';
import 'package:pocket_commit/features/commits/data/repository/commit_repository.dart';
import 'package:pocket_commit/features/commits/viewmodel/commit_state.dart';

class CommitViewModel extends StateNotifier<CommitState> {
  final CommitRepository _repository;

  CommitViewModel(this._repository) : super(CommitState.initial());

  // ═══════════════════════════════════════════════════════════════
  // LOAD DATA
  // ═══════════════════════════════════════════════════════════════

  /// Load all commits and streak data for the user
  Future<void> loadAllCommits() async {
    try {
      state = state.copyWith(isLoading: true, error: null);

      final commits = await _repository.getAllCommits();
      final streak = await _repository.getUserStreak();

      // Check if streak is still alive
      final effectiveStreak = streak.isStreakAlive ? streak.currentStreak : 0;

      state = state.copyWith(
        commits: commits,
        currentIndex: 0,
        isLoading: false,
        globalStreak: effectiveStreak,
        longestStreak: streak.longestStreak,
        lastActiveDate: streak.lastActiveDate,
        streakDates: streak.activeDates,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  /// Alias for loadAllCommits (for backward compatibility)
  Future<void> loadDailyCommit() => loadAllCommits();

  // ═══════════════════════════════════════════════════════════════
  // NAVIGATION
  // ═══════════════════════════════════════════════════════════════

  /// Change current commit index (for swipe navigation)
  void setCurrentIndex(int index) {
    if (index >= 0 && index < state.commits.length) {
      state = state.copyWith(currentIndex: index);
    }
  }

  /// Go to next commit
  void nextCommit() {
    if (state.currentIndex < state.commits.length - 1) {
      state = state.copyWith(currentIndex: state.currentIndex + 1);
    }
  }

  /// Go to previous commit
  void previousCommit() {
    if (state.currentIndex > 0) {
      state = state.copyWith(currentIndex: state.currentIndex - 1);
    }
  }

  // ═══════════════════════════════════════════════════════════════
  // MARK DONE (with Global Streak)
  // ═══════════════════════════════════════════════════════════════

  /// Mark a specific commit as done AND update global streak
  Future<void> markAsDone(String commitId) async {
    final currentIdx = state.commits.indexWhere((c) => c.id == commitId);
    if (currentIdx == -1) return;

    final current = state.commits[currentIdx];
    if (current.id == null) return;

    try {
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);

      // === OPTIMISTIC UPDATE: Commit ===
      final optimisticCommit = current.copyWith(
        lastCompleted: now,
        completedDates: [...current.completedDates, today],
      );

      // === OPTIMISTIC UPDATE: Global Streak ===
      int newStreak = state.globalStreak;
      List<DateTime> newStreakDates = List.from(state.streakDates);

      // Only update streak if not already active today
      if (!state.isActiveToday) {
        if (state.lastActiveDate == null) {
          // First activity ever
          newStreak = 1;
        } else {
          final lastActive = DateTime(
            state.lastActiveDate!.year,
            state.lastActiveDate!.month,
            state.lastActiveDate!.day,
          );
          final difference = today.difference(lastActive).inDays;

          if (difference == 1) {
            // Yesterday was active, continue streak
            newStreak = state.globalStreak + 1;
          } else if (difference > 1) {
            // Streak broken, start fresh
            newStreak = 1;
          }
          // difference == 0 means same day, keep streak
        }
        newStreakDates.add(today);
      }

      final newLongestStreak = newStreak > state.longestStreak
          ? newStreak
          : state.longestStreak;

      // Update local state optimistically
      final updatedCommits = List<Commit>.from(state.commits);
      updatedCommits[currentIdx] = optimisticCommit;

      state = state.copyWith(
        commits: updatedCommits,
        globalStreak: newStreak,
        longestStreak: newLongestStreak,
        lastActiveDate: now,
        streakDates: newStreakDates,
      );

      // === PERSIST TO FIREBASE ===
      // Save the commit
      await _repository.markDone(current.id!);

      // Save the global streak
      final updatedStreak = UserStreak(
        currentStreak: newStreak,
        longestStreak: newLongestStreak,
        lastActiveDate: now,
        activeDates: newStreakDates,
      );
      await _repository.saveUserStreak(updatedStreak);
    } catch (e) {
      // Revert on error
      state = state.copyWith(error: "Failed to save: $e");
      await loadAllCommits(); // Refresh from server
    }
  }

  // ═══════════════════════════════════════════════════════════════
  // CREATE NEW COMMIT
  // ═══════════════════════════════════════════════════════════════

  /// Create a new commitment
  Future<void> createCommit(
    String title, {
    String description = '',
    String? scheduledTime,
  }) async {
    try {
      state = state.copyWith(isLoading: true);

      final newCommit = Commit(
        title: title,
        description: description,
        scheduledTime: scheduledTime,
        streak: 0,
        longestStreak: 0,
        lastCompleted: DateTime.fromMillisecondsSinceEpoch(0),
        completedDates: [],
        createdAt: DateTime.now(),
      );

      await _repository.createCommit(newCommit);

      // Reload all commits to get the new one with its ID
      await loadAllCommits();

      // Navigate to the new commit (first one - newest at top)
      if (state.commits.isNotEmpty) {
        state = state.copyWith(currentIndex: 0);
      }
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  // ═══════════════════════════════════════════════════════════════
  // DELETE COMMIT
  // ═══════════════════════════════════════════════════════════════

  /// Delete a commit
  Future<void> deleteCommit(String commitId) async {
    try {
      await _repository.deleteCommit(commitId);

      // Remove from local state
      final updatedCommits = state.commits
          .where((c) => c.id != commitId)
          .toList();

      // Adjust index if needed
      int newIndex = state.currentIndex;
      if (newIndex >= updatedCommits.length && updatedCommits.isNotEmpty) {
        newIndex = updatedCommits.length - 1;
      }

      state = state.copyWith(commits: updatedCommits, currentIndex: newIndex);
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }
}
