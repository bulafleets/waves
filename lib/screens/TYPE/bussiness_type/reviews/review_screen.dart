import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:waves/contants/common_params.dart';
import 'package:waves/models/my_review_model.dart';

class ReviewScreen extends StatefulWidget {
  const ReviewScreen({Key? key}) : super(key: key);

  @override
  _ReviewScreenState createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  late Future<MyReviewModel> _future;
  @override
  void initState() {
    _future = getReview();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
            preferredSize:
                const Size.fromHeight(80.0), // here the desired height
            child: AppBar(
              backgroundColor: Theme.of(context).primaryColor,
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
        body: FutureBuilder<MyReviewModel>(
            future: _future,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data!.review.isNotEmpty) {
                  return ListView.builder(
                    itemCount: snapshot.data!.review.length,
                    itemBuilder: (context, index) {
                      var data = snapshot.data!.review[index];
                      int starCount = int.parse(data.rating.numberDecimal);
                      return Container(
                          height: 250,
                          padding: const EdgeInsets.all(15),
                          margin: const EdgeInsets.only(top: 11),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CircleAvatar(
                                  radius: 17,
                                  backgroundColor: data.user.age > 17 &&
                                          data.user.age < 30
                                      ? const Color.fromRGBO(0, 0, 255, 1)
                                      : data.user.age > 29 && data.user.age < 50
                                          ? const Color.fromRGBO(255, 255, 0, 1)
                                          : const Color.fromRGBO(
                                              0, 255, 128, 1),
                                  child: CircleAvatar(
                                    radius: 15,
                                    backgroundImage:
                                        NetworkImage(data.user.avatar),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Padding(
                                    padding: const EdgeInsets.only(top: 8.0),
                                    child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(data.user.username),
                                                const SizedBox(width: 5),
                                                SizedBox(
                                                  width: 120,
                                                  height: 50,
                                                  child: ListView.builder(
                                                      scrollDirection:
                                                          Axis.horizontal,
                                                      itemCount: starCount,
                                                      itemBuilder:
                                                          (context, i) {
                                                        return FaIcon(
                                                          FontAwesomeIcons
                                                              .solidStar,
                                                          color:
                                                              Theme.of(context)
                                                                  .primaryColor,
                                                          size: 18,
                                                        );
                                                      }),
                                                ),
                                              ]),
                                          Flexible(
                                            child: Container(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width -
                                                    80,
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 10.0,
                                                        horizontal: 3),
                                                child:
                                                    Text(data.reviewComment)),
                                          )
                                        ]))
                              ]));
                    },
                  );
                } else {
                  return const Center(child: Text('No review Found'));
                }
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            }));
  }

  Future<MyReviewModel> getReview() async {
    var data;
    http.Response response = await http.post(Uri.parse(GetReviews),
        body: {'user_id': user_id},
        headers: {HttpHeaders.authorizationHeader: "Bearer $authorization"});
    final jsonString = response.body;

    final jsonMap = jsonDecode(jsonString);
    data = MyReviewModel.fromJson(jsonMap);
    return data;
  }
}
