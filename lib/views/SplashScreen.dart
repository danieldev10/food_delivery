import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery/main.dart';
import 'package:food_delivery/modals/AddedLocations.dart';
import 'package:food_delivery/modals/CartItems.dart';
import 'package:food_delivery/modals/Toppings.dart';
import 'package:food_delivery/views/DeliveryBoy/DeliveryBoyProfile.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

import 'HomeScreen.dart';

class SplashScreen extends StatefulWidget {

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  String token;
  bool isTokenAvailable = false;
  FirebaseMessaging _firebaseMessaging;
  
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("stepAA");
    Hive.registerAdapter(CartITemsAdapter());
    Hive.registerAdapter(ToppingsAdapter());
    Hive.registerAdapter(AddedLocationsAdapter());

    getToken();
  }

  getToken() async{
    print("step1");
    SharedPreferences.getInstance().then((pref) async{
      print("step2");
        isTokenAvailable = pref.getBool('tokenExist') ?? false;
        if(isTokenAvailable){
          Timer(Duration(seconds: 3), (){
            SharedPreferences.getInstance().then((pref){
              pref.getString('vehicle_no') == null
                  ? Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => HomeScreen()),
              )
                  : Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => DeliveryBoyProfile()),
              );
            });
          });
        }else{
          print("step3");
          await FirebaseMessaging().getToken().then((value){
            //Toast.show(value, context, duration: 2);
            print("step4");
            print(value); // here device token print
            setState(() {
              token = value;
            });
          });

          final response = await post("$SERVER_ADDRESS/api/tokan_data",
              body: {
                'token' : token,
                'type' : Platform.isAndroid ? "Android" : "Iphone",
              });
          final jsonResponse = jsonDecode(response.body);
          print(response.body);
          if(response.statusCode == 200 && jsonResponse['data']['success'] == "1"){
            Timer(Duration(seconds: 1), (){
              SharedPreferences.getInstance().then((pref){
                pref.setBool('tokenExist', true);
                pref.getString('vehicle_no') == null
                    ? Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => HomeScreen()),
                )
                    : Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => DeliveryBoyProfile()),
                );
              });
            });
          }else{
            Toast.show("Network connection error", context, duration: 3);
          }
        }
    });


  }

  void getMessages(){
    _firebaseMessaging.configure(
      onMessage: (msg) async{
        print('On Message : $msg');
        setState(() {
          //message = msg["notification"]['title'];
        });
      },
      onResume: (msg) async{
        print('On Resume : $msg');
        setState(() {
          //message = msg["notification"]['title'];
        });
      },
      onLaunch: (msg) async{
        print('On Launch : $msg');
        setState(() {
          //message = msg["notification"]['title'];
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            child: Image.asset("assets/icons/splash_bg.png",
              fit: BoxFit.cover,
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(60),
              child: Image.asset('assets/icons/splash_icon.png', fit: BoxFit.contain,),
            ),
          ),
        ],
      ),
    );
  }
}
