import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:waves/contants/common_params.dart';
import 'package:waves/models/my_friends_model.dart';
import 'package:http/http.dart' as http;
import 'package:waves/screens/TYPE/bussiness_type/wave/widget/Wave_Created_Succesfully.dart';

class InviteScreen extends StatefulWidget {
  final String wavename;
  final String log;
  final String lat;
  final String eventId;
  final String eventDetails;
  final String address;
  final bool isFriendOnly;
  final bool isInviteOnly;
  final String image;
  final String startTime;
  final String endTime;
  final String date;

  const InviteScreen({
    Key? key,
    required this.wavename,
    required this.address,
    required this.log,
    required this.lat,
    required this.eventId,
    required this.eventDetails,
    required this.isFriendOnly,
    required this.isInviteOnly,
    required this.image,
    required this.startTime,
    required this.endTime,
    required this.date,
  }) : super(key: key);

  @override
  _InviteScreenState createState() => _InviteScreenState();
}

class _InviteScreenState extends State<InviteScreen> {
  TextEditingController searchController = TextEditingController();
  bool haveFriends = false;
  bool _isAdded = false;
  var _inviteIdData = [];
  @override
  void initState() {
    seeAllFriends();
    super.initState();
  }

  @override
  void dispose() {
    EasyLoading.dismiss();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print(_inviteIdData.toString());
    bool keyboardIsOpened = MediaQuery.of(context).viewInsets.bottom != 0.0;
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(80.0), // here the desired height
          child: AppBar(
            backgroundColor: Theme.of(context).primaryColor,
            leading: Padding(
              padding: const EdgeInsets.only(top: 17.0, left: 5),
              child: IconButton(
                iconSize: 24,
                alignment: Alignment.bottomLeft,
                icon: const FaIcon(FontAwesomeIcons.arrowLeft),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ),
            flexibleSpace: Container(
                width: 85,
                height: 70,
                margin: const EdgeInsets.only(top: 40),
                child: Image.asset(
                  'assets/login.png',
                  width: 85,
                  height: 70,
                  fit: BoxFit.contain,
                )),
            centerTitle: true,
          )),
      body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.all(20),
          child: Column(
              // crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Invites',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.quicksand(
                      fontSize: 29, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 35),
                TextField(
                  onChanged: onSearchTextChanged,
                  onTap: () {},
                  style: const TextStyle(color: Colors.black),
                  controller: searchController,
                  keyboardType: TextInputType.text,
                  cursorColor: Colors.grey,
                  decoration: InputDecoration(
                      suffixIcon: searchController.text.isNotEmpty
                          ? GestureDetector(
                              onTap: () {
                                searchController.clear();
                                onSearchTextChanged('');
                              },
                              child: const Padding(
                                  padding: EdgeInsets.all(10.0),
                                  child: FaIcon(Icons.close,
                                      size: 20, color: Colors.black)))
                          : null,
                      filled: true,
                      fillColor: const Color.fromRGBO(234, 234, 234, 1),
                      enabledBorder: UnderlineInputBorder(
                          borderSide: const BorderSide(color: Colors.white),
                          borderRadius: BorderRadius.circular(8)),
                      focusedBorder: UnderlineInputBorder(
                          borderSide: const BorderSide(color: Colors.white),
                          borderRadius: BorderRadius.circular(8)),
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 20, horizontal: 20),
                      hintText: "Friends",
                      hintStyle: const TextStyle(
                          color: Color.fromRGBO(145, 145, 145, 1),
                          fontFamily: 'RobotoRegular'),
                      border: const OutlineInputBorder()),
                ),
                SizedBox(height: 10),
                if (_data.isNotEmpty)
                  Flexible(
                    child: GridView.builder(
                        itemCount: _data.length,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          childAspectRatio: 3.5,
                          // mainAxisExtent: 30,
                          crossAxisCount: 2,
                        ),
                        itemBuilder: (context, index) {
                          return Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(28),
                                color: Colors.grey[350]),
                            child: Row(children: [
                              const SizedBox(width: 15),
                              CircleAvatar(
                                  radius: 15,
                                  backgroundImage: NetworkImage(
                                    _data[index].profileUrl,
                                  )),
                              const SizedBox(width: 15),
                              Text(
                                _data[index].firstName,
                                style: GoogleFonts.quicksand(
                                    fontSize: 10, fontWeight: FontWeight.w400),
                              ),
                              const SizedBox(width: 15),
                              GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _inviteIdData.removeAt(index);
                                      _data.removeAt(index);
                                      // _data.remove(UserDetails(
                                      //     id: _searchResult[index].id,
                                      //     firstName:
                                      //         _searchResult[index].firstName,
                                      //     profileUrl:
                                      //         _searchResult[index].profileUrl));
                                    });
                                  },
                                  child: const FaIcon(Icons.close,
                                      color: Colors.black))
                            ]),
                          );
                        }),
                  ),
                if (haveFriends)
                  Padding(
                    padding: const EdgeInsets.all(25.0),
                    child: Center(
                        child: Text(
                      'Don\'t have any friends to invite',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.quicksand(
                          color: Colors.grey,
                          fontSize: 22,
                          fontWeight: FontWeight.w500),
                    )),
                  ),
                Expanded(
                  child: _searchResult.isNotEmpty &&
                          searchController.text.isNotEmpty
                      ? ListView.builder(
                          itemCount: _searchResult.length,
                          itemBuilder: (context, i) {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Card(
                                child: ListTile(
                                  onTap: () {
                                    setState(() {
                                      if (!_data
                                          .map((e) => e.id)
                                          .contains(_userDetails[i].id)) {
                                        _data.add(UserDetails(
                                            id: _userDetails[i].id,
                                            firstName:
                                                _userDetails[i].firstName,
                                            profileUrl:
                                                _userDetails[i].profileUrl));

                                        _inviteIdData.add(_userDetails[i].id);
                                      }
                                    });
                                  },
                                  leading: CircleAvatar(
                                    backgroundImage: NetworkImage(
                                      _searchResult[i].profileUrl,
                                    ),
                                  ),
                                  title: Text(_searchResult[i].firstName),
                                ),
                                margin: const EdgeInsets.all(0.0),
                              ),
                            );
                          },
                        )
                      // : Container()
                      : ListView.builder(
                          itemCount: _userDetails.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Card(
                                child: ListTile(
                                  onTap: () {
                                    setState(() {
                                      if (!_data
                                          .map((e) => e.id)
                                          .contains(_userDetails[index].id)) {
                                        _data.add(UserDetails(
                                            id: _userDetails[index].id,
                                            firstName:
                                                _userDetails[index].firstName,
                                            profileUrl: _userDetails[index]
                                                .profileUrl));
                                        print(_inviteIdData.toString());
                                        _inviteIdData
                                            .add(_userDetails[index].id);
                                      }
                                    });
                                  },
                                  leading: CircleAvatar(
                                    backgroundImage: NetworkImage(
                                      _userDetails[index].profileUrl,
                                    ),
                                  ),
                                  title: Text(_userDetails[index].firstName),
                                ),
                                margin: const EdgeInsets.all(0.0),
                              ),
                            );
                          },
                        ),
                ),
              ])),
      floatingActionButton: keyboardIsOpened ? null : confirm(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      backgroundColor: Colors.transparent,
    );
  }

  onSearchTextChanged(String text) async {
    _searchResult.clear();
    if (text.isEmpty) {
      setState(() {});
      return;
    }

    for (var userDetail in _userDetails) {
      if (userDetail.firstName.contains(text)) {
        _searchResult.add(userDetail);
      }
    }

    setState(() {});
  }

  List<UserDetails> _data = [];

  List<UserDetails> _searchResult = [];

  List<UserDetails> _userDetails = [];

  Future<MyAllFriendModel?> seeAllFriends() async {
    var data;
    http.Response response =
        await http.post(Uri.parse(MyAllFriends), body: {'user_id': user_id});
    final jsonString = response.body;

    final jsonMap = jsonDecode(jsonString);
    if (MyAllFriendModel.fromJson(jsonMap).myAllFriends.isEmpty) {
      data = MyAllFriendModel.fromJson(jsonMap);
      setState(() {
        haveFriends = true;
      });
    } else {
      setState(() {
        for (var element in MyAllFriendModel.fromJson(jsonMap).myAllFriends) {
          _userDetails.add(UserDetails(
              id: element.userId,
              firstName: element.name,
              profileUrl: element.avatar));
        }
      });

      return data;
    }
  }

  Widget confirm() {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 10.0),
      height: 60,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          onPrimary: Colors.white,
          primary: const Color.fromRGBO(0, 69, 255, 1),
          minimumSize: const Size(88, 36),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(30)),
          ),
        ),
        onPressed: () {
          // showBottomSheet(
          //     context: context, builder: (context) => SelectDateTime());
          // _selectDate(context);
          if (_data.isEmpty) {
            String message = 'Please add invity first';
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(message), backgroundColor: Colors.red));
          } else {
            createWaveRegular();
            EasyLoading.show(status: 'Please Wait ...');
          }
        },
        child: const Text(
          "Confirm",
          style: TextStyle(
              color: Colors.white, fontSize: 18, fontFamily: 'RobotoBold'),
        ),
      ),
    );
  }

  Future<void> createWaveRegular() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    // var userid = _prefs.getString('user_id');
    var request = http.MultipartRequest('POST', Uri.parse(WaveCreate));
    request.files.add(await http.MultipartFile.fromPath('media', widget.image));
    request.fields['wave_name'] = widget.wavename;
    request.fields['user_id'] = user_id;
    request.fields['event_id'] = widget.eventId;
    request.fields['date'] = widget.date;
    request.fields['user_type'] = AccountType;
    request.fields['waves_location'] = widget.address;
    request.fields['event_detail'] = widget.eventDetails;
    request.fields['address'] = widget.address;
    request.fields['lattitude'] = widget.lat;
    request.fields['longitude'] = widget.log;
    request.fields['isFriend'] = widget.isFriendOnly.toString();
    request.fields['isInvite'] = widget.isInviteOnly.toString();
    request.fields['start_time'] = widget.startTime;
    request.fields['end_time'] = widget.endTime;
    request.fields['invite_tags'] = _inviteIdData.toString();

    // invite_tags[0] see it later

    var res = await request.send();
    EasyLoading.dismiss();

    var response = await http.Response.fromStream(res);
    String data = response.body;
    String status = jsonDecode(data)['status'].toString();
    print(data);

    if (status == "200") {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => WaveCreatedSuccesfully()));
      // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      //   content: Text('successfully'),
      // ));
      // ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      //   content: Text('OTP send successfully'),
      //   backgroundColor: Colors.green,
      // ));
      // Navigator.of(context).pushNamed(OTP_SCREEN);
    }
    if (status == "400") {
      String message = jsonDecode(data)['message'];
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message), backgroundColor: Colors.red));
    }
  }
}

class UserDetails {
  final String id;
  final String firstName, profileUrl;

  UserDetails(
      {required this.id, required this.firstName, required this.profileUrl});

  // factory UserDetails.fromJson(Map<String, dynamic> json) {
  //   return  UserDetails(
  //     id: json['id'],
  //     firstName: json['name'], profileUrl:json['profileImage'],
  //   );
  // }

}
