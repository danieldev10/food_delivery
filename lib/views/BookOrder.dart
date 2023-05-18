

import 'dart:async';
import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:food_delivery/AllText.dart';
import 'package:food_delivery/main.dart';
import 'package:food_delivery/modals/BookOrderClass.dart';
import 'package:food_delivery/modals/OrderProcessClass.dart';
import 'package:food_delivery/views/OrderProgress.dart';
import 'package:food_delivery/views/login/LoginAsCustomer.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'dart:convert' as convert;

import 'package:shared_preferences/shared_preferences.dart';

class bookorderscreen extends StatefulWidget {
  @override
  _bookorderscreenState createState() => _bookorderscreenState();
}

class _bookorderscreenState extends State<bookorderscreen> {

  List<BookOrderClass> list = List();
  String userId;
  //List<String> orderStatus = List();
  OrderProcessClass orderProcessClass;
  bool loading = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchBookedOrders();

  }

  // getOrderStatus(String id) async{
  //   setState(() {
  //     loading = true;
  //   });
  //   final response = await get("https://freaktemplate.com/fooddelivery_app/api/order_details?order_id=$id");
  //   final jsonResponse = await jsonDecode(response.body);
  //   if(response.statusCode == 200){
  //
  //     setState(() {
  //       orderStatus.add(jsonResponse["order_details"][0]["order_status"]);
  //     });
  //   }
  // }

  fetchBookedOrders() async{

    setState(() {
      loading = true;
      //orderStatus.clear();
    });

    await SharedPreferences.getInstance().then((pref){
      setState(() {
        userId = pref.getString("userId");
      });
    });

    String url = "$SERVER_ADDRESS/api/noOfOrder?user_id=$userId";
    final response = await http.get(url);
    if(response.statusCode == 200){
      print(response.body);
      final jsonResponse = await convert.jsonDecode(response.body);
      print(jsonResponse['order'].length);
      for(int i =0; i<jsonResponse['order'].length;i++){
        setState(() {
          list.add(BookOrderClass(
            jsonResponse['order'][i]['order_no'].toString(),
            jsonResponse['order'][i]['total_amount'],
            jsonResponse['order'][i]['order_id'].toString(),
            jsonResponse['order'][i]['address'],
            jsonResponse['order'][i]['delivery_mode'],
            jsonResponse['order'][i]['order_status'],
          ));
          //getOrderStatus(jsonResponse['order'][i]['order_no'].toString());
        });
      }
    }
    setState(() {
      loading = false;
    });

  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: list == null
            ? Center(child: CircularProgressIndicator(),)
            : Stack(
              children: [
                Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
          child: Column(
                children: [
                  SizedBox(height: 45,),
                  Expanded(
                    child: ListView.builder(
                      itemCount: list.length,
                        itemBuilder: (context,index){
                          return InkWell(
                              onTap: (){
                                Navigator.push(context, MaterialPageRoute(builder: (context) => OrderProgress(list[index].order_id)));
                              },
                            child: Container(
                              margin: EdgeInsets.fromLTRB(0, 8, 8, 10),
                              decoration: BoxDecoration(
                                color: LIGHT_GREY,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(15, 20, 15, 20),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text("$ORDER_NUMBER : ${list[index].order_no}",style: TextStyle(
                                              fontFamily: 'GlobalFonts',
                                              color: BLACK,
                                              fontSize: 13,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            ),
                                            SizedBox(height: 10,),
                                            Text("$CURRENCY${double.parse(list[index].total_amount).toStringAsFixed(2)}",style: TextStyle(
                                                fontFamily: 'GlobalFonts',
                                                color: BLACK,
                                                fontSize: 25,
                                                fontWeight: FontWeight.bold),),
                                          ],
                                        ),
                                        Container(
                                          height: 30,
                                          width: 100,
                                          //margin: EdgeInsets.fromLTRB(0, 0, 10, 0),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(15),
                                            border: Border.all(color: GREY)
                                          ),
                                          child: Center(child: Text(list[index].orderStatus,style: TextStyle(
                                              fontFamily: 'GlobalFonts',
                                              color: BLACK,
                                            fontSize: 12
                                          )
                                            ,)),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 15,),
                                    Text("${list[index].address == null ? ORDER_FOR_PICKUP : list[index].address}",style: TextStyle(
                                        fontFamily: 'GlobalFonts',
                                        color: GREY,
                                        fontSize: 12,
                                    ),)
                                  ],
                                ),
                              ),
                            ),
                          );
                        }),
                    ),
                ],
          ),
        ),
                Container(
                  color: WHITE,
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
                          color: BLACK,
                        ),
                      ),
                      SizedBox(width: 10,),
                      Text(BOOK_ORDER,style: TextStyle(
                          fontFamily: 'GlobalFonts',
                          color: BLACK,fontWeight: FontWeight.bold,fontSize: 23),),
                    ],
                  ),
                ),
              ],
            ),
      ),
    );
  }
}
