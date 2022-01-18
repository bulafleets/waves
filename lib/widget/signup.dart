import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:waves/contants/common_params.dart';
import 'package:waves/screens/otp_page.dart';
import 'package:http/http.dart' as http;

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  bool value = false;
  final emailValidator = MultiValidator([
    RequiredValidator(errorText: 'Please Enter Email ID'),
    EmailValidator(errorText: 'Please Enter Valid Email ID'),
  ]);
  final GlobalKey<FormState> _formkey = GlobalKey();

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmpasswordController = TextEditingController();
  bool isObscureText = true;
  bool isObscureTextc = true;
  var isalldone = false;
  String OTP = "";
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formkey,
      child: Column(
        children: [
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
              prefixIcon: const Icon(Icons.email, color: Colors.grey, size: 20),
              labelText: "Email",
              labelStyle: TextStyle(
                  color: const Color(0xFFb6b3c6).withOpacity(0.8),
                  fontFamily: 'RobotoRegular'),
              border: const OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 15),
          TextFormField(
              style: const TextStyle(color: Colors.black),
              // validator:RequiredValidator(errorText: "Please Enter Your Mobile Number."),
              controller: passwordController,
              keyboardType: TextInputType.text,
              obscureText: isObscureText,
              cursorColor: Colors.grey,
              inputFormatters: [
                LengthLimitingTextInputFormatter(20),
              ],
              validator: (val) {
                if (val!.isEmpty) return 'Please Enter Password';
                if (val.length < 8) {
                  return 'Please enter Minimum 8 char Password';
                }
                return null;
              },
              onChanged: (val) {
                setState(() {
                  if (emailController.text.isNotEmpty &&
                      passwordController.text.isNotEmpty) {
                    isalldone = true;
                  } else {
                    isalldone = false;
                  }
                });
              },
              decoration: InputDecoration(
                suffixIcon: IconButton(
                    icon: Icon(
                      // Based on passwordVisible state choose the icon
                      isObscureText ? Icons.visibility : Icons.visibility_off,
                      color: !isObscureText ? Colors.grey : Colors.black,
                    ),
                    onPressed: () {
                      // Update the state i.e. toogle the state of passwordVisible variable
                      setState(() {
                        isObscureText = !isObscureText;
                      });
                    }),
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
                labelText: "Password",
                labelStyle: TextStyle(
                    color: const Color(0xFFb6b3c6).withOpacity(0.8),
                    fontFamily: 'RobotoRegular'),
                border: const OutlineInputBorder(),
              )),
          const SizedBox(height: 15),
          TextFormField(
              style: const TextStyle(color: Colors.black),
              // validator:RequiredValidator(errorText: "Please Enter Your Mobile Number."),
              controller: confirmpasswordController,
              keyboardType: TextInputType.text,
              obscureText: isObscureTextc,
              cursorColor: Colors.grey,
              inputFormatters: [
                LengthLimitingTextInputFormatter(20),
              ],
              validator: (val) {
                if (val!.isEmpty) return 'Please Enter Password';
                if (val != passwordController.text) return 'Password not match';
                if (val.length < 8) {
                  return 'Please enter Minimum 8 char Password';
                }
                return null;
              },
              onChanged: (val) {
                setState(() {
                  if (emailController.text.isNotEmpty &&
                      passwordController.text.isNotEmpty &&
                      confirmpasswordController.text.isNotEmpty) {
                    isalldone = true;
                  } else {
                    isalldone = false;
                  }
                });
              },
              decoration: InputDecoration(
                suffixIcon: IconButton(
                    icon: Icon(
                      // Based on passwordVisible state choose the icon
                      isObscureTextc ? Icons.visibility : Icons.visibility_off,
                      color: !isObscureTextc ? Colors.grey : Colors.black,
                    ),
                    onPressed: () {
                      // Update the state i.e. toogle the state of passwordVisible variable
                      setState(() {
                        isObscureTextc = !isObscureTextc;
                      });
                    }),
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
                labelText: "Re-enter Password",
                labelStyle: TextStyle(
                    color: const Color(0xFFb6b3c6).withOpacity(0.8),
                    fontFamily: 'RobotoRegular'),
                border: const OutlineInputBorder(),
              )),
          const SizedBox(height: 20),
          // const SizedBox(width: 5),
          InkWell(
              onTap: () {},
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Use Biometric ID',
                    style: GoogleFonts.quicksand(
                        fontSize: 13, color: Colors.white),
                  ),
                  const SizedBox(width: 5),
                  Checkbox(
                    checkColor: Colors.white,
                    activeColor: Colors.transparent,
                    side: const BorderSide(
                      color: Colors.white,
                      width: 1.5,
                    ),
                    value: this.value,
                    onChanged: (var value) {
                      setState(() {
                        this.value = value!;
                        isBiometric = value.toString();
                      });
                    },
                  )
                ],
              )),
          const SizedBox(height: 50),
          signUpButton()
        ],
      ),
    );
  }

  Widget signUpButton() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 60,
      margin: const EdgeInsets.only(left: 20.0, right: 20.0),
      // padding: EdgeInsets.symmetric(horizontal: 16),
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
            email = emailController.text;
            password = passwordController.text;
            // SharedPreferences _prefs = await SharedPreferences.getInstance();
            // _prefs.setString(password, passwordController.text);
            // _prefs.setString(email, emailController.text);
            sendOTP();

            EasyLoading.show(status: 'Please Wait ...');

            //CircularProgressIndicator();
            //  EasyLoading.show(status: 'Please Wait ...');

            //print("Routing to your account");
          }
        },
        child: const Text(
          "Sign Up",
          style: TextStyle(
              color: Colors.white, fontSize: 18, fontFamily: 'RobotoBold'),
        ),
      ),
    );
  }

  Future<void> sendOTP() async {
    setState(() {
      _isLoading = true;
    });
    final response = await http.post(
      Uri.parse(URL_OTP),
      body: {
        'email': emailController.text,
      },
    );
    print(URL_OTP + emailController.text);

    String data = response.body;
    print(data);
    String status = jsonDecode(data)['status'].toString();

    EasyLoading.dismiss();
    if (status == "200") {
      OTP = jsonDecode(data)['Otp'];
      setState(() {
        _isLoading = false;
      });
      isSignUp = 'true';
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => OtpPage(emailController.text, OTP)));
      // Navigator.of(context).pushNamed(OTP_SCREEN);
    }
    if (status == "400") {
      String message = jsonDecode(data)['message'];
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(message),
      ));
      setState(() {
        _isLoading = false;
      });
    }
  }
}
