import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../config/app_theme.dart';
import '../providers/auth_provider.dart';

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
    _setupAnimations();
    _navigateAfterDelay();
  }

  void _setupAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.0, 0.6, curve: Curves.easeIn),
    ));

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.2, 0.8, curve: Curves.elasticOut),
    ));

    _animationController.forward();
  }

  void _navigateAfterDelay() {
    Future.delayed(const Duration(milliseconds: 3000), () {
      if (mounted) {
        final authProvider = context.read<AuthProvider>();
        if (authProvider.isInitialized) {
          if (authProvider.isAuthenticated) {
            context.go('/home');
          } else {
            // Check if user has seen onboarding
            _checkOnboardingStatus();
          }
        }
      }
    });
  }

  Future<void> _checkOnboardingStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final onboardingCompleted = prefs.getBool('onboarding_completed') ?? false;

    if (mounted) {
      if (onboardingCompleted) {
        context.go('/auth');
      } else {
        context.go('/onboarding');
      }
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
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppTheme.primaryTeal,
              AppTheme.primaryDark,
            ],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo Animation
              AnimatedBuilder(
                animation: _animationController,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _scaleAnimation.value,
                    child: FadeTransition(
                      opacity: _fadeAnimation,
                      child: Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.people_alt_rounded,
                          size: 60,
                          color: AppTheme.primaryTeal,
                        ),
                      ),
                    ),
                  );
                },
              ),

              const SizedBox(height: 32),

              // App Name Animation
              AnimatedBuilder(
                animation: _fadeAnimation,
                builder: (context, child) {
                  return FadeTransition(
                    opacity: _fadeAnimation,
                    child: const Text(
                      'SKILLSHARE',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 2,
                      ),
                    ),
                  );
                },
              ),

              const SizedBox(height: 16),

              // Tagline Animation
              AnimatedBuilder(
                animation: _fadeAnimation,
                builder: (context, child) {
                  return FadeTransition(
                    opacity: _fadeAnimation,
                    child: const Text(
                      'Connect. Learn. Grow.',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white70,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  );
                },
              ),

              const SizedBox(height: 80),

              // Loading Indicator
              AnimatedBuilder(
                animation: _fadeAnimation,
                builder: (context, child) {
                  return FadeTransition(
                    opacity: _fadeAnimation,
                    child: const SizedBox(
                      width: 40,
                      height: 40,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        strokeWidth: 3,
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
