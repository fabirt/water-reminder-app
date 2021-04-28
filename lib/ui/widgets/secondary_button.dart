import 'package:flutter/material.dart';

class SecondaryButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String title;

  const SecondaryButton({
    Key? key,
    required this.onPressed,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return TextButton(
      onPressed: onPressed,
      style: ButtonStyle(
        foregroundColor: MaterialStateProperty.all(theme.primaryColor),
        overlayColor:
            MaterialStateProperty.all(theme.primaryColor.withOpacity(0.06)),
        padding: MaterialStateProperty.all(EdgeInsets.symmetric(vertical: 16)),
        shape: MaterialStateProperty.all(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
      ),
      child: Text("Cancel"),
    );
  }
}
