import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:pocket_commit/app/app_theme.dart";
import "package:pocket_commit/splash_screen.dart";

class PocketCommitApp extends ConsumerWidget {
  const PocketCommitApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: "Pocket Commit",
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      home: const SplashScreen(),
    );
  }
}
