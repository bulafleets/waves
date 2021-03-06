import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:waves/contants/common_params.dart';
import 'package:waves/contants/common_widgets.dart';
import 'package:waves/screens/auth/login_page.dart';
import 'package:http/http.dart' as http;

class ChangePassword extends StatefulWidget {
  const ChangePassword({Key? key}) : super(key: key);

  @override
  _ChangePasswordState createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmcontroll = TextEditingController();
  bool isObscureText = true;
  bool isObscureTextC = true;
  GlobalKey<FormState> _formkey = GlobalKey();
  bool isalldone = false;
  bool _isLoading = false;
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
            child: ListView(children: [
              const SizedBox(height: 10),
              Center(
                child: Text('Change Password',
                    style: GoogleFonts.quicksand(
                        fontWeight: FontWeight.bold,
                        fontSize: 26,
                        color: Colors.white)),
              ),
              const SizedBox(height: 100),
              TextFormField(
                  inputFormatters: <TextInputFormatter>[
                    LengthLimitingTextInputFormatter(20),
                    FilteringTextInputFormatter.deny(' ')
                  ],
                  validator: (val) {
                    if (val!.isEmpty) {
                      return 'Please Enter Password';
                    } else if (!validateStructure(val)) {
                      return 'should be a combination of upper case,lower case and special character with minimum 8 characters';
                    }
                    return null;
                  },
                  style: const TextStyle(color: Colors.black),
                  controller: passwordController,
                  keyboardType: TextInputType.text,
                  obscureText: isObscureText,
                  cursorColor: Colors.grey,
                  decoration: InputDecoration(
                    errorStyle:
                        const TextStyle(color: Color.fromRGBO(98, 8, 15, 1)),
                    errorMaxLines: 2,
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
                    suffixIcon: IconButton(
                      icon: Icon(
                        // Based on passwordVisible state choose the icon
                        isObscureText ? Icons.visibility : Icons.visibility_off,
                        color: isObscureText ? Colors.black : Colors.grey,
                      ),
                      onPressed: () {
                        // Update the state i.e. toogle the state of passwordVisible variable
                        setState(() {
                          isObscureText = !isObscureText;
                        });
                      },
                    ),
                    prefixIcon:
                        const Icon(Icons.lock, color: Colors.grey, size: 20),
                    hintText: "New Password",
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 20, horizontal: 20),
                    hintStyle: TextStyle(
                        color: const Color(0xFFb6b3c6).withOpacity(0.8),
                        fontFamily: 'RobotoRegular'),
                    border: const OutlineInputBorder(),
                  )),
              const SizedBox(height: 15),
              TextFormField(
                inputFormatters: <TextInputFormatter>[
                  LengthLimitingTextInputFormatter(20),
                  FilteringTextInputFormatter.deny(' ')
                ],
                validator: (val) {
                  if (val!.isEmpty) return 'Please Enter Password';
                  if (val != passwordController.text) {
                    return 'Password and Confirm Password must match.';
                  }

                  return null;
                },
                style: const TextStyle(color: Colors.black),
                controller: confirmcontroll,
                keyboardType: TextInputType.text,
                obscureText: isObscureTextC,
                cursorColor: Colors.grey,
                onChanged: (val) {
                  setState(() {
                    if (passwordController.text.isNotEmpty &&
                        confirmcontroll.text.isNotEmpty) {
                      isalldone = true;
                    } else {
                      isalldone = false;
                    }
                  });
                },
                decoration: InputDecoration(
                  errorStyle: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color.fromRGBO(98, 8, 15, 1)),
                  suffixIcon: IconButton(
                    icon: Icon(
                      // Based on passwordVisible state choose the icon
                      isObscureTextC ? Icons.visibility : Icons.visibility_off,
                      color: isObscureTextC ? Colors.black : Colors.grey,
                    ),
                    onPressed: () {
                      // Update the state i.e. toogle the state of passwordVisible variable
                      setState(() {
                        isObscureTextC = !isObscureTextC;
                      });
                    },
                  ),
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
                      const Icon(Icons.lock, color: Colors.grey, size: 20),
                  hintText: "Confirm New Password",
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                  hintStyle: TextStyle(
                      color: const Color(0xFFb6b3c6).withOpacity(0.8)),
                  border: const OutlineInputBorder(),
                ),
              )
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
        onPressed: _isLoading
            ? null
            : () {
                if (_formkey.currentState!.validate()) {
                  EasyLoading.show(status: 'Please Wait ...');
                  changePassword();
                }
              },
        child: const Text(
          "Confirm",
          style: TextStyle(
              color: Colors.white, fontSize: 18, fontFamily: 'RobotoBold'),
        ),
      ),
    );
  }

  Future<void> changePassword() async {
    setState(() {
      _isLoading = true;
    });
    final response = await http.post(
      Uri.parse(Reset_password),
      body: {'email': email, 'password': passwordController.text},
    );
    print(Reset_password + email + passwordController.text);

    String data = response.body;
    print(data);
    String status = jsonDecode(data)['status'].toString();

    EasyLoading.dismiss();
    if (status == "200") {
      email = '';
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const LoginPage()),
          (Route<dynamic> route) => false);
      setState(() {
        _isLoading = false;
      });
      String message = jsonDecode(data)['message'];
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(message),
      ));
      // ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      //   content: Text('OTP send successfully'),
      //   backgroundColor: Colors.green,
      // ));
      // Navigator.of(context).pushNamed(OTP_SCREEN);
    }
    if (status == "400") {
      setState(() {
        _isLoading = false;
      });
      String message = jsonDecode(data)['message'];
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(message),
      ));
    }
  }
}
