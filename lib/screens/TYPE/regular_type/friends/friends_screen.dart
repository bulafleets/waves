import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:waves/contants/common_params.dart';
import 'package:waves/models/my_friends_model.dart';
import 'package:waves/models/myallfriends_request_model.dart';
import 'package:waves/screens/TYPE/regular_type/friends/add_friends.dart';
import 'package:waves/screens/TYPE/regular_type/friends/widget/show_dialog.dart';
import 'package:waves/screens/friends/add_friends.dart';
import 'package:http/http.dart' as http;

class FriendsScreen extends StatefulWidget {
  const FriendsScreen({Key? key}) : super(key: key);

  @override
  _FriendsScreenState createState() => _FriendsScreenState();
}

class _FriendsScreenState extends State<FriendsScreen> {
  late Future<MyAllFriendRequestsModel?> _futureRequests;
  late Future<MyAllFriendModel?> _futurefriends;
  var hasRequestedData = false;
  var hasFreinds = false;
  @override
  void initState() {
    _futureRequests = seeAllFriendRequests();
    _futurefriends = seeAllFriends();

    // TODO: implement initState
    super.initState();
  }

  Future<void> _pullRefresh() async {
    await Future.delayed(const Duration(seconds: 2));
    setState(() {
      _futureRequests = seeAllFriendRequests();
      _futurefriends = seeAllFriends();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Theme.of(context).primaryColor,
          elevation: 0,
          title: Text('Friends',
              textAlign: TextAlign.center,
              style: GoogleFonts.quicksand(
                  fontWeight: FontWeight.bold,
                  fontSize: 26,
                  color: Colors.white)),
          actions: [
            TextButton(
                child: Text('Add Friend',
                    style: GoogleFonts.quicksand(
                        fontWeight: FontWeight.w300,
                        fontSize: 18,
                        color: Colors.white)),
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const AddFriends(true)));
                })
          ],
        ),
        body: Container(
            color: Theme.of(context).primaryColor,
            width: MediaQuery.of(context).size.width,
            child: RefreshIndicator(
              onRefresh: _pullRefresh,
              child: ListView(children: [
                Container(
                  // width: 300,
                  height: 50,
                  margin: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        const BoxShadow(
                          color: const Color.fromRGBO(78, 114, 136, .15),
                        )
                      ]),
                  child: TextField(
                    onChanged: onSearchTextChanged,
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
                if (!hasRequestedData)
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 25.0, vertical: 8),
                    child: Text('FRIEND REQUESTS',
                        style: GoogleFonts.quicksand(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: Colors.white)),
                  ),
                if (!hasRequestedData)
                  FutureBuilder<MyAllFriendRequestsModel?>(
                      future: _futureRequests,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return ListView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount:
                                  snapshot.data!.myAllFriendRequests.length,
                              itemBuilder: (context, index) {
                                var data =
                                    snapshot.data!.myAllFriendRequests[index];
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
                                                padding:
                                                    const EdgeInsets.all(3),
                                                decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    // ),
                                                    color: age > 17 && age < 30
                                                        ? const Color.fromRGBO(
                                                            0, 0, 255, 1)
                                                        : age > 29 && age < 50
                                                            ? const Color
                                                                    .fromRGBO(
                                                                255, 255, 0, 1)
                                                            : const Color
                                                                    .fromRGBO(0,
                                                                255, 128, 1)),
                                                child: CircleAvatar(
                                                  radius: 25,
                                                  child: CachedNetworkImage(
                                                    imageUrl: data.avatar,
                                                    imageBuilder: (context,
                                                            imageProvider) =>
                                                        Container(
                                                      width: 80.0,
                                                      height: 80.0,
                                                      decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        image: DecorationImage(
                                                            image:
                                                                imageProvider,
                                                            fit: BoxFit.cover),
                                                      ),
                                                    ),
                                                    placeholder: (context,
                                                            url) =>
                                                        const CircularProgressIndicator(),
                                                    errorWidget: (context, url,
                                                            error) =>
                                                        const Icon(Icons.error),
                                                  ),
                                                )),
                                            const SizedBox(width: 15),
                                            Text(data.name,
                                                style: GoogleFonts.quicksand(
                                                    fontSize: 17,
                                                    fontWeight: FontWeight.w500,
                                                    color: Colors.white)),
                                          ],
                                        ),
                                        SizedBox(
                                          // margin: const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 50.0),
                                          height: 40,
                                          child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              onPrimary: Colors.white,
                                              primary: const Color.fromRGBO(
                                                  0, 69, 255, 1),
                                              minimumSize: const Size(88, 36),
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 16),
                                              shape:
                                                  const RoundedRectangleBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(30)),
                                              ),
                                            ),
                                            onPressed: () {
                                              EasyLoading.show(
                                                  status: 'Please Wait ...');
                                              acceptFriendRequests(data.userId);
                                            },
                                            child: const Text(
                                              "ACCEPT",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 18,
                                                  fontFamily: 'RobotoBold'),
                                            ),
                                          ),
                                        )
                                      ]),
                                );
                              });
                        } else if (snapshot.connectionState ==
                                ConnectionState.done &&
                            snapshot.data == null) {
                          return Center(
                              child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text('No request found',
                                style: GoogleFonts.quicksand(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white)),
                          ));
                        } else {
                          return const Center(
                              child: CircularProgressIndicator());
                        }
                      }),
                // FutureBuilder<GetAllUsersModel>(
                //         future: _future,
                //         builder: (context, snapshot) {
                //           if (snapshot.hasData) {
                //             return
                if (!hasFreinds)
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 25.0, vertical: 8),
                    child: Text('YOUR FRIEND',
                        style: GoogleFonts.quicksand(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: Colors.white)),
                  ),
                if (!hasFreinds)
                  SizedBox(
                      height: MediaQuery.of(context).size.height,
                      child: _searchResult.isNotEmpty
                          ? Expanded(
                              child: ListView.builder(
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: _searchResult.length,
                                  itemBuilder: (context, index) {
                                    var data = _searchResult[index];
                                    int age = data.age;
                                    // if (index == 0) {
                                    //   return const SizedBox(height: 20);
                                    // }
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
                                                            : age > 29 &&
                                                                    age < 50
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
                                                                fit: BoxFit
                                                                    .cover),
                                                          ),
                                                        ),
                                                        imageUrl: data.avatar,
                                                        placeholder: (context,
                                                                url) =>
                                                            const CircularProgressIndicator(),
                                                        errorWidget: (context,
                                                                url, error) =>
                                                            const Icon(
                                                                Icons.error),
                                                      ),
                                                    )),
                                                const SizedBox(width: 15),
                                                Text(data.name,
                                                    style:
                                                        GoogleFonts.quicksand(
                                                            fontSize: 17,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            color:
                                                                Colors.white)),
                                              ],
                                            ),
                                            SizedBox(
                                              // margin: const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 50.0),
                                              height: 40,
                                              child: ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                  onPrimary: Colors.white,
                                                  primary: const Color.fromRGBO(
                                                      0, 69, 255, 1),
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
                                                  ),
                                                ),
                                                onPressed: () {
                                                  setState(() {
                                                    _futurefriends =
                                                        seeAllFriends();
                                                  });
                                                  showDialog(
                                                      context: context,
                                                      builder: (_) =>
                                                          ShowDialogRemoveFriend(
                                                              data.userId,
                                                              context));
                                                },
                                                child: const Text(
                                                  "Remove",
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 18,
                                                      fontFamily: 'RobotoBold'),
                                                ),
                                              ),
                                            )
                                          ]),
                                    );
                                  }))
                          : FutureBuilder<MyAllFriendModel?>(
                              future: _futurefriends,
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  return ListView.builder(
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      itemCount:
                                          snapshot.data!.myAllFriends.length,
                                      itemBuilder: (context, index) {
                                        var data =
                                            snapshot.data!.myAllFriends[index];
                                        int age = data.age;
                                        // if (index == 0) {
                                        //   return const SizedBox(height: 20);
                                        // }
                                        return Container(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 8.0, horizontal: 15),
                                          child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Row(
                                                  children: [
                                                    Container(
                                                        // margin: const EdgeInsets.only(right: 5),
                                                        padding: const EdgeInsets
                                                            .all(3),
                                                        decoration:
                                                            BoxDecoration(
                                                                shape: BoxShape
                                                                    .circle,
                                                                color: age > 17 &&
                                                                        age < 30
                                                                    ? const Color
                                                                            .fromRGBO(
                                                                        0,
                                                                        0,
                                                                        255,
                                                                        1)
                                                                    : age > 29 &&
                                                                            age <
                                                                                50
                                                                        ? const Color.fromRGBO(
                                                                            255,
                                                                            255,
                                                                            0,
                                                                            1)
                                                                        : const Color.fromRGBO(
                                                                            0,
                                                                            255,
                                                                            128,
                                                                            1)),
                                                        child: CircleAvatar(
                                                          radius: 25,
                                                          child:
                                                              CachedNetworkImage(
                                                            imageBuilder: (context,
                                                                    imageProvider) =>
                                                                Container(
                                                              width: 80.0,
                                                              height: 80.0,
                                                              decoration:
                                                                  BoxDecoration(
                                                                shape: BoxShape
                                                                    .circle,
                                                                image: DecorationImage(
                                                                    image:
                                                                        imageProvider,
                                                                    fit: BoxFit
                                                                        .cover),
                                                              ),
                                                            ),
                                                            imageUrl:
                                                                data.avatar,
                                                            placeholder: (context,
                                                                    url) =>
                                                                const CircularProgressIndicator(),
                                                            errorWidget: (context,
                                                                    url,
                                                                    error) =>
                                                                const Icon(Icons
                                                                    .error),
                                                          ),
                                                        )),
                                                    const SizedBox(width: 15),
                                                    Text(data.name,
                                                        style: GoogleFonts
                                                            .quicksand(
                                                                fontSize: 17,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                color: Colors
                                                                    .white)),
                                                  ],
                                                ),
                                                SizedBox(
                                                  // margin: const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 50.0),
                                                  height: 40,
                                                  child: ElevatedButton(
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                      onPrimary: Colors.white,
                                                      primary:
                                                          const Color.fromRGBO(
                                                              0, 69, 255, 1),
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
                                                      ),
                                                    ),
                                                    onPressed: () {
                                                      setState(() {
                                                        _futurefriends =
                                                            seeAllFriends();
                                                      });
                                                      showDialog(
                                                          context: context,
                                                          builder: (_) =>
                                                              ShowDialogRemoveFriend(
                                                                  data.userId,
                                                                  context));
                                                    },
                                                    child: const Text(
                                                      "Remove",
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 18,
                                                          fontFamily:
                                                              'RobotoBold'),
                                                    ),
                                                  ),
                                                )
                                              ]),
                                        );
                                      });
                                } else if (snapshot.connectionState ==
                                        ConnectionState.done &&
                                    snapshot.data == null) {
                                  return Center(
                                      child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text('No Friends found',
                                        style: GoogleFonts.quicksand(
                                            fontSize: 17,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.white)),
                                  ));
                                } else {
                                  return const Center(
                                      child: CircularProgressIndicator());
                                }
                              })),
                if (hasFreinds && hasRequestedData)
                  Center(
                      child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('No data found',
                        style: GoogleFonts.quicksand(
                            fontSize: 17,
                            fontWeight: FontWeight.w500,
                            color: Colors.white)),
                  ))
              ]),
            )));
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

  List<MyAllFriend> _searchResult = [];

  List<MyAllFriend> _userDetails = [];
  Future<MyAllFriendModel?> seeAllFriends() async {
    var data;
    http.Response response =
        await http.post(Uri.parse(MyAllFriends), body: {'user_id': user_id});
    final jsonString = response.body;

    final jsonMap = jsonDecode(jsonString);
    if (MyAllFriendModel.fromJson(jsonMap).myAllFriends.isEmpty) {
      data = MyAllFriendModel.fromJson(jsonMap);
      setState(() {
        hasFreinds = true;
      });
    } else {
      data = MyAllFriendModel.fromJson(jsonMap);
      _userDetails = MyAllFriendModel.fromJson(jsonMap).myAllFriends;
      return data;
    }
  }

  Future<MyAllFriendRequestsModel?> seeAllFriendRequests() async {
    var data;
    http.Response response = await http
        .post(Uri.parse(MyFriendREquests), body: {'user_id': user_id});
    final jsonString = response.body;

    final jsonMap = jsonDecode(jsonString);
    if (MyAllFriendRequestsModel.fromJson(jsonMap)
        .myAllFriendRequests
        .isEmpty) {
      data = MyAllFriendRequestsModel.fromJson(jsonMap);

      setState(() {
        hasRequestedData = true;
      });
    } else {
      data = MyAllFriendRequestsModel.fromJson(jsonMap);

      return data;
    }
  }

  Future<void> acceptFriendRequests(String receiverID) async {
    final response = await http.post(Uri.parse(AceeptFriendsRequest), body: {
      'accepter_id': user_id,
      'requester_id': receiverID,
      'accept_status': 'true'
    }, headers: {
      HttpHeaders.authorizationHeader: "Bearer $authorization"
    });

    String data = response.body;
    print(data);
    String status = jsonDecode(data)['status'].toString();

    EasyLoading.dismiss();
    if (status == "200") {
      String message = jsonDecode(data)['message'];
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message), backgroundColor: Colors.green));
      setState(() {
        _futureRequests = seeAllFriendRequests();
        _futurefriends = seeAllFriends();
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
