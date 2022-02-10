import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
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
            child: ListView.builder(
                itemCount: 3,
                itemBuilder: (context, index) => Container(
                      width: 100,
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                          child: ListTile(
                        leading: CircleAvatar(),
                        title: Text('Tony Stark Add You as a Friend'),
                        trailing: Icon(Icons.close),
                        onTap: () {},
                      )),
                    ))));
  }
}
