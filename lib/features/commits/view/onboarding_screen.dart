import 'package:flutter/material.dart';
import 'package:pocket_commit/app/app_theme.dart';
import 'package:pocket_commit/core/services/auth.service.dart';
import 'package:pocket_commit/features/commits/view/home_navigation.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  final AuthService _authService = AuthService();

  int _currentPage = 0;
  bool _isLoading = false;

  final List<Map<String, dynamic>> _pages = [
    {
      "title": "Small Daily Commitments",
      "subtitle":
          "Focus on just one thing each day.\nSimple, achievable, done.",
      "image": "assets/images/onboard1.png",
    },
    {
      "title": "Build Calm Discipline",
      "subtitle": "Create a streak without the pressure.\nConsistency is key.",
      "image": "assets/images/onboard2.png",
    },
    {
      "title": "Your Pocket Awaits",
      "subtitle": "Ready to define your first habit?\nLet's get started.",
      "image": "assets/images/onboard3.png",
    },
  ];

  void _onGetStarted() async {
    setState(() => _isLoading = true);
    // Save messenger before async gap
    final messenger = ScaffoldMessenger.of(context);

    try {
      // 1. Silent Login
      await _authService.ensureSignedIn();

      // 2. Navigate to Home
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const HomeNavigation()),
        );
      }
    } catch (e) {
      messenger.showSnackBar(SnackBar(content: Text("Login failed: $e")));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: Column(
          children: [
            // 1. SKIP BUTTON (Top Right)
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextButton(
                  onPressed: _currentPage == 2
                      ? null
                      : () => _controller.jumpToPage(2),
                  child: Text(
                    _currentPage == 2 ? "" : "Skip",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              ),
            ),

            // 2. SWIPEABLE CONTENT
            Expanded(
              child: PageView.builder(
                controller: _controller,
                itemCount: _pages.length,
                onPageChanged: (index) => setState(() => _currentPage = index),
                itemBuilder: (context, index) {
                  return _OnboardingPage(
                    title: _pages[index]['title'],
                    subtitle: _pages[index]['subtitle'],
                    image: _pages[index]['image'],
                  );
                },
              ),
            ),

            // 3. INDICATORS & BUTTONS
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  // Page Indicators (The dots)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      _pages.length,
                      (index) => AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        height: 8,
                        width: _currentPage == index ? 24 : 8,
                        decoration: BoxDecoration(
                          color: _currentPage == index
                              ? AppTheme.primaryGreen
                              : AppTheme.cardBorder,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 32),

                  // "Next" or "Get Started" Button
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: _isLoading
                          ? null
                          : (_currentPage == 2
                                ? _onGetStarted
                                : () {
                                    _controller.nextPage(
                                      duration: const Duration(
                                        milliseconds: 300,
                                      ),
                                      curve: Curves.easeInOut,
                                    );
                                  }),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryGreen,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        elevation: 0,
                      ),
                      child: _isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : Text(
                              _currentPage == 2 ? "Get Started" : "Next",
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// HELPER WIDGET FOR INDIVIDUAL PAGES
class _OnboardingPage extends StatelessWidget {
  final String title;
  final String subtitle;
  final String image;

  const _OnboardingPage({
    required this.title,
    required this.subtitle,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Image with circle background
          Container(
            height: 250,
            width: 250,
            decoration: BoxDecoration(
              color: AppTheme.primaryGreen.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            padding: const EdgeInsets.all(40),
            child: Image.asset(image, fit: BoxFit.contain),
          ),
          const SizedBox(height: 48),

          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: AppTheme.textDark,
            ),
          ),

          const SizedBox(height: 16),

          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: AppTheme.textMedium,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
