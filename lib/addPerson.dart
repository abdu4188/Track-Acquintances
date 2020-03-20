import 'package:flutter/material.dart';
import 'dart:async';

class Formscreen extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return FormscreenState();
  }
  
}

class FormscreenState extends State<Formscreen>{
  String _name;
  String _phonenumber;
  DateTime _selectedDate = DateTime.now();

  final GlobalKey<FormState> _formKey =  GlobalKey<FormState>();

  Widget _buildDateFIeld(){
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
                    style: TextStyle(
                      fontSize: 16,
                      fontFamily: 'Montserrat'
                    ),
                  ),
                ],
              )
            )
          ],
        ),
      ),
    );
  }

  Widget _buildNameField(){
    return TextField(
      decoration: InputDecoration(
        icon: Icon(Icons.person),
        labelText: 'Name',
        labelStyle: TextStyle(
          fontFamily: 'Montserrat',
          fontWeight: FontWeight.bold,
          color: Colors.grey
        )
      ),
    );
  }

  Widget _builPhoneField(){
    return TextField(
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        icon: Icon(Icons.phone),
        labelText: 'Phone Number',
        labelStyle: TextStyle(
          fontFamily: 'Montserrat',
          fontWeight: FontWeight.bold,
          color: Colors.grey
        )
      ),
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
              fontWeight: FontWeight.bold
            ),
          ),
        ),
      ),
      // resizeToAvoidBottomPadding: false,
      body: ListView(
        // crossAxisAlignment: CrossAxisAlignment.start,
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
                      fontFamily: 'Montserrat'
                    ),
                  ),
                )
              ],
            )
          ),
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
                      fontFamily: 'Montserrat'
                    ),
                  )
                ),
                _buildNameField(),
                SizedBox(height: 10.0,),
                _builPhoneField(),
                SizedBox(height: 25.0,),
                Container(
                  height: 40.0,
                  child: Material(
                    borderRadius: BorderRadius.circular(20.0),
                    shadowColor: Colors.greenAccent,
                    color: Colors.teal,
                    elevation: 7.0,
                    child: GestureDetector(
                      onTap: () {},
                      child: Center(
                        child: Text(
                          'Add',
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.bold
                          ),
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
    );
  }
  
}

