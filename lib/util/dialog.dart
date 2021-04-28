import 'package:flutter/material.dart';
import 'package:animations/animations.dart';

import 'package:waterreminder/ui/widgets/confirmation_dialog.dart';
import 'package:waterreminder/ui/widgets/consumption_dialog.dart';

Future<bool> showConfirmationDialog(
  BuildContext context, {
  required String title,
  required String content,
}) async {
  final bool confirmed = await showModal(
        context: context,
        builder: (context) {
          return ConfirmationDialog(
            title: title,
            content: content,
            onConfirm: () => Navigator.of(context).pop(true),
            onCancel: () => Navigator.of(context).pop(false),
          );
        },
      ) ??
      false;

  return confirmed;
}

Future<void> showConsumptionDialog(BuildContext context) {
  return showModal(
    context: context,
    builder: (context) => ConsumptionDialog(),
  );
}
