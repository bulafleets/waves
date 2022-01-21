import 'dart:convert';
import 'package:flutter_sms/flutter_sms.dart';
import 'package:flutter/material.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:waves/contants/common_params.dart';
import 'package:http/http.dart' as http;

class ContactsPage extends StatefulWidget {
  const ContactsPage({Key? key}) : super(key: key);

  @override
  _ContactsPageState createState() => _ContactsPageState();
}

class _ContactsPageState extends State<ContactsPage> {
  String? _message;
  String message =
      'Hey, your friends are on waves app , download here http://wave.com ';
  List<String> people = [];
  late Iterable<Contact> _contacts;
  bool _isContact = false;
  var contactNumbers = [];
  @override
  void initState() {
    getContacts();
    getContactsApi();
    super.initState();
  }

  Future<void> getContacts() async {
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
                // print(contactNumbers.contains(contact.phones!.first.value));
                var vl = contact.phones!.first.value!.trim();
                print(vl);
                if (index == 0) {
                  return Container(
                    width: 300,
                    height: 50,
                    margin: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: const [
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
                        contentPadding: const EdgeInsets.only(top: 15),
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
                    subtitle: Text(contact.phones!.first.value.toString()),
                    trailing: SizedBox(
                        height: 40,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            onPrimary: Colors.white,
                            primary: Theme.of(context).primaryColor,
                            minimumSize: const Size(88, 36),
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(30)),
                            ),
                          ),
                          onPressed: !contactNumbers
                                  .contains(contact.phones!.first.value)
                              ? () async {
                                  var number = contact.phones!.first.value;
                                  setState(() {
                                    people.add(number!);
                                  });
                                  if (people.isNotEmpty) {
                                    await _sendSMS(people);
                                    people.clear();
                                  }
                                }
                              : null,
                          child: const Text(
                            "Invite",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontFamily: 'RobotoBold'),
                          ),
                        )));
              },
            )
          : const Center(child: CircularProgressIndicator()),
    );
  }

  Future<void> getContactsApi() async {
    final response = await http.post(Uri.parse(MobileList));

    String data = response.body;
    String status = jsonDecode(data)['status'].toString();
    if (status == "200") {
      setState(() {
        contactNumbers = jsonDecode(data)['MobileList'];
      });
    }
  }

  Future<void> _sendSMS(List<String> recipients) async {
    try {
      String _result = await sendSMS(message: message, recipients: recipients);
      setState(() => _message = _result);
    } catch (error) {
      setState(() => _message = error.toString());
    }
  }

  // Future<bool> _canSendSMS() async {
  //   bool _result = await canSendSMS();
  //   setState(() => _canSendSMSMessage =
  //       _result ? 'This unit can send SMS' : 'This unit cannot send SMS');
  //   return _result;
  // }
}
