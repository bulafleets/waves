import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:waves/contants/common_params.dart';
import 'package:waves/screens/about_us.dart';
import 'package:waves/screens/homePage.dart';
import 'package:waves/widget/local_auth.dart';
import 'package:http/http.dart' as http;
import '../screens/forget_password.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formkey = GlobalKey();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final emailValidator = MultiValidator([
    RequiredValidator(errorText: 'Please Enter Email ID'),
    EmailValidator(errorText: 'Please Enter Valid Email ID'),
  ]);
  bool isObscureText = true;
  var isalldone = false;
  bool value = false;
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
              validator: (val) {
                if (val!.isEmpty) return 'Please Enter Password';
                if (val.length < 8) {
                  return 'Please enter Minimum 8 char Password';
                }
                return null;
              },
              style: const TextStyle(color: Colors.black),
              // validator:RequiredValidator(errorText: "Please Enter Your Mobile Number."),
              controller: passwordController,
              keyboardType: TextInputType.text,
              obscureText: isObscureText,
              cursorColor: Colors.grey,
              inputFormatters: [
                LengthLimitingTextInputFormatter(20),
              ],
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
          const SizedBox(height: 20),
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
                      });
                    },
                  )
                ],
              )),
          const SizedBox(height: 50),
          TextButton(
              onPressed: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => ForgetPassword()));
              },
              child: Text('Forget Password?',
                  style: GoogleFonts.quicksand(
                      fontSize: 15, color: Colors.white))),
          signButton()
        ],
      ),
    );
  }

  Widget signButton() {
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
        // onPressed: () {
        onPressed: () async {
          final LocalAuthentication localAuthentication = LocalAuthentication();
          bool isBiometricSupported =
              await localAuthentication.isDeviceSupported();
          if (value) {
            bool isAuthenticated =
                await Authentication.authenticateWithBiometrics();
            print(isAuthenticated);

            if (isAuthenticated) {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => AboutUs()));
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Error authenticating using Biometrics.'),
                ),
              );
            }
          } else {
            if (_formkey.currentState!.validate()) {
              EasyLoading.show(status: 'Please Wait ...');
              loginPage();
            }
          }
        },
        // Navigator.of(context)
        //     .push(MaterialPageRoute(builder: (context) => AboutUs()));
        // if (_formkey.currentState.validate()) {
        // showDialog(
        //   context: context,
        //   builder: (_) ,
        // );
        //
        //sendRESENT();
        //CircularProgressIndicator();
        //  EasyLoading.show(status: 'Please Wait ...');

        //print("Routing to your account");
        // }

        child: const Text(
          "LOGIN",
          style: TextStyle(
              color: Colors.white, fontSize: 18, fontFamily: 'RobotoBold'),
        ),
      ),
    );
  }

  Future<void> loginPage() async {
    final response = await http.post(
      Uri.parse(URL_Login),
      body: {
        'username': emailController.text,
        'password': passwordController.text
      },
    );
    print(URL_Login + emailController.text + passwordController.text);

    String data = response.body;
    print(data);
    String status = jsonDecode(data)['status'].toString();

    EasyLoading.dismiss();
    if (status == "true") {
      authorization = jsonDecode(data)['accessToken'];
      // String userdata = jsonDecode(data)['user'].toString();

      email = jsonDecode(data)['user']['email'];
      user_id = jsonDecode(data)['user']['_id'].toString();
      AccountType = jsonDecode(data)['user']['role'];

      SharedPreferences _prefs = await SharedPreferences.getInstance();

      _prefs.setString('email', email);
      _prefs.setString('user_id', user_id);
      _prefs.setString('role', AccountType);
      _prefs.setString('token', authorization);

      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => MyHomePage()),
          (Route<dynamic> route) => false);

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
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(message),
      ));
    }
  }
}
