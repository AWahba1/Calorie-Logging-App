import 'package:flutter/material.dart';

SnackBar buildSnackBar(String text, Color color, Duration duration) {
  return SnackBar(
    content: Text(text, style: const TextStyle(fontSize: 15)),
    backgroundColor: color,
    duration: duration,
  );
}
