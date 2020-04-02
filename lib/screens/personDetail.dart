import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'addPerson.dart';
import 'editPerson.dart';

String date;
List<Map<String, dynamic>> temp = [];
List<Map<String, dynamic>> people = [];
bool _isLoading = true;

class PersonDetail extends StatefulWidget{

  PersonDetail(String _date){
    date = _date;
  }

  @override
  State<StatefulWidget> createState() {
    return PersonDetailState();
  }
}

class PersonDetailState extends State<PersonDetail>{

  void fetchPeople(String date) async{
      var databasesPath = await getDatabasesPath();
      String path = join(databasesPath, "people.db");

      Database db;
      db = await openDatabase(path, version: 1);

      for(int i=0; i< date.length; i++){
        people = await db.rawQuery("SELECT * FROM people WHERE date == '$date'");

        setState(() {
          _isLoading = false;
        });
      }
    }

  @override
  void initState() {
    super.initState();
    fetchPeople(date);
  }

  final globalKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: globalKey,
      appBar: AppBar(
        title: Center(
          child: Text(
            "Added People",
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.bold),
          ),
        ),
      ),
      body: _isLoading ? Center(
        child: CircularProgressIndicator( backgroundColor: Colors.teal, ),
      ) :
      Container(
        padding: EdgeInsets.fromLTRB(35.0, 40.0, 0.0, 0.0),
        child: Column(
          children: <Widget>[
            Text(
              date,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 30.0,
                color: Colors.teal,
                fontWeight: FontWeight.bold,
                fontFamily: 'Montserrat'),
            ),
            Expanded(
              child: ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: people.length,
              itemBuilder: (BuildContext buildContext, int index){
                return Card(
                  color: Colors.white,
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 6.0),
                    child: Center(
                      child: ListTile(
                        onTap: () => {},
                        title: Text(
                          "Name: "+people[index]['name'],
                          style: TextStyle(
                            color: Colors.teal,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Montserrat',
                            fontSize: 21
                            ),
                          ),
                        subtitle: Text(
                          "Phone number: "+people[index]['phone'],
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Montserrat',
                            fontSize: 16
                          ),
                        ),
                        trailing: Container(
                          child: Column(
                          children: <Widget>[
                            GestureDetector(
                              child: Icon(
                                Icons.edit,
                                color: Colors.teal,
                                size: 28,
                              ),
                              onTap: () => {
                                editTapped(people[index]['name'], people[index]['id'], people[index]['phone'], context),
                              }
                            ),
                            GestureDetector(
                              child: Icon(
                                Icons.delete,
                                color: Colors.red,
                                size: 28,
                              ),
                              onTap: () => {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context){
                                    return AlertDialog(
                                      title: Text("Alert"),
                                      content: Text("Are you sure you want to delete this entry"),
                                      actions: <Widget>[
                                        FlatButton(
                                          onPressed: () => {
                                            Navigator.of(context).pop(),
                                            deleteEntry(people[index]['id'], context)
                                            }, 
                                          child: Text("Yes")
                                        ),
                                        FlatButton(
                                          onPressed: () => {
                                            Navigator.of(context).pop()
                                          }, 
                                          child: Text("Close")
                                        )
                                      ],
                                    );
                                  }
                                )
                              },
                            )
                          ],
                        ),
                        )
                      )
                    ) 
                  ),
                );
                },
            ),
            )  
          ],
        )
      ),
    );

    
  }

  deleteEntry(int id, BuildContext context) async{
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, "people.db");

    Database db;
    db = await openDatabase(path, version: 1);
    
    var result = await db.delete('people', where: "id = ?", whereArgs: [id]);

    if(result == 0){
      final snackBar = SnackBar(
          content: Text('Something went Wrong!'),
          action: SnackBarAction(
            label: 'Close',
            onPressed: () {
              // Some code to undo the change.
            },
          ),
        );
        globalKey.currentState.showSnackBar(snackBar);
        setState(() {
          
        });
    }
    else{
      final snackBar = SnackBar(
          content: Text('Entry deleted successfuly'),
          action: SnackBarAction(
            label: 'Close',
            onPressed: () {
              // Some code to undo the change.
            },
          ),
        );
        globalKey.currentState.showSnackBar(snackBar);
        setState(() {
          
        });
    }
  }

  editTapped(String name, int id, String phone, BuildContext context){
      Navigator.of(context).pushNamed('/EditPerson');
      editContact(name, id, phone);
    }
  
}