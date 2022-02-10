import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:waves/contants/share_pref.dart';
import 'package:waves/screens/splash/splash.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:awesome_notifications/awesome_notifications.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  //setting device_token for pushNotification
  FirebaseMessaging messaging;
  SharedPreferences prefs = await SharedPreferences.getInstance();
  messaging = FirebaseMessaging.instance;
  messaging.getToken().then((value) {
    print(value);
    prefs.setString(Prefs.firebasetoken, value!);
  });
  messaging.setForegroundNotificationPresentationOptions();
  AwesomeNotifications().initialize('resource://drawable/new_logo', [
    NotificationChannel(
        channelKey: 'basic_channel',
        channelName: 'Basic notifications',
        importance: NotificationImportance.High,
        channelShowBadge: true,
        defaultColor: Colors.pink,
        playSound: true,
        ledColor: Colors.white,
        channelDescription: '')
  ]);
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print("message recieved");
    print(message.data);
    int id = Random().nextInt((pow(2, 31) - 1).toInt());
    AwesomeNotifications().createNotification(
        content: NotificationContent(
            showWhen: true,
            displayOnForeground: true,
            id: id,
            channelKey: 'basic_channel',
            title: message.data['title'],
            body: message.data['body']));
  });
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  runApp(const MyApp());
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("Handling a background message: ${message.messageId}");
  print(message.data);
  int id = Random().nextInt((pow(2, 31) - 1).toInt());
  //firebase push notification
  // AwesomeNotifications().createNotificationFromJsonData(message.data);
  AwesomeNotifications().createNotification(
      content: NotificationContent(
          displayOnForeground: true,
          id: id,
          channelKey: 'basic_channel',
          title: message.data['title'],
          body: message.data['body']));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          primarySwatch: Colors.blue,
          primaryColor: const Color.fromRGBO(42, 124, 202, 1)),
      home: const SplashScreen(),
      builder: EasyLoading.init(),
    );
  }
}
