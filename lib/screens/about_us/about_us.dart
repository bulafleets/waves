import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:waves/contants/common_params.dart';
import 'package:waves/screens/Main/main_page.dart';
import 'package:waves/screens/friends/add_friends.dart';

class AboutUs extends StatefulWidget {
  final String name;
  final bool isLogin;
  // ignore: use_key_in_widget_constructors
  const AboutUs(this.name, this.isLogin);
  @override
  _AboutUsState createState() => _AboutUsState();
}

class _AboutUsState extends State<AboutUs> {
  int _current = 0;
  final CarouselController _controller = CarouselController();
  // final List<Widget> dummyText = const [
  //   Text(
  //       'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry\'s standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.',
  //       style: TextStyle(color: Colors.white, fontSize: 16, height: 1.3),
  //       maxLines: 8,
  //       textAlign: TextAlign.center),
  //   Text(
  //       'It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout. The point of using Lorem Ipsum is that it has a more-or-less normal distribution of letters, as opposed to using Content here, content here, making it look like readable English. Many desktop publishing packages and web page editors now use Lorem Ipsum as their default model text, and a search for lorem ipsum will uncover many web sites still in their infancy. Various versions have evolved over the years, sometimes by accident, sometimes on purpose (injected humour and the like).',
  //       style: TextStyle(color: Colors.white, fontSize: 16, height: 1.3),
  //       maxLines: 8,
  //       textAlign: TextAlign.center),
  //   Text(
  //       'Contrary to popular belief, Lorem Ipsum is not simply random text. It has roots in a piece of classical Latin literature from 45 BC, making it over 2000 years old. Richard McClintock, a Latin professor at Hampden-Sydney College in Virginia, looked up one of the more obscure Latin words, consectetur, from a Lorem Ipsum passage, and going through the cites of the word in classical literature, discovered the undoubtable source. Lorem Ipsum comes from sections 1.10.32 and 1.10.33 of "de Finibus Bonorum et Malorum" (The Extremes of Good and Evil) by Cicero, written in 45 BC. This book is a treatise on the theory of ethics, very popular during the Renaissance. The first line of Lorem Ipsum, "Lorem ipsum dolor sit amet..", comes from a line in section 1.10.32.',
  //       style: TextStyle(color: Colors.white, fontSize: 16, height: 1.3),
  //       maxLines: 8,
  //       textAlign: TextAlign.center),
  // ];
  late int textLength;
  static const textSize = 16.0;

  @override
  void initState() {
    textLength = aboutdata.length;
    debugPrint('Text Length: $textLength');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var deviceData = MediaQuery.of(context);
    var deviceHeight = deviceData.size.height;
    var deviceWidth =
        deviceData.size.width - 60; // 60 - AppBar estimated height
    var deviceDimension = deviceHeight * deviceWidth;

    /// Compute estimated character limit per page
    /// Estimated dimension of each character: textSize * (textSize * 0.8)
    /// textSize width estimated dimension is 80% of its height
    var pageCharLimit =
        (deviceDimension / (textSize * (textSize * 2.3))).round();
    debugPrint('Character limit per page: $pageCharLimit');

    /// Compute pageCount base from the computed pageCharLimit
    var pageCount = (textLength / pageCharLimit).round();
    debugPrint('Pages: $pageCount');

    List<Widget> pageText = [];
    var index = 0;
    var startStrIndex = 0;
    var endStrIndex = pageCharLimit;
    while (index < pageCount) {
      /// Update the last index to the Document Text length
      if (index == pageCount - 1) endStrIndex = textLength;

      /// Add String on List<String>
      pageText.add(Text(
        aboutdata.substring(startStrIndex, endStrIndex),
        style: const TextStyle(color: Colors.white, fontSize: 16, height: 1.3),
      ));

      /// Update index of Document Text String to be added on [pageText]
      if (index < pageCount) {
        startStrIndex = endStrIndex;
        endStrIndex += pageCharLimit;
      }
      index++;
    }
    debugPrint(pageCount.toString());
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
            width: MediaQuery.of(context).size.width,
            color: Theme.of(context).primaryColor,
            padding: const EdgeInsets.all(20),
            child: Column(children: [
              const SizedBox(height: 60),
              Text('Hi ${widget.name}!',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.quicksand(
                      fontWeight: FontWeight.bold,
                      fontSize: 37,
                      color: Colors.white)),
              const SizedBox(height: 40),
              Image.asset(
                'assets/login.png',
                height: 142,
                width: 201,
                fit: BoxFit.cover,
              ),
              const SizedBox(height: 50),
              Text('About Us',
                  style: GoogleFonts.quicksand(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold)),
              const SizedBox(height: 15),
              CarouselSlider(
                items: pageText,
                carouselController: _controller,
                options: CarouselOptions(
                    autoPlay: false,
                    enlargeCenterPage: false,
                    viewportFraction: 1,
                    aspectRatio: 1.5,
                    onPageChanged: (index, reason) {
                      setState(() {
                        _current = index;
                      });
                    }),
              ),
              Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: pageText.asMap().entries.map((entry) {
                    return GestureDetector(
                      onTap: () => _controller.animateToPage(entry.key),
                      child: Container(
                          width: 11.0,
                          height: 11.0,
                          margin: const EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 4.0),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: _current != entry.key
                                    ? Colors.grey
                                    : Colors.white,
                                spreadRadius: 1,
                              )
                            ],
                            color: _current != entry.key
                                ? Colors.grey[300]
                                : Colors.blue[900],
                          )
                          // color: (Theme.of(context).brightness == Brightness.dark
                          //         ? Colors.white
                          //         : Colors.blue)
                          //     .withOpacity(_current == entry.key ? 0.9 : 0.4)),
                          ),
                    );
                  }).toList()),
              const SizedBox(height: 25),
              nextbutton(),
            ])),
      ),
    );
  }

  Widget nextbutton() {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 50.0),
      height: 60,
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
        onPressed: () async {
          SharedPreferences _prefs = await SharedPreferences.getInstance();
          _prefs.setString('seen', 'true');
          if (AccountType == 'REGULAR') {
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                    builder: (context) => widget.isLogin
                        ? const MainPage(0)
                        : const AddFriends(false)),
                (Route<dynamic> route) => false);
          } else {
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => const MainPage(0)),
                (Route<dynamic> route) => false);
          }
        },
        child: const Text(
          "Continue",
          style: TextStyle(
              color: Colors.white, fontSize: 18, fontFamily: 'RobotoBold'),
        ),
      ),
    );
  }
}
