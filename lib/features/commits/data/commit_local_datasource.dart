import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:pocket_commit/features/commits/data/models/commit_model.dart';
import 'package:pocket_commit/features/commits/data/models/user_streak_model.dart';

/// Local data source using Hive for offline-first caching
class CommitLocalDataSource {
  static const String _boxName = 'commits';
  static const String _streakBoxName = 'user_streak';
  static const String _streakKey = 'global_streak';

  /// Get the Hive box for commits
  Future<Box<Map>> _getBox() async {
    if (!Hive.isBoxOpen(_boxName)) {
      return await Hive.openBox<Map>(_boxName);
    }
    return Hive.box<Map>(_boxName);
  }

  /// Get the Hive box for streak data
  Future<Box<Map>> _getStreakBox() async {
    if (!Hive.isBoxOpen(_streakBoxName)) {
      return await Hive.openBox<Map>(_streakBoxName);
    }
    return Hive.box<Map>(_streakBoxName);
  }

  /// Get all commits from local storage
  Future<List<Commit>> getAllCommits() async {
    try {
      final box = await _getBox();

      final commits = <Commit>[];
      for (var key in box.keys) {
        final data = box.get(key);
        if (data != null) {
          // Convert Map<dynamic, dynamic> to Map<String, dynamic>
          final jsonData = Map<String, dynamic>.from(data);
          jsonData['id'] = key.toString();
          commits.add(Commit.fromJson(jsonData));
        }
      }

      // Sort by createdAt
      commits.sort((a, b) {
        final aCreated = a.createdAt ?? DateTime.now();
        final bCreated = b.createdAt ?? DateTime.now();
        return aCreated.compareTo(bCreated);
      });

      return commits;
    } catch (e) {
      debugPrint('Error loading from Hive: $e');
      return [];
    }
  }

  /// Get a specific commit by ID
  Future<Commit?> getCommit(String commitId) async {
    try {
      final box = await _getBox();
      final data = box.get(commitId);

      if (data != null) {
        final jsonData = Map<String, dynamic>.from(data);
        jsonData['id'] = commitId;
        return Commit.fromJson(jsonData);
      }
      return null;
    } catch (e) {
      debugPrint('Error getting commit from Hive: $e');
      return null;
    }
  }

  /// Save a commit to local storage
  Future<void> saveCommit(Commit commit) async {
    try {
      final box = await _getBox();
      final id = commit.id ?? DateTime.now().millisecondsSinceEpoch.toString();

      final jsonData = commit.toJson();
      // Remove id from json since it's stored as the key
      jsonData.remove('id');

      await box.put(id, jsonData);
    } catch (e) {
      debugPrint('Error saving to Hive: $e');
    }
  }

  /// Save multiple commits at once
  Future<void> saveAllCommits(List<Commit> commits) async {
    try {
      final box = await _getBox();

      for (var commit in commits) {
        final id =
            commit.id ?? DateTime.now().millisecondsSinceEpoch.toString();
        final jsonData = commit.toJson();
        jsonData.remove('id');
        await box.put(id, jsonData);
      }
    } catch (e) {
      debugPrint('Error saving commits to Hive: $e');
    }
  }

  /// Delete a commit from local storage
  Future<void> deleteCommit(String commitId) async {
    try {
      final box = await _getBox();
      await box.delete(commitId);
    } catch (e) {
      debugPrint('Error deleting from Hive: $e');
    }
  }

  /// Clear all local commits (useful for logout)
  Future<void> clearAll() async {
    try {
      final box = await _getBox();
      await box.clear();
    } catch (e) {
      debugPrint('Error clearing Hive: $e');
    }
  }

  /// Check if there are any local commits
  Future<bool> hasLocalData() async {
    try {
      final box = await _getBox();
      return box.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  // ═══════════════════════════════════════════════════════════════
  // GLOBAL STREAK METHODS
  // ═══════════════════════════════════════════════════════════════

  /// Get user's global streak from local storage
  Future<UserStreak> getUserStreak() async {
    try {
      final box = await _getStreakBox();
      final data = box.get(_streakKey);

      if (data != null) {
        final jsonData = Map<String, dynamic>.from(data);
        return UserStreak.fromJson(jsonData);
      }
      // Return default streak if none exists
      return const UserStreak();
    } catch (e) {
      debugPrint('Error getting streak from Hive: $e');
      return const UserStreak();
    }
  }

  /// Save user's global streak to local storage
  Future<void> saveUserStreak(UserStreak streak) async {
    try {
      final box = await _getStreakBox();
      final jsonData = streak.toJson();
      await box.put(_streakKey, jsonData);
    } catch (e) {
      debugPrint('Error saving streak to Hive: $e');
    }
  }
}
