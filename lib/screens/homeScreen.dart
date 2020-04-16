import 'dart:io';
import 'package:track_aquintances/drawer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class HomeScreen extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return HomeScreenState();
  }
}

class HomeScreenState extends State<HomeScreen>{

  saveToDb() async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, "people.db");

    await openDatabase(path, version: 1, onOpen: (db) {
    }, onCreate: (Database db, int version) async {
      await db.execute('''CREATE TABLE IF NOT EXISTS people
      (
        id INTEGER PRIMARY KEY,
        name TEXT,
        phone TEXT,
        date TEXT,
        location TEXT
      )
      '''
      );
    });
  }

  @override
  void initState() {
    saveToDb();
    syncToFirebase();
    super.initState();
  }

  List<Map<String, dynamic>> people = [];
  List<Map<String, dynamic>> mPeople;
  List firebaseIds = [];

  syncToFirebase() async {
    try {
      final result = await InternetAddress.lookup('fast.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {

        var data = Firestore.instance.collection('log').getDocuments().then(
          (QuerySnapshot snapshot) => {
            snapshot.documents.forEach((f) => 
            {firebaseIds.add(f.data['id']),
            getDbData()}
            )
          }
        );
      }
    } on SocketException catch (_) {
      print('not connected');
    }
  }

  getDbData() async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, "people.db");

    Database db;
    db = await openDatabase(path, version: 1);
    people = await db.rawQuery("SELECT * FROM people");
    mPeople = people.map((m) => Map.of(m)).toList();

    for(var i=0; i< firebaseIds.length; i++){
      mPeople.removeWhere((item) => item['id'] == int.parse(firebaseIds[i]));
    }

    FirebaseUser user = await FirebaseAuth.instance.currentUser();

    for (var i = 0; i < mPeople.length; i++) {
      Firestore.instance.collection('log').document().setData(
        {
          "id": mPeople[i]['id'].toString(),
          "name": mPeople[i]['name'],
          "phone": mPeople[i]['phone'],
          "date": mPeople[i]['date'],
          "location": mPeople[i]['location'],
          "user": user.uid
        }
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onWillPop ,
      child: Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            "Track Acquintances",
            style: TextStyle(
                color: Colors.white,
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.bold),
          ),
        ),
      ),
      drawer: Drawer(
          child: ListView(
            children: <Widget>[
              DrawerHeader(
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        colors: <Color>[Colors.teal, Colors.tealAccent])),
                child: Container(
                  child: Column(
                    children: <Widget>[
                      Material(
                          elevation: 10,
                          borderRadius: BorderRadius.all(Radius.circular(30.0)),
                          child: GestureDetector(
                            child: Image.asset('images/covid.png',
                                width: 100, height: 100),
                            onTap: () => Navigator.of(context).popAndPushNamed('/HomeScreen'),
                          )
                      )
                    ],
                  ),
                ),
              ),
              CustomListTile('Add Person', Icons.add, addTapped),
              CustomListTile('View added People', Icons.people, listTapped),
              CustomListTile('View Stats', Icons.show_chart, statusTapped),
              CustomListTile('Symptoms', Icons.check_circle_outline, symptomsTapped),
              CustomListTile('About', Icons.info, aboutTapped),
            ],
          ),
        ),
      body: Container(
        child: ListView(
          children: <Widget>[
            Text(
              "Please read the following precautions",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18.0,
                color: Colors.teal,
                fontFamily: 'Montserrat'),
            ),
            Container(
              height: 60,
            ),
            Image.asset(
              'images/home.PNG',
              width: 120,
              height: 120,
            ),
            Text(
              "Stay at home if there is no critical matter that needs your attention",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.teal,
                fontSize: 15
              ),
            ),
            Container(
              height: 40,
            ),
            Image.asset(
              'images/wash.PNG',
              width: 120,
              height: 120,
            ),
            Text(
              "Wash your hands frequently",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.teal,
                fontSize: 15
              ),
            ),
            Container(
              height: 40,
            ),
            Image.asset(
              'images/shake.PNG',
              width: 120,
              height: 120,
            ),
            Text(
              "Avoid hand shakes and keep your distance from people",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.teal,
                fontSize: 15
              ),
            ),
            Container(
              height: 40,
            ),
            Image.asset(
              'images/eye.PNG',
              width: 120,
              height: 120,
            ),
            Text(
              "Avoid touching your face",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.teal,
                fontSize: 15
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => {
            Navigator.of(context).pushNamed('/AddPerson')
        }
      ),  
    ), 
    ); 
    
    }

DateTime currentBackPressTime;

Future<bool> onWillPop() {
  print("object");
    DateTime now = DateTime.now();
    if (currentBackPressTime == null || 
        now.difference(currentBackPressTime) > Duration(seconds: 2)) {
      currentBackPressTime = now;
      SnackBar(content: Text("Press the back button twice to exit"));
      return Future.value(false);
    }
    return Future.value(true);
  }

}