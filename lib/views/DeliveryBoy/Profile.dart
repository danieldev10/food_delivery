import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:food_delivery/AllText.dart';
import 'package:food_delivery/main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {

  List<String> list = List();
  String id = "";

  getDeliveryBoyProfile() async{
    setState(() {
    list.add(NAME);
    list.add(MOBILE_NUMBER);
    list.add(EMAIL_ADDRESS);
    list.add(VEHICLE_NUMBER);
    list.add(VEHICLE_TYPE);
    });
    await SharedPreferences.getInstance().then((pref){
      setState(() {
        id = pref.getString("userId");
      });
    });
    final response = await get("$SERVER_ADDRESS/api/deliveryboy_profile?deliverboy_id=$id");
    final jsonResponse = jsonDecode(response.body);
    print(jsonResponse);
    setState(() {
      list.add(jsonResponse['order']['name']);
      list.add(jsonResponse['order']['mobile_no']);
      list.add(jsonResponse['order']['email']);
      list.add(jsonResponse['order']['vehicle_no']);
      list.add(jsonResponse['order']['vehicle_type']);
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getDeliveryBoyProfile();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            list.length < 9 ? Center(child: CircularProgressIndicator(),) : Container(
              margin: EdgeInsets.fromLTRB(0, 0, 0, 50),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(bottomRight: Radius.circular(20), bottomLeft: Radius.circular(20)),
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 60,),
                    Text(BASIC_INFORMATION,
                      style: GoogleFonts.comfortaa(
                        fontSize: 15
                      ),
                    ),
                    SizedBox(height: 15,),
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: 5,
                        itemBuilder: (context, index){
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 8,),
                              Text(list[index],
                                style: GoogleFonts.comfortaa(
                                    fontSize: 17,
                                  fontWeight: FontWeight.bold
                                ),
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              Text(list[index+5],
                                style: GoogleFonts.comfortaa(
                                    fontSize: 13,
                                  color: Colors.grey.shade600
                                ),
                              ),
                              SizedBox(height: 8,),
                              Divider(
                                thickness: 0.5,
                                height: 20,
                                color: Colors.grey.shade700,
                              )
                            ],
                          );
                        },
                    ),

                  ],
                ),
              ),
            ),

            Container(
              color: Colors.white,
              padding: EdgeInsets.all(20),
              child: Row(
                children: [
                  InkWell(
                    onTap: (){
                      Navigator.pop(context);
                    },
                    child: Icon(
                      Icons.arrow_back_ios_rounded,
                      size: 17,
                    ),
                  ),
                  SizedBox(width: 10,),
                  Text(MY_PROFILE,style: GoogleFonts.comfortaa(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 23),),
                ],
              ),
            ),

          ],
        ),
      ),
    );
  }
}
