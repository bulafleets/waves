import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:waves/contants/common_params.dart';
import 'package:waves/models/get_following_data_model.dart';
import 'package:waves/screens/TYPE/bussiness_type/followers/followers_screen.dart';
import 'package:waves/screens/TYPE/bussiness_type/profile/edit_profile_business.dart';
import 'package:waves/screens/TYPE/bussiness_type/reviews/review_screen.dart';

import 'package:waves/screens/auth/login_page.dart';

import 'package:waves/screens/TYPE/regular_type/profile/edit_profile.dart';
import 'package:waves/screens/setting/setting_screen.dart';
import 'package:http/http.dart' as http;

class MyProfileBussinessScreen extends StatefulWidget {
  const MyProfileBussinessScreen({Key? key}) : super(key: key);

  @override
  _MyProfileBussinessScreenState createState() =>
      _MyProfileBussinessScreenState();
}

class _MyProfileBussinessScreenState extends State<MyProfileBussinessScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(80.0), // here the desired height
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
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height - 100,
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
                    child: CachedNetworkImage(
                      imageUrl: profileimg,
                      imageBuilder: (context, imageProvider) => Container(
                        width: double.infinity,
                        height: double.infinity,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                              image: imageProvider, fit: BoxFit.cover),
                        ),
                      ),
                      placeholder: (context, url) =>
                          const CircularProgressIndicator(),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                    ),
                    radius: 57,
                  ),
                  // signOut()
                ],
              ),
              const SizedBox(height: 15),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Text(
                  name,
                  style: GoogleFonts.quicksand(
                      fontSize: 19, fontWeight: FontWeight.w500),
                ),
                const SizedBox(width: 10),
                Image.asset(
                  'assets/icons/verified.png',
                  scale: .9,
                ),
              ]),
              Text(
                email,
                style: GoogleFonts.quicksand(
                    fontSize: 15, fontWeight: FontWeight.w300),
              ),
              const SizedBox(height: 15),
              RatingBarIndicator(
                rating: averageReviews,
                itemBuilder: (context, index) => FaIcon(
                    FontAwesomeIcons.solidStar,
                    color: Theme.of(context).primaryColor,
                    size: 18),
                itemCount: 5,
                itemSize: 25.0,
                direction: Axis.horizontal,
              ),
              // Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              //   FaIcon(
              //     FontAwesomeIcons.solidStar,
              //     color: Theme.of(context).primaryColor,
              //     size: 18,
              //   ),
              //   FaIcon(
              //     FontAwesomeIcons.solidStar,
              //     color: Theme.of(context).primaryColor,
              //     size: 18,
              //   ),
              //   FaIcon(
              //     FontAwesomeIcons.solidStar,
              //     color: Theme.of(context).primaryColor,
              //     size: 18,
              //   ),
              //   FaIcon(
              //     FontAwesomeIcons.solidStar,
              //     color: Theme.of(context).primaryColor,
              //     size: 18,
              //   ),
              //   FaIcon(
              //     FontAwesomeIcons.solidStar,
              //     color: Theme.of(context).primaryColor,
              //     size: 18,
              //   ),
              // ]),
              SizedBox(
                height: 32,
                child: TextButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const ReviewScreen()));
                    },
                    child: const Text(
                      'Reviews',
                      style: TextStyle(
                        color: Colors.black,
                        decoration: TextDecoration.underline,
                      ),
                    )),
              ),

              const SizedBox(height: 8),
              Text(
                '$totalFollowing Followers',
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
                    bio,
                    // "Lorem Ipsum has been the industry's standard dummy text ever since the when an unknown printer took a galley of type and scrambled it to make a type  when an unknown printer took a galley of type  scrambled it to make a type when an unknown printer took a galley of type and scrambled it to make a type ",
                    // overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.quicksand(
                        fontSize: 14, fontWeight: FontWeight.w300),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              ListTile(
                title: Text('Edit Bussiness Info',
                    style: GoogleFonts.quicksand(
                        fontSize: 19, fontWeight: FontWeight.w300)),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const EditProfileScreenBusiness()));
                },
              ),

              // ListTile(
              //   title: Text('Notification',
              //       style: GoogleFonts.quicksand(
              //           fontSize: 19, fontWeight: FontWeight.w300)),
              //   trailing: const Icon(Icons.arrow_forward_ios),
              //   onTap: () {
              //     Navigator.of(context).push(MaterialPageRoute(
              //         builder: (context) => const NotificationScreen()));
              //   },
              // ),
              ListTile(
                title: Text('Followers',
                    style: GoogleFonts.quicksand(
                        fontSize: 19, fontWeight: FontWeight.w300)),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const FollowersScreen()));
                },
              ),
              ListTile(
                title: Text('Settings',
                    style: GoogleFonts.quicksand(
                        fontSize: 19, fontWeight: FontWeight.w300)),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const SettingScreen()));
                },
              ),
              ListTile(
                  onTap: () async {
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    prefs.remove('email');
                    // prefs.clear();
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext ctx) => const LoginPage()));
                  },
                  title: Text('Sign out',
                      style: GoogleFonts.quicksand(
                          fontSize: 19, fontWeight: FontWeight.w300))),
            ],
          ),
        ),
      ),
    );
  }

  Widget signOut() {
    return SizedBox(
      width: 130,
      height: 40,
      // margin: const EdgeInsets.only(top: 15),
      // padding: EdgeInsets.symmetric(horizontal: 16),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          onPrimary: Colors.white,
          primary: const Color.fromRGBO(0, 69, 255, 1),
          // minimumSize: const Size(88, 36),
          padding: const EdgeInsets.symmetric(horizontal: 6),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(30)),
          ),
        ),
        onPressed: () async {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.remove('email');
          prefs.clear();
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (BuildContext ctx) => const LoginPage()));
        },
        child: const Text(
          "Sign Out",
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
      ),
    );
  }
}
