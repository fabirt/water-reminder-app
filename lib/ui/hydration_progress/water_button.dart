import 'package:flutter/material.dart';
import 'package:waterreminder/domain/model/water_input.dart';

class WaterButton extends StatelessWidget {
  final WaterInput input;
  final ValueChanged<WaterInput> onPressed;

  const WaterButton({
    Key? key,
    required this.input,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screen = MediaQuery.of(context).size;
    return SizedBox(
      width: (screen.width - 16) / 2,
      height: 86,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        child: TextButton.icon(
          onPressed: () => onPressed(input),
          icon: Icon(input.icon),
          label: Text("${input.milliliters} ml"),
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(input.backgroundColor),
            foregroundColor: MaterialStateProperty.all(Colors.black),
            overlayColor:
                MaterialStateProperty.all(Colors.black.withOpacity(0.04)),
            shape: MaterialStateProperty.all(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            ),
          ),
        ),
      ),
    );
  }
}
