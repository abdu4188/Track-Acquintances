import 'package:flutter/material.dart';
import 'dart:async';
import 'addPerson.dart';

void main() => runApp(Home());

class Home extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Track Acquaintances',
      theme: ThemeData(
        primarySwatch: Colors.teal
      ),
      home: Formscreen(),
    );
  }
  
}