import 'dart:async';
import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(new MaterialApp(
    home: new stats(),



  ));




}







/*class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home:Text("Tutor joes")






    );
  }
}*/


class CustomStarBorder extends OutlinedBorder {
  final double innerRatio;

  CustomStarBorder({this.innerRatio = 0.5});

  @override
  EdgeInsetsGeometry get dimensions => EdgeInsets.zero;

  @override
  OutlinedBorder copyWith({BorderSide? side, BorderRadiusGeometry? borderRadius}) {
    return CustomStarBorder(innerRatio: innerRatio);
  }

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) {
    return getPath(rect.size.width, rect.size.height, innerRatio);
  }

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    return getPath(rect.size.width, rect.size.height, 1.0);
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {}

  @override
  ShapeBorder scale(double t) {
    return CustomStarBorder(innerRatio: innerRatio * t);
  }

  Path getPath(double width, double height, double innerRatio) {
    Path path = Path();

    double dx = width / 2;
    double dy = height / 2;

    double outerRadius = width / 2;
    double innerRadius = outerRadius * innerRatio;

    double angle = -90;
    double angleIncrement = 360 / 5;

    path.moveTo(dx + outerRadius * cos(degreesToRadians(angle)),
        dy + outerRadius * sin(degreesToRadians(angle)));

    for (int i = 0; i < 5; i++) {
      angle += angleIncrement;
      path.lineTo(dx + innerRadius * cos(degreesToRadians(angle)),
          dy + innerRadius * sin(degreesToRadians(angle)));

      angle += angleIncrement;
      path.lineTo(dx + outerRadius * cos(degreesToRadians(angle)),
          dy + outerRadius * sin(degreesToRadians(angle)));
    }

    path.close();
    return path;
  }

  double degreesToRadians(double degrees) {
    return degrees * (pi / 180.0);
  }
}

















class stats extends StatefulWidget {
  const stats({super.key});

  @override
  State<stats> createState() => _MyAppState();
}


class HeartRateData {
  final int heartRate;
  final String date;

  HeartRateData({required this.heartRate, required this.date});
}




class _MyAppState extends State<stats> {
  double _iconSize = 70.0;
  bool _isZoomed = false;
  Timer? _timer;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseReference _database = FirebaseDatabase.instance.reference();
  Map<String, List<HeartRateData>> groupedData = {};

  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  @override
  void initState() {
    super.initState();
    _fetchHeartRateData();
    Timer(Duration(seconds: 1), () {
      _startZoomAnimation();
    });
  }

  void _fetchHeartRateData() {
    User? user = _auth.currentUser;
    if (user != null) {
      String userId = user.uid;

      _database.child('heartRates').child(userId).onValue.listen((event) {
        // Check if the event snapshot exists and has data
        if (event.snapshot.value != null) {
          Map<dynamic, dynamic> heartRateDataMap =
          event.snapshot.value as Map<dynamic, dynamic>;

          groupedData.clear();

          heartRateDataMap.forEach((key, value) {
            HeartRateData heartRateData = HeartRateData(
              heartRate: value['heartRate'],
              date: value['date'],
            );

            if (groupedData.containsKey(heartRateData.date)) {
              groupedData[heartRateData.date]!.add(heartRateData);
            } else {
              groupedData[heartRateData.date] = [heartRateData];
            }
          });

          setState(() {});
        }
      });
    }
  }


  void _startZoomAnimation() {
    const zoomDuration = Duration(seconds: 5);

    // Toggle the zoom state every 2 seconds (adjust as needed)
    _timer = Timer.periodic(Duration(seconds: 2), (timer) {
      setState(() {
        _isZoomed = !_isZoomed;
      });
    });

    // Stop the animation after 10 seconds
    Timer(zoomDuration, () {
      setState(() {
        _isZoomed = false;
      });
      _timer?.cancel();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }






  @override
  Widget build(BuildContext context) {


    return







    Scaffold(
      backgroundColor: Color(0xFF252634),

      appBar: PreferredSize(
        preferredSize: Size.fromHeight(100.0),
        child: AppBar(
          title: Text('Stats'),
          foregroundColor: Colors.blueGrey,

          iconTheme: IconThemeData(color: Colors.deepPurple),

          backgroundColor: Colors.black26,


        ),
      ),


      body: Card(
        color: Colors.blueGrey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView.builder(
            itemCount: groupedData.keys.length,
            itemBuilder: (context, index) {
              String date = groupedData.keys.elementAt(index);
              List<HeartRateData> dateData = groupedData[date]!;

              return Column(

                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                      // Add your logic here
                      print('Button pressed');
                    },
                    icon: Icon(
                      Icons.date_range,
                      // Replace "your_icon" with the desired icon
                      color: Colors.white, // Customize the icon color
                    ),
                    label: Text('$date'),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.blueGrey, // Background color
                      onPrimary: Colors.white, // Text color
                    ),
                  ),


                  /*Text('$date'),*/
                  SizedBox(
                    height: 150.0,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      itemCount: dateData.length,
                      itemBuilder: (context, subIndex) {
                        HeartRateData heartRateData = dateData[subIndex];

                        return Container(
                          child: Stack(
                            alignment: Alignment.center,
                            children: [


                              // Heart icon
                              AnimatedContainer(
                                duration: Duration(milliseconds: 400),
                                curve: Curves.easeInOut,
                                width: _isZoomed ? _iconSize * 1.4 : _iconSize,
                                height: _isZoomed ? _iconSize * 1.4 : _iconSize,
                                child: Icon(
                                  Icons.favorite,
                                  color: Colors.red,
                                  size: _isZoomed ? _iconSize * 1.4 : _iconSize,
                                ),
                              ),

                              // Text inside the heart
                              Text(
                                '${heartRateData.heartRate}',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'DancingScript-VariableFont_wght',
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  Divider(
                    color: Colors.blue,
                    thickness: 4.0,
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );

  }
}