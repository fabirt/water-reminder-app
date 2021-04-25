import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

class WaterView extends StatelessWidget {
  final Animation<double> animation;
  final double progress;

  const WaterView({
    Key? key,
    required this.animation,
    required this.progress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final waveColor = Theme.of(context).accentColor.withOpacity(0.5);

    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return Stack(
          children: [
            ClipPath(
              clipper: WaveClipper(animation),
              child: child,
            ),
            SizedBox(
              width: double.infinity,
              height: 100,
              child: CustomPaint(
                painter: WaveStrokePainter(
                  animation: animation,
                  color: Theme.of(context).backgroundColor,
                  phase: 10,
                  amplitude: 10,
                ),
              ),
            ),
            SizedBox(
              width: double.infinity,
              height: 100,
              child: CustomPaint(
                painter: WaveStrokePainter(
                  animation: animation,
                  color: Theme.of(context).backgroundColor,
                  phase: 20,
                  amplitude: 20,
                  strokeWidth: 1,
                ),
              ),
            ),
          ],
        );
      },
      child: BackdropFilter(
        filter: ui.ImageFilter.blur(sigmaX: 6.0, sigmaY: 6.0),
        child: TweenAnimationBuilder<double>(
          duration: Duration(milliseconds: 1000),
          curve: Curves.easeInOutSine,
          tween: Tween(begin: 0.0, end: progress),
          builder: (context, value, child) {
            return FractionallySizedBox(
              widthFactor: 1.0,
              heightFactor: value,
              child: child,
            );
          },
          child: ColoredBox(color: waveColor),
        ),
      ),
    );
  }
}

class WaveClipper extends CustomClipper<Path> {
  final Animation? animation;

  WaveClipper(this.animation) : super(reclip: animation);

  @override
  Path getClip(Size size) {
    final path = Path();
    final points = <Offset>[];
    final width = size.width + 1;

    final t = animation?.value ?? 1;
    const amplitude = 20;
    const offset = 50;

    for (int i = 1; i < width; i++) {
      final phase = math.pi * i / (width - 1);
      final y = math.sin(2 * math.pi * t - phase) * amplitude + offset;
      // final y =
      //     math.sin(((animation?.value ?? 1) * 360 - i) % 360 * math.pi / 180) *
      //             20 +
      //         50;
      final point = Offset(i.toDouble(), y);

      points.add(point);
    }

    path.addPolygon(points, false);

    path.lineTo(size.width, size.height);
    path.lineTo(0.0, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(WaveClipper oldClipper) => false;
}

class WaveStrokePainter extends CustomPainter {
  final Animation<double>? animation;
  final Color color;
  final double phase;
  final double amplitude;
  final double strokeWidth;

  WaveStrokePainter({
    this.animation,
    required this.color,
    this.phase = 0.0,
    this.amplitude = 20.0,
    this.strokeWidth = 2.0,
  }) : super(repaint: animation);

  @override
  paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..color = color;
    final path = Path();
    final points = <Offset>[];
    final width = size.width + 1;

    final t = animation?.value ?? 1;
    const offset = 60;

    for (int i = 1; i < width; i++) {
      final phase = math.pi * i / (width - 1) + this.phase;
      final y = math.sin(2 * math.pi * t - phase) * amplitude + offset;

      final point = Offset(i.toDouble(), y);

      points.add(point);
    }

    path.addPolygon(points, false);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
