import 'package:flutter/material.dart';
import 'package:pocket_commit/app/app_theme.dart';
import 'package:pocket_commit/core/services/auth.service.dart';
import 'package:pocket_commit/features/commits/view/home_navigation.dart';

/// Splash screen shown when app launches
/// Signs in anonymously with Firebase and navigates to home
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    // Initialize animation controller
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    // Fade animation: logo fades in
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeIn),
      ),
    );

    // Scale animation: logo scales up with bouncy effect
    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.8, curve: Curves.elasticOut),
      ),
    );

    // Start animation
    _animationController.forward();

    // Sign in anonymously and navigate
    _initializeApp();
  }

  /// Sign in anonymously with Firebase and navigate to home
  Future<void> _initializeApp() async {
    try {
      // Sign in anonymously - creates a unique user ID
      final authService = AuthService();
      await authService.ensureSignedIn();

      // Wait for animation to complete
      await Future.delayed(const Duration(seconds: 2));

      // Check if widget is still mounted
      if (!mounted) return;

      // Navigate to HomeNavigation
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const HomeNavigation()),
      );
    } catch (e) {
      debugPrint('Error during initialization: $e');

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to initialize: $e'),
          backgroundColor: AppTheme.error,
        ),
      );
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: AppTheme.background,
        child: Center(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: ScaleTransition(
              scale: _scaleAnimation,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // App Icon
                  // Container(
                  //   padding: const EdgeInsets.all(28),
                  //   decoration: BoxDecoration(
                  //     color: AppTheme.primaryGreen.withOpacity(0.15),
                  //     borderRadius: BorderRadius.circular(32),
                  //   ),
                  //   child: const Icon(
                  //     Icons.check_circle_rounded,
                  //     size: 72,
                  //     color: AppTheme.primaryGreen,
                  //   ),
                  // ),
                  Image.asset(
                    'assets/images/pocket_logo.png',
                    // width: 120,
                    // height: 120,
                  ),
                  // const SizedBox(height: 32),

                  // Tagline
                  const Text(
                    'Track your daily commitments',
                    style: TextStyle(fontSize: 14, color: AppTheme.textMedium),
                  ),
                  const SizedBox(height: 48),

                  // Loading indicator
                  const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        AppTheme.primaryGreen,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
