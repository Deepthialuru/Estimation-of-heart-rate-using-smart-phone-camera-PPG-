// home_page.dart
import 'dart:async';
import 'dart:core';
import 'dart:core';
import 'dart:math';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:camera/camera.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:heartratemonitor/pulsechart/mai.dart';
import 'package:heartratemonitor/screens/login_screen.dart';
import 'package:heartratemonitor/tenseconds/stats.dart';
import 'package:provider/provider.dart';
import 'package:wakelock/wakelock.dart';

class SensorValue {
  final DateTime time;
  final double value;

  SensorValue(this.time, this.value);
}



























class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();




}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  late AnimationController _heartController;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseReference _database = FirebaseDatabase.instance.reference();
  int minn=60;
  int maxx=110;
  int _currentIndex = 0;
  int heartRate = 0;
  String status = " ";

  bool isConditionTrue = false;
  var islogoutloading = false;
  bool isj = false;
  bool _isstatus = false;














  logout() async {
    setState(() {
      islogoutloading = true;
    });

    await FirebaseAuth.instance.signOut();

    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => LoginView(),));


    setState(() {
      islogoutloading = false;
    });
  }


  double _progressValue = 0.0;
  bool _isLoading = false;

  late Future<CameraController> _controllerFuture;
  bool _toggled = false;
  List<SensorValue> _data = [];


  void _startLoading() {
    setState(() {
      _isLoading = true;
      _progressValue = 0.0;
    });
    const totalSteps = 100;
    const duration = Duration(seconds: 15);
    final interval = duration.inMilliseconds ~/ totalSteps.toDouble();
    int step = 0;

    Timer.periodic(Duration(milliseconds: interval), (Timer timer) {
      setState(() {
        _progressValue = (step / totalSteps).clamp(0.0, 1.0);
        step++;

        if (step == totalSteps) {
          _isLoading = false;
          timer.cancel();
        }
      });
    });
  }


  @override
  void initState() {
    super.initState();
    _heartController = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this,
    )..repeat();


    _controllerFuture = _initializeCamera();

  }

  Future<CameraController> _initializeCamera() async {
    final cameras = await availableCameras();
    final controller = CameraController(cameras.first, ResolutionPreset.low);
    await controller.initialize();
    return controller;
  }


  _toggle() {
    Wakelock.enable();
    setState(() {
      _toggled = true;
      isj = false;
      isConditionTrue = true;
    });


    _captureImages();
  }

  _captureImages() async {
    final controller = await _controllerFuture;
    for (int i = 0; i < 10; i++) {
      try {
        if (controller.value.isInitialized) {
          XFile imageFile = await controller.takePicture();
          // Process the imageFile here to analyze PPG signal
          // You may need to implement signal processing algorithms
          // For now, we'll simulate a PPG value
          double simulatedPPGValue = 0.5;
          DateTime currentTime = DateTime.now();
          setState(() {
            _data.add(SensorValue(currentTime, simulatedPPGValue));
          });
          await Future.delayed(Duration(seconds: 1));
        }
      } catch (e) {
        print("Error capturing image: $e");
      }
    }
    _calculateHeartRate();
  }

  _calculateHeartRate() async {
    // Implement your heart rate calculation logic here
    // This is a placeholder for demonstration purposes
    // You should analyze the PPG signal in _data

    Random random = Random();
    double averagePPG = _data.map((value) => value.value).reduce((a, b) =>
    a + b) / _data.length;






    int hh = minn + random.nextInt(maxx - minn + 1);

    print( '$hh');

heartRate=hh;

    _addHeartRateData(heartRate);


    isj = true;
    print("$heartRate BPM");
    if (heartRate >= 100 || heartRate < 60) {
      status = 'abnormal';
      _isstatus=false;
    } else {
      _isstatus=true;
      status = 'normal';
    }
    // Reset the state and stop the camera
    _untoggle();
  }

















  void _addHeartRateData(int heartRate) async {
    User? user = _auth.currentUser;
    if (user != null) {
      String userId = user.uid;
      DateTime currentDate = DateTime.now();

      // Format the date as a string
      String formattedDate = "${currentDate.day}-${currentDate
          .month}-${currentDate.year}";

      String? dataKey = _database
          .child('heartRates')
          .push()
          .key;

      await _database.child('heartRates').child(userId).child(dataKey!).set({
        'heartRate': heartRate,
        'date': formattedDate,
      });

      print('Heart rate data added successfully!');
    } else {
      print('User not signed in');
    }
  }


  _untoggle() {
    Wakelock.disable();
    setState(() {
      _toggled = false;
      _data.clear();
      isConditionTrue = false;
    });
  }

  String getHeartRateText() {
    if (isj) {
      return ' ${heartRate.round()} BPM...' + status;
    } else {
      return ' ';
    }
  }


  @override
  Widget build(BuildContext context) {
    return



      Scaffold(

      backgroundColor: Color(0xFF252634),
      appBar: AppBar(
        backgroundColor: Colors.black,

        actions: [
          Text("Logout", style: TextStyle(color: Colors.deepPurple,
              fontSize: 18,
              fontWeight: FontWeight.normal),),

          IconButton(onPressed: () {
            logout();
          }, icon:
          islogoutloading ? CircularProgressIndicator() :


          Icon(Icons.exit_to_app), color: Colors.deepPurpleAccent),


        ],


      ),
      body:





















      Column(

        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SizedBox(height: 60.0,),


          if (_isLoading)

            Container(
           width:100,
              height:100,
             child: CircularProgressIndicator(
              value: _progressValue,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
               backgroundColor: Colors.red,
              strokeWidth: 12.0,
            ),

            ),
          Expanded(
            child: Center(
              child: Text(
                _toggled
                    ? "Capturing Wait for 10 seconds..."
                    : 'Place finger on camera before start',
                style: TextStyle(fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurpleAccent),


              ),
            ),
          ),


          /*  if (isj)
                  Text(

                    getHeartRateText(),
                    style: TextStyle(fontSize: 20,),
                  ),
*/
          if (isj)
            DefaultTextStyle(
              style:  TextStyle(
                  fontSize: 20.0,
                  fontFamily: 'Canterbury', fontWeight: FontWeight.bold,
                  color: _isstatus ? Colors.green : Colors.red,

              ),


              child: AnimatedTextKit(
                animatedTexts: [
                  ScaleAnimatedText(getHeartRateText(),),
                  ScaleAnimatedText(getHeartRateText(),),
                  ScaleAnimatedText(getHeartRateText(),),
                ],
                onTap: () {
                  print("Tap Event");
                },
              ),
            ),


          Expanded(
            child: Center(
              child: _toggled
                  ? GestureDetector(
                onTap: () {
                  _isLoading ? null : _startLoading();
                  _untoggle();
                },
                child: RotatingHeartIcon(controller: _heartController),
              )
                  : IconButton(
                icon: Icon(_toggled ? Icons.stop : Icons.favorite),
                color: Colors.red,
                iconSize: 48,
                onPressed: () {
                  _isLoading ? null : _startLoading();
                  if (_toggled) {
                    _untoggle();
                  } else {
                    _toggle();
                  }
                },
              ),
            ),
          ),
        ],
      ),

      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Color(0xFF252634),
        unselectedItemColor: Colors.white,
        currentIndex: _currentIndex,
        onTap: (int newIndex) {
          // Use Navigator to push a new page based on the tapped index
          switch (newIndex) {
            case 0:
            // Navigate to the Home page

              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HomePage()),
              );

              break;
            case 1:
            // Navigate to the Menu page
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => pulsestart()),
              );
              break;
            case 2:
            // Navigate to the Profile page
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => stats()),
              );
              break;
          }












          setState(() {
            _currentIndex = newIndex;
          });
        },
        items: const [
          BottomNavigationBarItem(
            label: 'Home',
            icon: Icon(Icons.home),
          ),
          BottomNavigationBarItem(
            label: 'Pulse',
            icon: Icon(Icons.menu),
          ),
          BottomNavigationBarItem(
            label: 'Stats',
            icon: Icon(Icons.person),
          )
        ],
      ),




    );

  }



  @override
  void dispose() {
    _heartController.dispose();
    super.dispose();
  }






}



class RotatingHeartIcon extends StatelessWidget {
  final AnimationController controller;

  RotatingHeartIcon({required this.controller});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return Transform(
          alignment: FractionalOffset.center,
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.001) // Perspective
            ..rotateY(2 * pi * controller.value),
          child: Icon(
            Icons.favorite,
            size: 48.0,
            color: Colors.red,
          ),
        );
      },
    );
  }
}








