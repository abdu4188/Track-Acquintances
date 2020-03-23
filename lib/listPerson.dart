import 'package:flutter/material.dart';

class ListPerson extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return null;
  }
}

class ListPersonState extends State<ListPerson>{
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
              fontWeight: FontWeight.bold
            ),
          ),
        ),
      ),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: <Color>[ 
                  Colors.teal, Colors.tealAccent
                  ])
              ),
              child: Container(
                child: Column(
                  children: <Widget>[
                    Material(
                      elevation: 10,
                      borderRadius: BorderRadius.all(Radius.circular(50.0)),
                      child: Image.asset('images/corona.JPG', width: 100, height: 100),
                    )
                  ],
                ),
              ),
            ),
            CustomListTile('Add Person', Icons.add, addTapped()),
            CustomListTile('View added People', Icons.people, listTapped()),
          ],
        ),
      ),
      body: Container(
          child: Text('list'),
      ),
    );
  }
  
  addTapped(){}
  listTapped(){}
}


class CustomListTile extends StatelessWidget{
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
          border: Border(bottom: BorderSide(color: Colors.grey))
        ),
        child: InkWell(
          splashColor: Colors.teal,
          onTap: () => onTap,
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
                        fontSize: 16,
                        fontFamily: 'Montserrat'
                      ),
                    ),
                  )
                  ],
                )
              ],
            ),
          )
        ),
      )
    );
  }
}
