import 'dart:convert';
import 'dart:io';
import 'package:track_aquintances/drawer.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class StatusPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return StatusPageState();
  }
}

bool hasLoaded = false;
String selectedValue = "";
int confirmed = 0;
int death = 0;
int recovered =0;
class StatusPageState extends State<StatusPage>{
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetch();
    });
  }

  noInternet(){
    showDialog(
      context: context,
      child: AlertDialog(
        title: Text("No Internet"),
        content: Text("You must be connected to use this feature"),
        actions: <Widget>[
          FlatButton(
            child: Text("close"),
            onPressed: () => {
              Navigator.of(context).pushNamed('/HomeScreen')
            },
          )
        ],
      )
    );
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
      drawer: Drawer(
          child: ListView(
            children: <Widget>[
              DrawerHeader(
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        colors: <Color>[Colors.teal, Colors.tealAccent])),
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
              CustomListTile('Add Person', Icons.add, addTapped),
              CustomListTile('View added People', Icons.people, listTapped),
              CustomListTile('View Stats', Icons.show_chart, statusTapped),
              CustomListTile('Symptoms', Icons.check_circle_outline, symptomsTapped),
              CustomListTile('About', Icons.info, aboutTapped),
            ],
          ),
        ),
      body: hasLoaded ? Center(
        child: Column(
          children: <Widget>[
            Center(
              child: ListView(
                shrinkWrap: true,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(30),
                    child: Center(
                      child: Text(
                        "Pick a country to view data",
                        style: TextStyle(
                          color: Colors.teal,
                          fontFamily: "Montserrat",
                          fontSize: 16,
                          fontWeight: FontWeight.bold
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: 80,
                      child: ButtonTheme(
                        alignedDropdown: true,
                        child: DropdownButton<String>(
                          hint: Text(selectedValue),
                          isExpanded: true,
                          style: TextStyle(
                            color: Colors.teal,
                            fontSize: 16,
                            fontFamily: 'Montserrat'
                          ),
                          iconSize: 50,
                          iconEnabledColor: Colors.teal,
                          elevation: 10,
                          items: stringCountries.map((String value){
                            return DropdownMenuItem(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(), 
                          onChanged: (String value) => {
                            selectedValue = value,
                            calculateValues(value),
                          }
                        ),
                      ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Text(
                              "Confirmed: ",
                              style: TextStyle(
                                color: Colors.teal,
                                fontWeight: FontWeight.bold,
                                fontFamily: "Montserrat",
                                fontSize: 20
                              ),
                            ),
                            Text(
                              "$confirmed",
                              style: TextStyle(
                                fontFamily: "Montserrat",
                                fontSize: 18
                              ),
                            )
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            Text(
                              "Deaths: ",
                              style: TextStyle(
                                color: Colors.teal,
                                fontWeight: FontWeight.bold,
                                fontFamily: "Montserrat",
                                fontSize: 20
                              ),
                            ),
                            Text(
                              "$death",
                              style: TextStyle(
                                fontFamily: "Montserrat",
                                fontSize: 18
                              ),
                            )
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            Text(
                              "Recovered: ",
                              style: TextStyle(
                                color: Colors.teal,
                                fontWeight: FontWeight.bold,
                                fontFamily: "Montserrat",
                                fontSize: 20
                              ),
                            ),
                            Text(
                              "$recovered",
                              style: TextStyle(
                                fontFamily: "Montserrat",
                                fontSize: 18
                              ),
                            )
                          ],
                        ),
                      ],
                    )
                  )
                ],
              ),
            ),
            Text(
              "Source: John Hopkins University",
              style: TextStyle(
                fontSize: 16,
                color: Colors.teal,
                fontFamily: 'Montserrat'
              ),
              )
          ]
        )
        ) :
      Center(
        child: CircularProgressIndicator(          
        ),
      )
  );
  } 

fetch() async{
  try {
      final result = await InternetAddress.lookup('fast.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        API.getStats().then(
          (response) => {
            // print(countries),
            response = json.decode(response.body),
            covidData = response['data']['covid19Stats'].map((model) => CovidData.fromJson(model)).toList(), 
            show()
          }
        );
        setState(() {
        });
      }
    } on SocketException catch (_) {
      print('not connected');
      noInternet();
    }
}

show(){
  for (var i = 0; i < covidData.length; i++) {
    countries.add(covidData[i].country);
  }
  countries = countries.toSet().toList();
  for (var i = 0; i < countries.length; i++) {
    stringCountries.add(countries[i].toString());
  }
  hasLoaded = true;
  setState(() {
    
  });
}
  calculateValues(String selected){
    confirmed = 0;
    death = 0;
    recovered = 0;
    for (var i = 0; i < covidData.length; i++) {
      if(covidData[i].country.toString() == selected ){
        confirmed += covidData[i].confirmed;
        death += covidData[i].deaths;
        recovered += covidData[i].recovered;
      }
    }
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

List<dynamic> covidData = new List<dynamic>();
List<String> countries = new List<String>();
List <String> stringCountries = new List<String>();
Iterable lists;




const baseUrl = "https://covid-19-coronavirus-statistics.p.rapidapi.com/v1/stats";

class API {
  static Future getStats(){
    return http.get(baseUrl, headers: {
      "x-rapidapi-host": "covid-19-coronavirus-statistics.p.rapidapi.com",
      "x-rapidapi-key": "8ca140a965mshe408a2e58737ba5p14b104jsn19a57561ec85"
    });
  }
}

noInternet(){
  return true;
}