import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery/AllText.dart';
import 'package:food_delivery/main.dart';
import 'package:food_delivery/modals/OrderProcessClass.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';

import '../notificationHelper.dart';

class OrderProgress extends StatefulWidget {

  String id;

  OrderProgress(this.id);

  @override
  _OrderProgressState createState() => _OrderProgressState();
}

class _OrderProgressState extends State<OrderProgress> {

  //OrderProcessClass orderProcessClass;

  OrderProcessClass orderProcessClass;
  bool loading = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getOrderDetails();
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


  getOrderDetails() async{
    setState(() {
      loading = true;
    });
    final response = await get("$SERVER_ADDRESS/api/order_details?order_id=${widget.id}");
    final jsonResponse = await jsonDecode(response.body);
    if(response.statusCode == 200){
      orderProcessClass = OrderProcessClass.fromJson(jsonResponse);
      print(orderProcessClass.orderDetails[0].address);
    }
    setState(() {
      loading = false;
    });

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: loading
            ? Center(
          child: CircularProgressIndicator(),
        )
            : Stack(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: 70,),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              Text(orderProcessClass.orderDetails[0].orderPlacedDate != null ? orderProcessClass.orderDetails[0].orderPlacedDate.substring(10)  : "",
                                style: TextStyle(
                                    fontFamily: 'GlobalFonts',
                                    color: GREY,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 0.8,
                                    fontSize: 10),),
                              SizedBox(height: 5,),
                              Text(ORDER_PLACED,
                                style: TextStyle(
                                    fontFamily: 'GlobalFonts',
                                    color: GREY.withOpacity(0.7),
                                    fontWeight: FontWeight.w900,
                                    letterSpacing: 0.8,
                                    fontSize: 8),),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: Column(
                            children: [
                              Text(orderProcessClass.orderDetails[0].preparingDateTime != null ? orderProcessClass.orderDetails[0].preparingDateTime.substring(10)  : "",
                                style: TextStyle(
                                    fontFamily: 'GlobalFonts',
                                    color: GREY,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 0.8,
                                    fontSize: 10),),
                              SizedBox(height: 5,),
                              Text(PREPARING,
                                style: TextStyle(
                                    fontFamily: 'GlobalFonts',
                                    color: GREY.withOpacity(0.7),
                                    fontWeight: FontWeight.w900,
                                    letterSpacing: 0.8,
                                    fontSize: 8),),
                            ],
                          ),
                        ),
                        SizedBox(width: 10,),
                        Expanded(
                          child: Column(
                            children: [
                              Text(orderProcessClass.orderDetails[0].dispatchedDateTime != null ? orderProcessClass.orderDetails[0].dispatchedDateTime.substring(10)  : "",
                                style: TextStyle(
                                    fontFamily: 'GlobalFonts',
                                    color: GREY,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 0.8,
                                    fontSize: 10),),
                              SizedBox(height: 5,),
                              Text(DISPATCHING,
                                style: TextStyle(
                                    fontFamily: 'GlobalFonts',
                                    color: GREY.withOpacity(0.7),
                                    fontWeight: FontWeight.w900,
                                    letterSpacing: 0.8,
                                    fontSize: 8),),
                            ],
                          ),
                        ),
                        SizedBox(width: 10,),
                        Expanded(
                          child: Column(
                            children: [
                              Text(orderProcessClass.orderDetails[0].deliveredDateTime != null ? orderProcessClass.orderDetails[0].deliveredDateTime.substring(10)  : "",
                                style: TextStyle(
                                    fontFamily: 'GlobalFonts',
                                    color: GREY,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 0.8,
                                    fontSize: 10),),
                              SizedBox(height: 5,),
                              Text(DELIVERED,
                                style: TextStyle(
                                    fontFamily: 'GlobalFonts',
                                    color: GREY.withOpacity(0.7),
                                    fontWeight: FontWeight.w900,
                                    letterSpacing: 0.8,
                                    fontSize: 8),),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20,),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              Image.asset(
                                orderProcessClass.orderDetails[0].placeStatus == "Activate"
                                    ? "assets/orderProgress/placed_active.png"
                                    : "assets/orderProgress/placed.png",
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: 10,
                          child: Container(
                            decoration: BoxDecoration(
                              color: BLACK,
                              border: Border.all(color: Colors.grey.shade800, width: 1),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Column(
                            children: [
                              Image.asset(
                                orderProcessClass.orderDetails[0].preparingStatus == "Activate"
                                    ? "assets/orderProgress/prepared_active.png"
                                    : "assets/orderProgress/prepared.png",

                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: 10,
                          child: Container(
                            decoration: BoxDecoration(
                              color: BLACK,
                              border: Border.all(color: Colors.grey.shade800, width: 1),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Column(
                            children: [
                              Image.asset(
                                orderProcessClass.orderDetails[0].dispatchedStatus == "Activate"
                                ? "assets/orderProgress/dispatching_active.png"
                                : "assets/orderProgress/dispatching.png"
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: 10,
                          child: Container(
                            decoration: BoxDecoration(
                              color: BLACK,
                              border: Border.all(color: GREY, width: 1),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Column(
                            children: [
                              Image.asset(
                                orderProcessClass.orderDetails[0].deliveredStatus == "Activate"
                                ? "assets/orderProgress/delieverd_active.png"
                                : "assets/orderProgress/delieverd.png",
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: LIGHT_GREY,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 20,),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(orderProcessClass.orderDetails[0].orderPlacedDate,style: TextStyle(
                                      fontFamily: 'GlobalFonts',
                                      color: BLACK,
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    ),
                                    SizedBox(height: 10,),
                                    Text(orderProcessClass.orderDetails[0].contact,style: TextStyle(
                                        fontFamily: 'GlobalFonts',
                                        color: BLACK,
                              fontSize: 12
                        ),)
                                ],
                                ),
                                Center(
                                    child : Text("$CURRENCY${double.parse(orderProcessClass.orderDetails[0].totalPrice).toStringAsFixed(2)}",style: TextStyle(
                                        fontFamily: 'GlobalFonts',
                                        color: BLACK,
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold),),)
                              ],
                            ),
                          ),
                          SizedBox(height: 15,),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                            child: Text(
                              orderProcessClass.orderDetails[0].address==null
                                ? ORDER_FOR_PICKUP
                                : orderProcessClass.orderDetails[0].address,style: TextStyle(
                                fontFamily: 'GlobalFonts',
                                color: GREY,
                                fontSize: 12,
                            ),),
                          ),
                          Divider(
                            height: 25,
                            thickness: 0.5,
                            color: GREY,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(20),
                            child: ListView.builder(
                              itemCount: orderProcessClass.orderDetails[0].menu.length,
                                shrinkWrap: true,
                                physics: ClampingScrollPhysics(),
                                itemBuilder: (context,index){
                                  return Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                orderProcessClass.orderDetails[0].menu[index].itemName,
                                                style: TextStyle(
                                                  fontFamily: 'GlobalFonts',
                                                  color: BLACK,
                                                fontSize: 13,
                                                fontWeight: FontWeight.bold,
                                              ),
                                              ),
                                              SizedBox(height: 10,),
                                              Text(
                                                "$CURRENCY${double.parse(orderProcessClass.orderDetails[0].menu[index].itemTotalPrice).toStringAsFixed(2)}",
                                                style: TextStyle(
                                                    fontFamily: 'GlobalFonts',
                                                    color: BLACK,
                                                  fontSize: 25,
                                                  fontWeight: FontWeight.bold),),
                                            ],
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 15,),
                                      Container(
                                        child: Wrap(
                                          children: List.generate(orderProcessClass.orderDetails[0].menu[index].topping.length, (i){
                                            return Text(
                                              "${orderProcessClass.orderDetails[0].menu[index].topping[i].name}${i<orderProcessClass.orderDetails[0].menu[index].topping.length-1 ? "," : ""}",style: TextStyle(
                                                fontFamily: 'GlobalFonts',
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                                color: GREY
                                            ),) ;
                                          }),
                                          spacing: 2,
                                          runSpacing: 0,
                                          alignment: WrapAlignment.start,
                                        ),
                                      ),
                                      Divider(
                                        thickness: 0.2,
                                        height: 40,
                                        color: GREY,
                                      ),
                                    ],
                                  );
                                }),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(SHIPPING_CHARGE,style: TextStyle(
                                    fontFamily: 'GlobalFonts',
                                    color: BLACK,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16
                                ),),
                                Text("$CURRENCY${orderProcessClass.orderDetails[0].deliveryCharges}",style: TextStyle(
                                    fontFamily: 'GlobalFonts',
                                    color: GREY.withOpacity(0.7),
                                    fontWeight: FontWeight.w900,
                                    fontSize: 14
                                ),)
                              ],
                            ),
                          ),
                          SizedBox(height: 20,)
                        ],
                      ),
                    ),
                    SizedBox(height: 20,),
                  ],
                ),
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
                    ),
                  ),
                  SizedBox(width: 10,),
                  Text("$ORDER_NUMBER - ${widget.id}",style: TextStyle(
                      fontFamily: 'GlobalFonts',
                      color: BLACK,fontWeight: FontWeight.bold,fontSize: 25),),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
