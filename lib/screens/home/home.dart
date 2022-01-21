import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:waves/screens/wave_details/wave_details_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
            preferredSize: Size.fromHeight(80.0), // here the desired height
            child: AppBar(
              backgroundColor: Theme.of(context).primaryColor,
              leading: Padding(
                padding: const EdgeInsets.only(top: 18.0, left: 5),
                child: IconButton(
                  iconSize: 24,
                  alignment: Alignment.bottomLeft,
                  icon: const FaIcon(FontAwesomeIcons.solidBell),
                  onPressed: () {},
                ),
              ),
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
              return InkWell(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const WaveDetailsScreen()));
                },
                child: Container(
                  height: 102,
                  // padding: const EdgeInsets.all(8),
                  margin: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: const Color.fromRGBO(188, 220, 243, 1)),
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
                      Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Row(
                              children: [
                                Text(
                                  'Person Name',
                                  style: GoogleFonts.quicksand(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w500),
                                ),
                                SizedBox(width: 15),
                                FaIcon(FontAwesomeIcons.solidIdBadge),
                                SizedBox(width: 30),
                                Text(
                                  '2m',
                                  style: GoogleFonts.quicksand(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400),
                                ),
                              ],
                            ),
                            SizedBox(height: 5),
                            Text(
                              'Checked into Bar Name',
                              style: GoogleFonts.quicksand(
                                  fontSize: 17, fontWeight: FontWeight.w400),
                            ),
                            SizedBox(height: 5),
                            Text(
                              '21/01/2021  2:00pm - 6:00pm',
                              style: GoogleFonts.quicksand(
                                  fontSize: 10, fontWeight: FontWeight.w400),
                            ),
                            SizedBox(height: 5),
                          ])
                    ],
                  ),
                ),
              );
            }));
  }
}
