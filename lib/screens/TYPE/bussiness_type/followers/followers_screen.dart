import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:waves/contants/common_params.dart';
import 'package:waves/models/get_following_data_model.dart';
import 'package:http/http.dart' as http;

class FollowersScreen extends StatefulWidget {
  const FollowersScreen({Key? key}) : super(key: key);

  @override
  _FollowersScreenState createState() => _FollowersScreenState();
}

class _FollowersScreenState extends State<FollowersScreen> {
  bool isBlocked = false;
  late Future<GetFollowingDataModel> _future;
  @override
  void initState() {
    _future = getfollowingNumber();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).primaryColor,
        leading: IconButton(
          iconSize: 24,
          icon: const FaIcon(FontAwesomeIcons.arrowLeft),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text('Followers',
            style: GoogleFonts.quicksand(
                fontSize: 24, fontWeight: FontWeight.w700)),
        centerTitle: true,
      ),
      body: Container(
        color: Theme.of(context).primaryColor,
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        padding: const EdgeInsets.only(top: 15),
        child: FutureBuilder<GetFollowingDataModel>(
            future: _future,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data!.followers.isNotEmpty) {
                  return ListView.builder(
                      itemCount: snapshot.data!.followers.length,
                      itemBuilder: (context, index) {
                        var data = snapshot.data!.followers[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 5),
                          child: ListTile(
                            leading: CircleAvatar(
                              radius: 40,
                              child: CachedNetworkImage(
                                imageUrl: data.user.avatar,
                                imageBuilder: (context, imageProvider) =>
                                    Container(
                                  width: double.infinity,
                                  height: double.infinity,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                        image: imageProvider,
                                        fit: BoxFit.cover),
                                  ),
                                ),
                                placeholder: (context, url) =>
                                    const CircularProgressIndicator(),
                                errorWidget: (context, url, error) =>
                                    const Icon(Icons.error),
                              ),
                            ),
                            title: Text(data.user.username,
                                style: GoogleFonts.quicksand(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w400)),
                            trailing: SizedBox(
                              // margin: const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 50.0),
                              height: 40,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  shadowColor: Colors.black,
                                  elevation: 10,
                                  onPrimary: Colors.white,
                                  primary: const Color.fromRGBO(0, 69, 255, 1),
                                  minimumSize: const Size(88, 36),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16),
                                  shape: const RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(30)),
                                  ),
                                ),
                                onPressed: () {
                                  EasyLoading.show(status: 'Please Wait ...');
                                  unfollowRequestApi(data.user.id);
                                },
                                child: const Text(
                                  "Block",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontFamily: 'RobotoBold'),
                                ),
                              ),
                            ),
                          ),
                        );
                      });
                } else {
                  return Center(
                    child: Text('No follower found!!',
                        style: GoogleFonts.quicksand(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w600)),
                  );
                }
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            }),
      ),
    );
  }

  Future<void> unfollowRequestApi(String followeringId) async {
    final response = await http.post(Uri.parse(UnFollow),
        body: {'followingId': user_id, 'followerId': followeringId},
        headers: {HttpHeaders.authorizationHeader: "Bearer $authorization"});
    EasyLoading.dismiss();

    String data = response.body;
    print(data);
    String status = jsonDecode(data)['status'].toString();

    if (status == "200") {
      setState(() {
        isBlocked = false;
        _future = getfollowingNumber();
      });
      String message = 'Blocked successfully';
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message), backgroundColor: Colors.green));

      if (status == "400") {
        String message = jsonDecode(data)['message'];
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(message),
        ));
      }
    }
  }

  Future<GetFollowingDataModel> getfollowingNumber() async {
    GetFollowingDataModel data;
    http.Response response = await http.post(Uri.parse(MyFollows),
        body: {'followingId': user_id},
        headers: {HttpHeaders.authorizationHeader: "Bearer $authorization"});
    final jsonString = response.body;

    final jsonMap = jsonDecode(jsonString);
    data = GetFollowingDataModel.fromJson(jsonMap);

    String apidata = response.body;
    // print(apidata);
    String status = jsonDecode(apidata)['status'].toString();
    // if (status == "200") {
    //   _getFollowingData = GetFollowingDataModel.fromJson(jsonMap).followers;
    // }
    // setState(() {
    //   totalFollowing = GetFollowingDataModel.fromJson(jsonMap).followers.length;
    // });
    setState(() {});
    return data;
  }
}
