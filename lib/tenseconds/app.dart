// app.dart
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:wakelock/wakelock.dart';
import 'home_page.dart';

class MyAppp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
    );
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final cameras = await availableCameras();
  runApp(MyAppp());
}
