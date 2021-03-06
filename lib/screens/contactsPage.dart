import 'package:flutter/material.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:track_aquintances/screens/addPerson.dart';

class ContactsPage extends StatefulWidget {
  @override
  _ContactsPageState createState() => _ContactsPageState();
}

class _ContactsPageState extends State<ContactsPage> {
  Iterable<Contact> _contacts;
  int currentIndex;
  String search = "";
  TextEditingController searchController = new TextEditingController();
  var contacts;

  @override
  void initState() {
    getContacts();
    super.initState();
  }

  searchChanged(){
    setState(() {
      search = searchController.text;
      print(search);
      getContacts();
      // if(contacts != null){
      //   _contacts = contacts.where(
      //   (contact) => contact?.displayName?.contains(search) ?? false
      //   ).toList();
      // }
      print(contacts);
    });
    // search = "";
  }

  Future<PermissionStatus>  _getPermission() async{
    PermissionStatus permission = await PermissionHandler().checkPermissionStatus(PermissionGroup.contacts);
    if (permission != PermissionStatus.granted && permission != PermissionStatus.denied) {
      Map<PermissionGroup, PermissionStatus> permissionStatus = await PermissionHandler().requestPermissions([PermissionGroup.contacts]);
      return permissionStatus[PermissionGroup.contacts] ?? PermissionStatus.unknown;
    } else {
      return permission;
    }
  }



  Future<void> getContacts() async {
    print("Get contacts");
    PermissionStatus permissionStatus = await _getPermission();
    if (permissionStatus == PermissionStatus.granted) {
      // Load without thumbnails initially.
      var contacts = await ContactsService.getContacts(withThumbnails: false);
//      var contacts = (await ContactsService.getContactsForPhone("8554964652"))
//          .toList();

      setState(() {
        _contacts = contacts;
        if(contacts != null){
          _contacts = contacts.where(
          (contact) => contact?.displayName?.contains(search) ?? false
          ).toList();
        }
      });

      // Lazy load thumbnails after rendering initial contacts.
      for (final contact in contacts) {
        ContactsService.getAvatar(contact).then((avatar) {
          if (avatar == null) return; // Don't redraw if no change.
          setState(() => contact.avatar = avatar);
        });
      }
    } else {
      _handleInvalidPermissions(permissionStatus);
    }
  }

  void _handleInvalidPermissions(PermissionStatus permissionStatus) {
    if (permissionStatus == PermissionStatus.denied) {
    }
  }



  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Navigator.of(context).pushNamed('/HomeScreen');
      },
      child: Scaffold(
      appBar: AppBar(
        title: (Text('Contacts')),
      ),
      body: Column(
        children: <Widget>[
          Container(
            width: 290,
            child: Column(
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  TextField(
                    decoration: InputDecoration(
                      icon: Icon(Icons.search),
                      labelText: "search"
                    ),
                    controller: searchController,
                  ),
                  FlatButton(
                    child: Icon(
                      Icons.search,
                      color: Colors.teal,
                      size: 45,
                      ),
                    onPressed: _contacts !=null ? () => searchChanged() : null,
                  )
                ],
              )
          ),
          SizedBox(
            height: 20,
          ),
          Expanded(
            child: _contacts != null
                ? ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: _contacts?.length ?? 0,
                  itemBuilder: (BuildContext context, int index) {
                    Contact c = _contacts?.elementAt(index);
                    return ListTile(
                      leading: (c.avatar != null && c.avatar.length > 0)
                          ? CircleAvatar(backgroundImage: MemoryImage(c.avatar))
                          : CircleAvatar(child: Text(c.initials())),
                      title: Text(c.displayName ?? ""),
                      subtitle:
                        c.phones.length > 0 ?
                        Text(
                          c.phones.elementAt(0).value
                        ):Text(""),
                      trailing: GestureDetector(
                        child: Icon(
                          Icons.add,
                          size: 40,
                          color: Colors.teal,
                        ),
                        onTap: () => {
                          setValuesInForm(c),
                          Navigator.of(context).pop(),
                          Navigator.of(context).pushNamed('/AddPerson'),
                          }
                      )
                    );
                  },
                )
                : Center(child: CircularProgressIndicator(),),
          ),
        ],
      )
      ),
    );
    }
}