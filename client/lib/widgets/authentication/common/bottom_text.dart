import 'package:flutter/material.dart';

class BottomTextButton extends StatelessWidget {
  // const BottomTextButton({Key? key}) : super(key: key);

  final String text;
  final String route;

  const BottomTextButton({required this.text, required this.route});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        Navigator.of(context).pushNamed(route);
      },
      child: Text(text),
    );
  }
}
