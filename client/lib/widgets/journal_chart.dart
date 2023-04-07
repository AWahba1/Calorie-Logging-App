import 'package:flutter/material.dart';
class JournalChart extends StatelessWidget {
  const JournalChart({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200, // Fixed height for the second widget
      color: Colors.red,
      child: const Center(
        child: Text(
          'Second Widget',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
