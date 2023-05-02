import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:client/services/api/prediction_service.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import '../../models/prediction_result.dart';
import 'prediction_results.dart';
import 'package:image/image.dart' as img;

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

  String? imagePath;
  List<PredictedItem> predictedItems = [];

  @override
  void initState() {
    super.initState();

    _controller = CameraController(
      widget.camera,
      ResolutionPreset.veryHigh,
      enableAudio: false
    );
    _controller.setFlashMode(FlashMode.off);

    _initializeControllerFuture = _controller.initialize();
  }

  void getPredictions() async {
    _controller.setFlashMode(FlashMode.off);
    final image = await _controller.takePicture();

    imagePath = await cropImage(File(image.path), 900) ?? image.path;
    print(imagePath);
    final imageFile = File(imagePath!);
    final response = await PredictionService.predictFromImage(imageFile);
    if (response.isSuccess) {
      setState(() {
        //imagePath = image.path;
        predictedItems = response.data!;
      });
    } else {
      //handle errors here
    }
  }

  Future<String?> cropImage(File file, int cropSize) async {
    try {
      final image = img.decodeImage(await file.readAsBytes());
      final croppedImage = img.copyCrop(image!,
          x: 0, y: 0, width: image!.width, height: image!.height - cropSize);
      final croppedFile = File(file.path);
      croppedFile.writeAsBytesSync(img.encodeJpg(croppedImage, quality: 85));

      return croppedFile?.path;
    } catch (exception) {
      return null;
    }
  }

  Future<void> _deleteCacheDir() async {
    final cacheDir = await getTemporaryDirectory();
    if (cacheDir.existsSync()) {
      cacheDir.deleteSync(recursive: true);
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
    //print(availableHeight);
    return SafeArea(
      child: WillPopScope(
        onWillPop: () async {
          _deleteCacheDir();
          return true;
        },
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
                bottom: mediaQuery.padding.bottom,
                child: PredictionResults(imagePath, predictedItems),
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: getPredictions,
            child: const Icon(Icons.add),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
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
      body: Image.file(File(imagePath)),
    );
  }
}
