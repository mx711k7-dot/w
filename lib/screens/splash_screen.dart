import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../utils/theme.dart';
import 'home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.5, curve: Curves.easeIn),
      ),
    );

    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.5, curve: Curves.easeOutBack),
      ),
    );

    _controller.forward();

    Future.delayed(const Duration(milliseconds: 3000), () {
      Get.off(() => const HomeScreen(), transition: Transition.fadeIn);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppTheme.background,
              AppTheme.surfaceDark,
              AppTheme.background,
            ],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Animated Shield Logo
              AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _scaleAnimation.value,
                    child: Opacity(
                      opacity: _fadeAnimation.value,
                      child: Container(
                        width: 140,
                        height: 140,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: AppTheme.primaryGradient,
                          boxShadow: [
                            BoxShadow(
                              color: AppTheme.primaryGreen.withOpacity(0.4),
                              blurRadius: 40,
                              spreadRadius: 10,
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.shield_moon_rounded,
                          size: 70,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 40),
              // App Name
              Text(
                'Secure VPN',
                style: GoogleFonts.cairo(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textPrimary,
                  letterSpacing: 2,
                ),
              )
                  .animate()
                  .fadeIn(delay: 800.ms, duration: 600.ms)
                  .slideY(begin: 0.3, end: 0),
              const SizedBox(height: 12),
              // Tagline
              Text(
                'اتصال آمن وسريع',
                style: GoogleFonts.cairo(
                  fontSize: 18,
                  color: AppTheme.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              )
                  .animate()
                  .fadeIn(delay: 1200.ms, duration: 600.ms)
                  .slideY(begin: 0.3, end: 0),
              const SizedBox(height: 60),
              // Loading Indicator
              Container(
                width: 200,
                height: 4,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(2),
                  color: AppTheme.surfaceLight,
                ),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return AnimatedBuilder(
                      animation: _controller,
                      builder: (context, child) {
                        return Container(
                          width: constraints.maxWidth * _controller.value,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(2),
                            gradient: AppTheme.primaryGradient,
                          ),
                        );
                      },
                    );
                  },
                ),
              )
                  .animate()
                  .fadeIn(delay: 1400.ms, duration: 400.ms),
              const SizedBox(height: 16),
              Text(
                'جاري التحميل...',
                style: GoogleFonts.cairo(
                  fontSize: 14,
                  color: AppTheme.textMuted,
                ),
              )
                  .animate()
                  .fadeIn(delay: 1600.ms, duration: 400.ms),
            ],
          ),
        ),
      ),
    );
  }
}
