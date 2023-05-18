
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationHelper{

  String title;
  String body;
  String payload;
  String id;


  NotificationHelper(this.title, this.body, this.payload,
      this.id); // initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
  initialize() async{
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');
    final IOSInitializationSettings initializationSettingsIOS =
    IOSInitializationSettings(
        onDidReceiveLocalNotification: onDidReceiveLocalNotification, requestAlertPermission: true, requestBadgePermission: true, requestSoundPermission: true);
    final InitializationSettings initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid,
        iOS: initializationSettingsIOS);
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);

    AndroidNotificationDetails androidPlatformChannelSpecifics =
    new AndroidNotificationDetails(
        id, id, id,
        importance: Importance.max,
        priority: Priority.high,
        showWhen: false);
    NotificationDetails platformChannelSpecifics =
    NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
        0, title, body, platformChannelSpecifics,
        payload: payload);

  }

  Future onSelectNotification(String payload) async {
    if (payload != null) {
      print('notification payload: $payload');
    }
    // await Navigator.push(
    //   context,
    //   MaterialPageRoute<void>(builder: (context) => SecondScreen(payload)),
    // );
  }

  Future onDidReceiveLocalNotification(
      int id, String title, String body, String payload) async {
// display a dialog with the notification details, tap ok to go to another page
  print("on did received called");
  }


}