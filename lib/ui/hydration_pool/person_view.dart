import 'dart:math';

import 'package:flutter/material.dart';
import 'package:waterreminder/resources/assets.dart';

class PersonView extends StatelessWidget {
  final Animation<double> animation;

  const PersonView({Key? key, required this.animation}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        final t = animation.value;
        final phase = pi * (width / 2) / (width - 1);
        const amplitude = 20.0;
        final y = sin(2 * pi * t - phase) * amplitude;
        return Transform.translate(
          offset: Offset(0.0, y),
          child: child,
        );
      },
      child: Transform.scale(
        scale: 1.4,
        alignment: Alignment.topCenter,
        child: Image.asset(Assets.person),
      ),
    );
  }
}
