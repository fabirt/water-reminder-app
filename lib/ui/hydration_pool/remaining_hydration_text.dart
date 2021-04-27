import 'package:flutter/material.dart';
import 'package:waterreminder/util/num_extension.dart';

class RemainingHydrationText extends StatelessWidget {
  final int quantity;

  RemainingHydrationText(this.quantity);

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 1500),
      tween: Tween(begin: 0.0, end: 1.0),
      curve: Interval(0.8, 1.0),
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: child,
        );
      },
      child: Text("Remaining ${quantity.asMilliliters()}"),
    );
  }
}
