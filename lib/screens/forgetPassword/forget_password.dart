import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:waves/contants/common_params.dart';
import 'package:waves/screens/otp/otp_page.dart';
import 'package:http/http.dart' as http;

class ForgetPassword extends StatefulWidget {
  const ForgetPassword({Key? key}) : super(key: key);

  @override
  State<ForgetPassword> createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  TextEditingController emailController = TextEditingController();
  final emailValidator = MultiValidator([
    RequiredValidator(errorText: 'Please Enter Email ID'),
    EmailValidator(errorText: 'Please Enter Valid Email ID'),
  ]);
  GlobalKey<FormState> _formkey = GlobalKey();
  String OTP = '';
  @override
  void dispose() {
    EasyLoading.dismiss();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool keyboardIsOpened = MediaQuery.of(context).viewInsets.bottom != 0.0;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          color: Theme.of(context).primaryColor,
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formkey,
            child: Column(children: [
              const SizedBox(height: 10),
              Text('Forget Password',
                  style: GoogleFonts.quicksand(
                      fontWeight: FontWeight.bold,
                      fontSize: 26,
                      color: Colors.white)),
              const SizedBox(height: 10),
              SizedBox(
                  width: MediaQuery.of(context).size.width / 2,
                  child: Text('Enter email associated with your account',
                      overflow: TextOverflow.clip,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.quicksand(
                          fontSize: 14, color: Colors.white))),
              const SizedBox(height: 100),
              TextFormField(
                  style: const TextStyle(color: Colors.black),
                  validator: emailValidator,
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  cursorColor: Colors.grey,
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(25),
                  ],
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    enabledBorder: UnderlineInputBorder(
                      borderSide: const BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: const BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    prefixIcon:
                        const Icon(Icons.email, color: Colors.grey, size: 20),
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                    hintText: "Email",
                    hintStyle: TextStyle(
                        color: const Color(0xFFb6b3c6).withOpacity(0.8),
                        fontFamily: 'RobotoRegular'),
                    border: const OutlineInputBorder(),
                  )),
            ]),
          )),
      floatingActionButton: keyboardIsOpened ? null : nextbutton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      backgroundColor: Colors.transparent,
    );
  }

  Widget nextbutton() {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 50.0),
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
            sendOTP();
            EasyLoading.show(status: 'Please Wait ...');
          }
          // showDialog(
          //   context: context,
          //   builder: (_) ,
          // );
          //  EasyLoading.show(status: 'Please Wait ...');
          //sendRESENT();
          //CircularProgressIndicator();
          //  EasyLoading.show(status: 'Please Wait ...');

          //print("Routing to your account");
          // }
        },
        child: const Text(
          "Send Code",
          style: TextStyle(
              color: Colors.white, fontSize: 18, fontFamily: 'RobotoBold'),
        ),
      ),
    );
  }

  Future<void> sendOTP() async {
    final response = await http.post(
      Uri.parse(Reset_passwordOtp),
      body: {
        'username': emailController.text,
      },
    );
    print(Reset_passwordOtp + emailController.text);

    String data = response.body;
    print(data);
    String status = jsonDecode(data)['status'].toString();

    EasyLoading.dismiss();
    if (status == "200") {
      isSignUp = 'false';
      OTP = jsonDecode(data)['otp'];
      email = emailController.text;
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => OtpPage(emailController.text, OTP)));
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
}
