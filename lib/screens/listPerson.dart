import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:track_aquintances/screens/personDetail.dart';

class ListPerson extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return ListPersonState();
  } 
}

class ListPersonState extends State<ListPerson>{

  List<Map> date = [];

  void fetchDate() async{
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, "people.db");

    Database db;
    db = await openDatabase(path, version: 1);
    
    date = await db.rawQuery("SELECT DISTINCT date FROM people");
    setState(() {
      
    });

  }

  @override
  void initState(){
    super.initState();
    fetchDate();
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
      body: Container(
        child: Column(
          children: <Widget>[
            Expanded(
              child: ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: date.length,
                itemBuilder: (BuildContext context, int index){
                  return Card(
                    color: Colors.white,
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 14.0, horizontal: 16.0),
                      child: Center(
                        child: ListTile(
                          onTap: () => dateTapped(date[index]['date'], context),
                          title: Text(date[index]['date']),
                          subtitle: Icon(Icons.navigate_next),
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

  dropClicked() {}

  dateTapped(String date, BuildContext context) async{
    await Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => PersonDetail(date))
    );
    Navigator.of(context).pop();
  }
  
}