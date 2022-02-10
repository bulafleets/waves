import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:waves/contants/common_params.dart';
import 'package:waves/screens/TYPE/regular_type/friends/friends_screen.dart';
import 'package:waves/screens/auth/login_page.dart';
import 'package:waves/screens/friends/add_friends.dart';
import 'package:waves/screens/notification/notification_screen.dart';
import 'package:waves/screens/profile/edit_profile.dart';
import 'package:waves/screens/setting/setting_screen.dart';

class MyProfileScreen extends StatefulWidget {
  const MyProfileScreen({Key? key}) : super(key: key);

  @override
  _MyProfileScreenState createState() => _MyProfileScreenState();
}

class _MyProfileScreenState extends State<MyProfileScreen> {
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
                      radius: 57, backgroundImage: NetworkImage(profileimg)),
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
                const FaIcon(
                  FontAwesomeIcons.solidIdBadge,
                  color: Color.fromRGBO(38, 125, 213, 1),
                  size: 22,
                )
              ]),
              Text(
                email,
                style: GoogleFonts.quicksand(
                    fontSize: 15, fontWeight: FontWeight.w300),
              ),
              const SizedBox(height: 20),
              if (AccountType == "BUSINESS")
                Text(
                  '10,000 Following',
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
                title: Text('Edit Profile',
                    style: GoogleFonts.quicksand(
                        fontSize: 19, fontWeight: FontWeight.w300)),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const EditProfileScreen()));
                },
              ),
              ListTile(
                title: Text('Privacy Settings',
                    style: GoogleFonts.quicksand(
                        fontSize: 19, fontWeight: FontWeight.w300)),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {},
              ),
              ListTile(
                title: Text('Notification',
                    style: GoogleFonts.quicksand(
                        fontSize: 19, fontWeight: FontWeight.w300)),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const NotificationScreen()));
                },
              ),
              ListTile(
                title: Text('Friends',
                    style: GoogleFonts.quicksand(
                        fontSize: 19, fontWeight: FontWeight.w300)),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const FriendsScreen()));
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
