import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:heartratemonitor/screens/dashboard.dart';
import 'package:heartratemonitor/tenseconds/app.dart';

class AuthService{
createuser(data, context) async {
  try {
    final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: data['email'],
      password:data['password'] ,
    );
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) =>  Dashboard(),));

  } catch (e) {
    showDialog(context: context, builder: (context) {
      return AlertDialog(
        title: Text("Sign Up Failed"),
        content: Text(e.toString()),

      );
    });
  }









  }

  login(data, context) async {
    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: data['email'],
        password: data['password'],
      );
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) =>  MyAppp(),));



    } catch (e) {
      showDialog(context: context, builder: (context) {
        return AlertDialog(
          title: Text("Login Error"),
          content: Text(e.toString()),

        );
      });
    }
}}









