import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class CommentScreen extends StatefulWidget {
  const CommentScreen({Key? key}) : super(key: key);

  @override
  _CommentScreenState createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      child: ListView.builder(
          itemCount: 10,
          itemBuilder: (context, index) {
            return Container(
              height: 200,
              width: MediaQuery.of(context).size.width - 50,
              padding: const EdgeInsets.all(15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(radius: 30),
                  SizedBox(width: 15),
                  Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Persons Name',
                            style: GoogleFonts.quicksand(
                                fontSize: 15, fontWeight: FontWeight.w500)),
                        SizedBox(height: 10),
                        Container(
                          width: MediaQuery.of(context).size.width - 150,
                          child: Text(
                              "Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took",
                              maxLines: 4,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.quicksand(
                                  fontSize: 12, fontWeight: FontWeight.w300)),
                        ),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              IconButton(
                                onPressed: () {},
                                icon: const FaIcon(FontAwesomeIcons.heart,
                                    size: 16),
                              ),
                              Text('3 Likes  |',
                                  style: GoogleFonts.quicksand(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w200)),
                              SizedBox(width: 5),
                              TextButton(
                                  onPressed: () {},
                                  child: Text('Reply',
                                      style: GoogleFonts.quicksand(
                                          fontSize: 12,
                                          color:
                                              const Color.fromRGBO(0, 0, 0, 1),
                                          fontWeight: FontWeight.w200))),
                            ]),
                        Row(
                          children: [
                            Container(
                                height: 2,
                                width: 36,
                                color: const Color.fromARGB(112, 112, 112, 1)),
                            TextButton.icon(
                              onPressed: () {},
                              label: const FaIcon(FontAwesomeIcons.chevronDown,
                                  color: Color.fromRGBO(0, 0, 0, 1), size: 13),
                              icon: Text('view 3 Replies',
                                  style: GoogleFonts.quicksand(
                                      fontSize: 12,
                                      color: const Color.fromRGBO(0, 0, 0, 1),
                                      fontWeight: FontWeight.w200)),
                            )
                          ],
                        )
                      ]),
                  Text('2m',
                      style: GoogleFonts.quicksand(
                          fontSize: 12, fontWeight: FontWeight.w300))
                ],
              ),
            );
          }),
    );
  }
}
