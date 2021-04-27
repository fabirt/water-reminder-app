import 'package:flutter/material.dart';

import 'package:waterreminder/util/num_extension.dart';

class HydrationQuantityText extends StatelessWidget {
  final int quantity;

  HydrationQuantityText(this.quantity);

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints.loose(Size.fromWidth(400)),
      child: TweenAnimationBuilder<double>(
        duration: Duration(milliseconds: 1000),
        curve: Curves.decelerate,
        tween: Tween(begin: 0.0, end: quantity.toDouble()),
        builder: (context, value, child) {
          return Text(
            value.asMilliliters(),
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headline1,
          );
        },
      ),
    );
  }
}
