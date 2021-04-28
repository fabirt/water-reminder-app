import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:waterreminder/bloc/water_bloc.dart';
import 'package:waterreminder/ui/hydration_pool/hydration_quantity_text.dart';
import 'package:waterreminder/ui/hydration_pool/person_view.dart';
import 'package:waterreminder/ui/hydration_pool/remaining_hydration_text.dart';
import 'package:waterreminder/ui/hydration_pool/water_view.dart';

class HydrationPoolPage extends StatefulWidget {
  @override
  _HydrationPoolPageState createState() => _HydrationPoolPageState();
}

class _HydrationPoolPageState extends State<HydrationPoolPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    );

    _controller.repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bloc = context.watch<WaterBloc>();

    return Stack(
      children: [
        Align(
          alignment: Alignment(0.0, -0.1),
          child: PersonView(animation: _controller),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: WaterView(
            animation: _controller,
            progress: bloc.progress,
          ),
        ),
        Align(
          alignment: Alignment(0.0, -0.68),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              HydrationQuantityText(bloc.currentWater),
              SizedBox(height: 8),
              RemainingHydrationText(bloc.remainigWater),
            ],
          ),
        ),
      ],
    );
  }
}
