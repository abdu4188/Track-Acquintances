import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return SplashScreenState();
  }
  
}

class SplashScreenState extends State<SplashScreen>{
  @override
  initState(){
    FirebaseAuth.instance
    .currentUser().then(
      (currentUser) => {
        if(currentUser == null){
          {Navigator.pushReplacementNamed(context, "/login")}
        }
        else{
          Firestore.instance
          .collection("users")
          .document(currentUser.uid)
          .get()
          .then((DocumentSnapshot result) => 
            startTime()
          ).catchError((err) => print(err))
        }
      }
    ).catchError((err) => print(err));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal,
      body: new Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "Track Acquintances",
              style: TextStyle(
                fontSize: 35.0,
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontFamily: 'Montserrat'
              ),
            ),
            Image.asset(
              'images/covid.png',
              height: 80,
              width: 80,
              )
          ],
        )
      ),
    );
  }
  
  startTime() async {
    var _duration = new Duration(seconds: 3);
    return new Timer(_duration, navigationPage);
  }

  void navigationPage() {
    Navigator.of(context).pushReplacementNamed('/HomeScreen');
  }
}