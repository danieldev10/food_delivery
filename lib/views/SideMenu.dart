import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery/AllText.dart';
import 'package:food_delivery/main.dart';
import 'package:food_delivery/modals/CartItems.dart';
import 'package:food_delivery/views/AboutUs.dart';
import 'package:food_delivery/views/BookOrder.dart';
import 'package:food_delivery/views/CartPage.dart';
import 'package:food_delivery/views/DeliveryBoy/Profile.dart';
import 'package:food_delivery/views/FavouritesPage.dart';
import 'package:food_delivery/views/HomeScreen.dart';
import 'package:food_delivery/views/PrivacyPolicy.dart';
import 'package:food_delivery/views/login/LoginAsCustomer.dart';
import 'package:food_delivery/views/login/LoginAsDeliveryBoy.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

import '../notificationHelper.dart';
import 'DeliveryBoy/DeliveryBoyProfile.dart';

class SideMenu extends StatefulWidget {
  @override
  _SideMenuState createState() => _SideMenuState();
}

class _SideMenuState extends State<SideMenu> {

  int totalCartItems = 0;
  CartITems cartITems = CartITems();
  bool isLoggedIn = false;
  String name = "";
  String email = "";
  String userId = "";
  String bookOrderLength = '0';
  String vehicalNumber = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    read();
    //getMessages();
  }

  void getMessages(){
    FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
    NotificationHelper notificationHelper;
    _firebaseMessaging.configure(
      onMessage: (msg) async{
        print('On Message : $msg');
        setState(() {
          //message = msg["notification"]['title'];
          notificationHelper = NotificationHelper(msg["notification"]['title'], msg["notification"]['body'], null, "Food Explorer");
          notificationHelper.initialize();
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

    print(_firebaseMessaging.toString());

  }


  read() async{
    setState(() {
      totalCartItems = 0;
      bookOrderLength = '0';
    });
    List<CartITems> list = List();
    await cartITems.readingCart().then((value){
      setState(() {
        list.addAll(value);
        totalCartItems = list.length;
      });
    });
    await SharedPreferences.getInstance().then((pref){
      setState(() {
        isLoggedIn = pref.getBool("isLoggedIn") ?? false;
        name = pref.getString("name");
        email = pref.getString("email");
        userId = pref.getString("userId");
        vehicalNumber = pref.getString("vehicle_no");
        //Toast.show(vehicalNumber, context);
      });
    });

    if(userId != null){
      String url = "$SERVER_ADDRESS/api/noOfOrder?user_id=$userId";
      final response = await get(url);
      if(response.statusCode == 200){
        final jsonResponse = await jsonDecode(response.body);
        setState(() {
          bookOrderLength = jsonResponse['order'].length.toString();
          print("Book order length : $bookOrderLength");
        });
      }
    }
    print(list);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        InkWell(
                          child: Image.asset("assets/sideMenuIcons/cancel.png",
                            height: 20,
                            width: 20,
                            fit: BoxFit.contain,
                          ),
                          onTap: (){
                            HomeScreen().createState().closeDrawer(context);
                          },
                        ),
                      ],
                    ),
                    InkWell(
                      onTap: (){
                        if(!isLoggedIn){
                          Navigator.push(context,
                          MaterialPageRoute(builder: (context) => LoginAsCustomer()),
                          );
                        }
                        if(vehicalNumber != null){
                          Navigator.push(context,
                            MaterialPageRoute(builder: (context) => DeliveryBoyProfile()),
                          );
                        }
                      },
                      child: Row(
                        children: [
                          Container(
                            height: 70,
                            width: 70,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(35),
                              color: LIGHT_GREY
                            ),
                            child: Icon(Icons.account_circle,size: 70,color: THEME_COLOR,),
                          ),
                          SizedBox(width: 15,),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                isLoggedIn ? name : SIGN_IN,
                                style: TextStyle(
                                  fontFamily: 'GlobalFonts',
                                  color: BLACK,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                              SizedBox(height: 8,),
                              Text(
                                isLoggedIn
                                    ? email
                                    : PROFILE,
                                style: TextStyle(
                                  fontFamily: 'GlobalFonts',
                                  color: GREY,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w800,
                                ),
                              )
                            ],
                          ),
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                IconButton(
                                    icon: Icon(Icons.power_settings_new_rounded),
                                    onPressed: () {
                                      showdialog2();
                                    })
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(height: 30,),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                      child: ListTile(
                        title: Text(
                          "  $MENU_LIST",
                          style: TextStyle(
                            fontFamily: 'GlobalFonts',
                            color: BLACK,
                              fontWeight: FontWeight.w900,
                              fontSize: 14,
                          ),
                        ),
                        onTap: (){
                          HomeScreen().createState().closeDrawer(context);
                        },
                        leading: Image.asset(
                          "assets/sideMenuIcons/1.png",
                          height: 25,
                          width: 25,
                          fit: BoxFit.contain,
                          color: BLACK,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                      child: ListTile(
                        title: Text(
                          "  $MY_CART",
                          style: TextStyle(
                              fontFamily: 'GlobalFonts',
                              color: BLACK,
                              fontWeight: FontWeight.w900,
                              fontSize: 14
                          ),
                        ),
                        leading: Image.asset(
                          "assets/sideMenuIcons/2.png",
                          height: 25,
                          width: 25,
                          color: BLACK,
                          fit: BoxFit.contain,
                        ),
                        trailing: Container(
                          height: 25,
                          width: 25,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(13),
                            color: THEME_COLOR
                          ),
                          child: Center(
                            child: Text(
                              totalCartItems.toString(),
                              style: TextStyle(
                                fontFamily: 'GlobalFonts',
                                color: BLACK,
                                  fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),),
                          ),
                        ),
                        onTap: () async{
                          await Navigator.push(context,
                            MaterialPageRoute(builder: (context) => CartPage()),
                          );
                          read();
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                      child: ListTile(
                        title: Text(
                          "  $BOOK_ORDER",
                          style: TextStyle(
                              fontFamily: 'GlobalFonts',
                              color: BLACK,
                              fontWeight: FontWeight.w900,
                              fontSize: 14
                          ),
                        ),
                        onTap: (){
                          userId == null
                              ? showdialog()
                              //? Navigator.push(context, MaterialPageRoute(builder: (context) => LoginAsCustomer()))
                              : Navigator.push(context, MaterialPageRoute(builder: (context) => bookorderscreen()));
                        },
                        leading: Image.asset(
                          "assets/sideMenuIcons/3.png",
                          height: 25,
                          width: 25,
                          fit: BoxFit.contain,
                          color: BLACK,
                        ),
                        trailing: Container(
                          height: 25,
                          width: 25,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(13),
                            color: THEME_COLOR
                          ),
                          child: Center(
                            child: Text(
                              userId == null ? "0":bookOrderLength,
                              style: TextStyle(
                                fontFamily: 'GlobalFonts',
                                color: BLACK,
                                  fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                      child: ListTile(
                        title: Text(
                          "  $FAVOURITE",
                          style: TextStyle(
                              fontFamily: 'GlobalFonts',
                              color: BLACK,
                              fontWeight: FontWeight.w900,
                              fontSize: 14
                          ),
                        ),
                        onTap: (){
                          Navigator.push(context,
                            MaterialPageRoute(
                              builder: (context) => FavouritesPage(),
                            )
                          );
                        },
                        leading: Image.asset(
                          "assets/sideMenuIcons/4.png",
                          height: 25,
                          width: 25,
                          color: BLACK,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                      child: ListTile(
                        title: Text(
                          "  $ABOUT_US",
                          style: TextStyle(
                              fontFamily: 'GlobalFonts',
                              color: BLACK,
                              fontWeight: FontWeight.w900,
                              fontSize: 14
                          ),
                        ),
                        onTap: (){
                          Navigator.push(context,
                            MaterialPageRoute(builder: (context) => AboutUs()),
                          );
                        },
                        leading: Image.asset(
                          "assets/sideMenuIcons/5.png",
                          height: 25,
                          width: 25,
                          color: BLACK,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                      child: ListTile(
                        title: Text(
                          "  $OUR_POLICY",
                          style: TextStyle(
                              fontFamily: 'GlobalFonts',
                              color: BLACK,
                              fontWeight: FontWeight.w900,
                              fontSize: 14
                          ),
                        ),
                        onTap: (){
                          Navigator.push(context,
                            MaterialPageRoute(builder: (context) => PrivacyPolicy()),
                          );
                        },
                        leading: Image.asset(
                          "assets/sideMenuIcons/6.png",
                          height: 25,
                          width: 25,
                          color: BLACK,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),

                  ],
                ),
              ),
            ),
            userId == null ? Padding(
              padding: const EdgeInsets.all(5.0),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: InkWell(
                  onTap: (){
                    Navigator.push(context,
                      MaterialPageRoute(builder: (context) => LoginAsDeliveryBoy()),
                    );
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: 65,
                        width: 65,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(35),
                          border: Border.all(color: GREY)
                        ),
                        child: Center(
                          child: Image.asset(
                            "assets/sideMenuIcons/login.png",
                            height: 30,
                            width: 30,
                            fit: BoxFit.contain,
                            color: BLACK,
                          ),
                        ),
                      ),
                      SizedBox(width: 15,),
                      Text(
                        "$LOGIN_AS_DELIVERY_BOY",
                        style: TextStyle(
                          fontFamily: 'GlobalFonts',
                          color: BLACK,
                          fontWeight: FontWeight.w900,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ) : Container(),
          ],
        ),
      ),
    );
  }

  showdialog(){
    return showDialog(
        context: context,
      builder: (context){
          return AlertDialog(
            title: Text(ALERT,style: TextStyle(
              fontFamily: 'GlobalFonts',
              color: BLACK,
              fontWeight: FontWeight.bold,
            ),),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(SIDEMENU_DIALOG_TEXT,style: TextStyle(
                  fontFamily: 'GlobalFonts',
                  color: BLACK,
                  fontSize: 15,
                ),)
              ],
            ),
            actions: [
              FlatButton(
                  onPressed: (){
                    Navigator.pop(context);
                  },
                  child: Text('No',style: TextStyle(
                    fontFamily: 'GlobalFonts',
                    color: THEME_COLOR,
                    fontWeight: FontWeight.w900,
                  ),),
              ),
              FlatButton(
                  onPressed: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => LoginAsCustomer()));
                  },
                color: THEME_COLOR,
                  child: Text(YES,style: TextStyle(
                    fontFamily: 'GlobalFonts',
                    color: BLACK,
                    fontWeight: FontWeight.w900,
                  ),),
              ),
            ],
          );
      }
    );
  }

  showdialog2(){
    return showDialog(
        context: context,
      builder: (context){
          return AlertDialog(
            title: Text(LOGOUT,style: TextStyle(
              fontFamily: 'GlobalFonts',
              color: BLACK,
              fontWeight: FontWeight.bold,
            ),),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(ARE_YOU_SURE_TO_LOGOUT,style: TextStyle(
                  fontFamily: 'GlobalFonts',
                  color: BLACK,
                  fontSize: 15,
                ),)
              ],
            ),
            actions: [
              FlatButton(
                  onPressed: (){
                    Navigator.pop(context);
                  },
                  child: Text(NO,style: TextStyle(
                    fontFamily: 'GlobalFonts',
                    fontWeight: FontWeight.w900,
                    color: THEME_COLOR,
                  ),),
              ),
              FlatButton(
                  onPressed: () async{
                    await SharedPreferences.getInstance().then((pref){
                      pref.setBool("isLoggedIn", false);
                      pref.setString("userId", null);
                      pref.setString("name", null);
                      pref.setString("phone", null);
                      pref.setString("email", null);
                    });
                    Navigator.of(context).popUntil((route) => route.isFirst);
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => HomeScreen()),
                    );
                  },
                color: THEME_COLOR,
                  child: Text(YES,style: TextStyle(
                    fontFamily: 'GlobalFonts',
                    color: BLACK,
                    fontWeight: FontWeight.w900,
                  ),),
              ),
            ],
          );
      }
    );
  }

}
