import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:waves/screens/Main/main_page.dart';
import 'package:waves/screens/TYPE/bussiness_type/home/homePage_bussiness.dart';

class WaveCreatedSuccesfully extends StatelessWidget {
  const WaveCreatedSuccesfully({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset('assets/icons/Icon-check-circle.png'),
            const SizedBox(height: 30),
            Text('Wave Created',
                style: GoogleFonts.quicksand(
                    color: const Color.fromRGBO(0, 69, 255, 1),
                    fontSize: 22,
                    fontWeight: FontWeight.w700)),
            const SizedBox(height: 25),
            SizedBox(
              width: MediaQuery.of(context).size.width / 2 + 10,
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
                onPressed: () {
                  // showBottomSheet(
                  //     context: context, builder: (context) => SelectDateTime());
                  // _selectDate(context);
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) => const MainPage()),
                      (Route<dynamic> route) => false);
                },
                child: Text(
                  "Take me Home",
                  style:
                      GoogleFonts.quicksand(color: Colors.white, fontSize: 16),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
