import 'package:flutter/material.dart';
import 'dart:async';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import 'listPerson.dart';
import 'package:path/path.dart';

class Formscreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return FormscreenState();
  }
}

class FormscreenState extends State<Formscreen> {
  DateTime _selectedDate = DateTime.now();
  TextEditingController nameController = new TextEditingController();
  TextEditingController phoneController = new TextEditingController();

  @override
  initState(){
    super.initState();
  }

  Widget _buildDateFIeld() {
    return Container(
      padding: const EdgeInsets.all(10),
      child: Center(
        child: Row(
          children: <Widget>[
            Expanded(
                child: Column(
              children: <Widget>[
                Text(
                  "When did you meet this person?",
                  style: TextStyle(fontSize: 16, fontFamily: 'Montserrat'),
                ),
              ],
            ))
          ],
        ),
      ),
    );
  }

  Widget _buildNameField() {
    return TextField(
      controller: nameController,
      decoration: InputDecoration(
          icon: Icon(Icons.person),
          labelText: 'Name',
          labelStyle: TextStyle(
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.bold,
              color: Colors.grey)),
    );
  }

  Widget _builPhoneField() {
    return TextField(
      controller: phoneController,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
          icon: Icon(Icons.phone),
          labelText: 'Phone Number',
          labelStyle: TextStyle(
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.bold,
              color: Colors.grey)),
    );
  }

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: _selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != _selectedDate)
      setState(() {
        _selectedDate = picked;
      });
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
                        borderRadius: BorderRadius.all(Radius.circular(50.0)),
                        child: Image.asset('images/corona.JPG',
                            width: 100, height: 100),
                      )
                    ],
                  ),
                ),
              ),
              CustomListTile('Add Person', Icons.add, addTapped),
              CustomListTile('View added People', Icons.people, listTapped),
            ],
          ),
        ),
        body: ListView(
          children: <Widget>[
            Container(
                child: Stack(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.fromLTRB(15.0, 40.0, 0.0, 0.0),
                  child: Text(
                    'Add Person',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 40.0,
                        color: Colors.teal,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Montserrat'),
                  ),
                )
              ],
            )),
            Container(
              padding: EdgeInsets.only(top: 35.0, left: 20.0),
              child: Column(
                children: <Widget>[
                  _buildDateFIeld(),
                  RaisedButton(
                      onPressed: () => _selectDate(context),
                      child: Text(
                        'Select date',
                        style: TextStyle(fontFamily: 'Montserrat'),
                      )),
                  _buildNameField(),
                  SizedBox(
                    height: 10.0,
                  ),
                  _builPhoneField(),
                  SizedBox(
                    height: 25.0,
                  ),
                  Container(
                    height: 40.0,
                    child: Material(
                      borderRadius: BorderRadius.circular(20.0),
                      shadowColor: Colors.greenAccent,
                      color: Colors.teal,
                      elevation: 7.0,
                      child: GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onTap: () => addPerson(),
                        child: Center(
                          child: Text(
                            'Add',
                            style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ));
  }
  String stringDate;
  addPerson() {
    var formatter = new DateFormat('yyyy-MM-dd');
    stringDate = formatter.format(_selectedDate);

    saveToDb();
    
  }
  saveToDb() async{
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, "people.db");

    Database db;

    db = await openDatabase(path, version: 1, onOpen: (db) {
    }, onCreate: (Database db, int version) async {
      await db.execute('''CREATE TABLE IF NOT EXISTS people
      (
        id INTEGER PRIMARY KEY,
        name TEXT,
        phone TEXT,
        date TEXT
      )
      '''
      );
    });

    print( await db.insert("people", {
      "name": nameController.text,
      "phone": phoneController.text,
      "date": stringDate
      }));

  }

}


addTapped(BuildContext context) async{
  Navigator.of(context).pop();
}

listTapped(BuildContext context) async {
  await Navigator.of(context)
      .push(MaterialPageRoute(builder: (context) => ListPerson()));
  Navigator.of(context).pop();
}

class CustomListTile extends StatelessWidget {
  final String _name;
  final IconData _icon;
  final Function onTap;

  CustomListTile(this._name, this._icon, this.onTap);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.fromLTRB(9, 0, 9, 0),
        child: Container(
          decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.grey))),
          child: InkWell(
              splashColor: Colors.teal,
              onTap: () => onTap(context),
              child: Container(
                height: 50,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Icon(_icon),
                        Padding(
                          padding: EdgeInsets.all(10),
                          child: Text(
                            _name,
                            style: TextStyle(
                                fontSize: 16, fontFamily: 'Montserrat'),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              )),
        ));
  }
}

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Formscreen(),
    );
  }
}