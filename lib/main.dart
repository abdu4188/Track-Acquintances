import 'package:flutter/material.dart';
import 'screens/addPerson.dart';

void main() => runApp(Home());

final navigatorKey = GlobalKey<NavigatorState>();
class Home extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      title: 'Track Acquaintances',
      theme: ThemeData(
        primarySwatch: Colors.teal
      ),
      home: Scaffold(
        body: Formscreen(),
      ),
    );
  }
  
  
}