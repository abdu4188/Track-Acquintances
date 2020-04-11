import 'package:flutter/material.dart';
import 'package:track_aquintances/screens/addPerson.dart';

class Symptoms extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return SymptomsState();
  }
}

enum Cough {yes, no}
enum Fever {yes, no}
enum Tiredness {yes, no}
enum Breathing {yes, no}

Cough 
_cough = Cough.no;
Fever _fever = Fever.no;
Tiredness _tiredness = Tiredness.no;
Breathing _breathing = Breathing.no;

class SymptomsState extends State<Symptoms>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Center(
            child: Text(
              "Symptoms",
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
        body: Column(
          children: <Widget>[
            Expanded(
              child: ListView(
                children: <Widget>[
                  Card(
                    margin: EdgeInsets.all(0),
                    child: Padding(
                      padding: EdgeInsets.all(7),
                      child: Stack(
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.all(10),
                            child: Column(
                              children: <Widget>[
                                Center(
                                  child: Text(
                                    "Do you have dry Cough?",
                                    style: TextStyle(
                                      color: Colors.teal,
                                      fontSize: 16, 
                                      fontFamily: 'Montserrat'
                                    ),
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Radio(
                                      value: Cough.yes,
                                      groupValue: _cough,
                                      onChanged: (Cough value) {
                                        setState(() {
                                          _cough = value;
                                        });
                                      },
                                    ),
                                    Text("Yes"),
                                    Radio(
                                      value: Cough.no,
                                      groupValue: _cough,
                                      onChanged: (Cough value) {
                                        setState(() {
                                          _cough = value;
                                        });
                                      },
                                    ),
                                    Text("No"),
                                  ],
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    )
                  ),
                  Card(
                    margin: EdgeInsets.all(0),
                    child: Padding(
                      padding: EdgeInsets.all(7),
                      child: Stack(
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.all(10),
                            child: Column(
                              children: <Widget>[
                                Center(
                                  child: Text(
                                    "Do you have a fever?",
                                    style: TextStyle(
                                      color: Colors.teal,
                                      fontSize: 16, 
                                      fontFamily: 'Montserrat'
                                    ),
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Radio(
                                      value: Fever.yes,
                                      groupValue: _fever,
                                      onChanged: (Fever value) {
                                        setState(() {
                                          _fever = value;
                                        });
                                      },
                                    ),
                                    Text("Yes"),
                                    Radio(
                                      value: Fever.no,
                                      groupValue: _fever,
                                      onChanged: (Fever value) {
                                        setState(() {
                                          _fever = value;
                                        });
                                      },
                                    ),
                                    Text("No"),
                                  ],
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    )
                  ),
                  Card(
                    margin: EdgeInsets.all(0),
                    child: Padding(
                      padding: EdgeInsets.all(7),
                      child: Stack(
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.all(10),
                            child: Column(
                              children: <Widget>[
                                Center(
                                  child: Text(
                                    "Do you feel tired frequently?",
                                    style: TextStyle(
                                      color: Colors.teal,
                                      fontSize: 16, 
                                      fontFamily: 'Montserrat'
                                    ),
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Radio(
                                      value: Tiredness.yes,
                                      groupValue: _tiredness,
                                      onChanged: (Tiredness value) {
                                        setState(() {
                                          _tiredness = value;
                                        });
                                      },
                                    ),
                                    Text("Yes"),
                                    Radio(
                                      value: Tiredness.no,
                                      groupValue: _tiredness,
                                      onChanged: (Tiredness value) {
                                        setState(() {
                                          _tiredness = value;
                                        });
                                      },
                                    ),
                                    Text("No"),
                                  ],
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    )
                  ),
                  Card(
                    margin: EdgeInsets.all(0),
                    child: Padding(
                      padding: EdgeInsets.all(7),
                      child: Stack(
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.all(10),
                            child: Column(
                              children: <Widget>[
                                Center(
                                  child: Text(
                                    "Do you have difficulty breathing?",
                                    style: TextStyle(
                                      color: Colors.teal,
                                      fontSize: 14, 
                                      fontFamily: 'Montserrat'
                                    ),
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Radio(
                                      value: Breathing.yes,
                                      groupValue: _breathing,
                                      onChanged: (Breathing value) {
                                        setState(() {
                                          _breathing = value;
                                        });
                                      },
                                    ),
                                    Text("Yes"),
                                    Radio(
                                      value: Breathing.no,
                                      groupValue: _breathing,
                                      onChanged: (Breathing value) {
                                        setState(() {
                                          _breathing = value;
                                        });
                                      },
                                    ),
                                    Text("No"),
                                  ],
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    )
                  ),
                ],
              ),
            ),
            Container(
              width: 100,
              margin: EdgeInsets.all(10),
              child: RaisedButton(
                child: Text(
                  "Submit",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14, 
                      fontFamily: 'Montserrat'
                  ),
                  ),
                onPressed: () => submitTapped(context),
                color: Colors.teal,
              ),
            )
          ],
        )
      );
  }
  submitTapped(BuildContext context){
    if(_breathing == Breathing.yes && _fever == Fever.yes && _tiredness == Tiredness.yes && _cough == Cough.yes){
      showDialog(
        context: context,
        builder: (BuildContext context){
          return AlertDialog(
            title: Text("Alert"),
            content: Text(
              "You have all 4 symptoms of COVID-19. Please isolate your self and seek medical attention.",
              style: TextStyle(
                fontFamily: 'Montserrat',
                color: Colors.red
              ),
            ),
            actions: <Widget>[
            new FlatButton(
              child: new Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
          );
        }
      );
    }
    else if(_breathing == Breathing.yes || _fever == Fever.yes || _tiredness == Tiredness.yes || _cough == Cough.yes){
      showDialog(
        context: context,
        builder: (BuildContext context){
          return AlertDialog(
            content: Text(
              "You have one or more of the symptoms but not all. Please isolate your self and monitor yur symptoms. If they persist or get worse please seak medical attention.",
              style: TextStyle(
                fontFamily: 'Montserrat',
                color: Colors.orange,
              ),
            ),
            actions: <Widget>[
            new FlatButton(
              child: new Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
          );
        }
      );
    }
    else {
      showDialog(
        context: context,
        builder: (BuildContext context){
          return AlertDialog(
            content: Text(
              "You have none of the symptoms. Stay at home if you don't need to attend a critical matter.",
              style: TextStyle(
                fontFamily: 'Montserrat',
                color: Colors.teal,
              ),
            ),
            actions: <Widget>[
            new FlatButton(
              child: new Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
          );
        }
      );
    }
  }
}