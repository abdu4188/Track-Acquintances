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

  @override
  void initState() {
    getContacts();
    super.initState();
  }

  Future<void> getContacts() async {
    //We already have permissions for contact when we get to this page, so we
    // are now just retrieving it
    final Iterable<Contact> contacts = await ContactsService.getContacts();
    setState(() {
      _contacts = contacts;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: (Text('Contacts')),
      ),
      body: _contacts != null
          //Build a list view of all contacts, displaying their avatar and
          // display name
          ? ListView.builder(
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
    );
  }
}