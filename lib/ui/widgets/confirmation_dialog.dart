import 'package:flutter/material.dart';

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
    final theme = Theme.of(context);
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
          ElevatedButton(
            onPressed: onConfirm,
            style: ButtonStyle(
              elevation: MaterialStateProperty.all(0),
              backgroundColor: MaterialStateProperty.all(theme.primaryColor),
              padding:
                  MaterialStateProperty.all(EdgeInsets.symmetric(vertical: 16)),
              shape: MaterialStateProperty.all(RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10))),
            ),
            child: Text("Confirm"),
          ),
          SizedBox(height: 10),
          TextButton(
            onPressed: onCancel,
            style: ButtonStyle(
              foregroundColor: MaterialStateProperty.all(theme.primaryColor),
              overlayColor: MaterialStateProperty.all(
                  theme.primaryColor.withOpacity(0.06)),
              padding:
                  MaterialStateProperty.all(EdgeInsets.symmetric(vertical: 16)),
              shape: MaterialStateProperty.all(RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10))),
            ),
            child: Text("Cancel"),
          ),
        ],
      ),
    );
  }
}
