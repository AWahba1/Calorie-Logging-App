import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import './prediction_results.dart';
import '../services/firebase_storage.dart';

class CameraPage extends StatefulWidget {
  final CameraDescription camera;
  static const route = '/add-food';

  const CameraPage({
    super.key,
    required this.camera,
  });

  @override
  _CameraPageState createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;

  String? foodImageURL;

  @override
  void initState() {
    super.initState();

    _controller = CameraController(
      widget.camera,
      ResolutionPreset.high,
    );

    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void uploadImage() async
  {
    final image = await _controller.takePicture();
    final imageFile=File(image.path);
    String? downloadURL = await FirebaseStorageService.uploadImage(imageFile);
    if (downloadURL != null) {
      print('Download URL: $downloadURL');
      setState(() {
        foodImageURL=downloadURL;
      });
    } else {
      print('Error uploading image');  //TODO: adjust circular avatar when error occurs
    }
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final size = mediaQuery.size;
    final availableHeight = size.height -
        MediaQuery.of(context).padding.top -
        MediaQuery.of(context).padding.bottom;
    final deviceWidth = size.width;

    return SafeArea(
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: Stack(
          children: [
            FutureBuilder<void>(
              future: _initializeControllerFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return Container(
                      height: availableHeight,
                      width: deviceWidth,
                      child: CameraPreview(_controller));
                } else {
                  // Otherwise, display a loading indicator.
                  return const Center(child: CircularProgressIndicator());
                }
              },
            ),
            Positioned(
                bottom: mediaQuery.padding.bottom, child: PredictionResults(foodImageURL)),
          ],
        ),
        //floatingActionButtonLocation: FloatingActionButtonLocation.centerTop,
        floatingActionButton: FloatingActionButton(
          onPressed: uploadImage,
          child:Icon(Icons.add),
        ),
        // floatingActionButton: FloatingActionButton(
        //   // Provide an onPressed callback.
        //   onPressed: () async {
        //     setState(() {
        //       //print('balabuzo');
        //     });
        //     // await _initializeControllerFuture;
        //     // Timer.periodic(Duration(seconds: 1), (Timer timer)async {
        //     //   final image = await _controller.takePicture();
        //     //   print(image.path);
        //     // });
        //
        //     final image = await _controller.takePicture();
        //   },
        //   // onPressed: () async {
        //   //   // Take the Picture in a try / catch block. If anything goes wrong,
        //   //   // catch the error.
        //   //   try {
        //   //     // Ensure that the camera is initialized.
        //   //     await _initializeControllerFuture;
        //   //
        //   //     // Attempt to take a picture and get the file `image`
        //   //     // where it was saved.
        //   //     final image = await _controller.takePicture();
        //   //
        //   //     if (!mounted) return;
        //   //
        //   //     // If the picture was taken, display it on a new screen.
        //   //     await Navigator.of(context).push(
        //   //       MaterialPageRoute(
        //   //         builder: (context) => DisplayPictureScreen(
        //   //           // Pass the automatically generated path to
        //   //           // the DisplayPictureScreen widget.
        //   //           imagePath: image.path,
        //   //         ),
        //   //       ),
        //   //     );
        //   //   } catch (e) {
        //   //     // If an error occurs, log the error to the console.
        //   //     print(e);
        //   //   }
        //   // },
        //   child: const Icon(Icons.camera_alt),
        // ),
      ),
    );
  }
}

// A widget that displays the picture taken by the user.
class DisplayPictureScreen extends StatelessWidget {
  final String imagePath;

  const DisplayPictureScreen({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    print(imagePath);
    return Scaffold(
      appBar: AppBar(title: const Text('Display the Picture')),
      // The image is stored as a file on the device. Use the `Image.file`
      // constructor with the given path to display the image.
      body: Image.file(File(imagePath)),
    );
  }
}
