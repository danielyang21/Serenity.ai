import 'dart:math' as math;

import 'package:flutter/cupertino.dart';

class WavePainter extends CustomPainter {
  final double animationValue;
  final int waveIndex;
  final Color color;

  WavePainter(
      {required this.animationValue,
      required this.waveIndex,
      required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withOpacity(0.3 - (waveIndex * 0.1))
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 2;

    final wave = Path();
    for (var i = 0; i < 360; i++) {
      final radians = i * math.pi / 180;
      final waveHeight =
          math.sin((radians - animationValue * 2 * math.pi) * 2) * 3;
      final x = center.dx +
          (radius + waveHeight + (waveIndex * 10)) * math.cos(radians);
      final y = center.dy +
          (radius + waveHeight + (waveIndex * 10)) * math.sin(radians);

      if (i == 0) {
        wave.moveTo(x, y);
      } else {
        wave.lineTo(x, y);
      }
    }
    wave.close();

    canvas.drawPath(wave, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
