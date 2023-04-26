import 'package:flutter/material.dart';

class SubmitFormButton extends StatelessWidget {
  // const SubmitFormButton({Key? key}) : super(key: key);

  final bool isLoading;
  final VoidCallback onFormSubmit;
  final String text;

  const SubmitFormButton(
      {required this.isLoading,
      required this.onFormSubmit,
      required this.text});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        fixedSize: const Size(200, 50),
        foregroundColor: Colors.white,
        backgroundColor: Colors.lightBlue[600],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        //elevation: 0.0,
        textStyle: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      onPressed: isLoading ? null : onFormSubmit,
      child: isLoading
          ? const SizedBox(
              height: 24.0,
              width: 24.0,
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                strokeWidth: 3.0,
              ),
            )
          : Text(text),
    );
  }
}
