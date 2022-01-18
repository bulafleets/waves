import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        actions: [
          IconButton(
            icon: FaIcon(FontAwesomeIcons.plus),
            onPressed: () {},
          )
        ],
        title: Image.asset('assets/login.png', width: 85, height: 61),
        centerTitle: true,
      ),
      body: Container(
        height: 102,
        // padding: const EdgeInsets.all(8),
        margin: const EdgeInsets.all(10),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(55),
            color: Color.fromRGBO(188, 220, 243, 1)),
        child: Row(
          children: [
            Stack(
              alignment: Alignment.bottomRight,
              children: const [
                CircleAvatar(
                  radius: 60,
                  backgroundColor: Colors.black,
                  child: CircleAvatar(
                    radius: 50,
                    backgroundImage: NetworkImage(
                        "https://i.pinimg.com/564x/bd/cd/4e/bdcd4e097d609543724874b01aa91c76.jpg"),
                  ),
                ),
                CircleAvatar(
                  radius: 17,
                  child: CircleAvatar(
                    radius: 15,
                    backgroundImage: NetworkImage(
                        "https://miro.medium.com/max/1200/1*mk1-6aYaf_Bes1E3Imhc0A.jpeg"),
                  ),
                ),
              ],
            ),
            Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        ' Person Name',
                        style: GoogleFonts.quicksand(
                            fontSize: 17, fontWeight: FontWeight.w500),
                      ),
                      SizedBox(width: 15),
                      FaIcon(FontAwesomeIcons.solidIdBadge)
                    ],
                  ),
                  SizedBox(height: 5),
                  Text(
                    'Checked into Bar Name',
                    style: GoogleFonts.quicksand(
                        fontSize: 17, fontWeight: FontWeight.w400),
                  ),
                ])
          ],
        ),
      ),
    );
  }
}
