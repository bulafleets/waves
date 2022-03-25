import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:waves/contants/common_params.dart';
import 'package:waves/screens/about_us/about_us.dart';
import 'package:waves/screens/forgetPassword/change_password.dart';
import 'package:http/http.dart' as http;
import 'package:waves/screens/TYPE/regular_type/profile/create_profile.dart';
import 'package:waves/screens/TYPE/bussiness_type/profile/create_profile_business.dart';

class OtpPage extends StatefulWidget {
  final String emailid;
  final String otp;
  const OtpPage(this.emailid, this.otp, {Key? key}) : super(key: key);

  @override
  _OtpPageState createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  String OTP = "";
  TextEditingController otpcontroller = TextEditingController();
  late Timer _timer;
  int _start = 25;
  bool isselect = false;
  bool isverify = false;
  final GlobalKey<FormState> _formkey = GlobalKey();
  void startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_start == 0) {
          setState(() {
            timer.cancel();
          });
        } else {
          setState(() {
            _start--;
          });
        }
      },
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    // sendOTP();
    startTimer();
    super.initState();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool keyboardIsOpened = MediaQuery.of(context).viewInsets.bottom != 0.0;
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            color: Theme.of(context).primaryColor,
            padding: const EdgeInsets.all(20),
            child: Column(children: [
              const SizedBox(height: 100),
              Text('2 Step Verification ',
                  style: GoogleFonts.quicksand(
                      fontWeight: FontWeight.bold,
                      fontSize: 26,
                      color: Colors.white)),
              const SizedBox(height: 10),
              SizedBox(
                  width: MediaQuery.of(context).size.width / 2,
                  child: Text(
                      'A 6-digit verification code was just sent to ${widget.emailid}',
                      overflow: TextOverflow.clip,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.quicksand(
                          fontSize: 14, color: Colors.white))),
              const SizedBox(height: 100),
              OtpPinField(),
              const SizedBox(height: 10),
              resendText()
            ])),
      ),
      floatingActionButton: keyboardIsOpened ? null : nextbutton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      backgroundColor: Colors.transparent,
    );
  }

  Widget OtpPinField() {
    return Form(
      key: _formkey,
      child: PinCodeTextField(
        length: 6,
        obscureText: false,
        keyboardType: TextInputType.phone,
        animationType: AnimationType.fade,
        validator: (val) {
          if (val!.isEmpty) {
            return '    Please Enter OTP';
          }
          if (OTP.isNotEmpty && val != OTP) {
            return '    OTP is incorrect';
          }
          if (OTP.isEmpty && val != widget.otp) {
            return '    OTP is incorrect';
          }
          return null;
        },

        textStyle: const TextStyle(color: Colors.black),
        pinTheme: PinTheme(
          shape: PinCodeFieldShape.box,
          borderRadius: BorderRadius.circular(8),
          fieldHeight: 60,
          fieldWidth: 50,
          activeFillColor: Colors.white,
          selectedColor: Colors.white,
          selectedFillColor: Colors.white,
          inactiveColor: Colors.white,
          disabledColor: Colors.white,
          inactiveFillColor: Colors.white,
          errorBorderColor: Colors.red,
        ),
        animationDuration: const Duration(milliseconds: 300),
        // backgroundColor: Colors.blue.shade50,
        enableActiveFill: true,
        //errorAnimationController: errorController,
        controller: otpcontroller,
        onCompleted: (v) {
          // _timer.cancel();
          setState(() {
            if (v == OTP) {
              isselect = true;
              isverify = true;
            }
          });
          print(otpcontroller.text);
        },
        onChanged: (value) {
          setState(() {
            if (value.length < 6) {
              isselect = false;
            }
          });
        },
        beforeTextPaste: (text) {
          print("Allowing to paste $text");
          //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
          //but you can show anything you want here, like your pop up saying wrong paste format or etc
          return true;
        },
        appContext: context,
      ),
    );
  }

  Widget nextbutton() {
    return Container(
      // color: Colors.white,
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 40.0),
      height: 60,
      child:
          //  Column(children: [
          //   const Text.rich(TextSpan(children: [
          //     TextSpan(
          //         text: 'Didn\'t recieve text ?',
          //         style: TextStyle(color: Colors.white)),
          //   InkWell ( child:TextSpan(
          //       text: ' Resend code',
          //       style: TextStyle(
          //         fontWeight: FontWeight.normal,
          //       ),
          //     ),
          //  ) ])),
          // Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          //   Text('Didn\'t recieve text ?', style: TextStyle(color: Colors.white)),
          //   InkWell(
          //     onTap: () {
          //       sendOTP();
          //     },
          //     child: const Text(
          //       ' Resend code',
          //       style: TextStyle(
          //         fontWeight: FontWeight.normal,
          //       ),
          //     ),
          //   )
          // ]),
          // const SizedBox(height: 25),
          // TextButton(onPressed: (){}, child:Text(''))
          SizedBox(
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
            if (_formkey.currentState!.validate()) {
              if (isSignUp == 'true') {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => AccountType == 'REGULAR'
                        ? const CreateProfile()
                        : const CreateProfileForBusiness()));
              } else {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const ChangePassword()));
              }
            }
          },
          child: const Text(
            "Continue",
            style: TextStyle(
                color: Colors.white, fontSize: 18, fontFamily: 'RobotoBold'),
          ),
        ),
      ),
      // ]),
    );
  }

  Future<void> sendOTP() async {
    final response = await http.post(
        Uri.parse(isSignUp == 'true' ? URL_OTP : Reset_passwordOtp),
        body: isSignUp == 'true'
            ? {
                'email': widget.emailid,
              }
            : {
                'username': widget.emailid,
              });
    print(URL_OTP + widget.emailid);

    String data = response.body;
    print(data);
    String status = jsonDecode(data)['status'].toString();

    EasyLoading.dismiss();
    if (status == "200") {
      OTP = isSignUp == 'true'
          ? jsonDecode(data)['Otp']
          : jsonDecode(data)['otp'];
      // ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      //   content: Text('OTP send successfully'),
      //   backgroundColor: Colors.green,
      // ));
      // Navigator.of(context).pushNamed(OTP_SCREEN);
    }
    if (status == "400") {
      String message = jsonDecode(data)['message'];
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(message),
      ));
    }
  }

  Widget resendText() {
    return Container(
      alignment: Alignment.center,
      //margin: EdgeInsets.only(left: _width / 10.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          GestureDetector(
            onTap: () {
              if (_start == 0) {
                sendOTP();
                setState(() {
                  _start = 25;
                  startTimer();
                });
              }
            },
            child: Text(
              _start == 0 ? "RESEND OTP" : "Wait | " + _start.toString(),
              style: const TextStyle(
                color: Colors.white,
                fontFamily: 'RobotoBold',
                fontWeight: FontWeight.w400,
                fontSize: 16,
              ),
            ),
          )
        ],
      ),
    );
  }
}
