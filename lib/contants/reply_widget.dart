import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:waves/contants/common_widgets.dart';
import 'package:waves/contants/leave_comment.dart';
import 'package:waves/models/singlewave_model.dart';

class ReplyScreen extends StatefulWidget {
  final List<CommentReply> reply;

  const ReplyScreen(this.reply, {Key? key}) : super(key: key);

  @override
  _ReplyScreenState createState() => _ReplyScreenState();
}

class _ReplyScreenState extends State<ReplyScreen> {
  bool _like = false;
  @override
  Widget build(BuildContext context) {
    double vv = widget.reply.length.toDouble();
    return SizedBox(
      // height: double.maxFinite,
      height: 50 * vv,
      width: 250,
      child: ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: widget.reply.length,
          itemBuilder: (context, index) {
            // var time = DateTime.now()
            //     .difference(widget.reply[index])
            //     .inMinutes;
            // String tt = time > 59
            //     ? time > 1440
            //         ? '${DateTime.now().difference(widget.comment[index].createdAt).inDays.toString()} d'
            //         : '${DateTime.now().difference(widget.comment[index].createdAt).inHours.toString()} h'
            //     : "${DateTime.now().difference(widget.comment[index].createdAt).inMinutes.toString()} m";
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundImage: NetworkImage(widget.reply[index].avatar),
                ),
                const SizedBox(width: 15),
                Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.reply[index].username,
                          style: GoogleFonts.quicksand(
                              fontSize: 15, fontWeight: FontWeight.w500)),
                      const SizedBox(height: 10),
                      SizedBox(
                        width: 190,
                        child: Text(widget.reply[index].comment,
                            maxLines: 4,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.quicksand(
                                fontSize: 12, fontWeight: FontWeight.w300)),
                      ),
                      // Row(
                      //     mainAxisAlignment: MainAxisAlignment.start,
                      //     children: [
                      //       IconButton(
                      //         onPressed: () {
                      //           // setState(() {
                      //           //   _like = !_like;
                      //           // });
                      //           // likeAPi(widget.reply[index].);
                      //         },
                      //         icon: _like
                      //             ? const FaIcon(FontAwesomeIcons.solidHeart,
                      //                 color: Colors.red, size: 20)
                      //             : const FaIcon(FontAwesomeIcons.heart,
                      //                 size: 16),
                      //       ),
                      //       Text(
                      //           '${widget.reply[index].commentLikes.length} Likes  ',
                      //           style: GoogleFonts.quicksand(
                      //               fontSize: 12, fontWeight: FontWeight.w200)),
                      //       // SizedBox(width: 5),
                      //       // TextButton(
                      //       //     onPressed: () {
                      //       //       showDialog(
                      //       //           context: context,
                      //       //           builder: (_) => const LeaveComment());
                      //       //     },
                      //       //     child: Text('Reply',
                      //       //         style: GoogleFonts.quicksand(
                      //       //             fontSize: 12,
                      //       //             color: const Color.fromRGBO(0, 0, 0, 1),
                      //       //             fontWeight: FontWeight.w200))),
                      //     ]),
                    ]),
                // Text(tt,
                //     style: GoogleFonts.quicksand(
                //         fontSize: 12, fontWeight: FontWeight.w300))
              ],
            );
          }),
    );
  }
}