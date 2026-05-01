import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme/app_theme.dart';

class SplashScreen extends StatefulWidget {
  final VoidCallback onFinish;
  const SplashScreen({super.key, required this.onFinish});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 2900), widget.onFinish);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppColors.primary, Color(0xFF0055CC)],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'B',
                    style: TextStyle(
                      fontSize: 72,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                      letterSpacing: 2,
                    ),
                  )
                      .animate()
                      .fadeIn(duration: 600.ms, delay: 200.ms)
                      .slideX(begin: -0.5, end: 0, duration: 600.ms, curve: Curves.easeOutBack),
                  const SizedBox(width: 4),
                  Text(
                    'on',
                    style: TextStyle(
                      fontSize: 72,
                      fontWeight: FontWeight.w300,
                      color: Colors.white.withValues(alpha: 0.9),
                      letterSpacing: 2,
                    ),
                  )
                      .animate()
                      .fadeIn(duration: 600.ms, delay: 500.ms)
                      .scaleXY(begin: 0.5, end: 1, duration: 600.ms, curve: Curves.easeOutBack),
                  Text(
                    'D',
                    style: TextStyle(
                      fontSize: 72,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                      letterSpacing: 2,
                    ),
                  )
                      .animate()
                      .fadeIn(duration: 600.ms, delay: 800.ms)
                      .slideX(begin: 0.5, end: 0, duration: 600.ms, curve: Curves.easeOutBack),
                  Text(
                    'eal',
                    style: TextStyle(
                      fontSize: 72,
                      fontWeight: FontWeight.w300,
                      color: Colors.white.withValues(alpha: 0.9),
                      letterSpacing: 2,
                    ),
                  )
                      .animate()
                      .fadeIn(duration: 600.ms, delay: 1100.ms)
                      .scaleXY(begin: 0.5, end: 1, duration: 600.ms, curve: Curves.easeOutBack),
                ],
              ),
              ),
              const SizedBox(height: 16),
              Text(
                'Achetez, Vendez, Échangez',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white.withValues(alpha: 0.8),
                  fontWeight: FontWeight.w500,
                  letterSpacing: 1,
                ),
              )
                  .animate()
                  .fadeIn(duration: 600.ms, delay: 1500.ms)
                  .slideY(begin: 0.3, end: 0, duration: 600.ms),
            ],
          ),
        ),
      ),
    );
  }
}
