import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MapPopScreen extends StatefulWidget {
  final String image;
  final String waveName;
  final String waveDetail;
  final String waveHistory;
  const MapPopScreen(
      {Key? key,
      required this.image,
      required this.waveName,
      required this.waveDetail,
      required this.waveHistory})
      : super(key: key);
  @override
  State<StatefulWidget> createState() => MapPopScreenState();
}

class MapPopScreenState extends State<MapPopScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> scaleAnimation;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 450));
    scaleAnimation =
        CurvedAnimation(parent: controller, curve: Curves.fastOutSlowIn);

    controller.addListener(() {
      setState(() {});
    });

    controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
        child: Center(
          child: Material(
            color: Colors.transparent,
            child: ScaleTransition(
              scale: scaleAnimation,
              child: Container(
                  margin: const EdgeInsets.all(10.0),
                  height: 320.0,
                  width: 320,
                  decoration: ShapeDecoration(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                          side: const BorderSide(color: Colors.white))),
                  child: Column(
                    children: <Widget>[
                      const SizedBox(height: 8),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const SizedBox(width: 40),
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: CircleAvatar(
                                  radius: 46,
                                  backgroundColor: Colors.black,
                                  child: CircleAvatar(
                                    radius: 45,
                                    child: CachedNetworkImage(
                                      imageUrl: widget.image,
                                      imageBuilder: (context, imageProvider) =>
                                          Container(
                                        width: double.infinity,
                                        height: double.infinity,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          image: DecorationImage(
                                              image: imageProvider,
                                              fit: BoxFit.cover),
                                        ),
                                      ),
                                      placeholder: (context, url) =>
                                          const CircularProgressIndicator(),
                                      errorWidget: (context, url, error) =>
                                          const Icon(Icons.error),
                                    ),
                                    // backgroundImage:
                                    //     NetworkImage(widget.image)
                                  )),
                            ),
                            SizedBox(
                              height: 100,
                              child: IconButton(
                                  alignment: Alignment.topRight,
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  icon: const Icon(Icons.close, size: 28)),
                            )
                          ]),
                      const SizedBox(height: 8),
                      Text(widget.waveName,
                          style: GoogleFonts.quicksand(
                              color: const Color.fromRGBO(38, 69, 255, 1),
                              fontSize: 21,
                              fontWeight: FontWeight.w700)),
                      const SizedBox(height: 8),
                      Text(widget.waveDetail,
                          style: GoogleFonts.quicksand(
                              color: const Color.fromRGBO(38, 69, 255, 1),
                              fontSize: 18,
                              fontWeight: FontWeight.w300)),
                      const SizedBox(height: 15),
                      const Divider(color: Color.fromRGBO(128, 50, 246, 1)),
                      SizedBox(
                        width: 280,
                        child: Text('Created Waves',
                            textAlign: TextAlign.left,
                            style: GoogleFonts.quicksand(
                                color: const Color.fromRGBO(38, 69, 255, 1),
                                fontSize: 16,
                                fontWeight: FontWeight.w500)),
                      ),
                      const SizedBox(height: 5),
                      ListTile(
                          leading: const CircleAvatar(radius: 18),
                          title: Text('Name name',
                              style: GoogleFonts.quicksand(
                                  color: const Color.fromRGBO(38, 69, 255, 1),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w300)))
                    ],
                  )),
            ),
          ),
        ));
  }
}
