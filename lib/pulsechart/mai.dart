import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:heartratemonitor/pulsechart/HomePage.dart';


void main() => runApp(pulsestart());

class pulsestart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PPG',
      theme: ThemeData(
        brightness: Brightness.light,
      ),
      home: HomePagee(),
    );
  }
}