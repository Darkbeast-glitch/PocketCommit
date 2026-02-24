import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pocket_commit/app/app_theme.dart';
import 'package:pocket_commit/features/commits/data/models/user_profile_model.dart';
import 'package:pocket_commit/features/commits/viewmodel/commit_provider.dart';
import 'package:pocket_commit/features/commits/viewmodel/commit_state.dart';
import 'package:pocket_commit/features/commits/data/models/commit_model.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  final _nameController = TextEditingController();
  bool _isEditingName = false;
  bool _isSaving = false;

  // List of avatar emojis to choose from
  final List<String> _avatarEmojis = [
    '😊',
    '🚀',
    '💪',
    '🎯',
    '⭐',
    '🔥',
    '💎',
    '🌟',
    '🦊',
    '🐱',
    '🐶',
    '🦁',
    '🐼',
    '🦄',
    '🐸',
    '🦋',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authStateProvider);
    final userProfileState = ref.watch(userProfileProvider);
    final commitState = ref.watch(commitViewModelProvider);

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        backgroundColor: AppTheme.background,
        elevation: 0,
        title: Text(
          'Profile',
          style: TextStyle(
            color: AppTheme.textDark,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: authState.when(
        data: (user) {
          if (user == null) {
            return const Center(child: Text('Not logged in'));
          }
          return userProfileState.when(
            data: (profile) =>
                _buildProfile(context, user, profile, commitState),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, stack) =>
                _buildProfile(context, user, null, commitState),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
    );
  }

  Widget _buildProfile(
    BuildContext context,
    User user,
    UserProfile? profile,
    CommitState commitState,
  ) {
    // Use profile from Firestore, fallback to Auth
    final displayName =
        profile?.displayName ?? user.displayName ?? 'Pocket User';
    final avatar = profile?.avatar ?? user.photoURL ?? '😊';

    // Calculate stats
    final totalCommits = commitState.commits.length;
    final completedToday = commitState.commits
        .where((Commit c) => c.isCompletedToday)
        .length;
    // Use global streak from state (Duolingo-style)
    final globalStreak = commitState.globalStreak;
    final longestStreak = commitState.longestStreak;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        children: [
          // Profile Avatar (tappable to change)
          GestureDetector(
            onTap: () => _showAvatarPicker(user, avatar),
            child: Stack(
              children: [
                CircleAvatar(
                  radius: 60,
                  backgroundColor: AppTheme.primaryGreen.withValues(alpha: 0.1),
                  child: Text(avatar, style: const TextStyle(fontSize: 48)),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryGreen,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 3),
                    ),
                    child: const Icon(
                      Icons.edit,
                      size: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Name (editable)
          _isEditingName
              ? _buildNameEditor(user, displayName)
              : _buildNameDisplay(displayName),

          const SizedBox(height: 8),

          // User ID (for anonymous users)
          Text(
            'ID: ${user.uid.substring(0, 8)}...',
            style: TextStyle(fontSize: 12, color: AppTheme.textLight),
          ),

          const SizedBox(height: 32),

          // Stats Cards Row (Day Streak, Commits, Done Today)
          Row(
            children: [
              Expanded(
                child: _buildStreakCard(
                  globalStreak: globalStreak,
                  longestStreak: longestStreak,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatCard(
                  icon: '📝',
                  value: totalCommits.toString(),
                  label: 'Commits',
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatCard(
                  icon: '✅',
                  value: completedToday.toString(),
                  label: 'Done Today',
                ),
              ),
            ],
          ),

          const SizedBox(height: 32),

          // Menu Items
          _buildMenuItem(
            icon: Icons.person_outline,
            title: 'Edit Profile',
            subtitle: 'Change name and avatar',
            onTap: () {
              setState(() {
                _isEditingName = true;
                _nameController.text = displayName;
              });
            },
          ),
          const SizedBox(height: 12),

          _buildMenuItem(
            icon: Icons.notifications_outlined,
            title: 'Notifications',
            subtitle: 'Manage reminders',
            onTap: () => _showComingSoon('Notifications'),
          ),
          const SizedBox(height: 12),

          _buildMenuItem(
            icon: Icons.help_outline,
            title: 'Help & Support',
            subtitle: 'FAQs and contact',
            onTap: () => _showComingSoon('Help'),
          ),
          const SizedBox(height: 12),

          _buildMenuItem(
            icon: Icons.info_outline,
            title: 'About',
            subtitle: 'Version 1.0.0',
            onTap: () => _showAboutDialog(),
          ),

          const SizedBox(height: 32),

          // Sign Out Button
          SizedBox(
            width: double.infinity,
            height: 56,
            child: OutlinedButton.icon(
              onPressed: () => _confirmSignOut(),
              icon: const Icon(Icons.logout_rounded),
              label: const Text('Sign Out'),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.red,
                side: const BorderSide(color: Colors.red),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Anonymous user info
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.primaryGreen.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.info_outline,
                  color: AppTheme.primaryGreen,
                  size: 20,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Your data is saved securely with your unique ID. Signing out will create a new account.',
                    style: TextStyle(fontSize: 12, color: AppTheme.textMedium),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNameDisplay(String displayName) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _isEditingName = true;
          _nameController.text = displayName;
        });
      },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            displayName.isEmpty ? 'Pocket User' : displayName,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppTheme.textDark,
            ),
          ),
          const SizedBox(width: 8),
          Icon(Icons.edit_outlined, size: 18, color: AppTheme.textLight),
        ],
      ),
    );
  }

  Widget _buildNameEditor(User user, String currentAvatar) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 200,
          child: TextField(
            controller: _nameController,
            autofocus: true,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppTheme.textDark,
            ),
            decoration: InputDecoration(
              hintText: 'Enter your name',
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: AppTheme.primaryGreen, width: 2),
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        _isSaving
            ? const SizedBox(
                width: 40,
                height: 40,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : IconButton(
                onPressed: () => _saveName(user, currentAvatar),
                icon: Icon(
                  Icons.check_circle,
                  color: AppTheme.primaryGreen,
                  size: 32,
                ),
              ),
        IconButton(
          onPressed: () {
            setState(() {
              _isEditingName = false;
            });
          },
          icon: Icon(Icons.cancel, color: AppTheme.textLight, size: 32),
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required String icon,
    required String value,
    required String label,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(icon, style: const TextStyle(fontSize: 24)),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppTheme.textDark,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(fontSize: 12, color: AppTheme.textMedium),
          ),
        ],
      ),
    );
  }

  Widget _buildStreakCard({
    required int globalStreak,
    required int longestStreak,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppTheme.primaryGreen,
            AppTheme.primaryGreen.withValues(alpha: 0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryGreen.withValues(alpha: 0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          const Text('🔥', style: TextStyle(fontSize: 24)),
          const SizedBox(height: 4),
          Text(
            '$globalStreak',
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 2),
          const Text(
            'Day Streak',
            style: TextStyle(fontSize: 12, color: Colors.white70),
          ),
          Text(
            'Best: $longestStreak',
            style: const TextStyle(fontSize: 10, color: Colors.white54),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppTheme.background,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: AppTheme.textDark, size: 22),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textDark,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(fontSize: 12, color: AppTheme.textMedium),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: AppTheme.textMedium),
          ],
        ),
      ),
    );
  }

  String _getAvatarText(String avatar) {
    // Return the avatar emoji
    return avatar.isNotEmpty ? avatar : '😊';
  }

  void _showAvatarPicker(User user, String currentAvatar) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppTheme.cardBorder,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Choose Your Avatar',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppTheme.textDark,
              ),
            ),
            const SizedBox(height: 24),
            Wrap(
              spacing: 16,
              runSpacing: 16,
              children: _avatarEmojis.map((emoji) {
                return GestureDetector(
                  onTap: () async {
                    Navigator.pop(context);
                    // Get current display name to preserve it
                    final profile = await ref.read(userProfileProvider.future);
                    final currentName =
                        profile?.displayName ?? user.displayName ?? '';
                    await _updateProfile(user, currentName, emoji);
                  },
                  child: Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: AppTheme.background,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: _getAvatarText(currentAvatar) == emoji
                            ? AppTheme.primaryGreen
                            : Colors.transparent,
                        width: 3,
                      ),
                    ),
                    child: Center(
                      child: Text(emoji, style: const TextStyle(fontSize: 32)),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Future<void> _updateProfile(
    User user,
    String displayName,
    String avatar,
  ) async {
    try {
      final updateProfile = ref.read(updateUserProfileProvider);
      await updateProfile(displayName, avatar);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Profile updated!'),
            backgroundColor: AppTheme.primaryGreen,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to update profile: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _saveName(User user, String currentAvatar) async {
    if (_nameController.text.trim().isEmpty) return;

    setState(() {
      _isSaving = true;
    });

    try {
      await _updateProfile(user, _nameController.text.trim(), currentAvatar);

      setState(() {
        _isEditingName = false;
        _isSaving = false;
      });
    } catch (e) {
      setState(() {
        _isSaving = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to update name: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _showComingSoon(String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$feature coming soon!'),
        backgroundColor: AppTheme.primaryGreen,
      ),
    );
  }

  void _showAboutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Text('📝', style: const TextStyle(fontSize: 28)),
            const SizedBox(width: 12),
            const Text('Pocket Commit'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Version 1.0.0', style: TextStyle(color: AppTheme.textMedium)),
            const SizedBox(height: 16),
            const Text(
              'Track your daily commitments and build lasting habits with Pocket Commit.',
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Close',
              style: TextStyle(color: AppTheme.primaryGreen),
            ),
          ),
        ],
      ),
    );
  }

  void _confirmSignOut() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Sign Out?'),
        content: const Text(
          'Signing out will create a new anonymous account. Your current data will no longer be accessible.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel', style: TextStyle(color: AppTheme.textMedium)),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await FirebaseAuth.instance.signOut();
            },
            child: const Text('Sign Out', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
