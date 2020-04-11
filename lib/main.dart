import 'package:flutter/material.dart';
import 'package:track_aquintances/screens/About.dart';
import 'package:track_aquintances/screens/Login.dart';
import 'package:track_aquintances/screens/Register.dart';
import 'package:track_aquintances/screens/addPerson.dart';
import 'package:track_aquintances/screens/contactsPage.dart';
import 'package:track_aquintances/screens/editPerson.dart';
import 'package:track_aquintances/screens/homeScreen.dart';
import 'package:track_aquintances/screens/listPerson.dart';
import 'package:track_aquintances/screens/status.dart';
import 'package:track_aquintances/screens/symptoms.dart';
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
      '/HomeScreen': (BuildContext context) => new HomeScreen(),
      '/AddPerson' : (BuildContext context) => new Formscreen(),
      '/EditPerson' : (BuildContext context) => new EditScreen(),
      '/ListDates' : (BuildContext context) => new ListPerson(),
      '/Status' : (BuildContext context) => new StatusPage(),
      '/Symptoms' : (BuildContext context) => new Symptoms(),
      '/Contacts' : (BuildContext context) => new ContactsPage(),
      '/login': (BuildContext context) => LoginPage(),
      '/register': (BuildContext context) => RegisterPage(),
      '/About' : (BuildContext context) => AboutPage(),
      },
    );
  }
  
  
}