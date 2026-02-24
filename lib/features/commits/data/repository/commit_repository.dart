import 'package:pocket_commit/features/commits/data/models/commit_model.dart';
import 'package:pocket_commit/features/commits/data/models/user_streak_model.dart';

abstract class CommitRepository {
  /// Get all commits for the current user
  Future<List<Commit>> getAllCommits();

  /// Get a specific commit by ID
  Future<Commit?> getCommit(String commitId);

  /// Save a new commit
  Future<void> createCommit(Commit commit);

  /// Update an existing commit
  Future<void> updateCommit(Commit commit);

  /// Delete a commit
  Future<void> deleteCommit(String commitId);

  /// Mark a commit as done for today
  Future<Commit> markDone(String commitId);

  /// Mark a commit as skipped (breaks streak)
  Future<void> markSkipped(String commitId);

  // ═══════════════════════════════════════════════════════════════
  // GLOBAL STREAK METHODS
  // ═══════════════════════════════════════════════════════════════

  /// Get the user's global streak data
  Future<UserStreak> getUserStreak();

  /// Save/update the user's global streak data
  Future<void> saveUserStreak(UserStreak streak);
}
