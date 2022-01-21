import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class ActivityScreen extends StatefulWidget {
  const ActivityScreen({Key? key}) : super(key: key);

  @override
  _ActivityScreenState createState() => _ActivityScreenState();
}

class _ActivityScreenState extends State<ActivityScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
            preferredSize: Size.fromHeight(80.0), // here the desired height
            child: AppBar(
              backgroundColor: Theme.of(context).primaryColor,
              actions: [
                Padding(
                  padding: const EdgeInsets.only(top: 18.0, right: 5),
                  child: IconButton(
                    iconSize: 24,
                    alignment: Alignment.bottomLeft,
                    icon: const FaIcon(FontAwesomeIcons.plus),
                    onPressed: () {},
                  ),
                )
              ],
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
        body: ListView.builder(
            itemCount: 10,
            itemBuilder: (context, index) {
              if (index == 0) {
                return const SizedBox(height: 15);
              }
              return Container(
                width: MediaQuery.of(context).size.width - 20,
                height: 102,
                // padding: const EdgeInsets.all(8),
                margin: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: Color.fromRGBO(188, 220, 243, 1)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      width: 102,
                      // color: Colors.black,
                      margin: const EdgeInsets.only(right: 20),
                      child: Stack(
                        alignment: Alignment.bottomRight,
                        children: const [
                          CircleAvatar(
                            radius: 60,
                            backgroundColor: Colors.black,
                            child: CircleAvatar(
                              radius: 48,
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
                    ),
                    Column(crossAxisAlignment: CrossAxisAlignment.start,
                        // mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          SizedBox(height: 15),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'My Wave',
                                style: GoogleFonts.quicksand(
                                    fontSize: 17, fontWeight: FontWeight.w500),
                              ),
                              SizedBox(width: 30),
                              Text(
                                '2m',
                                style: GoogleFonts.quicksand(
                                    fontSize: 12, fontWeight: FontWeight.w400),
                              ),
                            ],
                          ),
                          SizedBox(height: 15),
                          Text(
                            'Checked into Bar Name',
                            style: GoogleFonts.quicksand(
                                fontSize: 17, fontWeight: FontWeight.w400),
                          ),
                          SizedBox(height: 5),
                        ]),
                    Padding(
                      padding: const EdgeInsets.only(left: 12.0),
                      child: IconButton(
                          iconSize: 30,
                          onPressed: () {},
                          icon: FaIcon(
                            FontAwesomeIcons.solidTimesCircle,
                            color: Theme.of(context).primaryColor,
                          )),
                    ),
                  ],
                ),
              );
            }));
  }
}
