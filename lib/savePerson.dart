// // import 'package:shared_preferences/shared_preferences.dart';
// import 'dart:async';

// class SavePerson{
//   Future<bool> savePerson(String name, String phone, DateTime date) async{
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     prefs.setString("name", name);
//     prefs.setString("phone", phone);
//     prefs.setString("date", date.toIso8601String());

//     return prefs.commit();
//   }
// }