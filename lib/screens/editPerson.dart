import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import 'package:track_aquintances/screens/status.dart';
import 'package:track_aquintances/screens/symptoms.dart';
import 'addPerson.dart';
import 'contactsPage.dart';
import 'listPerson.dart';
import 'package:path/path.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:track_aquintances/drawer.dart';

class EditScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return EditScreenState();
  }
}

bool _nameValidate = false;
bool _phoneValidate = false;
TextEditingController nameController = new TextEditingController();
TextEditingController phoneController = new TextEditingController();
int personId;

class EditScreenState extends State<EditScreen> {

  DateTime _selectedDate = DateTime.now();

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
        errorText: _nameValidate ? "Value can't be empty" : null,
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
        errorText: _phoneValidate ? "Value can't be empty" : null,
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
              "Edit Person",
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
              CustomListTile('Home', Icons.add, homeTapped),
              CustomListTile('Add Person', Icons.add, addTapped),
              CustomListTile('View added People', Icons.people, listTapped),
              CustomListTile('View Stats', Icons.show_chart, statusTapped),
              CustomListTile('Symptoms', Icons.check_circle_outline, symptomsTapped),
            ],
          ),
        ),
        body: Column(
          children: <Widget>[
            Expanded(
              child: Builder(
          builder: (context) => 
            ListView(
            children: <Widget>[
              Container(
                  child: Stack(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.fromLTRB(15.0, 40.0, 0.0, 0.0),
                    child: Text(
                      'Edit Person',
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
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          color: Colors.teal
                          ),
                    )),
                    
                    RaisedButton(
                      onPressed: () async {
                        final PermissionStatus permissionStatus = await _getPermission();
                        if (permissionStatus == PermissionStatus.granted) {
                          Navigator.push(
                              context, MaterialPageRoute(builder: (context) => ContactsPage()));
                        } else {
                          //If permissions have been denied show standard cupertino alert dialog
                          showDialog(
                              context: context,
                              builder: (BuildContext context) => AlertDialog(
                                    title: Text('Permissions error'),
                                    content: Text('Please enable contacts access '
                                        'permission in system settings'),
                                    actions: <Widget>[
                                      FlatButton(
                                        child: Text('Close'),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                    ],
                                  ));
                        }
                      },
                      child: Text(
                        'Select from contacts',
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          color: Colors.teal
                          ),
                      )
                    ),
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
                          onTap: () => addPerson(context),
                          child: Center(
                            child: Text(
                              'Edit',
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
          )
          ),
            )
          ],
        )
        );
  }
  String stringDate;
  addPerson(BuildContext context) {
    var formatter = new DateFormat('yyyy-MM-dd');
    stringDate = formatter.format(_selectedDate);

    setState(() {
      nameController.text.isEmpty ? _nameValidate = true : _nameValidate = false;
      phoneController.text.isEmpty ? _phoneValidate = true : _phoneValidate = false;
    });
    if(_nameValidate == false && _phoneValidate == false){
      saveToDb(context);
    }    
  }
  saveToDb(BuildContext context) async{
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

    int insertResponse = await db.update("people", {
      "name": nameController.text,
      "phone": phoneController.text,
      "date": stringDate
      }, where: "id == $personId");

    if(insertResponse == -1){
      final snackBar = SnackBar(
          content: Text('Something went Wrong!'),
          action: SnackBarAction(
            label: 'Close',
            onPressed: () {
              // Some code to undo the change.
            },
          ),
        );
        BuildContext context;
        Scaffold.of(context).showSnackBar(snackBar);
    }
    else{
      FocusScope.of(context).unfocus();
      _selectedDate = DateTime.now();
      nameController.text = "";
      phoneController.text = "";
      final snackBar = SnackBar(
          content: Text('Entry edited successfully!'),
          action: SnackBarAction(
            label: 'Close',
            onPressed: () {
              Scaffold.of(context).hideCurrentSnackBar();
            },
          ),
        );
        Scaffold.of(context).showSnackBar(snackBar);
    }
  }


  setValuesInForm(Contact contact){
    
  }
}


  
addTapped(BuildContext context) async{
   await Navigator.of(context)
      .push(MaterialPageRoute(builder: (context) => Formscreen()));
  Navigator.of(context).pop();
}

listTapped(BuildContext context) async {
  await Navigator.of(context)
      .push(MaterialPageRoute(builder: (context) => ListPerson()));
  Navigator.of(context).pop();
}

statusTapped(BuildContext context) async {
  await Navigator.of(context)
      .push(MaterialPageRoute(builder: (context) => StatusPage()));
  Navigator.of(context).pop();
}

symptomsTapped(BuildContext context) async {
  await Navigator.of(context)
      .push(MaterialPageRoute(builder: (context) => Symptoms()));
  Navigator.of(context).pop();
}

Contact contact;



setValuesInForm(Contact contact){
  nameController.text = contact.displayName;
  phoneController.text = contact.phones.elementAt(0).value;
}

editContact(String name, int id, String phone){
  personId = id;
  nameController.text = name;
  phoneController.text = phone;
}


  Future<PermissionStatus>  _getPermission() async{
    final PermissionStatus permission = await PermissionHandler()
        .checkPermissionStatus(PermissionGroup.contacts);
    if (permission != PermissionStatus.granted &&
        permission != PermissionStatus.denied ){
      final Map<PermissionGroup, PermissionStatus> permissionStatus =
          await PermissionHandler()
              .requestPermissions([PermissionGroup.contacts]);
      return permissionStatus[PermissionGroup.contacts] ??
          PermissionStatus.unknown;
    } else {
      return permission;
    }
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
      title: 'Track Acquintances',
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      home: Formscreen(),
    );
  }
}