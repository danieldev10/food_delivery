import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:food_delivery/notificationHelper.dart';

class NotificationTest extends StatefulWidget {
  @override
  _NotificationTestState createState() => _NotificationTestState();
}

class _NotificationTestState extends State<NotificationTest> {

  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  String message = "";
  NotificationHelper notificationHelper;
  int id = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    notificationHelper = NotificationHelper("Test Title", "Test Body", null, "Food Explorer"); // why here static text??
    notificationHelper.initialize();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(message),
            OutlineButton(
              onPressed: (){
                setState(() {
                  id += 1;
                });
                notificationHelper = NotificationHelper("Test Title", "Test Body", null, id.toString());
                notificationHelper.initialize();
              },
              child: Text(message),
            )
          ],
        ),
      ),
    );
  }
}
