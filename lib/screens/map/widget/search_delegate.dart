
// import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:geolocator/geolocator.dart';

// class Search extends  StatefulWidget {

// @override
// _SearchState createState() => _SearchState();
// }
// class _SearchState extends State<Search> {
// String shoapname="";
// String shoapaddress="";
//   String lat="";
//   String long="";
// List<Place> _shoapDetails = [];
// List<Place> _searchResult = [];
// int  tappedIndex = -1;
//   TextEditingController editingController = TextEditingController();
//   @override
//   Widget build(BuildContext context) {
  

//     return Scaffold(
//         body:
//              Column(
//               mainAxisAlignment: MainAxisAlignment.start,
//               children: <Widget>[
//             Container(
//             margin: EdgeInsets.only(left: 15,right: 15,top: 15),
//             child: TextField(
//             controller: editingController,
//             keyboardType: TextInputType.text,
//             cursorColor: Colors.grey,
//             style:  TextStyle(color:Color(0xFF4d5060)) ,
//             onChanged: (val){
//               _searchResult.clear();
//               if (val.isEmpty) {
//                 setState(() {});
//                 return;
//               }

//               _shoapDetails.forEach((userDetail) {
//                   if(userDetail.name?.toLowerCase().contains(val?.toLowerCase()))
//                   _searchResult.add(userDetail);
//               });

//               setState(() {});
//             },
//             onTap: () {
//             },
//             decoration: InputDecoration(
//             filled: true,
//             fillColor: Color(0xFFedf0fd),
//             enabledBorder: UnderlineInputBorder(
//             borderSide: BorderSide(color: Color(0xFFedf0fd)),
//             borderRadius: BorderRadius.circular(30),
//             ),
//             focusedBorder: UnderlineInputBorder(
//             borderSide: BorderSide(color: Color(0xFFedf0fd)),
//             borderRadius: BorderRadius.circular(30),
//             ),
//             prefixIcon: Icon(Icons.search, color: Color(0xffb7c2d5), size: 20),
//             labelText: "Search for companies",
//             labelStyle: TextStyle(color: Color(0xffb7c2d5),fontFamily: 'RobotoBold' ),
//             border: OutlineInputBorder(),
//             ),
//             ),
//             ),
//                 SizedBox(
//                   height: 10.0,
//                 ),
//                 Expanded(
//                   child: _searchResult.length != 0 || editingController.text.isNotEmpty?
//                  new ListView.builder(
//                       itemCount: _searchResult.length,
//                       itemBuilder: (context, index) {
//                         return FutureProvider(
//                           create: (context) =>
//                               geoService.getDistance(
//                                   currentPosition.latitude,
//                                   currentPosition.longitude,
//                                   _searchResult[index]
//                                       .geometry
//                                       .location
//                                       .lat,
//                                   _searchResult[index]
//                                       .geometry
//                                       .location
//                                       .lng),
//                           child: Card(
//                             child: ListTile(
//                               onTap: ()async {
//                                 shoapname= _searchResult[index].name;
//                                 shoapaddress=_searchResult[index].vicinity;
//                                 lat= _searchResult[index]
//                                     .geometry
//                                     .location
//                                     .lat.toString();
//                                 long= _searchResult[index]
//                                     .geometry
//                                     .location
//                                     .lng.toString();
//                                 showDialog(
//                                   context: context,
//                                   builder: (_) => LogoutOverlay(shoapname:shoapname ,shoaplat: lat,shoaplng: long,shoapaddess:shoapaddress,),
//                                 );
//                               },
//                               title: Text(_searchResult[index].name,style: TextStyle(fontFamily: 'RobotoBold'),),
//                               subtitle: Column(
//                                 crossAxisAlignment:
//                                 CrossAxisAlignment.start,
//                                 children: <Widget>[
//                                   SizedBox(
//                                     height: 3.0,
//                                   ),
//                                   SizedBox(
//                                     height: 5.0,
//                                   ),
//                                   Consumer<double>(
//                                     builder:
//                                         (context, meters, wiget) {
//                                       return (meters != null)
//                                           ? Text(
//                                           '${_searchResult[index].vicinity} \u00b7 ${(meters / 1000).toStringAsFixed(1)} km',style: TextStyle(fontFamily: 'RobotoRegular'),)
//                                           : Container();
//                                     },
//                                   )
//                                 ],
//                               ),

//                             ),
//                           ),
//                         );
//                       }):new
//                   ListView.builder(
//                       itemCount: _shoapDetails.length,
//                       itemBuilder: (context, index) {
//                         return FutureProvider(
//                           create: (context) =>
//                               geoService.getDistance(
//                                   currentPosition.latitude,
//                                   currentPosition.longitude,
//                                   _shoapDetails[index]
//                                       .geometry
//                                       .location
//                                       .lat,
//                                   _shoapDetails[index]
//                                       .geometry
//                                       .location
//                                       .lng),
//                           child: Card(
//                             child: Ink(
//                               color: tappedIndex==index?Color(0xff00a5ac):Colors.transparent,
//                               child: ListTile(
//                                 onTap: ()async {
//                                     setState(() {
//                                       tappedIndex=index;
//                                     });
//                                   shoapname= _shoapDetails[index].name;
//                                   shoapaddress=_shoapDetails[index].vicinity;
//                                   lat= _shoapDetails[index]
//                                       .geometry
//                                       .location
//                                       .lat.toString();
//                                   long= _shoapDetails[index]
//                                       .geometry
//                                       .location
//                                       .lng.toString();
//                                   showDialog(
//                                     context: context,
//                                     builder: (_) => LogoutOverlay(shoapname:shoapname ,shoaplat: lat,shoaplng: long,shoapaddess:shoapaddress,),
//                                   );
//                                 },
//                                 title: Text(_shoapDetails[index].name,style: TextStyle(fontFamily: 'RobotoBold',fontSize: 16),),
//                                 subtitle: Column(
//                                   crossAxisAlignment:
//                                   CrossAxisAlignment.start,
//                                   children: <Widget>[
//                                     SizedBox(
//                                       height: 3.0,
//                                     ),
//                                     SizedBox(
//                                       height: 5.0,
//                                     ),
//                                     Consumer<double>(
//                                       builder:
//                                           (context, meters, wiget) {
//                                         return (meters != null)
//                                             ? Text(
//                                             '${_shoapDetails[index].vicinity} \u00b7 ${(meters / 1000).toStringAsFixed(1)} km',style: TextStyle(fontFamily: 'RobotoRegular',fontSize: 14))
//                                             : Container();
//                                       },
//                                     )
//                                   ],
//                                 ),

//                               ),
//                             ),
//                           ),
//                         );
//                       }),
//                 )
//               ],
//             )
//                 : Center(child: CircularProgressIndicator());
//           },
//         )
//             : Center(
//           child: CircularProgressIndicator(),
//         ),
//       ),
//     );
//   }