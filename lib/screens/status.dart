import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class StatusPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return StatusPageState();
  }
}

class StatusPageState extends State<StatusPage>{
  @override
  void initState() {
    super.initState();
    fetch();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            "COVID-19 Stats",
            style: TextStyle(
                color: Colors.white,
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.bold),
          ),
        ),
      ),
      body: Container(
        child: FlatButton(onPressed: () => show(), child: Text("Fetch")),
      ),
  );
  } 

fetch(){
  print("fetch");
  API.getStats().then(
    (response) => {
      response = json.decode(response.body),
      countries = response['data']['covid19Stats'].map((model) => CovidData.fromJson(model)).toList(), 
      // print(json.decode(response.body)['data']['covid19Stats'][0])
    }
  );
  setState(() {
    
  });
}
}

class CovidData{
  String city = "";
  String province = "";
  String country = "";
  String lastUpdate = "";
  String keyId = "";
  int confirmed = 0;
  int deaths = 0;
  int recovered = 0;
  
  CovidData(String city, String province, String country, String lastUpdate, String keyId, int confirmed, int deaths, int recovered){
    this.city = city;
    this.province = province;
    this.country = country;
    this.lastUpdate = lastUpdate;
    this.keyId = keyId;
    this.confirmed = confirmed;
    this.deaths = deaths;
    this.recovered = recovered;
  }

  CovidData.fromJson(Map json)
  : city = json['city'],
    province = json['province'],
    country = json['country'],
    lastUpdate = json['lastUpdate'],
    keyId = json['keyId'],
    confirmed = json['confirmed'],
    deaths = json['deaths'],
    recovered = json['recovered'];

  Iterable toJson(){
    return [
      {'city': city},
      {'province': province},
      {'country': country},
      {'lastUpdate': lastUpdate},
      {'keyId': keyId},
      {'confirmed': confirmed},
      {'deaths': deaths},
      {'recovered': recovered},
    ];
  }
}

List<dynamic> countries = [];
Iterable lists;

show(){
  for (var i = 0; i < countries.length; i++) {
    print(countries[i]['country']);
  }
}


const baseUrl = "https://covid-19-coronavirus-statistics.p.rapidapi.com/v1/stats";

class API {
  static Future getStats(){
    return http.get(baseUrl, headers: {
      "x-rapidapi-host": "covid-19-coronavirus-statistics.p.rapidapi.com",
      "x-rapidapi-key": "8ca140a965mshe408a2e58737ba5p14b104jsn19a57561ec85"
    });
  }
}