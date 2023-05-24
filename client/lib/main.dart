import 'package:camera/camera.dart';
import 'package:client/models/user_history_model.dart';
import 'package:client/services/api/common/secure_storage.dart';
import 'package:client/widgets/predicting_food/camera_page.dart';
import 'package:client/widgets/loading_screen/initial_loading_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'widgets/journaling/journal_page.dart';
import 'widgets/authentication//signup_page.dart';
import 'widgets/authentication/login_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

void main() async {
  runApp(App());
}

class App extends StatelessWidget {
  late final camera;
  late bool loginAutomatically;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: initializeApp(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return ChangeNotifierProvider(
            create: (_) => UserHistoryModel(),
            child: MaterialApp(
              debugShowCheckedModeBanner: false,
              initialRoute:
                  loginAutomatically ? LoginPage.route : LoginPage.route,
              routes: {
                SignUpPage.route: (ctx) => SignUpPage(),
                LoginPage.route: (ctx) => LoginPage(),
                JournalPage.route: (ctx) => JournalPage(),
                CameraPage.route: (ctx) => CameraPage(camera: camera),
              },
            ),
          );
        }
        return MaterialApp(
          home: LoadingScreen(),
          debugShowCheckedModeBanner: false,
        );
      },
    );
  }

  Future<void> initializeApp() async {
    WidgetsFlutterBinding.ensureInitialized();

    // Initialize firebase
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    // Allow only portrait mode
    await SystemChrome.setPreferredOrientations(
      [
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ],
    );

    // Get a specific camera from the list of available cameras.
    final cameras = await availableCameras();
    camera = cameras.first;

    // Load dotenv variables
    await dotenv.load();

    // Check if a refresh token exists
    final refreshToken = await SecureStorage.getRefreshToken();
    loginAutomatically =
        refreshToken != "" && !JwtDecoder.isExpired(refreshToken);
    // loginAutomatically = false;
  }
}
