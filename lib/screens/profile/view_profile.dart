import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:waves/contants/common_params.dart';
import 'package:waves/models/get_following_data_model.dart';
import 'package:waves/models/view_profile_model.dart';
import 'package:http/http.dart' as http;

class ViewProfleScreen extends StatefulWidget {
  final String profileId;
  const ViewProfleScreen({required this.profileId, Key? key}) : super(key: key);

  @override
  _ViewProfleScreenState createState() => _ViewProfleScreenState();
}

class _ViewProfleScreenState extends State<ViewProfleScreen> {
  late Future<ViewProfileModel> _future;
  List<Follower> _getFollowingData = [];
  bool isFollow = false;
  late int totalFollowing = 0;

  @override
  void initState() {
    super.initState();
    _future = viewProfileApi();
    getfollowingNumber();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    EasyLoading.dismiss();
  }

  @override
  Widget build(BuildContext context) {
    print(isFollow);
    return Scaffold(
        appBar: PreferredSize(
            preferredSize:
                const Size.fromHeight(80.0), // here the desired height
            child: AppBar(
              backgroundColor: Theme.of(context).primaryColor,
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
        body: FutureBuilder<ViewProfileModel>(
            future: _future,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                var data = snapshot.data!.profile;

                return SingleChildScrollView(
                    child: Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.all(30),
                  child: Column(
                      // crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // SizedBox(height: 50),
                        Stack(
                          alignment: AlignmentDirectional.bottomCenter,
                          children: [
                            CircleAvatar(
                                radius: 57,
                                child: CachedNetworkImage(
                                  imageUrl: data.avatar,
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
                                ))
                            // backgroundImage: NetworkImage(data.avatar)),
                            // signOut()
                          ],
                        ),
                        const SizedBox(height: 15),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                data.name,
                                style: GoogleFonts.quicksand(
                                    fontSize: 19, fontWeight: FontWeight.w500),
                              ),
                              const SizedBox(width: 10),
                              if (data.roles != 'BUSINESS')
                                const FaIcon(
                                  FontAwesomeIcons.solidIdBadge,
                                  color: Color.fromRGBO(38, 125, 213, 1),
                                  size: 22,
                                ),
                              if (data.roles == 'BUSINESS')
                                Image.asset(
                                  'assets/icons/verified.png',
                                  scale: .9,
                                ),
                            ]),
                        Text(
                          data.email,
                          style: GoogleFonts.quicksand(
                              fontSize: 15, fontWeight: FontWeight.w300),
                        ),
                        const SizedBox(height: 20),
                        if (data.roles == "BUSINESS")
                          isFollow
                              ? _unfollowButon()
                              : _getFollowingData
                                      .map((e) => e.user.id)
                                      .contains(user_id)
                                  ? _unfollowButon()
                                  : _followButon(),

                        const SizedBox(height: 20),

                        if (data.roles == "BUSINESS")
                          Text(
                            '$totalFollowing Following',
                            style: GoogleFonts.quicksand(
                                color: Colors.blue,
                                fontSize: 17,
                                fontWeight: FontWeight.w500),
                          ),
                        const SizedBox(height: 8),
                        Flexible(
                          child: Padding(
                            padding: const EdgeInsets.all(3.0),
                            child: Text(
                              data.biography,
                              // "Lorem Ipsum has been the industry's standard dummy text ever since the when an unknown printer took a galley of type and scrambled it to make a type  when an unknown printer took a galley of type  scrambled it to make a type when an unknown printer took a galley of type and scrambled it to make a type ",
                              // overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.quicksand(
                                  fontSize: 14, fontWeight: FontWeight.w300),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Flexible(
                          child: Padding(
                            padding: const EdgeInsets.all(3.0),
                            child: Text(
                              'Address : ${data.address}',
                              // "Lorem Ipsum has been the industry's standard dummy text ever since the when an unknown printer took a galley of type and scrambled it to make a type  when an unknown printer took a galley of type  scrambled it to make a type when an unknown printer took a galley of type and scrambled it to make a type ",
                              // overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.quicksand(
                                  fontSize: 14, fontWeight: FontWeight.w300),
                            ),
                          ),
                        ),
                      ]),
                ));
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            }));
  }

  _followButon() {
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
          followRequestApi();
        },
        child: const Text(
          "Follow",
          style: TextStyle(
              color: Colors.white, fontSize: 18, fontFamily: 'RobotoBold'),
        ),
      ),
    );
  }

  _unfollowButon() {
    return SizedBox(
      // margin: const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 50.0),
      height: 40,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          onPrimary: Colors.black,
          primary: Colors.white,
          minimumSize: const Size(88, 36),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(30)),
          ),
        ),
        onPressed: () {
          EasyLoading.show(status: 'Please Wait ...');
          unfollowRequestApi();
        },
        child: const Text(
          "Unfollow",
          style: TextStyle(
              color: Colors.black, fontSize: 18, fontFamily: 'RobotoBold'),
        ),
      ),
    );
  }

  Future<ViewProfileModel> viewProfileApi() async {
    ViewProfileModel data;
    http.Response response = await http.post(Uri.parse(ViewProfile),
        body: {'profile_id': widget.profileId},
        headers: {HttpHeaders.authorizationHeader: "Bearer $authorization"});
    final jsonString = response.body;

    final jsonMap = jsonDecode(jsonString);
    data = ViewProfileModel.fromJson(jsonMap);
    return data;
  }

  Future<void> followRequestApi() async {
    final response = await http.post(Uri.parse(Follow),
        body: {'followingId': widget.profileId, 'followerId': user_id},
        headers: {HttpHeaders.authorizationHeader: "Bearer $authorization"});
    EasyLoading.dismiss();

    String data = response.body;
    print(data);
    String status = jsonDecode(data)['status'].toString();

    if (status == "200") {
      setState(() {
        isFollow = true;
        getfollowingNumber();
      });
      String message = jsonDecode(data)['message'];
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

  Future<void> unfollowRequestApi() async {
    final response = await http.post(Uri.parse(UnFollow),
        body: {'followingId': widget.profileId, 'followerId': user_id},
        headers: {HttpHeaders.authorizationHeader: "Bearer $authorization"});
    EasyLoading.dismiss();

    String data = response.body;
    print(data);
    String status = jsonDecode(data)['status'].toString();

    if (status == "200") {
      setState(() {
        isFollow = false;
        getfollowingNumber();
      });
      String message = jsonDecode(data)['message'];
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
        body: {'followingId': widget.profileId},
        headers: {HttpHeaders.authorizationHeader: "Bearer $authorization"});
    final jsonString = response.body;

    final jsonMap = jsonDecode(jsonString);
    data = GetFollowingDataModel.fromJson(jsonMap);

    String apidata = response.body;
    // print(apidata);
    String status = jsonDecode(apidata)['status'].toString();
    if (status == "200") {
      _getFollowingData = GetFollowingDataModel.fromJson(jsonMap).followers;
    }
    setState(() {
      totalFollowing = GetFollowingDataModel.fromJson(jsonMap).followers.length;
    });
    return data;
  }
}
