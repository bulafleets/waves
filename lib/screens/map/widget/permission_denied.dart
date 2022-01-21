import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class PermissionDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      insetPadding: EdgeInsets.all(30),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: Padding(
        padding: EdgeInsets.all(20),
        child: SizedBox(
          width: 500,
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Icon(Icons.add_location_alt_rounded,
                color: Theme.of(context).primaryColor, size: 100),
            SizedBox(height: 20),
            Text(
              'you_denied_location_permission',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 20),
            Row(children: [
              Expanded(
                child: TextButton(
                  style: TextButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                        side: BorderSide(
                            width: 2, color: Theme.of(context).primaryColor)),
                    minimumSize: Size(1, 50),
                  ),
                  child: Text('close'),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                  child: TextButton(
                      child: Text('settings'),
                      onPressed: () async {
                        await Geolocator.openAppSettings();
                        Navigator.pop(context);
                      })),
            ]),
          ]),
        ),
      ),
    );
  }
}
