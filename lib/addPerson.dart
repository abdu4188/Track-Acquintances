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
    return Container(
      padding: const EdgeInsets.all(10),
      child: Center(
        child: Row(
          children: <Widget>[
            Expanded(
              child: Column(
                children: <Widget>[
                  Text(
                    "Enter name of person you met",
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                      icon: Icon(Icons.person),
                      hintText: 'Name of person',
                      labelText: 'Name',
                    ),
                    validator: (String value){
                      if(value.isEmpty){
                        return "Name is required";
                      }
                    },
                    onSaved: (String value){
                      _name = value;
                    },
                  )
                ],
              )
            )
          ],
        ),
      ),
    );
  }

  Widget _buildPhoneNumberField(){
    return Container(
      padding: const EdgeInsets.all(10),
      child: Center(
        child: Row(
          children: <Widget>[
            Expanded(
              child: Column(
                children: <Widget>[
                  Text(
                    "Enter Phone number of person",
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                      icon: Icon(Icons.phone),
                      hintText: 'Name of person',
                      labelText: 'Name',
                    ),
                    validator: (String value){
                      if(value.isEmpty){
                        return "Name is required";
                      }
                    },
                    onSaved: (String value){
                      _name = value;
                    },
                  )
                ],
              )
            )
          ],
        ),
      ),
    );;
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
      appBar: AppBar(title: Center(
        child: Text('Track Acquaintances'),
        ) 
      ),
      body: new Container(
        child: new Center(
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              RaisedButton(
                onPressed: () => _selectDate(context),
                child: Text('Select date'),
              ),
              _buildNameField(),
              _buildPhoneNumberField(),
              RaisedButton(
                color: Colors.cyanAccent,
                onPressed: () => {},
                child: Text('Submit', style: TextStyle(color: Colors.blue, fontSize: 16),),
                )
            ],
          ),
        ),
      )
    );
  }
  
}

