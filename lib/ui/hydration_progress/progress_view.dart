import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:waterreminder/bloc/water_bloc.dart';
import 'package:waterreminder/ui/hydration_progress/progress_painter.dart';
import 'package:waterreminder/util/num_extension.dart';

class ProgressView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bloc = context.watch<WaterBloc>();
    final theme = Theme.of(context);

    final gradient = SweepGradient(
      transform: GradientRotation(pi * 3 / 2),
      colors: [
        theme.accentColor.withOpacity(0.5),
        theme.accentColor.withOpacity(0.5),
      ],
    );

    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 1000),
      curve: Curves.easeInOut,
      tween: Tween(begin: 0.0, end: bloc.progress),
      builder: (context, value, child) {
        return CustomPaint(
          painter: ProgressPainter(
            gradient: gradient,
            inactiveColor: theme.unselectedWidgetColor,
            progress: value.clamp(0.0, 1.0),
          ),
          child: _DataColumn(progress: value),
        );
      },
    );
  }
}

class _DataColumn extends StatelessWidget {
  final double progress;

  const _DataColumn({
    Key? key,
    required this.progress,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bloc = context.watch<WaterBloc>();

    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(width: double.infinity),
        Text(
          "${(progress * 100).toInt()} %",
          style: theme.textTheme.headline1,
        ),
        SizedBox(height: 4),
        Text(
          bloc.state.currentMilliliters.asMilliliters(),
          style: theme.textTheme.bodyText1,
        ),
        SizedBox(height: 8),
        Text(
          bloc.remainigWater.asMilliliters(),
          style: theme.textTheme.caption,
        ),
      ],
    );
  }
}
