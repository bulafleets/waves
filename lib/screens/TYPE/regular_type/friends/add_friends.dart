// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:waves/screens/contact/see_contact.dart';

// class AddFriendsScreen extends StatefulWidget {
//   const AddFriendsScreen({Key? key}) : super(key: key);

//   @override
//   _AddFriendsScreenState createState() => _AddFriendsScreenState();
// }

// class _AddFriendsScreenState extends State<AddFriendsScreen> {
//   Future<PermissionStatus> _getPermission() async {
//     PermissionStatus permission = await Permission.contacts.status;
//     if (permission != PermissionStatus.granted &&
//         permission != PermissionStatus.permanentlyDenied) {
//       PermissionStatus permissionStatus = await Permission.contacts.request();
//       return permissionStatus;
//     } else {
//       return permission;
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//           centerTitle: true,
//           backgroundColor: Theme.of(context).primaryColor,
//           elevation: 0,
//           title: Text('Add Friends',
//               textAlign: TextAlign.center,
//               style: GoogleFonts.quicksand(
//                   fontWeight: FontWeight.bold,
//                   fontSize: 26,
//                   color: Colors.white)),
//           actions: [
//             TextButton(
//                 child: Text('Invite+',
//                     style: GoogleFonts.quicksand(
//                         fontWeight: FontWeight.w300,
//                         fontSize: 18,
//                         color: Colors.white)),
//                 onPressed: () async {
//                   final PermissionStatus permissionStatus =
//                       await _getPermission();
//                   if (permissionStatus == PermissionStatus.granted) {
//                     Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                             builder: (context) => ContactsPage()));
//                   } else {
//                     //If permissions have been denied show standard cupertino alert dialog
//                     showDialog(
//                         context: context,
//                         builder: (BuildContext context) => CupertinoAlertDialog(
//                               title: Text('Permissions error'),
//                               content: Text('Please enable contacts access '
//                                   'permission in system settings'),
//                               actions: <Widget>[
//                                 CupertinoDialogAction(
//                                   child: Text('OK'),
//                                   onPressed: () => Navigator.of(context).pop(),
//                                 )
//                               ],
//                             ));
//                   }
//                 }),
//           ],
//         ),
//         body: Container(
//             color: Theme.of(context).primaryColor,
//             width: MediaQuery.of(context).size.width,
//             child: ListView(children: [
//               Container(
//                 // width: 300,
//                 height: 50,
//                 margin: EdgeInsets.all(15),
//                 decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(30),
//                     boxShadow: [
//                       BoxShadow(
//                         color: Color.fromRGBO(78, 114, 136, .15),
//                       )
//                     ]),
//                 child: TextField(
//                   style: const TextStyle(color: Colors.black),
//                   keyboardType: TextInputType.text,
//                   cursorColor: Colors.grey,
//                   decoration: InputDecoration(
//                     filled: true,
//                     fillColor: Colors.white,
//                     enabledBorder: UnderlineInputBorder(
//                       borderSide: const BorderSide(color: Colors.white),
//                       borderRadius: BorderRadius.circular(30),
//                     ),
//                     focusedBorder: UnderlineInputBorder(
//                       borderSide: const BorderSide(color: Colors.white),
//                       borderRadius: BorderRadius.circular(30),
//                     ),
//                     prefixIcon: const Icon(Icons.search,
//                         color: Color(0xffb7c2d5), size: 20),
//                     hintText: "Search",
//                     contentPadding: const EdgeInsets.only(top: 15),
//                     // contentPadding:
//                     //     const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
//                     hintStyle: TextStyle(
//                         color: const Color(0xFFb6b3c6).withOpacity(0.8),
//                         fontFamily: 'RobotoRegular'),
//                     border: const OutlineInputBorder(),
//                   ),
//                 ),
//               ),
//               // FutureBuilder<GetAllUsersModel>(
//               //         future: _future,
//               //         builder: (context, snapshot) {
//               //           if (snapshot.hasData) {
//               //             return
//               ListView.builder(
//                   physics: const NeverScrollableScrollPhysics(),
//                   shrinkWrap: true,
//                   itemCount: 10,
//                   itemBuilder: (context, index) {
//                     // var data = snapshot.data!.nearbyUsers[index];
//                     // int age = data.age;
//                     if (index == 0) {
//                       return const SizedBox(height: 20);
//                     }
//                     return Container(
//                       width: MediaQuery.of(context).size.width,
//                       padding: const EdgeInsets.symmetric(
//                           vertical: 8.0, horizontal: 15),
//                       child: Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Row(
//                               children: [
//                                 Container(
//                                     // margin: const EdgeInsets.only(right: 5),
//                                     padding: const EdgeInsets.all(3),
//                                     decoration: BoxDecoration(
//                                       shape: BoxShape.circle,
//                                     ),
//                                     // color: age > 17 && age < 30
//                                     //     ? const Color.fromRGBO(
//                                     //         0, 0, 255, 1)
//                                     //     : age > 29 && age < 50
//                                     //         ? const Color.fromRGBO(
//                                     //             255, 255, 0, 1)
//                                     //         : const Color.fromRGBO(
//                                     //             0, 255, 128, 1)),
//                                     child: CircleAvatar(
//                                       radius: 25,
//                                       // backgroundImage: data.avatar != null
//                                       //     ? NetworkImage(data.avatar)
//                                       //     : null,
//                                     )),
//                                 SizedBox(width: 15),
//                                 Text('data.username',
//                                     style: GoogleFonts.quicksand(
//                                         fontSize: 17,
//                                         fontWeight: FontWeight.w500,
//                                         color: Colors.white)),
//                               ],
//                             ),
//                             button()
//                           ]),
//                     );
//                   })
//             ])));
//   }

//   Widget button() {
//     return SizedBox(
//       // margin: const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 50.0),
//       height: 40,
//       child: ElevatedButton(
//         style: ElevatedButton.styleFrom(
//           onPrimary: Colors.white,
//           primary: const Color.fromRGBO(0, 69, 255, 1),
//           minimumSize: const Size(88, 36),
//           padding: const EdgeInsets.symmetric(horizontal: 16),
//           shape: const RoundedRectangleBorder(
//             borderRadius: BorderRadius.all(Radius.circular(30)),
//           ),
//         ),
//         onPressed: () {},
//         child: const Text(
//           "Add",
//           style: TextStyle(
//               color: Colors.white, fontSize: 18, fontFamily: 'RobotoBold'),
//         ),
//       ),
//     );
//   }
// }
