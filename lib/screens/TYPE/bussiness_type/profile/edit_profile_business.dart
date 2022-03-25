import 'dart:convert';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:waves/contants/common_params.dart';
import 'package:waves/contants/common_widgets.dart';
import 'package:waves/contants/share_pref.dart';
import 'package:waves/screens/Main/main_page.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:waves/screens/map/map.dart';

class EditProfileScreenBusiness extends StatefulWidget {
  const EditProfileScreenBusiness({Key? key}) : super(key: key);

  @override
  _EditProfileScreenBusinessState createState() =>
      _EditProfileScreenBusinessState();
}

class _EditProfileScreenBusinessState extends State<EditProfileScreenBusiness> {
  TextEditingController nameController = TextEditingController(text: name);
  TextEditingController mobileController = TextEditingController(text: mobile);

  TextEditingController emailController = TextEditingController(text: email);
  TextEditingController addressController =
      TextEditingController(text: address);
  TextEditingController bioController = TextEditingController(text: bio);

  final GlobalKey<FormState> _formkey = GlobalKey();
  late PickedFile imageFile;
  bool _load = false;
  var log;
  var lat;
  bool _isChange = false;

  _addrss(String add, String longitute, String latitude) {
    setState(() {
      log = longitute;
      lat = latitude;
      addressController.text = add;
    });
  }

  @override
  void initState() {
    determinePosition(context);
    super.initState();
  }

  @override
  void dispose() {
    EasyLoading.dismiss();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print(profileimg);
    bool keyboardIsOpened = MediaQuery.of(context).viewInsets.bottom != 0.0;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text('Edit Profile',
            style: GoogleFonts.quicksand(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.w700)),
        elevation: 0,
        centerTitle: true,
      ),
      body: Container(
        color: Theme.of(context).primaryColor,
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.all(30),
        child: Form(
          key: _formkey,
          child: ListView(
            children: [
              Stack(alignment: Alignment.center, children: [
                if (_load)
                  CircleAvatar(
                      radius: 60,
                      foregroundColor: Colors.blue.withOpacity(0.1),
                      backgroundImage: FileImage(File(imageFile.path))),
                if (!_load)
                  CircleAvatar(
                    radius: 60,
                    foregroundColor: Colors.blue.withOpacity(0.1),
                    // backgroundImage: NetworkImage(profileimg),
                    child: CachedNetworkImage(
                      imageUrl: profileimg,
                      imageBuilder: (context, imageProvider) => Container(
                        width: double.infinity,
                        height: double.infinity,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                              image: imageProvider, fit: BoxFit.cover),
                        ),
                      ),
                      placeholder: (context, url) =>
                          const CircularProgressIndicator(),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                    ),
                  ),
                InkWell(
                  onTap: () {
                    _showPicker(context);
                  },
                  child: Column(children: [
                    const FaIcon(
                      FontAwesomeIcons.solidEdit,
                      color: Colors.white,
                      size: 27,
                    ),
                    Text('Edit',
                        style: GoogleFonts.quicksand(
                            color: Colors.white,
                            fontSize: 17,
                            fontWeight: FontWeight.w500))
                  ]),
                )
              ]),
              const SizedBox(height: 30),
              TextFormField(
                onChanged: (value) {
                  setState(() {
                    _isChange = true;
                  });
                },
                validator: (val) {
                  if (val!.isEmpty) return 'Please Enter Your Name';

                  return null;
                },
                style: const TextStyle(color: Colors.black),
                // validator: emailValidator,
                controller: nameController,
                keyboardType: TextInputType.name,
                cursorColor: Colors.grey,
                inputFormatters: [
                  LengthLimitingTextInputFormatter(25),
                  NoLeadingSpaceFormatter()
                ],
                decoration: InputDecoration(
                  errorStyle: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color.fromRGBO(98, 8, 15, 1)),
                  prefixIcon:
                      const Icon(Icons.person, color: Colors.grey, size: 20),
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
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                  hintText: "Your Name",
                  hintStyle: TextStyle(
                      color: const Color(0xFFb6b3c6).withOpacity(0.8),
                      fontFamily: 'RobotoRegular'),
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 15),
              TextFormField(
                  onChanged: (value) {
                    setState(() {
                      _isChange = true;
                    });
                  },
                  validator: (val) {
                    if (val!.isEmpty) return 'Please Enter bio';

                    return null;
                  },
                  style: const TextStyle(color: Colors.black),
                  controller: bioController,
                  keyboardType: TextInputType.text,
                  cursorColor: Colors.grey,
                  minLines: 1,
                  maxLines: 8,
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
                    prefixIcon: const Icon(Icons.description,
                        color: Colors.grey, size: 20),
                    // labelText: '',
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 20, horizontal: 20),
                    hintText: "bio",
                    hintStyle: TextStyle(
                        color: const Color(0xFFb6b3c6).withOpacity(0.8),
                        fontFamily: 'RobotoRegular'),
                    border: const OutlineInputBorder(),
                  )),
              const SizedBox(height: 15),
              TextFormField(
                enabled: false,
                validator: (val) {
                  if (val!.isEmpty) return 'Please enter your mobile number';

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
                  errorStyle: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color.fromRGBO(98, 8, 15, 1)),
                  prefixIcon:
                      const Icon(Icons.phone, color: Colors.grey, size: 20),
                  filled: true,
                  fillColor: Colors.white70,
                  enabledBorder: UnderlineInputBorder(
                    borderSide: const BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: const BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                  hintText: "Enter your mobile number",
                  hintStyle: TextStyle(
                      color: const Color(0xFFb6b3c6).withOpacity(0.8),
                      fontFamily: 'RobotoRegular'),
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 15),
              TextFormField(
                enabled: false,
                style: const TextStyle(color: Colors.black),
                controller: emailController,
                keyboardType: TextInputType.number,
                cursorColor: Colors.grey,
                decoration: InputDecoration(
                  errorStyle: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color.fromRGBO(98, 8, 15, 1)),
                  prefixIcon:
                      const Icon(Icons.email, color: Colors.grey, size: 20),
                  filled: true,
                  fillColor: Colors.white70,
                  enabledBorder: UnderlineInputBorder(
                    borderSide: const BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: const BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.circular(8),
                  ),
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
                minLines: 1,
                maxLines: 3,
                onChanged: (value) {
                  setState(() {
                    _isChange = true;
                  });
                },
                onTap: () {
                  _isChange = true;
                  determinePosition(context);
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => MapSample(_addrss)));
                },
                validator: (val) {
                  if (val!.isEmpty) return 'Pick your location from map';

                  return null;
                },
                style: const TextStyle(color: Colors.black),
                controller: addressController,
                keyboardType: TextInputType.none,
                cursorColor: Colors.grey,
                decoration: InputDecoration(
                  errorStyle: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color.fromRGBO(98, 8, 15, 1)),
                  prefixIcon: GestureDetector(
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
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                  hintText: "Pick your address from map",
                  hintStyle: TextStyle(
                      color: const Color(0xFFb6b3c6).withOpacity(0.8),
                      fontFamily: 'RobotoRegular'),
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 88),
            ],
          ),
        ),
      ),
      floatingActionButton:
          keyboardIsOpened || !_isChange ? null : saveButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      backgroundColor: Colors.transparent,
    );
  }

  Widget saveButton() {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.all(10),
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

          if (_formkey.currentState!.validate()) {
            EasyLoading.show(status: 'Please Wait ...');
            updateProfile();
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
      _isChange = true;
      _load = true;
    });
  }

  _imgFromGallery() async {
    final pickedFile = await ImagePicker()
        .getImage(source: ImageSource.gallery, imageQuality: 50);

    setState(() {
      imageFile = pickedFile!;
      _load = true;
      _isChange = true;
    });
  }

  Future<void> updateProfile() async {
    print(longitude);
    print(latitude);
    var headers = {HttpHeaders.authorizationHeader: "Bearer $authorization"};
    var request = http.MultipartRequest('POST', Uri.parse(UpdateProfile));
    request.headers.addAll(headers);
    if (_load) {
      request.files
          .add(await http.MultipartFile.fromPath('avatar', imageFile.path));
    }
    request.fields['_id'] = user_id;
    request.fields['name'] = nameController.text;
    request.fields['biography'] = bioController.text;

    request.fields['address'] = addressController.text;
    request.fields['latitude'] = latitude.toString();
    request.fields['longitude'] = longitude.toString();

    var res = await request.send();
    var response = await http.Response.fromStream(res);
    String data = response.body;
    print(data);
    EasyLoading.dismiss();

    String status = jsonDecode(data)['status'].toString();
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    if (status == "200") {
      profileimg = jsonDecode(data)['user']['avatar'];
      bio = bioController.text;
      name = nameController.text;
      address = addressController.text;
      _prefs.setString(Prefs.name, name);
      _prefs.setString(Prefs.address, address);
      _prefs.setString(Prefs.bio, bio);
      _prefs.setString(Prefs.avatar, profileimg);
      _prefs.setDouble(Prefs.latitude, latitude);
      _prefs.setDouble(Prefs.longitude, longitude);
      String message = jsonDecode(data)['message'];
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(message),
      ));
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const MainPage(0)),
          (Route<dynamic> route) => false);
    }
    if (status == "400") {
      String message = jsonDecode(data)['message'];
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(message),
      ));
    }
  }
}
