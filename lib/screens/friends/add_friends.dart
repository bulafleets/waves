import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:waves/contants/common_params.dart';
import 'package:waves/contants/share_pref.dart';
import 'package:waves/models/getAllUsers_model.dart';
import 'package:waves/screens/Main/main_page.dart';
import 'package:waves/screens/friends/add_friends_nearby.dart';
import 'package:http/http.dart' as http;
import 'package:waves/screens/contact/see_contact.dart';

class AddFriends extends StatefulWidget {
  final bool isInside;
  const AddFriends(this.isInside, {Key? key}) : super(key: key);

  @override
  _AddFriendsState createState() => _AddFriendsState();
}

class _AddFriendsState extends State<AddFriends> {
  // Future<void> share() async {
  //   await FlutterShare.share(
  //       title: 'share wave app',
  //       text: ' Hey, your friends are on waves app , download here  ',
  //       linkUrl: 'http://waves',
  //       chooserTitle: 'Waves');
  // }

  late Future<GetAllUsersModel> _future;
  TextEditingController _searchController = TextEditingController();
  @override
  void initState() {
    _future = findNearbyFriendsApi();
    super.initState();
  }

  Future<PermissionStatus> _getPermission() async {
    PermissionStatus permission = await Permission.contacts.status;
    if (permission != PermissionStatus.granted &&
        permission != PermissionStatus.permanentlyDenied) {
      PermissionStatus permissionStatus = await Permission.contacts.request();
      return permissionStatus;
    } else {
      return permission;
    }
  }

  @override
  void dispose() {
    EasyLoading.dismiss();
    super.dispose();
  }

  bool _issend = false;
  @override
  Widget build(BuildContext context) {
    print('user_id' + user_id);
    bool keyboardIsOpened = MediaQuery.of(context).viewInsets.bottom != 0.0;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0,
        title: Text('Add Friends',
            textAlign: TextAlign.center,
            style: GoogleFonts.quicksand(
                fontWeight: FontWeight.bold,
                fontSize: 26,
                color: Colors.white)),
        actions: [
          TextButton(
            // onPressed: () {s
            //   Navigator.of(context).push(
            //       MaterialPageRoute(builder: (context) => ContactsPage()));
            // },
            onPressed: () async {
              final PermissionStatus permissionStatus = await _getPermission();
              if (permissionStatus == PermissionStatus.granted) {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => ContactsPage()));
              } else {
                //If permissions have been denied show standard cupertino alert dialog
                showDialog(
                    context: context,
                    builder: (BuildContext context) => CupertinoAlertDialog(
                          title: const Text('Permissions error'),
                          content: const Text('Please enable contacts access '
                              'permission in system settings'),
                          actions: <Widget>[
                            CupertinoDialogAction(
                              child: const Text('OK'),
                              onPressed: () => Navigator.of(context).pop(),
                            )
                          ],
                        ));
              }
            },
            //  share,
            child: const Text(
              'Invite+',
              style: TextStyle(fontSize: 17, color: Colors.white),
            ),
          )
        ],
      ),
      body: Container(
        color: Theme.of(context).primaryColor,
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
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
                onChanged: onSearchTextChanged,
                style: const TextStyle(color: Colors.black),
                keyboardType: TextInputType.text,
                cursorColor: Colors.grey,
                decoration: InputDecoration(
                  suffixIcon: _searchController.text.isNotEmpty
                      ? GestureDetector(
                          onTap: () {
                            _searchController.clear();
                            onSearchTextChanged('');
                          },
                          child: const Padding(
                              padding: EdgeInsets.all(2.0),
                              child: FaIcon(Icons.close,
                                  size: 20, color: Colors.black)))
                      : null,

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
                  prefixIcon: const Icon(Icons.search,
                      color: Color(0xffb7c2d5), size: 20),
                  hintText: "Search",
                  contentPadding: const EdgeInsets.only(top: 15),
                  // contentPadding:
                  //     const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                  hintStyle: TextStyle(
                      color: const Color(0xFFb6b3c6).withOpacity(0.8),
                      fontFamily: 'RobotoRegular'),
                  border: const OutlineInputBorder(),
                ),
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => AddFriendsNearBy()));
              },
              child: const Text('Find Nearby users',
                  style: TextStyle(
                    color: Colors.white,
                    decoration: TextDecoration.underline,
                  ),
                  textAlign: TextAlign.center),
            ),
            const SizedBox(height: 10),
            Expanded(
                // height: MediaQuery.of(context).size.height,
                child: _searchResult.isNotEmpty
                    ? ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: _searchResult.length,
                        itemBuilder: (context, index) {
                          var data = _searchResult[index];
                          int age = data.age;

                          return Container(
                              width: MediaQuery.of(context).size.width,
                              padding: const EdgeInsets.symmetric(
                                  vertical: 8.0, horizontal: 15),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                          // margin: const EdgeInsets.only(right: 5),
                                          padding: const EdgeInsets.all(3),
                                          decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: age > 17 && age < 30
                                                  ? const Color.fromRGBO(
                                                      0, 0, 255, 1)
                                                  : age > 29 && age < 50
                                                      ? const Color.fromRGBO(
                                                          255, 255, 0, 1)
                                                      : const Color.fromRGBO(
                                                          0, 255, 128, 1)),
                                          child: CircleAvatar(
                                            radius: 25,
                                            child: CachedNetworkImage(
                                              imageUrl: data.avatar ??
                                                  'https://upload.wikimedia.org/wikipedia/commons/thumb/0/0a/Gnome-stock_person.svg/1024px-Gnome-stock_person.svg.png',
                                              imageBuilder:
                                                  (context, imageProvider) =>
                                                      Container(
                                                width: 80.0,
                                                height: 80.0,
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  image: DecorationImage(
                                                      image: imageProvider,
                                                      fit: BoxFit.cover),
                                                ),
                                              ),
                                              placeholder: (context, url) =>
                                                  const CircularProgressIndicator(),
                                              errorWidget:
                                                  (context, url, error) =>
                                                      const Icon(Icons.error),
                                            ),
                                          )),
                                      SizedBox(width: 15),
                                      Text(data.username,
                                          style: GoogleFonts.quicksand(
                                              color: Colors.white)),
                                    ],
                                  ),
                                  add(data.id, data.isFriend),
                                ],
                              ));
                        },
                      )
                    : FutureBuilder<GetAllUsersModel>(
                        future: _future,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            if (snapshot.data!.nearbyUsers.isNotEmpty) {
                              return ListView.builder(
                                shrinkWrap: true,
                                itemCount: snapshot.data!.nearbyUsers.length,
                                itemBuilder: (context, index) {
                                  var data = snapshot.data!.nearbyUsers[index];
                                  int age = data.age;
                                  print(snapshot.data!.nearbyUsers.length);

                                  return Container(
                                      width: MediaQuery.of(context).size.width,
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 8.0, horizontal: 15),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              Container(
                                                  // margin: const EdgeInsets.only(right: 5),
                                                  padding:
                                                      const EdgeInsets.all(3),
                                                  decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      color: age > 17 &&
                                                              age < 30
                                                          ? const Color
                                                                  .fromRGBO(
                                                              0, 0, 255, 1)
                                                          : age > 29 && age < 50
                                                              ? const Color
                                                                      .fromRGBO(
                                                                  255,
                                                                  255,
                                                                  0,
                                                                  1)
                                                              : const Color
                                                                      .fromRGBO(
                                                                  0,
                                                                  255,
                                                                  128,
                                                                  1)),
                                                  child: CircleAvatar(
                                                    radius: 25,
                                                    child: CachedNetworkImage(
                                                      imageUrl: data.avatar ??
                                                          'https://upload.wikimedia.org/wikipedia/commons/thumb/0/0a/Gnome-stock_person.svg/1024px-Gnome-stock_person.svg.png',
                                                      imageBuilder: (context,
                                                              imageProvider) =>
                                                          Container(
                                                        width: 80.0,
                                                        height: 80.0,
                                                        decoration:
                                                            BoxDecoration(
                                                          shape:
                                                              BoxShape.circle,
                                                          image: DecorationImage(
                                                              image:
                                                                  imageProvider,
                                                              fit:
                                                                  BoxFit.cover),
                                                        ),
                                                      ),
                                                      placeholder: (context,
                                                              url) =>
                                                          const CircularProgressIndicator(),
                                                      errorWidget: (context,
                                                              url, error) =>
                                                          const Icon(
                                                              Icons.error),
                                                    ),
                                                  )),
                                              SizedBox(width: 15),
                                              Text(data.username,
                                                  style: GoogleFonts.quicksand(
                                                      color: Colors.white)),
                                            ],
                                          ),
                                          add(data.id, data.isFriend),
                                        ],
                                      ));
                                },
                              );
                            } else {
                              return SizedBox(
                                height: MediaQuery.of(context).size.height,
                                child: Center(
                                    child: Text('No Users Found',
                                        style: GoogleFonts.quicksand(
                                            color: Colors.black,
                                            fontSize: 17,
                                            fontWeight: FontWeight.w400))),
                              );
                            }
                          } else {
                            return const Center(
                                child: CircularProgressIndicator());
                          }
                        }))
          ],
        ),
      ),
      floatingActionButton:
          keyboardIsOpened || widget.isInside ? null : continueButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      backgroundColor: Colors.transparent,
    );
  }

  Widget add(String recID, bool isFriend) {
    if (isReqData.contains(recID) || isFriend) {
      return SizedBox(
          // width: 126,
          // margin: const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 50.0),
          height: 40,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: const [
              Text('Request Sent',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontFamily: 'RobotoBold')),
              Icon(
                Icons.check_circle,
                color: Colors.white,
              )
            ],
          ));
    } else {
      return SizedBox(
        // margin: const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 50.0),
        height: 40,
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
            EasyLoading.show(status: 'Please Wait ...');
            isReqData.add(recID);
            sendFriendRequest(recID);
          },
          child: const Text(
            "Add",
            style: TextStyle(
                color: Colors.white, fontSize: 18, fontFamily: 'RobotoBold'),
          ),
        ),
      );
    }
  }

  Widget continueButton() {
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
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => const MainPage()),
              (Route<dynamic> route) => false);
          // Navigator.of(context).pushAndRemoveUntil(
          //     MaterialPageRoute(builder: (context) => const MyHomePage()),
          //     (Route<dynamic> route) => false);
        },
        child: const Text(
          "Continue",
          style: TextStyle(
              color: Colors.white, fontSize: 18, fontFamily: 'RobotoBold'),
        ),
      ),
    );
  }

  Future<GetAllUsersModel> findNearbyFriendsApi() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    var userID = _prefs.get('user_id');
    var apiData;
    // try {
    final response = await http.post(Uri.parse(Get_all_users), body: {
      'user_id': userID,
    }
        // headers: {HttpHeaders.authorizationHeader: "Bearer $authorization"},
        // body: {'latitude': latitude, 'longitude': longitude});
        );

    print(response.body);
    if (response.statusCode == 200) {
      String data = response.body;
      final jsonMap = jsonDecode(data);
      apiData = GetAllUsersModel.fromJson(jsonMap);
      setState(() {
        _userDetails = GetAllUsersModel.fromJson(jsonMap).nearbyUsers;
      });
      return apiData;
    }
    return apiData;
  }

  onSearchTextChanged(String text) async {
    _searchResult.clear();
    if (text.isEmpty) {
      setState(() {});
      return;
    }

    for (var userDetail in _userDetails) {
      if (userDetail.username.contains(text)) {
        _searchResult.add(userDetail);
      }
    }

    setState(() {});
  }

  List<NearbyUser> _searchResult = [];

  List<NearbyUser> _userDetails = [];

  Future<void> sendFriendRequest(String receiverID) async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    var userId = _prefs.get(Prefs.userId);
    var auth = _prefs.get(Prefs.accessToken);
    print(auth);

    final response = await http.post(Uri.parse(send_friend_request),
        body: {'sender_id': userId.toString(), 'reciever_id': receiverID},
        headers: {HttpHeaders.authorizationHeader: "Bearer $auth"});
    EasyLoading.dismiss();

    String data = response.body;
    print(data);
    String status = jsonDecode(data)['status'].toString();

    if (status == "200") {
      String message = jsonDecode(data)['message'];
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message), backgroundColor: Colors.green));
      setState(() {
        _issend = true;
      });
    }
    if (status == "400") {
      String message = jsonDecode(data)['message'];
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(message),
      ));
    }
  }
}
