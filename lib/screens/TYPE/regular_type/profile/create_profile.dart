import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:waves/contants/common_params.dart';
import 'package:waves/contants/common_widgets.dart';
import 'package:waves/contants/share_pref.dart';
import 'package:waves/screens/about_us/about_us.dart';
import 'package:waves/screens/friends/add_friends.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:waves/screens/map/map.dart';
import 'package:waves/screens/map/widget/permission_denied.dart';

import '../../../friends/add_friends.dart';

class CreateProfile extends StatefulWidget {
  const CreateProfile({Key? key}) : super(key: key);

  @override
  _CreateProfileState createState() => _CreateProfileState();
}

class _CreateProfileState extends State<CreateProfile> {
  TextEditingController nameController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController dobController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController bioController = TextEditingController();
  final GlobalKey<FormState> _formkey = GlobalKey();
  late PickedFile imageFile;
  bool _load = false;
  late String birthDateInString;
  DateTime birthDate = DateTime.now();
  bool isDateSelected = false;
  bool isLoading = true;
  var log;
  var lat;
  // ignore: prefer_typing_uninitialized_variables
  var differenceDOB;
  // var latitude;
  // var longitude;

  Future<Null> _selectDate(BuildContext context) async {
    DateFormat formatter = DateFormat('MM/dd/yy');

    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: isDateSelected ? birthDate : DateTime.now(),
        firstDate: DateTime(1901, 1),
        lastDate: DateTime.now());
    if (picked != null && picked != birthDate) {
      setState(() {
        isDateSelected = true;
        birthDate = picked;
        dobController.value = TextEditingValue(text: formatter.format(picked));
        differenceDOB = DateTime.now().difference(birthDate).inDays ~/ 365;

        if (differenceDOB > 17 && differenceDOB < 30) {
          ageController.value = const TextEditingValue(text: '18-30');
        } else if (differenceDOB > 29 && differenceDOB < 50) {
          ageController.value = const TextEditingValue(text: '30-50');
        } else if (differenceDOB > 49) {
          ageController.value = const TextEditingValue(text: '50 +');
        } else {
          ageController.clear();
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Your age should be 18 or above years'),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.red,
          ));
        }
      });
    }
  }

  _addrss(String add, String longitute, String latitude) {
    log = longitute;
    lat = latitude;
    addressController.text = add;
  }

  @override
  void initState() {
    addressController.text = '';
    determinePosition(context);
    super.initState();
  }

  @override
  void dispose() {
    addressController.clear();
    dobController.clear();
    EasyLoading.dismiss();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print(isBiometric);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
        title: Text(
          'Create Profile',
          style:
              GoogleFonts.quicksand(fontSize: 26, fontWeight: FontWeight.bold),
        ),
        elevation: 0,
      ),
      body: Container(
        color: Theme.of(context).primaryColor,
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Form(
            key: _formkey,
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                InkWell(
                    onTap: () {
                      _showPicker(context);
                    },
                    child: _load
                        ? Stack(alignment: Alignment.topRight, children: [
                            Container(
                              padding: const EdgeInsets.all(3),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50),
                                  color: isDateSelected
                                      ? differenceDOB > 17 && differenceDOB < 30
                                          ? const Color.fromRGBO(0, 0, 255, 1)
                                          : differenceDOB > 29 &&
                                                  differenceDOB < 50
                                              ? const Color.fromRGBO(
                                                  255, 255, 0, 1)
                                              : const Color.fromRGBO(
                                                  0, 255, 128, 1)
                                      : Colors.white),
                              child: CircleAvatar(
                                  radius: 50,
                                  backgroundImage:
                                      FileImage(File(imageFile.path))),
                            ),
                            Container(
                                alignment: Alignment.center,
                                height: 28,
                                width: 28,
                                margin: const EdgeInsets.all(3),
                                // padding: const EdgeInsets.all(2),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(50)),
                                child: const FaIcon(FontAwesomeIcons.camera,
                                    size: 15, color: Colors.black)),
                          ])
                        : Stack(alignment: Alignment.topRight, children: [
                            Container(
                              padding: const EdgeInsets.all(3),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50),
                                  color: Colors.white),
                              child: const CircleAvatar(
                                  radius: 50,
                                  child: Icon(
                                    Icons.person,
                                    size: 60,
                                  )),
                            ),
                            Container(
                                alignment: Alignment.center,
                                height: 28,
                                width: 28,
                                margin: const EdgeInsets.all(3),
                                // padding: const EdgeInsets.all(2),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(50)),
                                child: const FaIcon(FontAwesomeIcons.plus,
                                    size: 15, color: Colors.black)),
                          ])),
                const SizedBox(height: 30),
                TextFormField(
                  validator: (val) {
                    if (val!.isEmpty) return 'Please Enter Your Name';

                    return null;
                  },
                  style: const TextStyle(color: Colors.black),
                  // validator: emailValidator,
                  controller: nameController,
                  keyboardType: TextInputType.name,
                  textCapitalization: TextCapitalization.words,
                  cursorColor: Colors.grey,

                  inputFormatters: [
                    LengthLimitingTextInputFormatter(25),
                    NoLeadingSpaceFormatter(),
                  ],
                  decoration: InputDecoration(
                    errorStyle:
                        const TextStyle(color: Color.fromRGBO(98, 8, 15, 1)),
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
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 20, horizontal: 20),
                    hintText: "Your Name",
                    hintStyle: TextStyle(
                        color: const Color(0xFFb6b3c6).withOpacity(0.8),
                        fontFamily: 'RobotoRegular'),
                    border: const OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 15),
                TextFormField(
                  validator: (val) {
                    if (val!.isEmpty) return 'Please enter your mobile number';
                    if (val.length < 10) {
                      return 'Please enter your valid mobile number';
                    }

                    return null;
                  },
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(10),
                  ],
                  style: const TextStyle(color: Colors.black),
                  controller: mobileController,
                  keyboardType: TextInputType.number,
                  cursorColor: Colors.grey,
                  decoration: InputDecoration(
                    errorStyle:
                        const TextStyle(color: Color.fromRGBO(98, 8, 15, 1)),
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
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 20, horizontal: 20),
                    hintText: "Enter your mobile number",
                    hintStyle: TextStyle(
                        color: const Color(0xFFb6b3c6).withOpacity(0.8),
                        fontFamily: 'RobotoRegular'),
                    border: const OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 15),
                TextFormField(
                  validator: (val) {
                    if (val!.isEmpty) return 'Please choose you DOB';

                    return null;
                  },
                  onTap: () {
                    _selectDate(context);
                  },
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(10),
                  ],
                  style: const TextStyle(color: Colors.black),
                  controller: dobController,
                  keyboardType: TextInputType.none,
                  cursorColor: Colors.grey,
                  decoration: InputDecoration(
                    errorStyle:
                        const TextStyle(color: Color.fromRGBO(98, 8, 15, 1)),
                    suffixIcon: GestureDetector(
                        onTap: () {
                          _selectDate(context);
                        },
                        child: const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: FaIcon(FontAwesomeIcons.calendarAlt,
                              color: Colors.black),
                        )),
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
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 20, horizontal: 20),
                    hintText: "choose DOB",
                    hintStyle: TextStyle(
                        color: const Color(0xFFb6b3c6).withOpacity(0.8),
                        fontFamily: 'RobotoRegular'),
                    border: const OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 15),
                TextFormField(
                  enabled: false,
                  validator: (val) {
                    // print('ss');
                    // print(differenceDOB < 17);
                    if (val!.isEmpty) return 'Please Enter Your DOB';

                    return null;
                  },
                  style: const TextStyle(color: Colors.black),
                  controller: ageController,
                  keyboardType: TextInputType.none,
                  cursorColor: Colors.grey,
                  decoration: InputDecoration(
                    errorStyle:
                        const TextStyle(color: Color.fromRGBO(98, 8, 15, 1)),
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
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 20, horizontal: 20),
                    hintText: "Age Range",
                    hintStyle: TextStyle(
                        color: const Color(0xFFb6b3c6).withOpacity(0.8),
                        fontFamily: 'RobotoRegular'),
                    border: const OutlineInputBorder(),
                  ),
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
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(10),
                  ],
                  style: const TextStyle(color: Colors.black),
                  controller: addressController,
                  keyboardType: TextInputType.none,
                  cursorColor: Colors.grey,
                  decoration: InputDecoration(
                    errorStyle:
                        const TextStyle(color: Color.fromRGBO(98, 8, 15, 1)),
                    suffixIcon: GestureDetector(
                        onTap: () {
                          determinePosition(context);
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => MapSample(_addrss)));
                        },
                        child: const Padding(
                          padding: EdgeInsets.all(15.0),
                          child: FaIcon(Icons.my_location, color: Colors.black),
                        )),
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
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 20, horizontal: 20),
                    hintText: "Pick your address from map",
                    hintStyle: TextStyle(
                        color: const Color(0xFFb6b3c6).withOpacity(0.8),
                        fontFamily: 'RobotoRegular'),
                    border: const OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 15),
                TextFormField(
                  maxLines: 8,
                  style: const TextStyle(color: Colors.black),
                  // validator: emailValidator,
                  controller: bioController,
                  keyboardType: TextInputType.text,
                  cursorColor: Colors.grey,
                  // inputFormatters: [
                  //   LengthLimitingTextInputFormatter(25),
                  // ],
                  decoration: InputDecoration(
                    errorStyle:
                        const TextStyle(color: Color.fromRGBO(98, 8, 15, 1)),
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
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 20, horizontal: 20),
                    hintText: 'Bio(optional)',
                    hintStyle: TextStyle(
                        color: const Color(0xFFb6b3c6).withOpacity(1),
                        fontFamily: 'RobotoRegular'),
                    border: const OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 50),
                continueButton()
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget continueButton() {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.only(bottom: 150.0),
      height: 60,
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
          print(_load);

          // Navigator.of(context).push(
          //     MaterialPageRoute(builder: (context) => const AddFriends()));
          if (!_load) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text('Upload Profile picture'),
              behavior: SnackBarBehavior.floating,
              backgroundColor: Colors.red,
            ));
          } else if (nameController.text.isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text('Please enter your name'),
              backgroundColor: Colors.red,
              behavior: SnackBarBehavior.floating,
            ));
          } else if (nameController.text.length < 3) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text('Please enter minimum 3 characters'),
              backgroundColor: Colors.red,
              behavior: SnackBarBehavior.floating,
            ));
          } else if (mobileController.text.isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text('Please enter your mobile number'),
              backgroundColor: Colors.red,
              behavior: SnackBarBehavior.floating,
            ));
          } else if (mobileController.text.length < 10) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text('Please enter your valid mobile number'),
              backgroundColor: Colors.red,
              behavior: SnackBarBehavior.floating,
            ));
          } else if (dobController.text.isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text('Please enter your date of birth'),
              backgroundColor: Colors.red,
              behavior: SnackBarBehavior.floating,
            ));
          } else if (isDateSelected && differenceDOB < 17) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text('Your age should be 18 or above years'),
              backgroundColor: Colors.red,
              behavior: SnackBarBehavior.floating,
            ));
          } else if (addressController.text.isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text('Please enter your address'),
              backgroundColor: Colors.red,
              behavior: SnackBarBehavior.floating,
            ));
          } else {
            if (_formkey.currentState!.validate()) {
              EasyLoading.show(status: 'Please Wait ...');
              RegisterUser();
            }
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
          "Continue",
          style: TextStyle(
              color: Colors.white, fontSize: 18, fontFamily: 'RobotoBold'),
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

  // ignore: non_constant_identifier_names
  Future<void> RegisterUser() async {
    setState(() {
      isLoading = true;
    });
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    var fcmtoken = _prefs.getString(Prefs.firebasetoken);
    if (imageFile != null) {
      var request = http.MultipartRequest('POST', Uri.parse(URL_Signup));
      request.files
          .add(await http.MultipartFile.fromPath('avatar', imageFile.path));
      request.fields['name'] = nameController.text;
      request.fields['email'] = email;
      request.fields['password'] = password;
      request.fields['roleType'] = AccountType;
      request.fields['biography'] = bioController.text;
      request.fields['age'] = differenceDOB.toString();
      request.fields['isFaceId'] = isBiometric.toString();
      request.fields['address'] = addressController.text;
      request.fields['latitude'] = lat.toString();
      request.fields['longitude'] = log.toString();
      request.fields['dob'] = dobController.text;
      request.fields['mobile_number'] = mobileController.text;
      request.fields['firebase_token'] = fcmtoken.toString();
      print(latitude);
      var res = await request.send();
      var response = await http.Response.fromStream(res);
      String data = response.body;
      print(data);
      EasyLoading.dismiss();
      String status = jsonDecode(data)['status'].toString();
      if (status == '200') {
        user_id = jsonDecode(data)['user']['id'].toString();
        authorization = jsonDecode(data)['accessToken'];

        name = nameController.text;
        mobile = mobileController.text;
        profileimg = jsonDecode(data)['user']['avatar'];
        bio = bioController.text;
        age = differenceDOB.toString();
        address = addressController.text;
        dateOfBirth = dobController.text;
        _prefs.setString(Prefs.userId, user_id);
        _prefs.setString(Prefs.address, address);
        _prefs.setString(Prefs.name, name);
        _prefs.setString(Prefs.email, email);
        _prefs.setString(Prefs.mobile, mobile);
        _prefs.setString(Prefs.bio, bio);
        _prefs.setString(Prefs.avatar, profileimg);
        _prefs.setString(Prefs.roleType, AccountType);
        _prefs.setString(Prefs.password, password);
        _prefs.setString(Prefs.accessToken, authorization);
        _prefs.setString(Prefs.age, differenceDOB.toString());
        _prefs.setString(Prefs.faceId, isBiometric);
        _prefs.setDouble(Prefs.latitude, latitude);
        _prefs.setDouble(Prefs.longitude, longitude);
        _prefs.setString(Prefs.dob, dateOfBirth);
        // name = ;

        if (authorization != null) {
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                  builder: (context) => AboutUs(nameController.text, false)),
              (Route<dynamic> route) => false);
        }
        isSignUp = '';
        // Navigator.of(context).pushNamed(OTP_SCREEN);
      } else if (status == '400') {
        String message = jsonDecode(data)['message'].toString();
        EasyLoading.showToast(message);
      } else {
        String message = jsonDecode(data)['message'].toString();
        EasyLoading.showToast(message);
      }
    }
  }
}
