import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pocket_commit/features/commits/view/home_navigation.dart';
import 'package:pocket_commit/features/commits/view/onboarding_screen.dart';
import 'package:pocket_commit/features/commits/viewmodel/commit_provider.dart';

class AuthGate extends ConsumerWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);

    return authState.when(
      data: (user) {
        if (user == null) {
          // User not logged in → Show Onboarding
          return const OnboardingScreen();
        } else {
          // User logged in → Show Main App
          return const HomeNavigation();
        }
      },
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (err, stack) => Scaffold(
        body: Center(
          child: Text('Error: $err'),
        ),
      ),
    );
  }
}
