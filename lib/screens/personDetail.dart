import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        child: Stack(
          children: <Widget>[
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
                  SingleChildScrollView(
                    child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: people.length,
                    itemBuilder: (BuildContext context, int index){
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
          ],
          ),
        ),
      );
  }
  
}