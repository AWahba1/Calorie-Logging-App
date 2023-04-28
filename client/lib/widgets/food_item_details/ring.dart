import 'package:flutter/material.dart';

class Ring extends StatelessWidget {
  // const Ring({Key? key}) : super(key: key);

  final Color color;
  final String innerText;
  final String label;

  const Ring(
      {required this.color, required this.innerText, required this.label});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 5),
            child: CircleAvatar(
              radius: 35,
              backgroundColor: color,
              child: CircleAvatar(
                radius: 30,
                backgroundColor: Colors.white,
                child: FittedBox(
                  child: Text(
                    innerText,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ),
          Text(label)
        ],
      ),
    );
  }
}
