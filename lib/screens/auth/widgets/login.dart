import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:waves/contants/common_params.dart';
import 'package:waves/contants/share_pref.dart';
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
  bool isLoading = false;

  @override
  void dispose() {
    EasyLoading.dismiss();
    super.dispose();
  }

  @override
  void initState() {
    aboutdataApi();
    super.initState();
  }

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
              errorStyle: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color.fromRGBO(98, 8, 15, 1)),
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
                  const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
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
                errorStyle: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color.fromRGBO(98, 8, 15, 1)),

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
        onPressed: isLoading
            ? null
            : () {
                if (_formkey.currentState!.validate()) {
                  EasyLoading.show(status: 'Please Wait ...');
                  loginPage();
                }
              },
        child: const Text(
          "LOGIN",
          style: TextStyle(
              color: Colors.white, fontSize: 18, fontFamily: 'RobotoBold'),
        ),
      ),
    );
  }

  Future<void> loginPage() async {
    setState(() {
      isLoading = true;
    });

    SharedPreferences _prefs = await SharedPreferences.getInstance();
    var token = _prefs.getString(Prefs.firebasetoken);
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
    if (status == "200") {
      authorization = jsonDecode(data)['accessToken'];
      // String userdata = jsonDecode(data)['user'].toString();

      email = jsonDecode(data)['user']['email'];
      user_id = jsonDecode(data)['user']['_id'].toString();
      AccountType = jsonDecode(data)['user']['roles'];
      name = jsonDecode(data)['user']['username'];
      mobile = jsonDecode(data)['user']['mobile_number'];
      profileimg = jsonDecode(data)['user']['avatar'];
      isBiometric = jsonDecode(data)['user']['isFaceId'].toString();
      bio = jsonDecode(data)['user']['biography'];
      address = jsonDecode(data)['user']['address'];
      latitude = jsonDecode(data)['user']['latitude'];
      longitude = jsonDecode(data)['user']['longitude'];
      if (AccountType == 'REGULAR') {
        age = jsonDecode(data)['user']['age'].toString();
        dateOfBirth = jsonDecode(data)['user']['dob'];
      }
      _prefs.setString(Prefs.email, email);
      _prefs.setString(Prefs.userId, user_id);
      _prefs.setString(Prefs.roleType, AccountType);
      _prefs.setString(Prefs.name, name);
      _prefs.setString(Prefs.accessToken, authorization);
      _prefs.setString(Prefs.mobile, mobile);
      _prefs.setString(Prefs.avatar, profileimg);
      _prefs.setString(Prefs.faceId, isBiometric.toString());
      _prefs.setString(Prefs.bio, bio);
      _prefs.setString(Prefs.address, address);
      _prefs.setDouble(Prefs.latitude, latitude);
      _prefs.setDouble(Prefs.longitude, longitude);
      if (AccountType == 'REGULAR') {
        _prefs.setString(Prefs.dob, dateOfBirth);
        _prefs.setString(Prefs.age, age.toString());
      }
      // _prefs.setString('lat', lat);
      //   _prefs.setString('log', log);

      var isSeen = _prefs.getString('seen');
      setState(() {
        isLoading = false;
      });

      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
              builder: (context) =>
                  isSeen == 'true' ? const MainPage(0) : AboutUs(name, true)),
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
      setState(() {
        isLoading = false;
      });
      String message = jsonDecode(data)['message'];
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message), backgroundColor: Colors.red));
    }
  }

  Future<void> aboutdataApi() async {
    http.Response response =
        await http.post(Uri.parse(AboutData), body: {"slug": "about_us"});
    final jsonString = response.body;

    String status = jsonDecode(jsonString)['status'].toString();
    if (status == '200') {
      setState(() {
        aboutdata = jsonDecode(jsonString)['data']['description'].toString();
      });
    }
  }
}
