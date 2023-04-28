import 'package:flutter/material.dart';

import '../util_views/error_alert_dialog.dart';

class AddSaveButton extends StatelessWidget {
  // const AddSaveButton({Key? key}) : super(key: key);

  final bool isLoading;
  final String buttonText;
  final VoidCallback? onButtonPress;

  const AddSaveButton(
      {required this.isLoading,
      required this.buttonText,
      required this.onButtonPress});

  @override
  Widget build(BuildContext context) {
    return Container(
      // alignment: Alignment.center,
      height: 70,
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      child: ElevatedButton(
        onPressed: onButtonPress,
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : Text(buttonText),
      ),
    );
  }
}
