import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoadingScreen extends StatelessWidget {
  // const LoadingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
          backgroundColor: Colors.blue[900],
          body: const Center(
              child: SpinKitFadingCube(
                color: Colors.white,
                size: 50.0,
              )
          )
      );
  }
}
