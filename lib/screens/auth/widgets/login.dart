import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:waves/contants/common_params.dart';
import 'package:waves/screens/Main/main_page.dart';
import 'package:waves/screens/about_us/about_us.dart';
import 'package:waves/screens/auth/local_auth/local_auth.dart';
import 'package:http/http.dart' as http;
import '../../forgetPassword/forget_password.dart';

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
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.deny(' ')
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
              hintText: "Email",
              contentPadding:
                  EdgeInsets.symmetric(vertical: 20, horizontal: 20),
              hintStyle: TextStyle(
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
              inputFormatters: <TextInputFormatter>[
                LengthLimitingTextInputFormatter(20),
                FilteringTextInputFormatter.deny(' ')
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
                // labelText: '',
                contentPadding:
                    EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                hintText: "Password",
                hintStyle: TextStyle(
                    color: const Color(0xFFb6b3c6).withOpacity(0.8),
                    fontFamily: 'RobotoRegular'),
                border: const OutlineInputBorder(),
              )),
          const SizedBox(height: 10),
          // InkWell(
          //     onTap: () {},
          //     child: Row(
          //       mainAxisAlignment: MainAxisAlignment.center,
          //       children: [
          //         Text(
          //           'Use Biometric ID',
          //           style: GoogleFonts.quicksand(
          //               fontSize: 13, color: Colors.white),
          //         ),
          //         // const SizedBox(width: 2),
          //         Checkbox(
          //           checkColor: Colors.black,
          //           activeColor: Colors.white,
          //           side: const BorderSide(
          //             color: Colors.white,
          //             width: 1.5,
          //           ),
          //           value: this.value,
          //           onChanged: (var value) {
          //             setState(() {
          //               this.value = value!;
          //             });
          //           },
          //         )
          //       ],
          //     )),
          const SizedBox(height: 80),
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
      margin: const EdgeInsets.only(left: 10.0, right: 10.0),
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
          // if (value) {
          //   bool isAuthenticated =
          //       await Authentication.authenticateWithBiometrics();
          //   print(isAuthenticated);

          //   if (isAuthenticated) {
          //     Navigator.of(context)
          //         .push(MaterialPageRoute(builder: (context) => AboutUs()));
          //   } else {
          //     ScaffoldMessenger.of(context).showSnackBar(
          //       const SnackBar(
          //         content: Text('Error authenticating using Biometrics.'),
          //       ),
          //     );
          //   }
          // } else {
          if (_formkey.currentState!.validate()) {
            EasyLoading.show(status: 'Please Wait ...');
            loginPage();
          }
          // }
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
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    var token = _prefs.getString('device_token');
    print(token);
    final response = await http.post(
      Uri.parse(URL_Login),
      body: {
        'username': emailController.text,
        'password': passwordController.text,
        "firebase_token": token.toString()
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
      AccountType = jsonDecode(data)['user']['roles'];
      name = jsonDecode(data)['user']['username'];
      var mobile = jsonDecode(data)['user']['mobile_number'];
      var image = jsonDecode(data)['user']['avatar'];
      var faceId = jsonDecode(data)['user']['isFaceId'];
      var bio = jsonDecode(data)['user']['biography'];
      var age = jsonDecode(data)['user']['age'];
      var address = jsonDecode(data)['user']['address'];
      //   var lat = jsonDecode(data)['user']['location']['coordinates'][1];
      // var log = jsonDecode(data)['user']['location']['coordinates'][2];

      _prefs.setString('email', email);
      _prefs.setString('user_id', user_id);
      _prefs.setString('roleType', AccountType);
      _prefs.setString('name', name);
      _prefs.setString('token', authorization);
      _prefs.setString('mobileno', mobile);
      // _prefs.setString('profileimg', image);
      _prefs.setString('token', authorization);
      _prefs.setString('age', age.toString());
      _prefs.setString('faceId', faceId.toString());
      _prefs.setString('bio', bio);
      _prefs.setString('address', address);
      // _prefs.setString('lat', lat);
      //   _prefs.setString('log', log);

      var isSeen = _prefs.getString('seen');
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
              builder: (context) =>
                  isSeen == 'true' ? const MainPage() : AboutUs(name, true)),
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
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message), backgroundColor: Colors.red));
    }
  }
}
