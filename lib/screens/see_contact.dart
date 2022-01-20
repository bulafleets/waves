import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:permission_handler/permission_handler.dart';

class ContactsPage extends StatefulWidget {
  @override
  _ContactsPageState createState() => _ContactsPageState();
}

class _ContactsPageState extends State<ContactsPage> {
  late Iterable<Contact> _contacts;
  bool _isContact = false;

  @override
  void initState() {
    getContacts();
    super.initState();
  }

  Future<void> getContacts() async {
    //Make sure we already have permissions for contacts when we get to this
    //page, so we can just retrieve it
    final Iterable<Contact> contacts = await ContactsService.getContacts();
    setState(() {
      _contacts = contacts;
      _isContact = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Contacts',
            textAlign: TextAlign.center,
            style: GoogleFonts.quicksand(
                fontWeight: FontWeight.bold,
                fontSize: 26,
                color: Colors.white)),
        centerTitle: true,
      ),
      body: _isContact
          ? ListView.builder(
              itemCount: _contacts.length,
              itemBuilder: (BuildContext context, int index) {
                Contact? contact = _contacts.elementAt(index);
                if (index == 0) {
                  return Container(
                    width: 300,
                    height: 50,
                    margin: EdgeInsets.all(15),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                            color: Color.fromRGBO(78, 114, 136, .15),
                          )
                        ]),
                    child: TextField(
                      style: const TextStyle(color: Colors.black),
                      keyboardType: TextInputType.text,
                      cursorColor: Colors.grey,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        enabledBorder: UnderlineInputBorder(
                          borderSide: const BorderSide(color: Colors.white),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: const BorderSide(color: Colors.white),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        prefixIcon:
                            const Icon(Icons.search, color: Color(0xffb7c2d5)),
                        hintText: "Search",
                        // contentPadding:
                        //     const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                        hintStyle: TextStyle(
                            color: const Color(0xFFb6b3c6).withOpacity(0.8),
                            fontFamily: 'RobotoRegular'),
                        border: const OutlineInputBorder(),
                      ),
                    ),
                  );
                }
                return ListTile(
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 2, horizontal: 18),
                  leading:
                      (contact.avatar != null && contact.avatar!.isNotEmpty)
                          ? CircleAvatar(
                              backgroundImage: MemoryImage(contact.avatar!),
                            )
                          : CircleAvatar(
                              child: Text(contact.initials()),
                              backgroundColor: Theme.of(context).accentColor,
                            ),
                  title: Text(contact.displayName ?? ''),
                  //This can be further expanded to showing contacts detail
                  // onPressed().
                );
              },
            )
          : Center(child: const CircularProgressIndicator()),
    );
  }
}

// class SeeContactsButton extends StatelessWidget {
//   Future<PermissionStatus> getPermission() async {
//     PermissionStatus permission = await Permission.contacts.status;
//     if (permission != PermissionStatus.granted &&
//         permission != PermissionStatus.permanentlyDenied) {
//       PermissionStatus permissionStatus = await Permission.contacts.request();
//       return permissionStatus;
//     } else {
//       return permission;
//     }
//   }

//   Future<PermissionStatus> _getPermission() async {
//     final PermissionStatus permission = await Permission.contacts.status;
//     if (permission != PermissionStatus.granted &&
//         permission != PermissionStatus.denied) {
//       final Map<Permission, PermissionStatus> permissionStatus =
//           await [Permission.contacts].request();
//       return permissionStatus[Permission.contacts] ?? PermissionStatus.granted;
//     } else {
//       return permission;
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return RaisedButton(
//       onPressed: () async {
//         final PermissionStatus permissionStatus = await _getPermission();
//         if (permissionStatus == PermissionStatus.granted) {
//           Navigator.push(
//               context, MaterialPageRoute(builder: (context) => ContactsPage()));
//         } else {
//           //If permissions have been denied show standard cupertino alert dialog
//           showDialog(
//               context: context,
//               builder: (BuildContext context) => CupertinoAlertDialog(
//                     title: Text('Permissions error'),
//                     content: Text('Please enable contacts access '
//                         'permission in system settings'),
//                     actions: <Widget>[
//                       CupertinoDialogAction(
//                         child: Text('OK'),
//                         onPressed: () => Navigator.of(context).pop(),
//                       )
//                     ],
//                   ));
//         }
//       },
//       child: Container(child: Text('See Contacts')),
//     );
//   }
// }
