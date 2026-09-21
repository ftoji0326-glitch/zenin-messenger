import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class KokugetsuLogo extends StatelessWidget {
  const KokugetsuLogo({
    super.key,
    this.size = 96,
    this.showWordmark = false,
  });

  final double size;
  final bool showWordmark;

  @override
  Widget build(BuildContext context) {
    final mark = Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF2C234F), Color(0xFF0E0B18)],
        ),
        border: Border.all(color: AppTheme.primary.withOpacity(0.5)),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primary.withOpacity(0.18),
            blurRadius: 32,
            spreadRadius: 4,
          ),
        ],
      ),
      child: Image.asset(
        'assets/logo.png',
        width: size,
        height: size,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) {
          return CustomPaint(painter: _KokugetsuPainter());
        },
      ),
    );

    if (!showWordmark) return mark;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        mark,
        const SizedBox(height: 20),
        const Text(
          'ZENIN',
          style: TextStyle(
            color: AppTheme.textPrimary,
            fontSize: 20,
            fontWeight: FontWeight.w800,
            letterSpacing: 7,
          ),
        ),
        const SizedBox(height: 5),
        const Text(
          'MESSENGER',
          style: TextStyle(
            color: AppTheme.primaryBright,
            fontSize: 10,
            fontWeight: FontWeight.w700,
            letterSpacing: 4,
          ),
        ),
      ],
    );
  }
}

class _KokugetsuPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final moonPaint = Paint()
      ..color = AppTheme.primaryBright
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, size.width * 0.26, moonPaint);

    final cutoutPaint = Paint()
      ..color = const Color(0xFF171126)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(
      Offset(center.dx + size.width * 0.12, center.dy - size.height * 0.12),
      size.width * 0.22,
      cutoutPaint,
    );

    final letterPaint = Paint()
      ..color = Colors.white.withOpacity(0.92)
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.045
      ..strokeCap = StrokeCap.round;
    final path = Path()
      ..moveTo(size.width * 0.34, size.height * 0.67)
      ..lineTo(size.width * 0.45, size.height * 0.34)
      ..lineTo(size.width * 0.66, size.height * 0.67)
      ..moveTo(size.width * 0.39, size.height * 0.55)
      ..lineTo(size.width * 0.61, size.height * 0.55);
    canvas.drawPath(path, letterPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
