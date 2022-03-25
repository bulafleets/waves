import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:waves/contants/common_params.dart';
import 'package:waves/contants/common_widgets.dart';
import 'package:waves/screens/otp/otp_page.dart';
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
  TextEditingController confirmPasswordController = TextEditingController();
  bool isObscureText = true;
  bool isObscureTextc = true;
  var isalldone = false;
  String OTP = "";
  bool _isLoading = false;
  var _userType = ["REGULAR", "BUSINESS"];

  @override
  void dispose() {
    EasyLoading.dismiss();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formkey,
      child: Column(
        children: [
          Stack(children: <Widget>[
            Container(
              padding: EdgeInsets.only(left: 44.0),
              height: 50,
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(8)),
              // padding: const EdgeInsets.all(15),
              child: DropdownButtonHideUnderline(
                child: DropdownButton(
                    hint: Text(
                      AccountType,
                      style: const TextStyle(color: Colors.black),
                    ),
                    isExpanded: true,
                    icon: const Padding(
                      padding: EdgeInsets.only(right: 8.0),
                      child: Icon(Icons.arrow_drop_down,
                          color: Colors.black, size: 30),
                    ),
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.normal,
                      fontSize: 15,
                    ),
                    items: List.generate(
                        _userType.length,
                        (index) => DropdownMenuItem<String>(
                              value: _userType[index],
                              child: Text(_userType[index]),
                              onTap: () {},
                            )),
                    // onTap: _save,
                    onChanged: (val) {
                      setState(
                        () {
                          // maritalController.text = val.toString();
                          // _maritalstatusId = val.toString();
                          AccountType = val.toString();
                        },
                      );
                    }),
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 12.0, top: 14),
              child: FaIcon(
                  AccountType == 'BUSINESS'
                      ? FontAwesomeIcons.userTie
                      : FontAwesomeIcons.userAlt,
                  color: Colors.grey,
                  size: 20),
            ),
          ]),
          const SizedBox(height: 15),

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
              errorMaxLines: 2,
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
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
              hintText: "Email",
              hintStyle: TextStyle(
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
                errorMaxLines: 2,
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
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                hintText: "Password",
                hintStyle: TextStyle(
                    color: const Color(0xFFb6b3c6).withOpacity(0.8),
                    fontFamily: 'RobotoRegular'),
                border: const OutlineInputBorder(),
              )),
          const SizedBox(height: 15),
          TextFormField(
              style: const TextStyle(color: Colors.black),
              // validator:RequiredValidator(errorText: "Please Enter Your Mobile Number."),
              controller: confirmPasswordController,
              keyboardType: TextInputType.text,
              obscureText: isObscureTextc,
              cursorColor: Colors.grey,
              inputFormatters: <TextInputFormatter>[
                LengthLimitingTextInputFormatter(20),
                FilteringTextInputFormatter.deny(' ')
              ],
              validator: (val) {
                if (val!.isEmpty) return 'Please Enter Confirm Password';
                if (val != passwordController.text) {
                  return 'Password and Confirm Password must match.';
                }

                return null;
              },
              onChanged: (val) {
                setState(() {
                  if (emailController.text.isNotEmpty &&
                      passwordController.text.isNotEmpty &&
                      confirmPasswordController.text.isNotEmpty) {
                    isalldone = true;
                  } else {
                    isalldone = false;
                  }
                });
              },
              decoration: InputDecoration(
                errorMaxLines: 2,
                errorStyle: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color.fromRGBO(98, 8, 15, 1)),
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
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                hintText: "Re-enter Password",
                hintStyle: TextStyle(
                    color: const Color(0xFFb6b3c6).withOpacity(0.8),
                    fontFamily: 'RobotoRegular'),
                border: const OutlineInputBorder(),
              )),
          const SizedBox(height: 2),
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
                  // const SizedBox(width: 5),
                  Checkbox(
                    checkColor: Colors.black,
                    activeColor: Colors.white,
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
          const SizedBox(height: 29),
          // Spacer(),
          signUpButton()
        ],
      ),
    );
  }

  Widget signUpButton() {
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
        onPressed: _isLoading
            ? null
            : () {
                if (_formkey.currentState!.validate()) {
                  email = emailController.text;
                  password = passwordController.text.trim();

                  sendOTP();

                  EasyLoading.show(status: 'Please Wait ...');
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
    EasyLoading.dismiss();

    print(URL_OTP + emailController.text);

    String data = response.body;
    print(data);
    String status = jsonDecode(data)['status'].toString();

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
