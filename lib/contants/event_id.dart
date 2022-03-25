import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:waves/contants/common_params.dart';
import 'package:waves/contants/share_pref.dart';
import 'package:waves/models/event_model.dart';
import 'package:http/http.dart' as http;

class EventListWidget extends StatefulWidget {
  final void Function(String idd, String name) id;
  const EventListWidget(this.id, {Key? key}) : super(key: key);
  @override
  _EventListWidgetState createState() => _EventListWidgetState();
}

class _EventListWidgetState extends State<EventListWidget> {
  late Future<EventIdModel> _future;

  var _dropDownValue;
  var idLocal;
  Future<EventIdModel> eventIdAPi() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    var token = _prefs.getString(Prefs.accessToken);
    EventIdModel dataDropDown;
    http.Response response = await http.get(Uri.parse(EventList),
        headers: {HttpHeaders.authorizationHeader: "Bearer $token"});
    final jsonString = response.body;
    print(jsonString);
    final jsonMap = jsonDecode(jsonString);
    dataDropDown = EventIdModel.fromJson(jsonMap);
    return dataDropDown;
  }

  @override
  void initState() {
    _future = eventIdAPi();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 65,
      decoration: BoxDecoration(
          color: const Color.fromRGBO(234, 234, 234, 1),
          border: Border.all(color: Colors.white),
          borderRadius: BorderRadius.circular(8)),
      padding: const EdgeInsets.only(left: 15, right: 5),
      child: FutureBuilder<EventIdModel>(
          future: _future,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return DropdownButtonHideUnderline(
                child: DropdownButton(
                  hint: _dropDownValue == null
                      ? const Text(
                          'Event Type',
                          style: TextStyle(
                              color: Color.fromRGBO(145, 145, 145, 1),
                              fontFamily: 'RobotoRegular'),
                        )
                      : Text(
                          _dropDownValue,
                          style: const TextStyle(color: Colors.black),
                        ),
                  isExpanded: true,
                  iconSize: 45.0,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                  ),
                  items: List.generate(
                      snapshot.data!.data.length,
                      (index) => DropdownMenuItem<String>(
                            value: snapshot.data!.data[index].eventName,
                            child: Text(snapshot.data!.data[index].eventName),
                            onTap: () {
                              setState(() {
                                idLocal = snapshot.data!.data[index].id;
                                widget.id(idLocal,
                                    snapshot.data!.data[index].eventName);
                              });
                            },
                          )),
                  // onTap: _save,
                  onChanged: (val) {
                    setState(
                      () {
                        _dropDownValue = val.toString();
                      },
                    );
                  },
                ),
              );
            } else {
              return Container(
                  width: MediaQuery.of(context).size.width,
                  padding:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                  child: const Text(
                    'Event Type',
                    style: TextStyle(
                        color: Color.fromRGBO(145, 145, 145, 1),
                        fontFamily: 'RobotoRegular'),
                  ));
            }
          }),
    );
  }
}
