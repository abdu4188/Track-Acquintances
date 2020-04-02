import 'package:flutter/material.dart';
import 'package:contacts_service/contacts_service.dart';
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

  @override
  void initState() {
    getContacts();
    super.initState();
  }

  searchChanged(){
    setState(() {
      search = searchController.text;
    });
  }

  Future<void> getContacts() async {
    //We already have permissions for contact when we get to this page, so we
    // are now just retrieving it
    final Iterable<Contact> contacts = await ContactsService.getContacts();
    setState(() {
      _contacts = contacts.where(
        (contact) => contact.displayName.contains(search)
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: (Text('Contacts')),
      ),
      body: Container(
        child: ListView(
        children: <Widget>[
          Container(
            width: 90,
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
                    onPressed: () => searchChanged(),
                  )
                ],
              )
          ),
          SizedBox(
            height: 20,
          ),
          _contacts != null
          //Build a list view of all contacts, displaying their avatar and
          // display name
          ? ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: _contacts?.length ?? 0,
              itemBuilder: (BuildContext context, int index) {
                Contact contact = _contacts?.elementAt(index);
                return GestureDetector(
                  child: Card(
                    child: ListTile(
                    contentPadding:
                        const EdgeInsets.symmetric(vertical: 2, horizontal: 18),
                    leading: (contact.avatar != null && contact.avatar.isNotEmpty)
                        ? CircleAvatar(
                            backgroundImage: MemoryImage(contact.avatar),
                          )
                        : CircleAvatar(
                            child: Text(contact.initials()),
                            backgroundColor: Theme.of(context).accentColor,
                          ),
                    title: Text(
                      contact.displayName ?? '',
                      style: TextStyle(
                        fontFamily: 'Montserrat'
                      ),
                      ),
                    subtitle: ListView.builder(
                      shrinkWrap: true,
                      physics: ClampingScrollPhysics(),
                      itemCount: contact.phones.length,
                      itemBuilder: (BuildContext context, int index){
                        currentIndex = index;
                        return ListTile(
                          subtitle: Text(
                            contact.phones?.elementAt(index)?.value,
                            style: TextStyle(
                              fontFamily: 'Montserrat'
                            ),
                            ),
                        );
                      },
                    ),
                    trailing: GestureDetector(
                      child: Icon(
                        Icons.add,
                        size: 50,
                        color: Colors.teal,
                      ),
                      onTap: () => {
                        setValuesInForm(contact),
                        Navigator.of(context).pop(),
                        }
                    )
                  ),
                ),
                );
                },
            )
          : Center(child: const CircularProgressIndicator()),
        ],
      )
    
      )
      );
  }
}