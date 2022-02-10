import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

import 'package:waves/contants/common_widgets.dart';
import 'package:waves/contants/event_id.dart';
import 'package:waves/models/event_model.dart';
import 'package:waves/screens/TYPE/bussiness_type/wave/widget/calender_bussiness.dart';
import 'package:waves/screens/map/map.dart';
import 'package:flutter_switch/flutter_switch.dart';

class CreateWaveScreenBussiness extends StatefulWidget {
  const CreateWaveScreenBussiness({Key? key}) : super(key: key);

  @override
  _CreateWaveScreenBussinessState createState() =>
      _CreateWaveScreenBussinessState();
}

class _CreateWaveScreenBussinessState extends State<CreateWaveScreenBussiness> {
  final GlobalKey<FormState> _formkey = GlobalKey();
  TextEditingController waveNameController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController eventTypeController = TextEditingController();
  TextEditingController eventDetailsController = TextEditingController();
  TextEditingController discountDetailController = TextEditingController();
  TextEditingController additionalDetailController = TextEditingController();
  bool adultEvent = false;
  bool sendToFollowers = false;
  bool discount = true;
  bool discountAllusers = false;
  double _sliderValue = 30;
  var log;
  var lat;
  var eventName;
  var eventValue;
  late PickedFile imageFile;
  bool _load = false;
  _addrss(String add, String longitute, String latitude) {
    setState(() {
      log = longitute;
      lat = latitude;
      addressController.text = add;
    });
  }

  eventID(String id, String name) {
    eventValue = id;
    eventName = name;
    print(eventName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(80.0), // here the desired height
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
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formkey,
          child: SingleChildScrollView(
            child: Column(
              // crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Create a Wave',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.quicksand(
                      fontSize: 29, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 35),
                InkWell(
                  onTap: () {
                    _showPicker(context);
                  },
                  child: Container(
                      height: 100,
                      width: 100,
                      decoration: const BoxDecoration(
                          color: Colors.white60,
                          boxShadow: [BoxShadow(color: Colors.grey)]),
                      child: !_load
                          ? const Icon(Icons.add, size: 35)
                          : Image.file(File(imageFile.path),
                              fit: BoxFit.cover)),
                ),
                const SizedBox(height: 20),

                TextFormField(
                  // onTap: () {
                  //   determinePosition(context);
                  //   Navigator.of(context).push(MaterialPageRoute(
                  //       builder: (context) => MapSample(_addrss)));
                  // },
                  validator: (val) {
                    if (val!.isEmpty) return 'Please enter wave name';

                    return null;
                  },
                  style: const TextStyle(color: Colors.black),
                  controller: waveNameController,
                  keyboardType: TextInputType.text,
                  cursorColor: Colors.grey,
                  decoration: InputDecoration(
                      filled: true,
                      fillColor: const Color.fromRGBO(234, 234, 234, 1),
                      enabledBorder: UnderlineInputBorder(
                          borderSide: const BorderSide(color: Colors.white),
                          borderRadius: BorderRadius.circular(8)),
                      focusedBorder: UnderlineInputBorder(
                          borderSide: const BorderSide(color: Colors.white),
                          borderRadius: BorderRadius.circular(8)),
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 20, horizontal: 20),
                      hintText: "Wave Name",
                      hintStyle: const TextStyle(
                          color: Color.fromRGBO(145, 145, 145, 1),
                          fontFamily: 'RobotoRegular'),
                      border: const OutlineInputBorder()),
                ),
                const SizedBox(height: 15),
                TextFormField(
                  onTap: () {
                    determinePosition(context);
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => MapSample(_addrss)));
                  },
                  validator: (val) {
                    if (val!.isEmpty) return 'Pick your location from map';

                    return null;
                  },
                  style: const TextStyle(color: Colors.black),
                  controller: addressController,
                  keyboardType: TextInputType.none,
                  cursorColor: Colors.grey,
                  decoration: InputDecoration(
                      suffixIcon: GestureDetector(
                          onTap: () {
                            determinePosition(context);
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => MapSample(_addrss)));
                          },
                          child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Text('Pin on map',
                                  style: GoogleFonts.quicksand(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.blue)))),
                      filled: true,
                      fillColor: const Color.fromRGBO(234, 234, 234, 1),
                      enabledBorder: UnderlineInputBorder(
                          borderSide: const BorderSide(color: Colors.white),
                          borderRadius: BorderRadius.circular(8)),
                      focusedBorder: UnderlineInputBorder(
                          borderSide: const BorderSide(color: Colors.white),
                          borderRadius: BorderRadius.circular(8)),
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 20, horizontal: 20),
                      hintText: "Enter Location",
                      hintStyle: const TextStyle(
                          color: Color.fromRGBO(145, 145, 145, 1),
                          fontFamily: 'RobotoRegular'),
                      border: const OutlineInputBorder()),
                ),
                const SizedBox(height: 15),
                EventListWidget(eventID),
                // if (eventName == 'Others')
                //   TextFormField(
                //     onTap: () {},
                //     validator: (val) {
                //       if (val!.isEmpty) return 'choose your event type';

                //       return null;
                //     },
                //     style: const TextStyle(color: Colors.black),
                //     controller: eventTypeController,
                //     keyboardType: TextInputType.none,
                //     cursorColor: Colors.grey,
                //     decoration: InputDecoration(
                //         suffixIcon: GestureDetector(
                //             onTap: () {},
                //             child: const Padding(
                //                 padding: EdgeInsets.all(10.0),
                //                 child: FaIcon(Icons.arrow_drop_down_outlined,
                //                     size: 45, color: Colors.black))),
                //         filled: true,
                //         fillColor: const Color.fromRGBO(234, 234, 234, 1),
                //         enabledBorder: UnderlineInputBorder(
                //             borderSide: const BorderSide(color: Colors.white),
                //             borderRadius: BorderRadius.circular(8)),
                //         focusedBorder: UnderlineInputBorder(
                //             borderSide: const BorderSide(color: Colors.white),
                //             borderRadius: BorderRadius.circular(8)),
                //         contentPadding: const EdgeInsets.symmetric(
                //             vertical: 20, horizontal: 20),
                //         hintText: "Event Type",
                //         hintStyle: const TextStyle(
                //             color: Color.fromRGBO(145, 145, 145, 1),
                //             fontFamily: 'RobotoRegular'),
                //         border: const OutlineInputBorder()),
                //   ),
                const SizedBox(height: 15),
                TextFormField(
                    onTap: () {},
                    // validator: (val) {
                    //   if (val!.isEmpty) return 'choose your event type';

                    //   return null;
                    // },
                    style: const TextStyle(color: Colors.black),
                    controller: eventDetailsController,
                    keyboardType: TextInputType.text,
                    minLines: 5,
                    maxLines: 6,
                    cursorColor: Colors.grey,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: const Color.fromRGBO(234, 234, 234, 1),
                      enabledBorder: UnderlineInputBorder(
                          borderSide: const BorderSide(color: Colors.white),
                          borderRadius: BorderRadius.circular(8)),
                      focusedBorder: UnderlineInputBorder(
                          borderSide: const BorderSide(color: Colors.white),
                          borderRadius: BorderRadius.circular(8)),
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 20, horizontal: 20),
                      hintText: "Event Details",
                      hintStyle: const TextStyle(
                          color: Color.fromRGBO(145, 145, 145, 1),
                          fontFamily: 'RobotoRegular'),
                      border: const OutlineInputBorder(),
                    )),

                const SizedBox(height: 15),
                TextFormField(
                    onTap: () {},
                    // validator: (val) {
                    //   if (val!.isEmpty) return 'choose your event type';

                    //   return null;
                    // },
                    style: const TextStyle(color: Colors.black),
                    controller: discountDetailController,
                    keyboardType: TextInputType.text,
                    minLines: 3,
                    maxLines: 4,
                    cursorColor: Colors.grey,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: const Color.fromRGBO(234, 234, 234, 1),
                      enabledBorder: UnderlineInputBorder(
                          borderSide: const BorderSide(color: Colors.white),
                          borderRadius: BorderRadius.circular(8)),
                      focusedBorder: UnderlineInputBorder(
                          borderSide: const BorderSide(color: Colors.white),
                          borderRadius: BorderRadius.circular(8)),
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 20, horizontal: 20),
                      hintText: "Discount Details",
                      hintStyle: const TextStyle(
                          color: Color.fromRGBO(145, 145, 145, 1),
                          fontFamily: 'RobotoRegular'),
                      border: const OutlineInputBorder(),
                    )),
                const SizedBox(height: 15),
                InkWell(
                    onTap: () {},
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Checkbox(
                          checkColor: Colors.white,
                          activeColor: Colors.black,
                          side: const BorderSide(
                            color: Colors.black,
                            width: 1.5,
                          ),
                          value: discount,
                          onChanged: (var value) {
                            setState(() {
                              discount = value!;
                            });
                          },
                        ),
                        // const SizedBox(width: 5),

                        Text(
                          'Discount for followers',
                          style: GoogleFonts.quicksand(
                              fontWeight: FontWeight.w400,
                              fontSize: 17,
                              color: Colors.black),
                        )
                      ],
                    )),
                const SizedBox(height: 15),
                InkWell(
                    onTap: () {},
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Checkbox(
                          checkColor: Colors.white,
                          activeColor: Colors.black,
                          side: const BorderSide(
                            color: Colors.black,
                            width: 1.5,
                          ),
                          value: discountAllusers,
                          onChanged: (var value) {
                            setState(() {
                              discountAllusers = value!;
                            });
                          },
                        ),
                        // const SizedBox(width: 5),

                        Text(
                          'Discount to all users',
                          style: GoogleFonts.quicksand(
                              fontWeight: FontWeight.w400,
                              fontSize: 17,
                              color: Colors.black),
                        )
                      ],
                    )),
                const SizedBox(height: 15),
                Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: InkWell(
                        onTap: () {},
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '21+ year event ',
                                style: GoogleFonts.quicksand(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 19,
                                    color: Colors.black),
                              ),
                              // const SizedBox(width: 5),
                              FlutterSwitch(
                                  height: 25.0,
                                  width: 40.0,
                                  padding: 4.0,
                                  toggleSize: 15.0,
                                  borderRadius: 10.0,
                                  activeColor: Colors.black,
                                  inactiveText: 'off',
                                  activeText: 'on',
                                  activeTextColor: Colors.black,
                                  value: adultEvent,
                                  onToggle: (value) {
                                    setState(() {
                                      adultEvent = value;
                                    });
                                  })
                            ]))),
                Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: InkWell(
                        onTap: () {},
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Send invite to followers',
                                style: GoogleFonts.quicksand(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 19,
                                    color: Colors.black),
                              ),
                              // const SizedBox(width: 5),
                              FlutterSwitch(
                                  height: 25.0,
                                  width: 40.0,
                                  padding: 4.0,
                                  toggleSize: 15.0,
                                  borderRadius: 10.0,
                                  activeColor: Colors.black,
                                  inactiveText: 'off',
                                  activeText: 'on',
                                  activeTextColor: Colors.black,
                                  value: sendToFollowers,
                                  onToggle: (value) {
                                    setState(() {
                                      sendToFollowers = value;
                                    });
                                  })
                            ]))),
                const SizedBox(height: 15),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18.0),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      'Radius',
                      style: GoogleFonts.quicksand(
                          fontWeight: FontWeight.w500,
                          fontSize: 19,
                          color: Colors.black),
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Min Radius',
                      style: GoogleFonts.quicksand(
                          fontWeight: FontWeight.w500,
                          fontSize: 9,
                          color: Colors.blue),
                    ),
                    Text(
                      'Max Radius',
                      style: GoogleFonts.quicksand(
                          fontWeight: FontWeight.w500,
                          fontSize: 9,
                          color: Colors.blue),
                    )
                  ],
                ),
                Slider(
                    min: 0.0,
                    divisions: 100,
                    max: 100.0,
                    value: _sliderValue,
                    label: "${_sliderValue.round().toString()} miles",
                    onChanged: (dynamic values) {
                      setState(() {
                        _sliderValue = values as double;
                      });
                    }),
                const SizedBox(height: 25),
                TextFormField(
                    onTap: () {},
                    // validator: (val) {
                    //   if (val!.isEmpty) return 'choose your event type';

                    //   return null;
                    // },
                    style: const TextStyle(color: Colors.black),
                    controller: additionalDetailController,
                    keyboardType: TextInputType.text,
                    minLines: 5,
                    maxLines: 6,
                    cursorColor: Colors.grey,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: const Color.fromRGBO(234, 234, 234, 1),
                      enabledBorder: UnderlineInputBorder(
                          borderSide: const BorderSide(color: Colors.white),
                          borderRadius: BorderRadius.circular(8)),
                      focusedBorder: UnderlineInputBorder(
                          borderSide: const BorderSide(color: Colors.white),
                          borderRadius: BorderRadius.circular(8)),
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 20, horizontal: 20),
                      hintText: "Additional Details for followers",
                      hintStyle: const TextStyle(
                          color: Color.fromRGBO(145, 145, 145, 1),
                          fontFamily: 'RobotoRegular'),
                      border: const OutlineInputBorder(),
                    )),
                const SizedBox(height: 25),
                selectDateTime(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Wrap(
              children: <Widget>[
                ListTile(
                    leading: const Icon(Icons.photo_library),
                    title: const Text('Photo Library'),
                    onTap: () {
                      _imgFromGallery();
                      Navigator.of(context).pop();
                    }),
                ListTile(
                  leading: const Icon(Icons.photo_camera),
                  title: const Text('Camera'),
                  onTap: () {
                    _imgFromCamera();
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          );
        });
  }

  _imgFromCamera() async {
    final pickedFile = await ImagePicker().getImage(
        source: ImageSource.camera,
        //  maxWidth: 2300,
        // maxHeight: 1500,
        imageQuality: 50);
    setState(() {
      imageFile = pickedFile!;
      _load = true;
    });
  }

  _imgFromGallery() async {
    final pickedFile = await ImagePicker()
        .getImage(source: ImageSource.gallery, imageQuality: 50);

    setState(() {
      imageFile = pickedFile!;
      _load = true;
    });
  }

  Widget selectDateTime() {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
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
          if (_formkey.currentState!.validate()) {
            if (eventValue != null) {
              if (_load) {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => CalenderScreenBussiness(
                          address: addressController.text,
                          log: log,
                          lat: lat,
                          eventId: eventValue,
                          eventDetails: eventDetailsController.text,
                          waveName: waveNameController.text,
                          isDiscountFollower: discount,
                          isAdult: adultEvent,
                          isDiscountAll: discountAllusers,
                          disDetails: discountDetailController.text,
                          radius: _sliderValue.toString(),
                          additionalDetails: additionalDetailController.text,
                          isSendFollower: sendToFollowers,
                          image: imageFile.path,
                        )));
              } else {
                String message = 'please add event image ';
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(message), backgroundColor: Colors.red));
              }
            }
          } else {
            String message = 'please select event Type';
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(message), backgroundColor: Colors.red));
          }
        },
        child: const Text(
          "Select Date & Time",
          style: TextStyle(
              color: Colors.white, fontSize: 18, fontFamily: 'RobotoBold'),
        ),
      ),
    );
  }
}
