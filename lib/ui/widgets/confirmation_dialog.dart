import 'package:flutter/material.dart';
import 'package:waterreminder/ui/widgets/primary_button.dart';
import 'package:waterreminder/ui/widgets/secondary_button.dart';

class ConfirmationDialog extends StatelessWidget {
  final String title;
  final String content;
  final VoidCallback onConfirm;
  final VoidCallback onCancel;

  const ConfirmationDialog({
    Key? key,
    required this.title,
    required this.content,
    required this.onConfirm,
    required this.onCancel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        title,
        textAlign: TextAlign.center,
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            content,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 24),
          PrimaryButton(onPressed: onConfirm, title: "Confirm"),
          SizedBox(height: 10),
          SecondaryButton(onPressed: onCancel, title: "Cancel"),
        ],
      ),
    );
  }
}
