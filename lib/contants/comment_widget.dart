import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:waves/contants/common_params.dart';
import 'package:waves/contants/common_widgets.dart';
import 'package:waves/contants/leave_comment.dart';
import 'package:waves/contants/reply_comment.dart';
import 'package:waves/contants/reply_widget.dart';
import 'package:waves/models/singlewave_model.dart';
import 'package:http/http.dart' as http;

class CommentScreen extends StatefulWidget {
  final List<WaveComment> comment;
  final String waveId;
  final String userid;

  const CommentScreen(this.comment, this.waveId, this.userid, {Key? key})
      : super(key: key);

  @override
  _CommentScreenState createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  bool _isReply = false;
  var _likeData = [];
  var _likeCount = [];
  late List<bool> _reply;
  List<WaveComment> _commentData = [];

  @override
  void initState() {
    _reply = List.filled(widget.comment.length, false);

    _commentData = widget.comment;
    for (var element in _commentData) {
      if (element.commentLikes.map((e) => e).contains(user_id)) {
        _likeData.add(element.id);
      }
    }
    super.initState();
  }

  final List<String> _list = [];
  final List<CommentReply> _d = [];
  void _commentText(String commentText) {
    setState(() {
      _commentData.add(WaveComment(
          id: '',
          commentLikes: _list,
          commentReply: _d,
          userId: user_id,
          waveId: widget.waveId,
          comment: commentText,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
          v: 1,
          avatar: profileimg,
          username: name));
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_commentData.isEmpty) {
      return Container(
          margin: const EdgeInsets.only(bottom: 25),
          height: MediaQuery.of(context).size.height,
          child: Column(children: [
            if (widget.userid != user_id)
              Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
                Text(
                  'COMMENTS',
                  style: GoogleFonts.quicksand(
                      fontSize: 19, fontWeight: FontWeight.w300),
                ),
                TextButton(
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (_) =>
                              LeaveComment(widget.waveId, _commentText));
                    },
                    child: Text(
                      'Leave a comment+',
                      style: GoogleFonts.quicksand(
                          fontSize: 13,
                          color: const Color.fromRGBO(42, 124, 202, 1),
                          fontWeight: FontWeight.w300),
                    ))
              ]),
            SizedBox(
              height: 150,
              child: Center(
                  child: Text(
                'No comment found !',
                style: GoogleFonts.quicksand(
                    fontSize: 15,
                    color: Colors.black,
                    fontWeight: FontWeight.w300),
              )),
            )
          ]));
    } else {
      return Container(
        margin: const EdgeInsets.only(bottom: 25),
        height: MediaQuery.of(context).size.height,
        child: Column(children: [
          if (widget.userid != user_id)
            Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
              Text(
                'COMMENTS',
                style: GoogleFonts.quicksand(
                    fontSize: 19, fontWeight: FontWeight.w300),
              ),
              TextButton(
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (_) =>
                            LeaveComment(widget.waveId, _commentText));
                  },
                  child: Text(
                    'Leave a comment+',
                    style: GoogleFonts.quicksand(
                        fontSize: 13,
                        color: const Color.fromRGBO(42, 124, 202, 1),
                        fontWeight: FontWeight.w300),
                  ))
            ]),
          ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _commentData.length,
              itemBuilder: (context, index) {
                var time = DateTime.now()
                    .difference(_commentData[index].createdAt)
                    .inMinutes;
                String tt = time > 59
                    ? time > 1440
                        ? '${DateTime.now().difference(_commentData[index].createdAt).inDays.toString()} d'
                        : '${DateTime.now().difference(_commentData[index].createdAt).inHours.toString()} h'
                    : "${DateTime.now().difference(_commentData[index].createdAt).inMinutes.toString()} m";
                return Container(
                  // height: 200,
                  // width: MediaQuery.of(context).size.width - 50,
                  padding: const EdgeInsets.all(15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                          radius: 30,
                          backgroundImage:
                              NetworkImage(_commentData[index].avatar)),
                      const SizedBox(width: 15),
                      Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(_commentData[index].username,
                                style: GoogleFonts.quicksand(
                                    fontSize: 15, fontWeight: FontWeight.w500)),
                            const SizedBox(height: 10),
                            SizedBox(
                              width: MediaQuery.of(context).size.width - 150,
                              child: Text(_commentData[index].comment,
                                  maxLines: 4,
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.quicksand(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w300)),
                            ),
                            Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      setState(() {
                                        _likeCount.contains(
                                                _commentData[index].id)
                                            ? _likeCount
                                                .remove(_commentData[index].id)
                                            : _likeCount
                                                .add(_commentData[index].id);

                                        _likeData.contains(
                                                _commentData[index].id)
                                            ? _likeData
                                                .remove(_commentData[index].id)
                                            : _likeData
                                                .add(_commentData[index].id);
                                      });
                                      likeAPi(_commentData[index].id, index);
                                    },
                                    icon: _likeData
                                            .contains(_commentData[index].id)
                                        ? const FaIcon(
                                            FontAwesomeIcons.solidHeart,
                                            color: Colors.red,
                                            size: 20)
                                        : const FaIcon(FontAwesomeIcons.heart,
                                            size: 16),
                                  ),
                                  if (_likeData
                                          .contains(_commentData[index].id) &&
                                      _likeCount
                                          .contains(_commentData[index].id))
                                    Text(
                                        '${_commentData[index].commentLikes.length + 1} Likes  |',
                                        style: GoogleFonts.quicksand(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w200)),
                                  if (_likeData
                                          .contains(_commentData[index].id) &&
                                      !_likeCount
                                          .contains(_commentData[index].id))
                                    Text(
                                        '${_commentData[index].commentLikes.length} Likes  |',
                                        style: GoogleFonts.quicksand(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w200)),
                                  if (!_likeData
                                          .contains(_commentData[index].id) &&
                                      !_likeCount
                                          .contains(_commentData[index].id))
                                    Text(
                                        '${_commentData[index].commentLikes.length} Likes  |',
                                        style: GoogleFonts.quicksand(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w200)),
                                  if (!_likeData
                                          .contains(_commentData[index].id) &&
                                      _likeCount
                                          .contains(_commentData[index].id))
                                    Text(
                                        '${_commentData[index].commentLikes.length - 1} Likes  |',
                                        style: GoogleFonts.quicksand(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w200)),
                                  const SizedBox(width: 5),
                                  TextButton(
                                      onPressed: () {
                                        showDialog(
                                            context: context,
                                            builder: (_) => ReplyCommentWidget(
                                                commentId:
                                                    _commentData[index].id,
                                                waveId: widget
                                                    .comment[index].waveId));
                                      },
                                      child: Text('Reply',
                                          style: GoogleFonts.quicksand(
                                              fontSize: 12,
                                              color: const Color.fromRGBO(
                                                  0, 0, 0, 1),
                                              fontWeight: FontWeight.w200))),
                                ]),
                            if (_commentData[index].commentReply.isNotEmpty)
                              Row(children: [
                                Container(
                                    height: 2,
                                    width: 36,
                                    color:
                                        const Color.fromARGB(112, 112, 112, 1)),
                                TextButton.icon(
                                  onPressed: () {
                                    setState(() {
                                      _reply[index] = !_reply[index];
                                    });
                                  },
                                  label: const FaIcon(
                                      FontAwesomeIcons.chevronDown,
                                      color: Color.fromRGBO(0, 0, 0, 1),
                                      size: 13),
                                  icon: Text(
                                      'view ${_commentData[index].commentReply.length} Replies',
                                      style: GoogleFonts.quicksand(
                                          fontSize: 12,
                                          color:
                                              const Color.fromRGBO(0, 0, 0, 1),
                                          fontWeight: FontWeight.w200)),
                                )
                              ]),
                            if (_commentData[index].commentReply.isNotEmpty &&
                                _reply[index])
                              ReplyScreen(_commentData[index].commentReply)
                          ]),
                      Text(tt,
                          style: GoogleFonts.quicksand(
                              fontSize: 12, fontWeight: FontWeight.w300))
                    ],
                  ),
                );
              }),
        ]),
      );
    }
  }

  Future<void> likeAPi(String commentId, int index) async {
    final response = await http.post(
      Uri.parse(LikeComment),
      body: {
        "user_id": user_id,
        "comment_id": commentId,
      },
    );

    String data = response.body;
    print(data);
    String status = jsonDecode(data)['status'].toString();

    // if (status == "200") {
    //   String message = jsonDecode(data)['message'];
    //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    //     content: Text(message),
    //   ));
    //   setState(() {
    //     if (message == 'Comment Like has been successfully added.') {
    //       _commentData[index].commentLikes.length + 1;
    //     } else {
    //       _commentData[index].commentLikes.length - 1;
    //     }
    //   });
    // }
    // if (status == "400") {
    //   String message = jsonDecode(data)['message'];
    //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    //     content: Text(message),
    //   ));
    // }
  }
}
