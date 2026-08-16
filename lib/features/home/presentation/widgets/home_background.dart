import 'package:flutter/material.dart';
import '../../../../core/enums/theme_type.dart';

class HomeBackground extends StatelessWidget {
  final GameThemeData theme;
  const HomeBackground({super.key, required this.theme});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            theme.skyTop,
            theme.skyBottom,
            theme.groundPrimary.withOpacity(0.4)
          ],
        ),
      ),
      child: Stack(
        children: [
          // Vignette & blobs for AAA depth
          Positioned(
            top: -80,
            left: -60,
            child: Container(
              width: 220,
              height: 220,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: theme.accent.withOpacity(0.22),
              ),
            ),
          ),
          Positioned(
            bottom: 100,
            right: -50,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: theme.pipePrimary.withOpacity(0.18),
              ),
            ),
          ),
          // Subtle grid dots
          CustomPaint(
            size: Size.infinite,
            painter: _DotPainter(color: Colors.white.withOpacity(0.06)),
          ),
        ],
      ),
    );
  }
}

class _DotPainter extends CustomPainter {
  final Color color;
  _DotPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    for (double x = 20; x < size.width; x += 34) {
      for (double y = 20; y < size.height; y += 34) {
        canvas.drawCircle(Offset(x, y), 1.1, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
