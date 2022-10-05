import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:persistance/screens/home_screen.dart';
import 'package:persistance/screens/home_screen.dart';
import 'package:persistance/screens/taken_picture_screen.dart';

// void main() {
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final cameras = await availableCameras();
  final firstCamera = cameras.first;

  runApp(SqliteApp(firstCamera: firstCamera));
}

class SqliteApp extends StatelessWidget {
  final CameraDescription firstCamera;

  const SqliteApp({Key? key, required this.firstCamera}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "SQLite Example",
      initialRoute: "home",
      routes: {
        "home": (context) => const HomeScreen()
        // "open_camera": (context) => TakenPictureScreen(camera: firstCamera)
      },
      theme: ThemeData.light().copyWith(
          appBarTheme:
              const AppBarTheme(color: Color.fromARGB(255, 219, 36, 12))),
    );
  }
}
