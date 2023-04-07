import 'package:camera/camera.dart';
import 'package:client/widgets/camera_page.dart';
import 'package:flutter/material.dart';
import './widgets/journal_page.dart';
import './widgets/food_item_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
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
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute:JournalPage.route ,
      routes: {
        '/':(ctx)=> Home(),
        JournalPage.route:(ctx)=> JournalPage(),
        TakePictureScreen.route: (ctx) => TakePictureScreen(camera: camera),
        FoodItemPage.route: (ctx)=> FoodItemPage(),
      },
    );
  }
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: () {
          Navigator.of(context).pushNamed('/add-food');
        },
        child: const Text("Click"));
  }
}
