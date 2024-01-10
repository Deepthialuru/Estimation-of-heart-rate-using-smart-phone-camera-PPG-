import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:heartratemonitor/screens/login_screen.dart';
import 'package:heartratemonitor/widgets/auth_gate.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Wait for 10 seconds before redirecting to the next page
    Timer(Duration(seconds: 10), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => AuthGate()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF252634),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('images/rategif.gif',width: 150,height: 150,), // Replace 'assets/splash_image.png' with your image asset
            SizedBox(height: 20),
            Text(
              'Instant Heart Rate Monitor',
              style: TextStyle(fontSize: 27, fontWeight: FontWeight.bold,color: Color.fromARGB(255, 245, 89, 0)),



            ),
          ],
        ),
      ),
    );
  }
}


