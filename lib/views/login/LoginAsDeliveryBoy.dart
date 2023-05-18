import 'dart:ui';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery/AllText.dart';
import 'package:food_delivery/main.dart';
import 'package:food_delivery/views/DeliveryBoy/DeliveryBoyProfile.dart';
import 'package:food_delivery/views/SignUp.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

import '../HomeScreen.dart';

class LoginAsDeliveryBoy extends StatefulWidget {
  @override
  _LoginAsDeliveryBoyState createState() => _LoginAsDeliveryBoyState();
}

class _LoginAsDeliveryBoyState extends State<LoginAsDeliveryBoy> {

  String phoneNumber = "";
  String pass = "";
  bool isPhoneNumberError = false;
  bool isPasswordError = false;
  String passErrorText = "";
  String token = "";

  getToken() async{
    FirebaseMessaging().getToken().then((value){
      //Toast.show(value, context, duration: 2);
      print(value);
      setState(() {
        token = value;
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getToken();
  }

  loginInto() async{
    if(EmailValidator.validate(phoneNumber) == false){
      setState(() {
        isPhoneNumberError = true;
      });
    }else {
      dialog();
      //Toast.show("Logging In", context);
      String url = "$SERVER_ADDRESS/api/deliveryboy_login?email=$phoneNumber&password=$pass&token=$token&type=android";
      var response = await http.post(url, body: {
        'mobile_no': phoneNumber,
        'password': pass,
        'token': token,
      });
      print(response.statusCode);
      print(response.body);
      var jsonResponse = await convert.jsonDecode(response.body);
      if (jsonResponse['data']['success'] == "0") {
        setState(() {
          Navigator.pop(context);
          isPasswordError = true;
          passErrorText = EITHER_EMAIL_OR_PASSWORD_IS_INCORRECT;
        });
      }else{
        await SharedPreferences.getInstance().then((pref){
          pref.setBool("isLoggedIn", true);
          //String x = jsonResponse['data']['login']['id'].toString();
          pref.setString("userId",jsonResponse['data']['login'][0]['id'].toString());
          pref.setString("name", jsonResponse['data']['login'][0]['name']);
          pref.setString("phone", jsonResponse['data']['login'][0]['mobile_no']);
          pref.setString("email", jsonResponse['data']['login'][0]['email']);
          pref.setString("vehicle_no", jsonResponse['data']['login'][0]['vehicle_no']);
          pref.setString("vehicle_type", jsonResponse['data']['login'][0]['vehicle_type']);
          pref.setString("token", token.toString());
        });
        //Toast.show(jsonResponse['data']['login'][0]['vehical_no'], context,duration: 2);
        //Navigator.pop(context);
        Navigator.of(context).popUntil((route) => route.isFirst);
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => DeliveryBoyProfile())
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {



    return Scaffold(
      backgroundColor: BLACK,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: SafeArea(
              child: Container(
                decoration: BoxDecoration(
                    color: WHITE,
                    borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20))
                ),
                height: MediaQuery.of(context).size.height - 80,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          InkWell(
                              onTap: (){
                                Navigator.pop(context);
                              },
                              child: Icon(Icons.arrow_back_ios_rounded,size: 17, color: BLACK,)),
                          SizedBox(width: 10,),
                          Text(DELIVERY_BOY_LOGIN,
                            style:TextStyle(
                              fontFamily: 'GlobalFonts',
                              color: BLACK,
                              fontSize: 23,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 35,),
                      Image.asset(
                        "assets/loginIcons/deliveryman_icon.png",
                        height: 180,
                        width: 180,
                      ),
                      SizedBox(height: 20),
                      TextField(
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                            labelText: ENTER_EMAIL_ADDRESS,
                            labelStyle: TextStyle(
                                fontFamily: 'GlobalFonts',
                                color: GREY,
                                fontWeight: FontWeight.bold
                            ),
                            errorText: isPhoneNumberError ? ENTER_VALID_EMAIL : null,
                            focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: GREY,)
                            )
                        ),
                        style: TextStyle(
                            fontFamily: 'GlobalFonts',
                            color: BLACK,
                            fontWeight: FontWeight.bold
                        ),
                        onChanged: (val){
                          setState(() {
                            phoneNumber =val;
                            isPhoneNumberError = false;
                            isPasswordError = false;
                          });
                        },
                      ),
                      SizedBox(height: 10),
                      TextField(
                        obscureText: true,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          labelText: PASSWORD,
                          labelStyle: TextStyle(
                              fontFamily: 'GlobalFonts',
                              color: GREY,
                              fontWeight: FontWeight.bold
                          ),
                          errorText: isPasswordError ? passErrorText : null,
                          focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: GREY,)
                          ),
                        ),
                        style: TextStyle(
                            fontFamily: 'GlobalFonts',
                            color: BLACK,
                            fontWeight: FontWeight.bold
                        ),
                        onChanged: (val){
                          setState(() {
                            pass = val;
                            isPasswordError = false;
                          });
                        },
                      ),
                      SizedBox(height: 30),
                      Row(
                        children: [
                          Expanded(
                            child: FlatButton(
                              padding: EdgeInsets.all(13),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25)
                              ),
                              onPressed: () {
                                loginInto();
                              },
                              child: Text(
                                LOG_IN,
                                style: TextStyle(
                                    fontFamily: 'GlobalFonts',
                                    color: BLACK,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold
                                ),
                              ),
                              color: THEME_COLOR,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  dialog(){
    return showDialog(
        context: context,
        builder: (context){
          return AlertDialog(
            title: Text(LOGGING_IN,
              style: TextStyle(
                fontFamily: 'GlobalFonts',
                color: BLACK,),
            ),
            content: Container(
              margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
              child: Row(
                children: [
                  CircularProgressIndicator(),
                  SizedBox(width: 15,),
                  Expanded(
                    child: Text(PLEASE_WAIT_WHILE_LOGGING_INTO_ACCOUNT,
                      style: TextStyle(
                          fontFamily: 'GlobalFonts',
                          color: BLACK,
                          fontSize: 13
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        }
    );
  }



}
