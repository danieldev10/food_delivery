import 'dart:ui';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery/AllText.dart';
import 'package:food_delivery/main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convertor;
import 'dart:convert' as convert;
import 'package:toast/toast.dart';

class ForgetPassword extends StatefulWidget {
  @override
  _ForgetPasswordState createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {

  String email = "";
  bool isEmailError = false;
  
  sendMain() async{
    if(EmailValidator.validate(email)==false){
      setState(() {
        isEmailError = true;
      });
    }else{
      FocusScope.of(context).unfocus();
      Toast.show(SENDING_EMAIL, context,duration: 2);
      String url = "$SERVER_ADDRESS/api/forgotpassword?phone=$email";
      print(url);
      var response = await http.get(url);
      print(response.body);
      final jsonResponse = await convert.jsonDecode(response.body);
      print(jsonResponse['success']);
      if(jsonResponse['success'] == "1"){
        Toast.show(MAIL_SENT_SUCCESSFULLY, context,duration: 2);
      }else{
        Toast.show(jsonResponse['data'], context,duration: 2);
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
                              child: Icon(Icons.arrow_back_ios_rounded,size: 17,)),
                          SizedBox(width: 10,),
                          Text("Forget Password",
                            style: TextStyle(
                              fontFamily: 'GlobalFonts',
                              color: BLACK,
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 35,),
                      Image.asset(
                        "assets/icons/forget_pass.png",
                        height: 180,
                        width: 180,
                      ),
                      SizedBox(height: 20),
                      TextField(
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          labelText: ENTER_EMAIL_ADDRESS,
                          labelStyle: TextStyle(
                              fontFamily: 'GlobalFonts',
                              color: GREY,
                            fontWeight: FontWeight.bold
                          ),
                          errorText: isEmailError ? ENTER_VALID_EMAIL : null,
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
                            email =val;
                            isEmailError = false;
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
                                sendMain();
                              },
                              child: Text(
                                FORGET_PASSWORD,
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

}
