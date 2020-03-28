import 'package:flutter/material.dart';
import 'screens/addPerson.dart';
import 'screens/splashScreen.dart';

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
        body: SplashScreen(),
      ),
      routes: <String, WidgetBuilder>{
      '/HomeScreen': (BuildContext context) => new Formscreen()
      },
    );
  }
  
  
}