import 'package:camera/camera.dart';
import 'package:client/models/history_model.dart';
import 'package:client/widgets/camera_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './widgets/journal_page.dart';
import './widgets/food_item_page.dart';
import './widgets/signup_page.dart';
import './widgets/login_page.dart';

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final cameras = await availableCameras();

  // Get a specific camera from the list of available cameras.
  final firstCamera = cameras.first;

  runApp(App(firstCamera));
}

class App extends StatelessWidget {
  final camera;

  App(this.camera);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_)=> HistoryModel(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute:SignUpPage.route,
        routes: {
          SignUpPage.route:(ctx)=> SignUpPage(),
          LoginPage.route:(ctx)=> LoginPage(),
          JournalPage.route:(ctx)=> JournalPage(),
          CameraPage.route: (ctx) => CameraPage(camera: camera),
        },
      ),
    );
  }
}
