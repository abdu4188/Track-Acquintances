import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:track_aquintances/screens/addPerson.dart';
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
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                        child: Image.asset('images/covid.png',
                            width: 100, height: 100),
                      )
                    ],
                  ),
                ),
              ),
              CustomListTile('Add Person', Icons.add, addTapped),
              CustomListTile('View added People', Icons.people, listTapped),
              CustomListTile('View Stats', Icons.show_chart, statusTapped),
              CustomListTile('Symptoms', Icons.check_circle_outline, symptomsTapped),
            ],
          ),
        ),
      body: Container(
        child: ListView(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(20),
              child: Card(
                child: Column(
                  children: <Widget>[
                    Text(
                      "Genesis Technologies",
                      style: TextStyle(
                        fontSize: 16.0,
                          color: Colors.teal,
                          fontWeight: FontWeight.bold,
                        fontFamily: 'Montserrat'),
                    ),
                    Text(
                      'Track Acquintances is an app to help you track the people you met with recently to trace your contacts. We highly recommend you to stay home if you don\'t need to go out for critical reasons. Click the + icon to add a person',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18.0,
                        // color: Colors.teal,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Montserrat'),
                    ),
                  ],
                )
              ),
            ),
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
            Navigator.of(context).popAndPushNamed("/AddPerson")
        }
      ),  
    );
  }

}