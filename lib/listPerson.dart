import 'package:flutter/material.dart';

class ListPerson extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return ListPersonState();
  } 
}

class ListPersonState extends State<ListPerson>{

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
        )
      );
  }
  
}