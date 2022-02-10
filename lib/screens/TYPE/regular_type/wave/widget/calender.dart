import 'dart:convert';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:waves/contants/common_params.dart';
import 'package:waves/screens/TYPE/bussiness_type/wave/widget/Wave_Created_Succesfully.dart';
import 'package:waves/screens/TYPE/regular_type/wave/invite_screen.dart';
import 'package:intl/intl.dart';

class CalenderScreenRegular extends StatefulWidget {
  final String wavename;
  final String log;
  final String lat;
  final String eventId;
  final String eventDetails;
  final String address;
  final bool isFriendOnly;
  final bool isInviteOnly;
  final String image;

  const CalenderScreenRegular({
    Key? key,
    required this.wavename,
    required this.address,
    required this.log,
    required this.lat,
    required this.eventId,
    required this.eventDetails,
    required this.isFriendOnly,
    required this.isInviteOnly,
    required this.image,
  }) : super(key: key);
  @override
  _CalenderScreenRegularState createState() => _CalenderScreenRegularState();
}

class _CalenderScreenRegularState extends State<CalenderScreenRegular> {
  TextEditingController _starttimeController = TextEditingController();
  TextEditingController _dateController = TextEditingController();
  TextEditingController _endTimeController = TextEditingController();
  @override
  void initState() {
    _starttimeController.text = formatDate(
        DateTime(2019, 08, 1, DateTime.now().hour, DateTime.now().minute),
        [hh, ':', nn, " ", am]).toString();
    _endTimeController.text = _starttimeController.text;
    _dateController.text = DateFormat('yyyy-MM-dd').format(DateTime.now());
    super.initState();
  }

  TimeOfDay startSelectedTime = const TimeOfDay(hour: 00, minute: 00);
  TimeOfDay endSelectedTime = const TimeOfDay(hour: 00, minute: 00);
//  final DateFormat formatter = DateFormat('yyyy-MM-dd');
//   final String formatted = formatter.format(now);
  var _setTime, _setDate;

  var _hour, _minute, _time;

  Future<Null> _startselectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: startSelectedTime,
    );
    if (picked != null) {
      // _endselectTime(context, picked);
      setState(() {
        startSelectedTime = picked;
        _hour = startSelectedTime.hour.toString();
        _minute = startSelectedTime.minute.toString();
        _time = _hour + ' : ' + _minute;
        _starttimeController.text = _time;
        _starttimeController.text = formatDate(
            DateTime(
                2019, 08, 1, startSelectedTime.hour, startSelectedTime.minute),
            [hh, ':', nn, " ", am]).toString();
      });
    }
  }

  Future<Null> _endselectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: startSelectedTime,
    );
    if (picked != null)
      // ignore: curly_braces_in_flow_control_structures
      setState(() {
        endSelectedTime = picked;
        _hour = endSelectedTime.hour.toString();
        _minute = endSelectedTime.minute.toString();
        _time = _hour + ' : ' + _minute;
        _endTimeController.text = _time;
        _endTimeController.text = formatDate(
            DateTime(2019, 08, 1, endSelectedTime.hour, endSelectedTime.minute),
            [hh, ':', nn, " ", am]).toString();
      });
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
          child: ListView(
              // crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Create a Wave',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.quicksand(
                      fontSize: 29, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 35),
                // CalenderScreenRegular()
                Container(
                    // margin: const EdgeInsets.symmetric(vertical: 50.0, horizontal: 60),
                    // width: 300,
                    // height: 300,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.white, width: 2),
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 2,
                            offset: Offset(0, 3), // changes position of shadow
                          ),
                        ]),
                    child: CalendarDatePicker(
                      initialDate: DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime(2101),
                      onDateChanged: (DateTime value) {
                        _dateController.text =
                            DateFormat('yyyy-MM-dd').format(value);
                      },
                    )),
                SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: 150,
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width / 2 - 50,
                            child: TextFormField(
                              onTap: () {
                                _startselectTime(context);
                              },
                              validator: (val) {
                                if (val!.isEmpty)
                                  return 'please select start time';

                                return null;
                              },
                              style: GoogleFonts.quicksand(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                                color: Colors.black,
                              ),
                              controller: _starttimeController,
                              keyboardType: TextInputType.none,
                              cursorColor: Colors.grey,
                              decoration: InputDecoration(
                                  suffixIcon: const FaIcon(
                                      Icons.arrow_drop_down_outlined,
                                      size: 45,
                                      color: Colors.black),
                                  filled: true,
                                  fillColor:
                                      const Color.fromRGBO(234, 234, 234, 1),
                                  enabledBorder: UnderlineInputBorder(
                                      borderSide:
                                          const BorderSide(color: Colors.white),
                                      borderRadius: BorderRadius.circular(8)),
                                  focusedBorder: UnderlineInputBorder(
                                      borderSide:
                                          const BorderSide(color: Colors.white),
                                      borderRadius: BorderRadius.circular(8)),
                                  contentPadding: const EdgeInsets.symmetric(
                                      vertical: 20, horizontal: 10),
                                  hintText: "Time",
                                  hintStyle: const TextStyle(
                                      color: Color.fromRGBO(145, 145, 145, 1),
                                      fontFamily: 'RobotoRegular'),
                                  border: const OutlineInputBorder()),
                            ),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width / 2 - 50,
                            child: TextFormField(
                              onTap: () {
                                _endselectTime(context);
                              },
                              validator: (val) {
                                if (val!.isEmpty)
                                  return 'please select end time';

                                return null;
                              },
                              style: GoogleFonts.quicksand(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                                color: Colors.black,
                              ),
                              controller: _endTimeController,
                              keyboardType: TextInputType.none,
                              cursorColor: Colors.grey,
                              decoration: InputDecoration(
                                  suffixIcon: const FaIcon(
                                      Icons.arrow_drop_down_outlined,
                                      size: 45,
                                      color: Colors.black),
                                  filled: true,
                                  fillColor:
                                      const Color.fromRGBO(234, 234, 234, 1),
                                  enabledBorder: UnderlineInputBorder(
                                      borderSide:
                                          const BorderSide(color: Colors.white),
                                      borderRadius: BorderRadius.circular(8)),
                                  focusedBorder: UnderlineInputBorder(
                                      borderSide:
                                          const BorderSide(color: Colors.white),
                                      borderRadius: BorderRadius.circular(8)),
                                  contentPadding: const EdgeInsets.symmetric(
                                      vertical: 20, horizontal: 10),
                                  hintText: "Time",
                                  hintStyle: const TextStyle(
                                      color: Color.fromRGBO(145, 145, 145, 1),
                                      fontFamily: 'RobotoRegular'),
                                  border: const OutlineInputBorder()),
                            ),
                          )
                        ])),
                confirm()
              ])),
    );
  }

  Widget confirm() {
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
          if (widget.isInviteOnly) {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => InviteScreen(
                    wavename: widget.wavename,
                    address: widget.address,
                    log: widget.log,
                    lat: widget.lat,
                    eventId: widget.eventId,
                    eventDetails: widget.eventDetails,
                    isFriendOnly: widget.isFriendOnly,
                    isInviteOnly: widget.isInviteOnly,
                    image: widget.image,
                    startTime: _starttimeController.text,
                    endTime: _endTimeController.text,
                    date: _dateController.text)));
          } else {
            createWaveRegular();
            EasyLoading.show(status: 'Please Wait ...');
          }
        },
        child: Text(
          widget.isInviteOnly ? 'Select Invites' : "Confirm",
          style: const TextStyle(
              color: Colors.white, fontSize: 18, fontFamily: 'RobotoBold'),
        ),
      ),
    );
  }

  Future<void> createWaveRegular() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    var userid = _prefs.getString('user_id');
    var request = http.MultipartRequest('POST', Uri.parse(WaveCreate));
    request.files.add(await http.MultipartFile.fromPath('media', widget.image));
    request.fields['wave_name'] = widget.wavename;
    request.fields['user_id'] = userid!;
    request.fields['event_id'] = widget.eventId;
    request.fields['date'] = _dateController.text;
    request.fields['user_type'] = AccountType;
    request.fields['waves_location'] = widget.address;
    request.fields['event_detail'] = widget.eventDetails;
    request.fields['address'] = widget.address;
    request.fields['lattitude'] = widget.lat;
    request.fields['longitude'] = widget.log;
    request.fields['isFriend'] = widget.isFriendOnly.toString();
    request.fields['isInvite'] = widget.isInviteOnly.toString();
    request.fields['start_time'] = _starttimeController.text;
    request.fields['end_time'] = _endTimeController.text;
    // invite_tags[0] see it later

    var res = await request.send();
    var response = await http.Response.fromStream(res);
    String data = response.body;
    String status = jsonDecode(data)['status'].toString();
    EasyLoading.dismiss();
    if (status == "200") {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => WaveCreatedSuccesfully()));
      // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      //   content: Text('successfully'),
      // ));
      // ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      //   content: Text('OTP send successfully'),
      //   backgroundColor: Colors.green,
      // ));
      // Navigator.of(context).pushNamed(OTP_SCREEN);
    }
    if (status == "400") {
      String message = jsonDecode(data)['message'];
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message), backgroundColor: Colors.red));
    }
  }
}
