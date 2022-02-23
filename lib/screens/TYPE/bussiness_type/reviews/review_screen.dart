import 'dart:convert';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:google_fonts/google_fonts.dart';
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
    print(user_id);
    return Scaffold(
        appBar: PreferredSize(
            preferredSize:
                const Size.fromHeight(80.0), // here the desired height
            child: AppBar(
              backgroundColor: Theme.of(context).primaryColor,
              leading: Padding(
                padding: const EdgeInsets.only(top: 17.0, left: 5),
                child: IconButton(
                  iconSize: 24,
                  alignment: Alignment.bottomLeft,
                  icon: const FaIcon(FontAwesomeIcons.arrowLeft),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ),
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
                if (snapshot.data!.waves.isNotEmpty) {
                  return Container(
                    padding: const EdgeInsets.only(top: 19),
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    child: ListView.builder(
                      itemCount: snapshot.data!.waves.length,
                      itemBuilder: (context, index) {
                        var data = snapshot.data!.waves[index];
                        return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8.0, vertical: 5),
                                child: Text(
                                  "Wave : ${data.waveName}",
                                  style: GoogleFonts.quicksand(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 17),
                                ),
                              ),
                              Column(
                                  children:
                                      data.reviewData.asMap().entries.map((i) {
                                double ss = double.parse(
                                    i.value.rating.numberDecimal.toString());
                                int starCount = ss.toInt();
                                return Container(
                                  padding: const EdgeInsets.all(15),
                                  margin: const EdgeInsets.only(top: 11),
                                  child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        CircleAvatar(
                                          radius: 19,
                                          backgroundColor: i.value.userData
                                                          .first.age >
                                                      17 &&
                                                  i.value.userData.first.age <
                                                      30
                                              ? const Color.fromRGBO(
                                                  0, 0, 255, 1)
                                              : i.value.userData.first.age >
                                                          29 &&
                                                      i.value.userData.first
                                                              .age <
                                                          50
                                                  ? const Color.fromRGBO(
                                                      255, 255, 0, 1)
                                                  : const Color.fromRGBO(
                                                      0, 255, 128, 1),
                                          child: CircleAvatar(
                                            radius: 17,
                                            child: CachedNetworkImage(
                                              imageUrl:
                                                  i.value.userData.first.avatar,
                                              imageBuilder:
                                                  (context, imageProvider) =>
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
                                              errorWidget:
                                                  (context, url, error) =>
                                                      const Icon(Icons.error),
                                            ),
                                            // backgroundImage:
                                            //     NetworkImage(data.user.avatar),
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        Expanded(
                                          child: Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 8.0),
                                              child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            i.value.userData
                                                                .first.username,
                                                            style: GoogleFonts
                                                                .quicksand(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                    fontSize:
                                                                        16),
                                                          ),
                                                          const SizedBox(
                                                              width: 5),
                                                          SizedBox(
                                                            width: 120,
                                                            height: 25,
                                                            child: ListView
                                                                .builder(
                                                                    scrollDirection:
                                                                        Axis
                                                                            .horizontal,
                                                                    itemCount:
                                                                        starCount,
                                                                    itemBuilder:
                                                                        (context,
                                                                            i) {
                                                                      return FaIcon(
                                                                        FontAwesomeIcons
                                                                            .solidStar,
                                                                        color: Theme.of(context)
                                                                            .primaryColor,
                                                                        size:
                                                                            18,
                                                                      );
                                                                    }),
                                                          ),
                                                        ]),
                                                    Container(
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width -
                                                            80,
                                                        padding:
                                                            const EdgeInsets
                                                                    .symmetric(
                                                                horizontal: 3),
                                                        child: Text(
                                                          i.value.reviewComment,
                                                          style: GoogleFonts
                                                              .quicksand(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400,
                                                                  fontSize: 14),
                                                        )),
                                                  ])),
                                        )
                                      ]),
                                );
                              }).toList()
                                  // ListView.builder(
                                  //   physics: const NeverScrollableScrollPhysics(),
                                  //   itemCount: data.reviewData.length,
                                  //   itemBuilder: (context, i) {
                                  //     int starCount = int.parse(
                                  //         data.reviewData[i].rating.numberDecimal);
                                  //     return Container(
                                  //       padding: const EdgeInsets.all(15),
                                  //       margin: const EdgeInsets.only(top: 11),
                                  //       child: Row(
                                  //           mainAxisAlignment:
                                  //               MainAxisAlignment.start,
                                  //           crossAxisAlignment:
                                  //               CrossAxisAlignment.start,
                                  //           children: [
                                  //             CircleAvatar(
                                  //               radius: 17,
                                  //               backgroundColor: data.reviewData[i]
                                  //                               .userData.first.age >
                                  //                           17 &&
                                  //                       data.reviewData[i].userData
                                  //                               .first.age <
                                  //                           30
                                  //                   ? const Color.fromRGBO(
                                  //                       0, 0, 255, 1)
                                  //                   : data.reviewData[i].userData
                                  //                                   .first.age >
                                  //                               29 &&
                                  //                           data
                                  //                                   .reviewData[i]
                                  //                                   .userData
                                  //                                   .first
                                  //                                   .age <
                                  //                               50
                                  //                       ? const Color.fromRGBO(
                                  //                           255, 255, 0, 1)
                                  //                       : const Color.fromRGBO(
                                  //                           0, 255, 128, 1),
                                  //               child: CircleAvatar(
                                  //                 radius: 15,
                                  //                 child: CachedNetworkImage(
                                  //                   imageUrl: data.reviewData[i]
                                  //                       .userData.first.avatar,
                                  //                   imageBuilder:
                                  //                       (context, imageProvider) =>
                                  //                           Container(
                                  //                     width: double.infinity,
                                  //                     height: double.infinity,
                                  //                     decoration: BoxDecoration(
                                  //                       shape: BoxShape.circle,
                                  //                       image: DecorationImage(
                                  //                           image: imageProvider,
                                  //                           fit: BoxFit.cover),
                                  //                     ),
                                  //                   ),
                                  //                   placeholder: (context, url) =>
                                  //                       const CircularProgressIndicator(),
                                  //                   errorWidget:
                                  //                       (context, url, error) =>
                                  //                           const Icon(Icons.error),
                                  //                 ),
                                  //                 // backgroundImage:
                                  //                 //     NetworkImage(data.user.avatar),
                                  //               ),
                                  //             ),
                                  //             const SizedBox(width: 10),
                                  //             Expanded(
                                  //               child: Padding(
                                  //                   padding: const EdgeInsets.only(
                                  //                       top: 8.0),
                                  //                   child: Column(
                                  //                       crossAxisAlignment:
                                  //                           CrossAxisAlignment.start,
                                  //                       children: [
                                  //                         Row(
                                  //                             mainAxisAlignment:
                                  //                                 MainAxisAlignment
                                  //                                     .start,
                                  //                             crossAxisAlignment:
                                  //                                 CrossAxisAlignment
                                  //                                     .start,
                                  //                             children: [
                                  //                               Text(data
                                  //                                   .reviewData[i]
                                  //                                   .userData
                                  //                                   .first
                                  //                                   .username),
                                  //                               const SizedBox(
                                  //                                   width: 5),
                                  //                               SizedBox(
                                  //                                 width: 120,
                                  //                                 height: 50,
                                  //                                 child: ListView
                                  //                                     .builder(
                                  //                                         scrollDirection:
                                  //                                             Axis
                                  //                                                 .horizontal,
                                  //                                         itemCount:
                                  //                                             starCount,
                                  //                                         itemBuilder:
                                  //                                             (context,
                                  //                                                 i) {
                                  //                                           return FaIcon(
                                  //                                             FontAwesomeIcons
                                  //                                                 .solidStar,
                                  //                                             color: Theme.of(context)
                                  //                                                 .primaryColor,
                                  //                                             size:
                                  //                                                 18,
                                  //                                           );
                                  //                                         }),
                                  //                               ),
                                  //                             ]),
                                  //                         Container(
                                  //                             width: MediaQuery.of(
                                  //                                         context)
                                  //                                     .size
                                  //                                     .width -
                                  //                                 80,
                                  //                             padding:
                                  //                                 const EdgeInsets
                                  //                                         .symmetric(
                                  //                                     vertical: 3.0,
                                  //                                     horizontal: 3),
                                  //                             child: Text(data
                                  //                                 .reviewData[i]
                                  //                                 .reviewComment))
                                  //                       ])),
                                  //             )
                                  //           ]),
                                  //     );
                                  //   },
                                  // ),
                                  ),
                            ]);
                      },
                    ),
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
