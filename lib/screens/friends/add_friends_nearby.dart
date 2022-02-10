import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:waves/contants/common_params.dart';
import 'package:waves/models/nearby_friends_model.dart';

class AddFriendsNearBy extends StatefulWidget {
  const AddFriendsNearBy({Key? key}) : super(key: key);

  @override
  _AddFriendsNearByState createState() => _AddFriendsNearByState();
}

class _AddFriendsNearByState extends State<AddFriendsNearBy> {
  late Future<NearbyFriendsModel> _future;
  bool _issend = false;

  @override
  void initState() {
    _future = findNearbyFriendsApi();
    super.initState();
  }

  @override
  void dispose() {
    EasyLoading.dismiss();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0,
        title: Text('Find Nearby Friends',
            textAlign: TextAlign.center,
            style: GoogleFonts.quicksand(
                fontWeight: FontWeight.normal,
                fontSize: 20,
                color: Colors.white)),
      ),
      body: FutureBuilder<NearbyFriendsModel>(
          future: _future,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data!.nearbyUsers.isNotEmpty) {
                return SizedBox(
                  // color: Theme.of(context).primaryColor,
                  width: MediaQuery.of(context).size.width,
                  child: ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: snapshot.data!.nearbyUsers.length,
                    itemBuilder: (context, index) {
                      var data = snapshot.data!.nearbyUsers[index];
                      // int age = data.age;
                      int age = data.age;
                      // if (index == snapshot.data!.nearbyUsers.length - 1) {
                      //   return const SizedBox(height: 90);
                      // }
                      return Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 11.0, horizontal: 15),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                        backgroundImage: data.avatar != null
                                            ? NetworkImage(data.avatar)
                                            : null,
                                      )),
                                  SizedBox(width: 15),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(data.username,
                                          style: GoogleFonts.quicksand(
                                              color: Colors.black,
                                              fontSize: 17,
                                              fontWeight: FontWeight.w400)),
                                      SizedBox(height: 5),
                                      const Text('0.1 mile away'),
                                    ],
                                  )
                                ],
                              ),
                              add(data.id, data.isFriend),
                            ],
                          ));
                      // Padding(
                      //   padding: const EdgeInsets.all(8.0),
                      //   child: ListTile(
                      //     leading: Container(
                      //         padding: const EdgeInsets.all(3),
                      //         decoration: BoxDecoration(
                      //             shape: BoxShape.circle,
                      //             color: age > 17 && age < 30
                      //                 ? const Color.fromRGBO(0, 0, 255, 1)
                      //                 : age > 29 && age < 50
                      //                     ? const Color.fromRGBO(255, 255, 0, 1)
                      //                     : const Color.fromRGBO(
                      //                         0, 255, 128, 1)),
                      //         child: CircleAvatar(
                      //           radius: 50,
                      //           backgroundImage: data.avatar != 'null'
                      //               ? NetworkImage(data.avatar)
                      //               : null,
                      //         )),
                      // title: Text(data.username,
                      //     style: GoogleFonts.quicksand(
                      //         color: Colors.black,
                      //         fontSize: 17,
                      //         fontWeight: FontWeight.w400)),
                      // subtitle: const Text('0.1 mile away'),
                      //     trailing: add(data.id, data.isFriend),
                      //   ),
                      // );
                    },
                  ),
                );
              } else {
                return SizedBox(
                  height: MediaQuery.of(context).size.height,
                  child: Center(
                      child: Text('No user Nearby',
                          style: GoogleFonts.quicksand(
                              color: Colors.black,
                              fontSize: 17,
                              fontWeight: FontWeight.w400))),
                );
              }
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          }),
    );
  }

  Widget add(String recID, bool isFriend) {
    if (isReqData.contains(recID) || isFriend) {
      return SizedBox(
          width: 126,
          // margin: const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 50.0),
          height: 40,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: const [
              Text('Request Sent',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                      fontFamily: 'RobotoBold')),
              Icon(
                Icons.check_circle,
                color: Colors.black,
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
            // Navigator.of(context)
            //     .push(MaterialPageRoute(builder: (context) => OtpPage()));
            // if (_formkey.currentState.validate()) {
            // showDialog(
            //   context: context,
            //   builder: (_) ,
            // );
            //  EasyLoading.show(status: 'Please Wait ...');
            //sendRESENT();
            //CircularProgressIndicator();
            //  EasyLoading.show(status: 'Please Wait ...');

            //print("Routing to your account");
            // }
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

  Future<NearbyFriendsModel> findNearbyFriendsApi() async {
    var apiData;
    // try {
    final response = await http.post(Uri.parse(find_nearBy_friends),
        // headers: {HttpHeaders.authorizationHeader: "Bearer $authorization"},
        body: {
          'latitude': latitude.toString(),
          'longitude': longitude.toString()
        });
    // body: {'latitude': '26.838055', 'longitude': '75.7952836'});
    print("dddk");
    print(response.body);
    if (response.statusCode == 200) {
      String data = response.body;
      final jsonMap = jsonDecode(data);
      apiData = NearbyFriendsModel.fromJson(jsonMap);

      return apiData;

      // return [];
    }
    // } catch (e) {
    //   print(e.toString());
    //   return [];
    // }
    return apiData;
  }

  //  Future<NearbyFriendsModel> findNearbyFriendsApi() async {

  //   final response = await http.post(
  //     Uri.parse(find_nearBy_friends),
  //     body: {
  //       'latitude': latitude,
  //       'longitude':longitude
  //     },
  //   );
  //   print(find_nearBy_friends +latitude + longitude);

  //   String data = response.body;
  //   print(data);
  //   String status = jsonDecode(data)['status'].toString();
  //   if (status == "200") {

  //   }
  //   if (status == "400") {
  //     String message = jsonDecode(data)['message'];
  //     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
  //       content: Text(message),
  //     ));

  //   }
  // }

  Future<void> sendFriendRequest(String receiverID) async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    var userId = _prefs.get('user_id');

    final response = await http.post(Uri.parse(send_friend_request), body: {
      'sender_id': userId.toString(),
      'reciever_id': receiverID,
      'user_id': userId,
    }, headers: {
      HttpHeaders.authorizationHeader: "Bearer $authorization"
    });
    print(send_friend_request + userId.toString() + receiverID);

    String data = response.body;
    print(data);
    String status = jsonDecode(data)['status'].toString();

    EasyLoading.dismiss();
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
