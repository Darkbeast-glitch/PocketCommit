import 'package:flutter/foundation.dart';
import 'package:pocket_commit/features/commits/data/commit_local_datasource.dart';
import 'package:pocket_commit/features/commits/data/commit_remote_datasource.dart';
import 'package:pocket_commit/features/commits/data/models/commit_model.dart';
import 'package:pocket_commit/features/commits/data/models/user_streak_model.dart';
import 'package:pocket_commit/features/commits/data/repository/commit_repository.dart';

/// Repository implementation with offline-first approach
///
/// Strategy:
/// - READ: Load from Hive first (instant), then sync with Firebase
/// - WRITE: Save to both Hive and Firebase
class CommitRepositoryImpl implements CommitRepository {
  final CommitRemoteDataSource _remoteDataSource;
  final CommitLocalDataSource _localDataSource;

  CommitRepositoryImpl({
    required CommitRemoteDataSource remoteDataSource,
    required CommitLocalDataSource localDataSource,
  }) : _remoteDataSource = remoteDataSource,
       _localDataSource = localDataSource;

  @override
  Future<List<Commit>> getAllCommits() async {
    try {
      // 1. First, try to get from Firebase (source of truth)
      final remoteCommits = await _remoteDataSource.getAllCommits();

      if (remoteCommits.isNotEmpty) {
        // 2. Cache to local storage
        await _localDataSource.saveAllCommits(remoteCommits);
        return remoteCommits;
      }

      // 3. If Firebase is empty, try local cache
      final localCommits = await _localDataSource.getAllCommits();
      return localCommits;
    } catch (e) {
      // 4. If Firebase fails, fallback to local cache
      debugPrint('Firebase error, loading from Hive: $e');
      return await _localDataSource.getAllCommits();
    }
  }

  @override
  Future<Commit?> getCommit(String commitId) async {
    try {
      // Try Firebase first
      final remoteCommit = await _remoteDataSource.getCommit(commitId);

      if (remoteCommit != null) {
        // Cache locally
        await _localDataSource.saveCommit(remoteCommit);
        return remoteCommit;
      }

      // Fallback to local
      return await _localDataSource.getCommit(commitId);
    } catch (e) {
      // Fallback to local on error
      debugPrint('Firebase error, loading from Hive: $e');
      return await _localDataSource.getCommit(commitId);
    }
  }

  @override
  Future<void> createCommit(Commit commit) async {
    try {
      // 1. Save to Firebase first to get the ID
      final docId = await _remoteDataSource.createCommit(commit);

      // 2. Create commit with the Firebase ID
      final commitWithId = commit.copyWith(id: docId);

      // 3. Save to local cache
      await _localDataSource.saveCommit(commitWithId);
    } catch (e) {
      // If Firebase fails, save locally with temp ID
      debugPrint('Firebase error, saving to Hive only: $e');
      final tempId = 'temp_${DateTime.now().millisecondsSinceEpoch}';
      final commitWithTempId = commit.copyWith(id: tempId);
      await _localDataSource.saveCommit(commitWithTempId);
      // TODO: Add to sync queue for later Firebase upload
    }
  }

  @override
  Future<void> updateCommit(Commit commit) async {
    // Update both local and remote
    try {
      await _localDataSource.saveCommit(commit);
      await _remoteDataSource.updateCommit(commit);
    } catch (e) {
      debugPrint('Firebase update error: $e');
      // Local is already updated, Firebase will sync later
    }
  }

  @override
  Future<void> deleteCommit(String commitId) async {
    try {
      // Delete from both
      await _localDataSource.deleteCommit(commitId);
      await _remoteDataSource.deleteCommit(commitId);
    } catch (e) {
      debugPrint('Firebase delete error: $e');
      // Local is already deleted
    }
  }

  @override
  Future<Commit> markDone(String commitId) async {
    try {
      // Mark done in Firebase
      final updatedCommit = await _remoteDataSource.markDone(commitId);

      // Update local cache
      await _localDataSource.saveCommit(updatedCommit);

      return updatedCommit;
    } catch (e) {
      debugPrint('Firebase markDone error, updating locally: $e');

      // Fallback: Update locally
      final localCommit = await _localDataSource.getCommit(commitId);
      if (localCommit == null) {
        throw Exception('Commit not found');
      }

      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);

      // Check if already completed today
      if (localCommit.isCompletedToday) {
        return localCommit;
      }

      // Note: Per-commit streak is kept for backward compatibility
      // but the global streak is what matters now
      final newStreak = localCommit.streak + 1;
      final updatedCommit = localCommit.copyWith(
        streak: newStreak,
        longestStreak: newStreak > localCommit.longestStreak
            ? newStreak
            : localCommit.longestStreak,
        lastCompleted: now,
        completedDates: [...localCommit.completedDates, today],
      );

      await _localDataSource.saveCommit(updatedCommit);
      return updatedCommit;
    }
  }

  @override
  Future<void> markSkipped(String commitId) async {
    try {
      await _remoteDataSource.markSkipped(commitId);

      // Update local cache
      final commit = await _localDataSource.getCommit(commitId);
      if (commit != null) {
        final updatedCommit = commit.copyWith(streak: 0);
        await _localDataSource.saveCommit(updatedCommit);
      }
    } catch (e) {
      debugPrint('Firebase markSkipped error: $e');
      // Update locally anyway
      final commit = await _localDataSource.getCommit(commitId);
      if (commit != null) {
        final updatedCommit = commit.copyWith(streak: 0);
        await _localDataSource.saveCommit(updatedCommit);
      }
    }
  }

  // ═══════════════════════════════════════════════════════════════
  // GLOBAL STREAK METHODS
  // ═══════════════════════════════════════════════════════════════

  @override
  Future<UserStreak> getUserStreak() async {
    try {
      // Try Firebase first
      final remoteStreak = await _remoteDataSource.getUserStreak();
      if (remoteStreak != null) {
        // Cache locally
        await _localDataSource.saveUserStreak(remoteStreak);
        return remoteStreak;
      }
      // If no remote streak, try local
      return await _localDataSource.getUserStreak();
    } catch (e) {
      debugPrint('Firebase getUserStreak error, loading from Hive: $e');
      return await _localDataSource.getUserStreak();
    }
  }

  @override
  Future<void> saveUserStreak(UserStreak streak) async {
    try {
      // Save to both
      await _localDataSource.saveUserStreak(streak);
      await _remoteDataSource.saveUserStreak(streak);
    } catch (e) {
      debugPrint('Firebase saveUserStreak error: $e');
      // Local is already saved
    }
  }

  /// Sync local commits with Firebase
  /// Call this when coming back online
  Future<void> syncWithFirebase() async {
    try {
      final localCommits = await _localDataSource.getAllCommits();
      final remoteCommits = await _remoteDataSource.getAllCommits();

      // Find commits that exist locally but not remotely (temp IDs)
      for (var localCommit in localCommits) {
        if (localCommit.id?.startsWith('temp_') ?? false) {
          // Upload to Firebase
          final newId = await _remoteDataSource.createCommit(localCommit);

          // Delete temp and save with real ID
          await _localDataSource.deleteCommit(localCommit.id!);
          final updatedCommit = localCommit.copyWith(id: newId);
          await _localDataSource.saveCommit(updatedCommit);
        }
      }

      // Update local cache with latest from Firebase
      if (remoteCommits.isNotEmpty) {
        await _localDataSource.saveAllCommits(remoteCommits);
      }
    } catch (e) {
      debugPrint('Sync error: $e');
    }
  }
}
