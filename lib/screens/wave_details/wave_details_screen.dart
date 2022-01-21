import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class WaveDetailsScreen extends StatefulWidget {
  const WaveDetailsScreen({Key? key}) : super(key: key);

  @override
  _WaveDetailsScreenState createState() => _WaveDetailsScreenState();
}

class _WaveDetailsScreenState extends State<WaveDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(80.0), // here the desired height
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
      body: Column(
        children: [
          Container(
              height: 250,
              decoration: const BoxDecoration(
                color: Color.fromRGBO(188, 220, 243, 1),
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(60),
                    bottomRight: Radius.circular(60)),
              ),
              child: Column(children: [
                Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                  Container(
                    // width: 102,
                    // color: Colors.black,
                    margin: const EdgeInsets.only(right: 20, left: 20),
                    child: Stack(
                      alignment: Alignment.bottomRight,
                      children: const [
                        CircleAvatar(
                          radius: 50,
                          backgroundColor: Colors.black,
                          child: CircleAvatar(
                            radius: 48,
                            backgroundImage: NetworkImage(
                                "https://i.pinimg.com/564x/bd/cd/4e/bdcd4e097d609543724874b01aa91c76.jpg"),
                          ),
                        ),
                        CircleAvatar(
                          radius: 19,
                          child: CircleAvatar(
                            radius: 17,
                            backgroundImage: NetworkImage(
                                "https://miro.medium.com/max/1200/1*mk1-6aYaf_Bes1E3Imhc0A.jpeg"),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        SizedBox(height: 10),
                        Row(
                          children: [
                            Text(
                              'Wave Name',
                              style: GoogleFonts.quicksand(
                                  fontSize: 19, fontWeight: FontWeight.w500),
                            ),
                            SizedBox(width: 15),
                            FaIcon(
                              FontAwesomeIcons.shieldAlt,
                              color: Color.fromRGBO(0, 149, 242, 1),
                              size: 18,
                            ),
                            SizedBox(width: 30),
                            Text(
                              '2m',
                              style: GoogleFonts.quicksand(
                                  fontSize: 12, fontWeight: FontWeight.w400),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Restaurant Name',
                          style: GoogleFonts.quicksand(
                              fontSize: 17, fontWeight: FontWeight.w300),
                        ),
                        SizedBox(height: 15),
                        Text(
                          'Event Type  21/01/2021  2:00pm - 6:00pm',
                          style: GoogleFonts.quicksand(
                              fontSize: 10, fontWeight: FontWeight.w400),
                        ),
                        SizedBox(
                          height: 10,
                        )
                      ])
                ]),
                Row(children: [
                  SizedBox(width: 30),
                  Column(children: [
                    Row(children: [
                      Text('4.5'),
                      Icon(Icons.star, color: Colors.yellow)
                    ]),
                    Row(children: [
                      Text('Review',
                          style: GoogleFonts.quicksand(
                              fontSize: 13, fontWeight: FontWeight.w300)),
                      Icon(Icons.edit_location_alt, size: 20)
                    ]),
                  ]),
                  SizedBox(width: 50),
                  Expanded(
                      child: Text(
                          "Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type ",
                          textAlign: TextAlign.start,
                          overflow: TextOverflow.fade,
                          style: GoogleFonts.quicksand(
                              fontSize: 14, fontWeight: FontWeight.w500)))
                ]),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton.icon(
                        onPressed: () {},
                        label: Icon(Icons.location_on,
                            color: Color.fromRGBO(42, 124, 202, 1)),
                        icon: Text('See Location',
                            style: GoogleFonts.quicksand(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                                color: Color.fromRGBO(42, 124, 202, 1)))),
                    SizedBox(width: 15),
                    TextButton(
                        onPressed: () {},
                        child: Text('Check-In',
                            style: GoogleFonts.quicksand(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                                color: Color.fromRGBO(42, 124, 202, 1)))),
                  ],
                )
              ])),
        ],
      ),
    );
  }
}
