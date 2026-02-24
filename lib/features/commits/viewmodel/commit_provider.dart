import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pocket_commit/core/services/auth.service.dart';
import 'package:pocket_commit/features/commits/data/commit_local_datasource.dart';
import 'package:pocket_commit/features/commits/data/commit_remote_datasource.dart';
import 'package:pocket_commit/features/commits/data/commit_repository_impl.dart';
import 'package:pocket_commit/features/commits/data/repository/commit_repository.dart';
import 'package:pocket_commit/features/commits/data/models/user_profile_model.dart';
import 'package:pocket_commit/features/commits/viewmodel/commit_state.dart';
import 'package:pocket_commit/features/commits/viewmodel/commit_viewmodel.dart';

// ═══════════════════════════════════════════════════════════════
// 1. CORE SERVICES
// ═══════════════════════════════════════════════════════════════

final firebaseFirestoreProvider = Provider<FirebaseFirestore>((ref) {
  return FirebaseFirestore.instance;
});

final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService();
});

// ═══════════════════════════════════════════════════════════════
// 2. DATA LAYER
// ═══════════════════════════════════════════════════════════════

/// Remote data source - Firebase Firestore
final commitRemoteDataSourceProvider = Provider<CommitRemoteDataSource>((ref) {
  return CommitRemoteDataSource(
    ref.read(firebaseFirestoreProvider),
    ref.read(authServiceProvider),
  );
});

/// Local data source - Hive
final commitLocalDataSourceProvider = Provider<CommitLocalDataSource>((ref) {
  return CommitLocalDataSource();
});

/// Repository - combines local and remote
final commitRepositoryProvider = Provider<CommitRepository>((ref) {
  return CommitRepositoryImpl(
    remoteDataSource: ref.read(commitRemoteDataSourceProvider),
    localDataSource: ref.read(commitLocalDataSourceProvider),
  );
});

// ═══════════════════════════════════════════════════════════════
// 3. VIEWMODEL
// ═══════════════════════════════════════════════════════════════

final commitViewModelProvider =
    StateNotifierProvider<CommitViewModel, CommitState>((ref) {
      return CommitViewModel(ref.read(commitRepositoryProvider));
    });

// ═══════════════════════════════════════════════════════════════
// 4. AUTH STREAM
// ═══════════════════════════════════════════════════════════════

/// Listens to Firebase Auth state changes
final authStateProvider = StreamProvider<User?>((ref) {
  return FirebaseAuth.instance.authStateChanges();
});

// ═══════════════════════════════════════════════════════════════
// 5. USER PROFILE (Real-time from Firestore)
// ═══════════════════════════════════════════════════════════════

/// Real-time user profile from Firestore
final userProfileProvider = StreamProvider.autoDispose<UserProfile?>((ref) {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) return Stream.value(null);

  return FirebaseFirestore.instance
      .collection('users')
      .doc(user.uid)
      .snapshots()
      .map((snapshot) {
    if (!snapshot.exists) {
      // Return default profile if not exists
      return UserProfile(
        uid: user.uid,
        displayName: user.displayName ?? '',
        avatar: user.photoURL ?? '😊',
      );
    }
    final data = snapshot.data() as Map<String, dynamic>;
    data['uid'] = user.uid;
    return UserProfile.fromJson(data);
  });
});

/// Update user profile in Firestore
final updateUserProfileProvider = Provider<Future<void> Function(String displayName, String avatar)>((ref) {
  return (String displayName, String avatar) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) throw Exception('No user logged in');

    final profile = UserProfile(
      uid: user.uid,
      displayName: displayName,
      avatar: avatar,
      lastUpdated: DateTime.now(),
    );

    // Update Firestore (source of truth)
    await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .set(profile.toJson(), SetOptions(merge: true));

    // Also update Firebase Auth for compatibility
    await user.updateDisplayName(displayName);
    await user.updatePhotoURL(avatar);
    await user.reload();
  };
});
