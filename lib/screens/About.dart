import 'package:flutter/material.dart';

import 'addPerson.dart';

class AboutPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return AboutPageState();
  }
}

class AboutPageState extends State<AboutPage>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            "About",
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
            Center(
              child: Text(
                "Genesis Technologies",
                style: TextStyle(
                  fontSize: 25.0,
                    color: Colors.teal,
                    fontWeight: FontWeight.bold,
                  fontFamily: 'Montserrat'),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20),
              child: Card(
                child: Column(
                  children: <Widget>[
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
          ],
        ),
      ),

    );
  }
}