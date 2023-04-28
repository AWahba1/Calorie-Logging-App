import 'package:flutter/material.dart';

Future<void> showErrorAlertDialog(
  BuildContext context, {
  String title = 'Error',
  String message = 'An error has occurred. Please try again later.',
  String primaryButtonText = 'Okay',
  VoidCallback? primaryButtonOnPressed,
  String? secondaryButtonText,
  VoidCallback? secondaryButtonOnPressed,
}) async {
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            onPressed: primaryButtonOnPressed ??
                () {
                  Navigator.of(context).pop();
                },
            child: Text(primaryButtonText),
          ),
          if (secondaryButtonText != null)
            TextButton(
              onPressed: secondaryButtonOnPressed,
              child: Text(secondaryButtonText),
            ),
        ],
      );
    },
  );
}
