import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:waves/contants/common_params.dart';
import 'package:waves/models/notification_model.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  List<NotificationLocalModel> _data = [];
  @override
  void initState() {
    isNotification = false;
    _data = notificationData;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          elevation: 0,
          title: Text('Notification',
              style: GoogleFonts.quicksand(
                  fontWeight: FontWeight.w500,
                  fontSize: 21,
                  color: Colors.white)),
          centerTitle: true,
        ),
        body: Container(
            color: Theme.of(context).primaryColor,
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            padding: const EdgeInsets.all(7),
            child: _data.isNotEmpty
                ? ListView.builder(
                    itemCount: _data.length,
                    itemBuilder: (context, index) {
                      return Container(
                        width: 100,
                        padding: const EdgeInsets.all(8.0),
                        child: Card(
                            child: ListTile(
                          leading: const CircleAvatar(
                            backgroundImage:
                                AssetImage('assets/icons/logo_noti.png'),
                          ),
                          title: Text(_data[index].title),
                          subtitle: Text(_data[index].description),
                          trailing: IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: () {
                              print(index);
                              _data.removeAt(index);
                              notificationData.removeAt(index);
                            },
                          ),
                          // onTap: () {
                          //   setState(() {
                          //     _data.removeAt(index);
                          //     notificationData.removeAt(index);
                          //   });
                          // },
                        )),
                      );
                    })
                : Center(
                    child: Text(
                      'No Notification Found!',
                      style: GoogleFonts.quicksand(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w500),
                    ),
                  )));
  }
}
