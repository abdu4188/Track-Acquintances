import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sqflite/sqflite.dart';
import 'package:track_aquintances/drawer.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as importedPath;
import 'package:flutter_svg/flutter_svg.dart';
import 'constant.dart';

class StatusPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return StatusPageState();
  }
}

bool hasLoaded = false;
String selectedValue = "select country";
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

  List<Map<String, dynamic>> people = [];
  List<Map<String, dynamic>> mPeople;
  List firebaseIds = [];

  syncToFirebase() async {
    try {
      final result = await InternetAddress.lookup('fast.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {

        var data = Firestore.instance.collection('log').getDocuments().then(
          (QuerySnapshot snapshot) => {
            snapshot.documents.forEach((f) => 
            {firebaseIds.add(f.data['id']),
            getDbData()}
            )
          }
        );
      }
    } on SocketException catch (_) {
      print('not connected');
    }
  }

  getDbData() async {
    var databasesPath = await getDatabasesPath();
    String path = importedPath.join(databasesPath, "people.db");

    Database db;
    db = await openDatabase(path, version: 1);
    people = await db.rawQuery("SELECT * FROM people");
    mPeople = people.map((m) => Map.of(m)).toList();

    for(var i=0; i< firebaseIds.length; i++){
      mPeople.removeWhere((item) => item['id'] == int.parse(firebaseIds[i]));
    }

    FirebaseUser user = await FirebaseAuth.instance.currentUser();

    for (var i = 0; i < mPeople.length; i++) {
      Firestore.instance.collection('log').document().setData(
        {
          "id": mPeople[i]['id'].toString(),
          "name": mPeople[i]['name'],
          "phone": mPeople[i]['phone'],
          "date": mPeople[i]['date'],
          "location": mPeople[i]['location'],
          "user": user.uid
        }
      );
    }
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
    return WillPopScope(
      onWillPop: () {
        Navigator.of(context).pushNamed('/HomeScreen');
      },
      child: Scaffold(
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
                        colors: <Color>[Colors.green, Colors.teal])),
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
              CustomListTile('Home', Icons.home, homeTapped),
              CustomListTile('Add Person', Icons.add, addTapped),
              CustomListTile('View added People', Icons.people, listTapped),
              CustomListTile('View Stats', Icons.show_chart, statusTapped),
              CustomListTile('Symptoms', Icons.check_circle_outline, symptomsTapped),
            ],
          ),
        ),
      body: hasLoaded ? ListView(
        children: <Widget>[
          ClipPath(
            clipper: MyClipper(),
            child: Container(
              padding: EdgeInsets.only(left: 30, top: 50, right: 20),
              height: 250,
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [
                    Colors.green,
                    Colors.teal
                  ]
                ),
                image: DecorationImage(
                  image: AssetImage("images/virus.png")
                )
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start  ,
                children: <Widget>[
                  SizedBox(
                    height: 20,
                  ),
                  Expanded(
                    child: Stack(
                      children: <Widget>[
                        SvgPicture.asset(
                          "assets/icons/Drcorona.svg",
                          width: 265,
                          fit: BoxFit.fitWidth,
                          alignment: Alignment.topCenter,
                        ),
                        Positioned(
                          top: 20,
                          left: 140,
                          child: Text(
                            "Stay Home",
                            style: kHeadingTextStyle.copyWith(color: Colors.white),
                          ),
                        ),
                        Container()
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20),
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            height: 60,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(25),
              border: Border.all(
                color: Color(0xFFE5E5E5)
              )
            ),
            child: Row(
              children: <Widget>[
                SvgPicture.asset("assets/icons/maps-and-flags.svg"),
                SizedBox(width: 20,),
                Expanded(
                  child: DropdownButton(
                    isExpanded: true,
                    underline: SizedBox(),
                    icon: SvgPicture.asset("assets/icons/dropdown.svg"),
                    // value: selectedValue,
                    hint: Text(selectedValue),
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
                )
              ],
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 20,
                ),
                Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        offset: Offset(0, 4),
                        blurRadius: 30,
                        color: kShadowColor
                      )
                    ]
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Counter(
                        color: kInfectedColor, 
                        number: confirmed, 
                        title: "Infected",
                      ),
                      Counter(
                        color: kDeathColor, 
                        number: death, 
                        title: "Deaths",
                      ),
                      Counter(
                        color: kRecovercolor, 
                        number: recovered, 
                        title: "Recovered",
                      ),                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 20, top: 10),
                  child: Row(
                    children: <Widget>[
                      Text(
                        "Source: John Hopkins University",
                        style: kTitleTextStyle,
                      )
                    ],
                  ),
                )
              ],
            ),
          )
        ],
      ) :
      Center(
        child: CircularProgressIndicator(          
        ),
      )
  ),
    );
    } 

fetch() async{
  try {
      final result = await InternetAddress.lookup('fast.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        syncToFirebase();
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


class Counter extends StatelessWidget {
  final int number;
  final Color color;
  final String title;
  const Counter({
    Key key, this.number, this.color, this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          padding: EdgeInsets.all(6),
          height: 25,
          width: 25,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color.withOpacity(0.26)
          ),
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.transparent,
              border: Border.all(
                color: color,
                width: 2
              )
            ),
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Text(
          "$number",
          style: TextStyle(
            fontSize: 20,
            color: color
          ),
        ),
        Text(
          title,
          style: kSubTextStyle,
        )
      ],
    );
  }
}

class MyClipper extends CustomClipper<Path>{
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, size.height - 80);
    path.quadraticBezierTo(size.width/2, size.height, size.width, size.height - 80);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
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