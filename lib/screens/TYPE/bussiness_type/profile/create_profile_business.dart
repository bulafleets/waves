import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:waves/contants/common_params.dart';
import 'package:waves/contants/common_widgets.dart';
import 'package:waves/contants/share_pref.dart';
import 'package:waves/screens/about_us/about_us.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:waves/screens/map/map.dart';

class CreateProfileForBusiness extends StatefulWidget {
  const CreateProfileForBusiness({Key? key}) : super(key: key);

  @override
  _CreateProfileForBusinessState createState() =>
      _CreateProfileForBusinessState();
}

class _CreateProfileForBusinessState extends State<CreateProfileForBusiness> {
  TextEditingController nameController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController bioController = TextEditingController();
  final GlobalKey<FormState> _formkey = GlobalKey();
  late PickedFile imageFile;
  bool _load = false;
  var log;
  var lat;
  // ignore: prefer_typing_uninitialized_variables
  // var latitude;
  // var longitude;

  _addrss(String add, String longitute, String latitude) {
    setState(() {
      log = longitute;
      lat = latitude;
      addressController.text = add;
    });
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
    EasyLoading.dismiss();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print(AccountType);
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
                                  color: Colors.white),
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
                                  child: FaIcon(
                                    FontAwesomeIcons.userTie,
                                    size: 50,
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
                    if (val!.isEmpty) return 'Please Enter Your Business Name';

                    return null;
                  },
                  style: const TextStyle(color: Colors.black),
                  // validator: emailValidator,
                  controller: nameController,
                  keyboardType: TextInputType.name,
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
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 20, horizontal: 20),
                    hintText: "Your Business Name",
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
                    hintText: "Enter Business mobile number",
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
                    if (val!.isEmpty) {
                      return 'Pick your business location from map';
                    }

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
                    hintText: "Pick your business location from map",
                    hintStyle: TextStyle(
                        color: const Color(0xFFb6b3c6).withOpacity(0.8),
                        fontFamily: 'RobotoRegular'),
                    border: const OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 15),
                TextFormField(
                  validator: (val) {
                    if (val!.isEmpty) return 'Please Enter business Bio';

                    return null;
                  },
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
                    hintText: 'Business bio',
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
          } else {
            if (_formkey.currentState!.validate()) {
              EasyLoading.show(status: 'Please Wait ...');
              RegisterUser();
            }
          }
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
    SharedPreferences _prefs = await SharedPreferences.getInstance();

    var fcmtoken = _prefs.getString(Prefs.firebasetoken);
    print(isBiometric);
    if (imageFile != null) {
      var request = http.MultipartRequest('POST', Uri.parse(URL_Signup));
      request.files
          .add(await http.MultipartFile.fromPath('avatar', imageFile.path));
      request.fields['name'] = nameController.text;
      request.fields['email'] = email;
      request.fields['password'] = password;
      request.fields['roleType'] = AccountType;
      request.fields['biography'] = bioController.text;
      request.fields['isFaceId'] = isBiometric.toString();
      request.fields['address'] = addressController.text;
      request.fields['latitude'] = lat.toString();
      request.fields['longitude'] = log.toString();
      request.fields['mobile_number'] = mobileController.text;
      request.fields['firebase_token'] = fcmtoken.toString();
      print(latitude);
      var res = await request.send();
      var response = await http.Response.fromStream(res);
      String data = response.body;
      print(data);
      String status = jsonDecode(data)['status'].toString();

      EasyLoading.dismiss();
      if (status == '200') {
        user_id = jsonDecode(data)['user']['id'].toString();
        authorization = jsonDecode(data)['accessToken'];
        name = nameController.text;
        mobile = mobileController.text;
        profileimg = jsonDecode(data)['user']['avatar'];
        bio = bioController.text;
        address = addressController.text;
        _prefs.setString(Prefs.address, address);
        _prefs.setString(Prefs.name, name);
        _prefs.setString(Prefs.email, email);
        _prefs.setString(Prefs.userId, user_id);
        _prefs.setString(Prefs.mobile, mobile);
        _prefs.setString(Prefs.bio, bio);
        _prefs.setString(Prefs.avatar, profileimg);
        _prefs.setString(Prefs.roleType, AccountType);
        _prefs.setString(Prefs.password, password);
        _prefs.setString(Prefs.accessToken, authorization);
        _prefs.setString(Prefs.faceId, isBiometric);
        _prefs.setDouble(Prefs.latitude, latitude);
        _prefs.setDouble(Prefs.longitude, longitude);
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
