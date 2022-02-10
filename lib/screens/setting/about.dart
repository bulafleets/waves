import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:waves/contants/common_params.dart';

class AboutScreen extends StatefulWidget {
  const AboutScreen({Key? key}) : super(key: key);

  @override
  _AboutScreenState createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0,
        title: Text('About',
            style: GoogleFonts.ptSans(
                fontWeight: FontWeight.w700,
                fontSize: 28,
                color: Colors.white)),
        centerTitle: true,
      ),
      body: Container(
        color: Theme.of(context).primaryColor,
        padding: const EdgeInsets.all(25),
        child: ListView(
          children: [
            const SizedBox(height: 50),
            Image.asset(
              'assets/login.png',
              height: 106,
              width: 148,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 60),
            Text(aboutdata,
                textAlign: TextAlign.left,
                style: GoogleFonts.ptSans(
                    fontWeight: FontWeight.w300,
                    fontSize: 15,
                    color: Colors.white))
          ],
        ),
      ),
    );
  }

  // Future<void> aboutdata() async {
  //   http.Response response =
  //       await http.post(Uri.parse(AboutData), body: {"slug": "about_us"});
  //   final jsonString = response.body;

  //   final jsonMap = jsonDecode(jsonString);
  //   var status = jsonMap['status'];
  //   if (status == '200') {
  //     setState(() {
  //       description = jsonMap['data']['description'];
  //     });
  //   }
  // }
}
