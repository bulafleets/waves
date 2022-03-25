import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter_sms/flutter_sms.dart';
import 'package:flutter/material.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:waves/contants/common_params.dart';
import 'package:http/http.dart' as http;
import 'package:waves/models/map_listing_model.dart';

class ContactsPage extends StatefulWidget {
  const ContactsPage({Key? key}) : super(key: key);

  @override
  _ContactsPageState createState() => _ContactsPageState();
}

class _ContactsPageState extends State<ContactsPage> {
  TextEditingController _searchController = TextEditingController();
  String? _message;
  String message =
      'Hey, your friends are on waves app , download here http://wave.com ';
  List<String> people = [];
  // late Iterable<Contact> _contacts;
  bool _isContact = false;
  var contactNumbers = [];
  var invtedContact = [];
  List<Conta> alreadyContact = [];
  @override
  void initState() {
    getContacts();
    getContactsApi();
    getContactInvited();
    super.initState();
  }

  Future<void> getContacts() async {
    final Iterable<Contact> contacts = await ContactsService.getContacts();
    for (var i in contacts) {
      // var str = i.phones!.forEach((element) {
      //   element.value;
      // }).value!;
      for (var j in i.phones!) {
        var str = j.value;
        var number = replaceWhitespacesUsingRegex(str!, '');
        if (number!.length > 10) {
          var s = number.substring(3);

          alreadyContact
              .add(Conta(name: i.displayName!, avtar: i.initials(), number: s));
        }
      }
    }
    setState(() {
      _isContact = true;
      _userDetails = alreadyContact;
    });
  }

  String? replaceWhitespacesUsingRegex(String s, String replace) {
    if (s == null) {
      return null;
    }
    final pattern = RegExp('\\s+');
    return s.replaceAll(pattern, replace);
  }

  onSearchTextChanged(String text) async {
    _searchResult.clear();
    if (text.isEmpty) {
      setState(() {});
      return;
    }

    for (var userDetail in _userDetails) {
      if (userDetail.name.contains(text)) {
        _searchResult.add(userDetail);
      }
    }

    setState(() {});
  }

  List<Conta> _searchResult = [];

  List<Conta> _userDetails = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Contacts List',
            textAlign: TextAlign.center,
            style: GoogleFonts.quicksand(
                fontWeight: FontWeight.bold,
                fontSize: 26,
                color: Colors.white)),
        centerTitle: true,
      ),
      body: _isContact
          ? _searchResult.isNotEmpty
              ? ListView.builder(
                  itemCount: _searchResult.length,
                  itemBuilder: (BuildContext context, int index) {
                    // Contact? contact = _searchResult.elementAt(index);
                    // print(contactNumbers.contains(contact.phones!.first.value));
                    // var vl = contact.phones!.first.value!.trim();
                    if (index == 0) {
                      return Column(children: [
                        Container(
                          width: MediaQuery.of(context).size.width - 50,
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
                            controller: _searchController,
                            onChanged: onSearchTextChanged,
                            style: const TextStyle(color: Colors.black),
                            keyboardType: TextInputType.text,
                            cursorColor: Colors.grey,
                            decoration: InputDecoration(
                              errorStyle: const TextStyle(
                                  color: Color.fromRGBO(98, 8, 15, 1)),
                              suffixIcon: _searchController.text.isEmpty
                                  ? null
                                  : InkWell(
                                      onTap: () {
                                        _searchController.text = '';
                                        _searchResult.clear();
                                        FocusScope.of(context).unfocus();
                                      },
                                      child: const Icon(Icons.close,
                                          color: Colors.black)),
                              filled: true,
                              fillColor: Colors.white,
                              enabledBorder: UnderlineInputBorder(
                                borderSide:
                                    const BorderSide(color: Colors.white),
                                borderRadius: BorderRadius.circular(30),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide:
                                    const BorderSide(color: Colors.white),
                                borderRadius: BorderRadius.circular(30),
                              ),
                              prefixIcon: const Icon(Icons.search,
                                  color: Color(0xffb7c2d5)),
                              hintText: "Search",
                              contentPadding: const EdgeInsets.only(top: 15),
                              hintStyle: TextStyle(
                                  color:
                                      const Color(0xFFb6b3c6).withOpacity(0.8),
                                  fontFamily: 'RobotoRegular'),
                              border: const OutlineInputBorder(),
                            ),
                          ),
                        ),
                        if (_searchResult.isEmpty &&
                            _searchController.text.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Center(
                                child: Text('No Result Found!',
                                    style: GoogleFonts.quicksand(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black))),
                          ),
                      ]);
                    }

                    return ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 2, horizontal: 18),
                        leading:
                            //  (alreadyContact[index].avtar != null)
                            // ? CircleAvatar(
                            //     backgroundImage:
                            //         MemoryImage(alreadyContact[index].avtar),
                            //   )
                            // :
                            CircleAvatar(
                          child: Text(_searchResult[index].avtar),
                          backgroundColor: Theme.of(context).accentColor,
                        ),
                        title: Text(_searchResult[index].name),
                        subtitle: Text(_searchResult[index].number),
                        trailing: SizedBox(
                            height: 40,
                            child: !contactNumbers
                                    .contains(_searchResult[index].number)
                                ? !invtedContact
                                        .contains(_searchResult[index].number)
                                    ? ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          onPrimary: Colors.white,
                                          primary:
                                              Theme.of(context).primaryColor,
                                          minimumSize: const Size(88, 36),
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 16),
                                          shape: const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(30)),
                                          ),
                                        ),
                                        onPressed: () async {
                                          var number =
                                              _searchResult[index].number;
                                          setState(() {
                                            people.add(number);
                                          });
                                          if (people.isNotEmpty) {
                                            await _sendSMS(people);
                                            people.clear();
                                          }
                                        },
                                        child: const Text(
                                          "Invite",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 18,
                                              fontFamily: 'RobotoBold'),
                                        ),
                                      )
                                    : SizedBox(
                                        width: 155,
                                        child: Row(
                                          children: [
                                            ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                    shadowColor: Colors.black,
                                                    primary: Colors.white,
                                                    onPrimary: Theme.of(context)
                                                        .primaryColor,
                                                    minimumSize:
                                                        const Size(88, 36),
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 16),
                                                    shape:
                                                        const RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  30)),
                                                    )),
                                                onPressed: () async {
                                                  var number =
                                                      _searchResult[index]
                                                          .number;
                                                  setState(() {
                                                    people.add(number);
                                                  });

                                                  if (people.isNotEmpty) {
                                                    await _sendSMS(people);
                                                    people.clear();
                                                  }
                                                },
                                                child: const Text(
                                                  "Resend",
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 18,
                                                      fontFamily: 'RobotoBold'),
                                                )),
                                            const SizedBox(width: 5),
                                            const Text(
                                              "Sent",
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 16,
                                                  fontFamily: 'RobotoBold'),
                                            ),
                                            const Icon(Icons.check)
                                          ],
                                        ))
                                : const Text(
                                    "Already on Waves",
                                    style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 16,
                                        fontFamily: 'RobotoBold'),
                                  )));
                  },
                )
              : ListView.builder(
                  itemCount: alreadyContact.length,
                  itemBuilder: (BuildContext context, int index) {
                    // Contact? contact = _contacts.elementAt(index);
                    // print(contactNumbers.contains(contact.phones!.first.value));
                    // var vl = contact.phones!.first.value!.trim();
                    if (index == 0) {
                      return Column(children: [
                        Container(
                          width: MediaQuery.of(context).size.width - 50,
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
                            controller: _searchController,
                            onChanged: onSearchTextChanged,
                            style: const TextStyle(color: Colors.black),
                            keyboardType: TextInputType.text,
                            cursorColor: Colors.grey,
                            decoration: InputDecoration(
                              errorStyle: const TextStyle(
                                  color: Color.fromRGBO(98, 8, 15, 1)),
                              suffixIcon: _searchController.text.isEmpty
                                  ? null
                                  : InkWell(
                                      onTap: () {
                                        _searchController.text = '';
                                        _searchResult.clear();
                                        FocusScope.of(context).unfocus();
                                      },
                                      child: const Icon(Icons.close,
                                          color: Colors.black)),
                              filled: true,
                              fillColor: Colors.white,
                              enabledBorder: UnderlineInputBorder(
                                borderSide:
                                    const BorderSide(color: Colors.white),
                                borderRadius: BorderRadius.circular(30),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide:
                                    const BorderSide(color: Colors.white),
                                borderRadius: BorderRadius.circular(30),
                              ),
                              prefixIcon: const Icon(Icons.search,
                                  color: Color(0xffb7c2d5)),
                              hintText: "Search",
                              contentPadding: const EdgeInsets.only(top: 15),
                              hintStyle: TextStyle(
                                  color:
                                      const Color(0xFFb6b3c6).withOpacity(0.8),
                                  fontFamily: 'RobotoRegular'),
                              border: const OutlineInputBorder(),
                            ),
                          ),
                        ),
                        if (_searchResult.isEmpty &&
                            _searchController.text.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Center(
                                child: Text('No Result Found!',
                                    style: GoogleFonts.quicksand(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black))),
                          ),
                      ]);
                    }

                    return ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 2, horizontal: 18),
                        leading:
                            //  (alreadyContact[index].avtar != null)
                            // ? CircleAvatar(
                            //     backgroundImage:
                            //         MemoryImage(alreadyContact[index].avtar),
                            //   )
                            // :
                            CircleAvatar(
                          child: Text(alreadyContact[index].avtar),
                          backgroundColor: Theme.of(context).accentColor,
                        ),
                        title: Text(alreadyContact[index].name),
                        subtitle: Text(alreadyContact[index].number),
                        trailing: SizedBox(
                            height: 40,
                            child: !contactNumbers
                                    .contains(alreadyContact[index].number)
                                ? !invtedContact
                                        .contains(alreadyContact[index].number)
                                    ? ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          onPrimary: Colors.white,
                                          primary:
                                              Theme.of(context).primaryColor,
                                          minimumSize: const Size(88, 36),
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 16),
                                          shape: const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(30)),
                                          ),
                                        ),
                                        onPressed: () async {
                                          var number =
                                              alreadyContact[index].number;
                                          setState(() {
                                            print(number);
                                            inviteContacts(number);
                                            people.add(number);
                                          });

                                          if (people.isNotEmpty) {
                                            await _sendSMS(people);
                                            people.clear();
                                          }
                                        },
                                        child: const Text(
                                          "Invite",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 18,
                                              fontFamily: 'RobotoBold'),
                                        ),
                                      )
                                    : SizedBox(
                                        width: 155,
                                        child: Row(
                                          children: [
                                            ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                    shadowColor: Colors.black,
                                                    primary: Colors.white,
                                                    onPrimary: Theme.of(context)
                                                        .primaryColor,
                                                    minimumSize:
                                                        const Size(88, 36),
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 16),
                                                    shape:
                                                        const RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  30)),
                                                    )),
                                                onPressed: () async {
                                                  var number =
                                                      alreadyContact[index]
                                                          .number;
                                                  setState(() {
                                                    people.add(number);
                                                  });

                                                  if (people.isNotEmpty) {
                                                    await _sendSMS(people);
                                                    people.clear();
                                                  }
                                                },
                                                child: const Text(
                                                  "Resend",
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 18,
                                                      fontFamily: 'RobotoBold'),
                                                )),
                                            const SizedBox(width: 5),
                                            const Text(
                                              "Sent",
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 16,
                                                  fontFamily: 'RobotoBold'),
                                            ),
                                            const Icon(Icons.check)
                                          ],
                                        ))
                                : const Text(
                                    "Already on Waves",
                                    style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 16,
                                        fontFamily: 'RobotoBold'),
                                  )));
                  },
                )
          : const Center(child: CircularProgressIndicator()),
    );
  }

  Future<void> getContactInvited() async {
    final response = await http
        .post(Uri.parse(MobileInvitedList), body: {"user_id": user_id});

    String data = response.body;
    String status = jsonDecode(data)['status'].toString();
    if (status == "200") {
      setState(() {
        invtedContact = jsonDecode(data)['MobileList'];
      });
    }
  }

  Future<void> getContactsApi() async {
    final response =
        await http.post(Uri.parse(MobileList), body: {"user_id": user_id});

    String data = response.body;
    String status = jsonDecode(data)['status'].toString();
    print(data);
    if (status == "200") {
      setState(() {
        contactNumbers = jsonDecode(data)['MobileList'];
      });
    }
  }

  Future<void> inviteContacts(String phoneNumber) async {
    final response = await http.post(Uri.parse(MobileInvitePost),
        body: {"user_id": user_id, "phone": phoneNumber});

    String data = response.body;
    print(data);
    String status = jsonDecode(data)['status'].toString();
    if (status == "200") {
      // setState(() {
      //   invtedContact = jsonDecode(data)['MobileList'];
      // });
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

class Conta {
  final String name;
  final String avtar;
  final String number;
  Conta({required this.name, required this.avtar, required this.number});
}
