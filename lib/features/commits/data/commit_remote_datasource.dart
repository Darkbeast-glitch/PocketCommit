import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pocket_commit/core/services/auth.service.dart';
import 'package:pocket_commit/features/commits/data/models/commit_model.dart';
import 'package:pocket_commit/features/commits/data/models/user_streak_model.dart';

class CommitRemoteDataSource {
  final FirebaseFirestore _firestore;
  final AuthService _auth;

  CommitRemoteDataSource(this._firestore, this._auth);

  /// Reference to user's commits collection
  CollectionReference get _commitsCollection =>
      _firestore.collection('users').doc(_auth.uid).collection('commits');

  /// Reference to user's profile document (for streak data)
  DocumentReference get _userProfileDoc =>
      _firestore.collection('users').doc(_auth.uid);

  /// Get all commits for the current user
  Future<List<Commit>> getAllCommits() async {
    final snapshot = await _commitsCollection
        .orderBy('createdAt', descending: true)
        .get();

    return snapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      data['id'] = doc.id; // Add document ID to data
      return Commit.fromJson(data);
    }).toList();
  }

  /// Get a single commit by ID
  Future<Commit?> getCommit(String commitId) async {
    final doc = await _commitsCollection.doc(commitId).get();

    if (doc.exists && doc.data() != null) {
      final data = doc.data() as Map<String, dynamic>;
      data['id'] = doc.id;
      return Commit.fromJson(data);
    }
    return null;
  }

  /// Create a new commit
  Future<String> createCommit(Commit commit) async {
    final docRef = await _commitsCollection.add(commit.toJson());
    return docRef.id;
  }

  /// Update an existing commit
  Future<void> updateCommit(Commit commit) async {
    if (commit.id == null) {
      throw Exception('Cannot update commit without ID');
    }
    await _commitsCollection.doc(commit.id).update(commit.toJson());
  }

  /// Delete a commit
  Future<void> deleteCommit(String commitId) async {
    await _commitsCollection.doc(commitId).delete();
  }

  /// Mark a commit as done - adds today to completedDates
  /// Note: Per-commit streak is kept for backward compatibility
  /// but the global streak (in user profile) is what matters now
  Future<Commit> markDone(String commitId) async {
    final commit = await getCommit(commitId);

    if (commit == null) {
      throw Exception('Commit not found');
    }

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    // Check if already completed today
    if (commit.isCompletedToday) {
      return commit; // Already done today
    }

    // Add today to completed dates
    final newCompletedDates = [...commit.completedDates, today];

    // Calculate per-commit streak (kept for backward compatibility)
    int newStreak = commit.streak + 1;

    // Check if we need to reset streak (if yesterday wasn't completed)
    final yesterday = today.subtract(const Duration(days: 1));
    final wasYesterdayCompleted = commit.wasCompletedOn(yesterday);

    // If streak was 0 or yesterday wasn't completed, start fresh
    if (commit.streak == 0 || !wasYesterdayCompleted) {
      if (commit.completedDates.isEmpty || !wasYesterdayCompleted) {
        newStreak = 1;
      }
    }

    // Update longest streak if needed
    final newLongestStreak = newStreak > commit.longestStreak
        ? newStreak
        : commit.longestStreak;

    final updatedCommit = commit.copyWith(
      streak: newStreak,
      longestStreak: newLongestStreak,
      lastCompleted: now,
      completedDates: newCompletedDates,
    );

    await updateCommit(updatedCommit);
    return updatedCommit;
  }

  /// Mark as skipped - resets streak
  Future<void> markSkipped(String commitId) async {
    final commit = await getCommit(commitId);

    if (commit != null) {
      final updatedCommit = commit.copyWith(streak: 0);
      await updateCommit(updatedCommit);
    }
  }

  // ═══════════════════════════════════════════════════════════════
  // GLOBAL STREAK METHODS
  // ═══════════════════════════════════════════════════════════════

  /// Get user's global streak from Firestore
  Future<UserStreak?> getUserStreak() async {
    final doc = await _userProfileDoc.get();

    if (doc.exists && doc.data() != null) {
      final data = doc.data() as Map<String, dynamic>;
      // Streak data is stored in the 'streak' field
      if (data.containsKey('streak')) {
        final streakData = Map<String, dynamic>.from(data['streak']);
        return UserStreak.fromJson(streakData);
      }
    }
    return null;
  }

  /// Save user's global streak to Firestore
  Future<void> saveUserStreak(UserStreak streak) async {
    await _userProfileDoc.set({
      'streak': streak.toJson(),
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }
}
