import 'dart:async';
import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import '../widgets/kokugetsu_logo.dart';
import 'login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _flash;
  late AnimationController _logo;

  @override
  void initState() {
    super.initState();

    _flash = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );

    _logo = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );

    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) _flash.forward();
    });

    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) _logo.forward();
    });

    Future.delayed(const Duration(milliseconds: 1900), () {
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    });
  }

  @override
  void dispose() {
    _flash.dispose();
    _logo.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: AnimatedBuilder(
        animation: Listenable.merge([_flash, _logo]),
        builder: (_, __) {
          final shakeX = _flash.value > 0.5 ? 3.0 : -2.0;
          final shakeY = _flash.value > 0.5 ? -2.0 : 2.0;

          return Stack(
            fit: StackFit.expand,
            children: [
              Container(color: AppTheme.background),

              // Вспышка во время удара
              Opacity(
                opacity: _flash.value * 0.15,
                child: Container(color: Colors.white),
              ),

              // Молния
              Opacity(
                opacity: _flash.value,
                child: Transform.translate(
                  offset: Offset(shakeX, shakeY),
                  child: CustomPaint(
                    painter: _BlackFlashPainter(),
                  ),
                ),
              ),

              // Дым
              Opacity(
                opacity: _logo.value * 0.35,
                child: IgnorePointer(
                  child: Container(
                    decoration: const BoxDecoration(
                      gradient: RadialGradient(
                        center: Alignment.center,
                        radius: 0.8,
                        colors: [
                          Color(0x33FFFFFF),
                          Color(0x11000000),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              // Логотип
              Center(
                child: Transform.scale(
                  scale: Curves.easeOutBack.transform(_logo.value),
                  child: Opacity(
                    opacity: _logo.value,
                    child: const KokugetsuLogo(
                      size: 125,
                      showWordmark: false,
                    ),
                  ),
                ),
              ),

              // Текст
              Positioned(
                bottom: 90,
                left: 0,
                right: 0,
                child: Opacity(
                  opacity: _logo.value,
                  child: Column(
                    children: const [
                      Text(
                        "ZENIN MESSENGER",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 4,
                        ),
                      ),
                      SizedBox(height: 6),
                      Text(
                        "Kokugetsu",
                        style: TextStyle(
                          color: Colors.white54,
                          fontSize: 14,
                          letterSpacing: 2,
                        ),
                      ),
                      SizedBox(height: 18),
                      Text(
                        "by lonelyyy3",
                        style: TextStyle(
                          color: Colors.white24,
                          fontSize: 11,
                          letterSpacing: 1,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _BlackFlashPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final glow = Paint()
      ..color = Colors.white.withOpacity(0.28)
      ..strokeWidth = 12
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final core = Paint()
      ..color = Colors.black
      ..strokeWidth = 5
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final path = Path()
      ..moveTo(size.width * 0.48, 0)
      ..lineTo(size.width * 0.54, size.height * 0.12)
      ..lineTo(size.width * 0.43, size.height * 0.24)
      ..lineTo(size.width * 0.60, size.height * 0.39)
      ..lineTo(size.width * 0.39, size.height * 0.58)
      ..lineTo(size.width * 0.56, size.height * 0.78)
      ..lineTo(size.width * 0.49, size.height);

    canvas.drawPath(path, glow);
    canvas.drawPath(path, core);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}