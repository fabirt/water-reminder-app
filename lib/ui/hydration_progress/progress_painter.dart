import 'dart:math';

import 'package:flutter/material.dart';

class ProgressPainter extends CustomPainter {
  final Gradient gradient;
  final Color inactiveColor;
  final double progress;

  ProgressPainter({
    required this.gradient,
    required this.inactiveColor,
    required this.progress,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final radius = min(size.width, size.height) / 2 - 40;
    final center = Offset(size.width / 2, size.height / 2);
    final rect = Rect.fromCircle(center: center, radius: radius);

    final inactivePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 16
      ..strokeCap = StrokeCap.round
      ..color = Color(0xFFf0f7ff);

    final activePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 16
      ..strokeCap = StrokeCap.round
      ..shader = gradient.createShader(rect);

    final startAngle = pi * 3 / 2;
    final sweepAngle = 2 * pi * progress;

    // inactive circle
    canvas.drawCircle(center, radius, inactivePaint);

    // active progress
    canvas.drawArc(rect, startAngle, sweepAngle, false, activePaint);
  }

  @override
  bool shouldRepaint(ProgressPainter oldDelegate) =>
      gradient != oldDelegate.gradient ||
      inactiveColor != oldDelegate.inactiveColor ||
      progress != oldDelegate.progress;
}
