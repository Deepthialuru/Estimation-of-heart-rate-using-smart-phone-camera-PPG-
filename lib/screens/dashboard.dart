import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'login_screen.dart';

void main() {
  runApp(new MaterialApp(
    home: new Dashboard(),



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
class Dashboard extends StatefulWidget {

  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  var islogoutloading=false;

  logout() async{
  setState(() {
    islogoutloading=true;

  });

    await FirebaseAuth.instance.signOut();

  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) =>  LoginView(),));






    setState(() {
    islogoutloading=false;

  });


  }

/*
String value='Text';
void Clickme(){

setState(() {
value='tutor';


});


}
*/
  @override
  Widget build(BuildContext context) {
    return Scaffold(
appBar:  AppBar(
  backgroundColor: Colors.blueAccent,

  actions: [
    IconButton(onPressed: (){logout();}, icon:
    islogoutloading ? CircularProgressIndicator():


    Icon(Icons.exit_to_app)),


        ],


),
body:
Text("HELLO"),

);






  }
}








