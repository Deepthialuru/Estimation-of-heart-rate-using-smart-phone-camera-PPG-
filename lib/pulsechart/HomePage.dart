

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:heartratemonitor/pulsechart/chartpulse.dart';
import 'package:wakelock/wakelock.dart';


class HomePagee extends StatefulWidget {
  @override
  HomePageView createState() {
    return HomePageView();
  }
}

class HomePageView extends State<HomePagee> {
  bool _touch= false;
  bool _toggled = false;
  bool _processing = false;
  List<SensorValue> _data = [];
    CameraController? _controller;
  double _alpha = 0.3;
  int _bpm = 0;

  _toggle() {
    _initController().then((onValue) {
      Wakelock.enable();
      setState(() {

        _toggled = true;
        _processing = false;
      });
      _updateBPM();
    });
  }

  _untoggle() {
    _disposeController();
    Wakelock.disable();
    setState(() {
      _toggled = false;
      _processing = false;
    });
  }

  Future<void> _initController() async {
    try {
      List _cameras = await availableCameras();
      _controller = CameraController(_cameras.first, ResolutionPreset.medium);
      await _controller?.initialize();
      Future.delayed(Duration(milliseconds: 500)).then((onValue) {
        _controller?.setFlashMode(FlashMode.torch);
      });
      _controller?.startImageStream((CameraImage image) {
        if (!_processing) {
          setState(() {
            _processing = true;
          });
          _scanImage(image);
        }
      });
    } catch (Exception) {
      print(Exception);
    }
  }

  _updateBPM() async {
    List<SensorValue> _values;
    double _avg;
    int _n;
    double _m;
    double _threshold;
    double _bpm;
    int _counter;
    int _previous;
    while (_toggled) {
      _values = List.from(_data);
      _avg = 0;
      _n = _values.length;
      _m = 0;
      _values.forEach((SensorValue value) {
        _avg += value.value / _n;
        if (value.value > _m) _m = value.value;
      });
      _threshold = (_m + _avg) / 2;
      _bpm = 0;
      _counter = 0;
      _previous = 0;
      for (int i = 1; i < _n; i++) {
        if (_values[i - 1].value < _threshold &&
            _values[i].value > _threshold) {
          if (_previous != 0) {
            _counter++;
            _bpm +=
                60000 / (_values[i].time.millisecondsSinceEpoch - _previous);
          }
          _previous = _values[i].time.millisecondsSinceEpoch;
        }
      }
      if (_counter > 0) {
        _bpm = _bpm / _counter;
        setState(() {
          _bpm = (1 - _alpha) * _bpm + _alpha * _bpm;
       print('hhhhhhhhhhhhhhh'+_bpm.round().toString());

        });
      }
      await Future.delayed(Duration(milliseconds: (1000 * 50 / 30).round()));

      print(_bpm);
    }
  }

  _scanImage(CameraImage image) {
    double _avg =
        image.planes.first.bytes.reduce((value, element) => value + element) /
            image.planes.first.bytes.length;
    if (_data.length >= 50) {
      _data.removeAt(0);
    }
    setState(() {
      _data.add(SensorValue(DateTime.now(), _avg));
    });
    Future.delayed(Duration(milliseconds: 1000 ~/ 30)).then((onValue) {
      setState(() {
        _processing = false;
      });
    });
  }

  _disposeController() {
    _controller?.dispose();
    _controller = null;
  }

  @override
  void dispose() {
    _disposeController();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF252634),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Expanded(
              child: Row(
                children: <Widget>[


                  Expanded(
                    child: Center(
        child: Padding(
        padding: EdgeInsets.all(25.0),
        child: Container(
          height: 100.0, // Adjust the height as needed
          width: 450.0,  //

        child: Card(color: Colors.black,elevation: 10.0,shadowColor: Colors.blue,

          child: Center(
              child: AnimatedDefaultTextStyle(
                style: _touch
                    ? TextStyle(
                  fontFamily: 'DancingScript-VariableFont_wght',
                  fontSize: 28.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                )
                    : TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent,
                  fontFamily: 'DancingScript-VariableFont_wght',
                ),
                duration: Duration(milliseconds: 500), // Adjust the duration as needed
                curve: Curves.easeInOut, // Adjust the curve as needed
                child: Text(
                  _touch ? 'Capturing...' : 'Place your finger before click',
                ),
              ),






                 /*style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold,  color: Colors.blueAccent,fontFamily:'DancingScript-VariableFont_wght' ),*/


                          )
                      ),
                    ),
                  ),
                  )
                    )
                ]
                 ),
            ),
            Expanded(
              child: Center(
                child: IconButton(
                  icon: Icon(_toggled ? Icons.favorite : Icons.favorite_border),
                  color: Colors.red,
                  iconSize: 128,
                  onPressed: () {
                    if (_toggled) {
                      _untoggle();
                      _touch =false;


                    } else {
                      _toggle();
                      _touch =true;

                    }
                  },
                ),
              ),
            ),
            Expanded(
              child: Container(
                margin: EdgeInsets.all(12),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(18),
                    ),
                    color: Colors.black),
                child: Chart(_data),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

