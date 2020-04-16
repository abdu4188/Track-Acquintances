import 'package:flutter/material.dart';

class CustomListTile extends StatelessWidget {
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
              border: Border(bottom: BorderSide(color: Colors.grey))),
          child: InkWell(
              splashColor: Colors.teal,
              onTap: () => onTap(context),
              child: Container(
                height: 50,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Icon(
                        _icon,
                        color: Colors.teal,
                        ),
                        Padding(
                          padding: EdgeInsets.all(10),
                          child: Text(
                            _name,
                            style: TextStyle(
                                fontSize: 16, fontFamily: 'Montserrat'),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              )),
        ));
  }
}

addTapped(BuildContext context) async{
  Navigator.of(context).popAndPushNamed("/AddPerson");

}
aboutTapped(BuildContext context) async{
  Navigator.of(context).popAndPushNamed("/About");
}

listTapped(BuildContext context) async {
  Navigator.of(context).popAndPushNamed("/ListDates");
}

statusTapped(BuildContext context) async {
  Navigator.of(context).popAndPushNamed("/Status");
}

symptomsTapped(BuildContext context) async {
  Navigator.of(context).popAndPushNamed("/Symptoms");
}
