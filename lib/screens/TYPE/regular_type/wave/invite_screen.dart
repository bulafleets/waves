import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class InviteScreen extends StatefulWidget {
  const InviteScreen({Key? key}) : super(key: key);

  @override
  _InviteScreenState createState() => _InviteScreenState();
}

class _InviteScreenState extends State<InviteScreen> {
  TextEditingController searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
            preferredSize:
                const Size.fromHeight(80.0), // here the desired height
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
                    onTap: () {},
                    style: const TextStyle(color: Colors.black),
                    controller: searchController,
                    keyboardType: TextInputType.text,
                    cursorColor: Colors.grey,
                    decoration: InputDecoration(
                        suffixIcon: searchController.text.isNotEmpty
                            ? GestureDetector(
                                onTap: () {},
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
                ])));
  }
}
