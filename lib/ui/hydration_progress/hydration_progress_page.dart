import 'package:flutter/material.dart';
import 'package:waterreminder/ui/hydration_progress/progress_view.dart';
import 'package:waterreminder/ui/hydration_progress/water_input_group.dart';

class HydrationProgressPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 32 + 64 + 40, top: 32.0),
        child: Column(
          children: [
            SizedBox(width: double.infinity),
            Text(
              "Current Hydration",
              style: Theme.of(context).textTheme.headline4,
            ),
            Expanded(
              child: ProgressView(),
            ),
            WaterInputGroup(),
          ],
        ),
      ),
    );
  }
}
