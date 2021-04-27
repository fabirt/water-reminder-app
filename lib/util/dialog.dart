import 'package:animations/animations.dart';
import 'package:flutter/material.dart';

Future<bool> showConfirmationDialog(BuildContext context) async {
  final bool confirmed = await showModal(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Hard reset"),
            content: Text("Reset data"),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: Text("Reset"),
              ),
            ],
          );
        },
      ) ??
      false;

  return confirmed;
}
