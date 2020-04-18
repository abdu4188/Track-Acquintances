import 'dart:io';
import 'package:flutter/services.dart';
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
      onWillPop: () => onWillPop(context) ,
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
                        colors: <Color>[Colors.green, Colors.teal])),
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
              CustomListTile('Home', Icons.home, homeTapped),
              CustomListTile('Add Person', Icons.add, addTapped),
              CustomListTile('View added People', Icons.people, listTapped),
              CustomListTile('View Stats', Icons.show_chart, statusTapped),
              CustomListTile('Symptoms', Icons.check_circle_outline, symptomsTapped),
            ]
          ),
        ),
      body: Container(
        child: Stack(
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.green,
                    Colors.teal,
                  ]
                )
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white60, width:  2.0)
                        ),
                        padding:  EdgeInsets.all(8),
                        child: CircleAvatar(
                          backgroundColor: Colors.white,
                          child: Icon(Icons.image)
                          // Image.asset(
                          //   "images/logo.png",
                          //   height: 550,
                          //   width: 550,
                          // )
                        ),
                      ),
                    ]
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Text(
                    "Genesis Technologies",
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.bold,
                      fontSize: 23,
                      color: Colors.white
                    ),
                  ),
                  SizedBox(
                    height: 6,
                  ),
                  Text(
                    "Please take the following precautions",
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 16,
                      color: Colors.white70
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 300),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                )
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 200),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30)
                )
              ),
              child: Padding(
                padding: EdgeInsets.all(0),
                child: GridView(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
                  children: <Widget>[
                    Container(
                      height: 200,
                      width: 100,
                      child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)
                      ),
                      elevation: 10,
                      child: Container(
                        margin: EdgeInsets.all(4),
                        color: Colors.white,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            Image.asset(
                              'images/cough.PNG',
                              height: 80,
                            ),
                            Text(
                              "Cover your mouth and nose when you sneeze or cough",
                              style: TextStyle(
                                fontFamily: 'Montserrat',
                                fontSize: 13.8,
                                
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    ),
                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)
                      ),
                      elevation: 10,
                      child: Container(
                        margin: EdgeInsets.all(4),
                        color: Colors.white,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            Image.asset(
                              'images/eye.PNG',
                              height: 80,
                            ),
                            Text(
                              "Avoid touching your face with unwashed hands",
                              style: TextStyle(
                                fontFamily: 'Montserrat',
                                fontSize: 13.8,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)
                      ),
                      elevation: 10,
                      child: Container(
                        margin: EdgeInsets.all(4),
                        color: Colors.white,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            Image.asset(
                              'images/home.PNG',
                              height: 80,
                            ),
                            Text(
                              "Stay home if you don't need to get out for critical matters",
                              style: TextStyle(
                                fontFamily: 'Montserrat',
                                fontSize: 13.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)
                      ),
                      elevation: 10,
                      child: Container(
                        margin: EdgeInsets.all(4),
                        color: Colors.white,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            Image.asset(
                              'images/wash.PNG',
                              height: 80,
                            ),
                            Text(
                              "Wash your hands frequently for atleast 20 seconds with soap.",
                              style: TextStyle(
                                fontFamily: 'Montserrat',
                                fontSize: 13.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)
                      ),
                      elevation: 10,
                      child: Container(
                        margin: EdgeInsets.all(4),
                        color: Colors.white,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            Image.asset(
                              'images/shake.PNG',
                              height: 80,
                            ),
                            Text(
                              "Avoid hand shakes and keep your distance with people",
                              style: TextStyle(
                                fontFamily: 'Montserrat',
                                fontSize: 13.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                )
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

Future<bool> onWillPop(BuildContext context){
    return showDialog(
    context: context,
    builder: (context) => new AlertDialog(
      title: new Text('Are you sure?'),
      content: new Text('Do you want to exit the App'),
      actions: <Widget>[
        new FlatButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text("No"),
        ),
        SizedBox(height: 16),
        new FlatButton(
          onPressed: () => SystemNavigator.pop(),
          child: Text("Yes"),
        ),
      ],
    ),
  ) ??
      false;
}

}