import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
    return SizedBox(
      width: 240,
      child: ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: widget.reply.length,
          itemBuilder: (context, index) {
            var time = DateTime.now()
                .difference(widget.reply[index].createdAt)
                .inMinutes;
            String tt = time > 59
                ? time > 1440
                    ? '${DateTime.now().difference(widget.reply[index].createdAt).inDays.toString()} d'
                    : '${DateTime.now().difference(widget.reply[index].createdAt).inHours.toString()} h'
                : "${DateTime.now().difference(widget.reply[index].createdAt).inMinutes.toString()} m";
            return Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 20,
                    child: CachedNetworkImage(
                      imageUrl: widget.reply[index].avatar,
                      imageBuilder: (context, imageProvider) => Container(
                        width: double.infinity,
                        height: double.infinity,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                              image: imageProvider, fit: BoxFit.cover),
                        ),
                      ),
                      placeholder: (context, url) =>
                          const CircularProgressIndicator(),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                    ),
                    // backgroundImage: NetworkImage(widget.reply[index].avatar),
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
                          width: 140,
                          child: Text(widget.reply[index].comment,
                              // overflow: TextOverflow.ellipsis,
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
                  Text(tt,
                      style: GoogleFonts.quicksand(
                          fontSize: 12, fontWeight: FontWeight.w300))
                ],
              ),
            );
          }),
    );
  }
}
