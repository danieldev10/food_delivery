import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:food_delivery/AllText.dart';
import 'package:food_delivery/main.dart';
import 'package:food_delivery/modals/OrderProcessClass.dart';
import 'package:food_delivery/views/DeliveryBoy/DeliveryBoyMap.dart';
import 'package:food_delivery/views/DeliveryBoy/modals/OrderItemDetails.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
import 'package:toast/toast.dart';
import 'package:url_launcher/url_launcher.dart';

class DeliveryBoyOrderDetails extends StatefulWidget {

  String id;
  DeliveryBoyOrderDetails(this.id);

  @override
  _DeliveryBoyOrderDetailsState createState() => _DeliveryBoyOrderDetailsState();
}

class _DeliveryBoyOrderDetailsState extends State<DeliveryBoyOrderDetails> {

  bool loading = true;
  OrderProcessClass orderProcessClass;
  OrderItemDetails orderItemDetails;
  bool isPickedUp = false;
  bool isCanceled = false;
  bool isDelivered = false;
  String name = "";
  String payMethod = "";
  double lat = 0.0;
  double lng = 0.0;


  getOrderStatus() async{
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
      isPickedUp = orderProcessClass.orderDetails[0].dispatchedStatus=="Activate" ? true : false;
      isDelivered = orderProcessClass.orderDetails[0].deliveredStatus=="Activate" ? true : false;
      isCanceled = orderProcessClass.orderDetails[0].cancelDateTime != null ? true : false;
    });
  }

  getOrderDetails() async{
    setState(() {
      loading = true;
    });
    final response = await get("$SERVER_ADDRESS/api/order_item_details?order_id=${widget.id}");
    final jsonResponse = await jsonDecode(response.body);
    if(response.statusCode == 200){
      orderItemDetails = OrderItemDetails.fromJson(jsonResponse);
     setState(() {
       name = orderItemDetails.order.customerName;
       payMethod = orderItemDetails.order.payment;
       lat = double.parse(orderItemDetails.order.latitude);
       lng = double.parse(orderItemDetails.order.longitude);
     });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getOrderStatus();
    getOrderDetails();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            loading
                ? Center(
              child: CircularProgressIndicator(),
            )
                : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                child: Column(
                  children: [
                    SizedBox(height: 50,),
                    Container(
                      margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
                      decoration: BoxDecoration(
                        color: LIGHT_GREY,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: EdgeInsets.all(20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "$ORDER_NUMBER: " +widget.id,
                                style: TextStyle(
                                  fontFamily: 'GlobalFonts',
                                  color: BLACK,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                              loading ? CircularProgressIndicator() : Text(
                                orderProcessClass.orderDetails[0].orderPlacedDate,
                                style: TextStyle(
                                    fontFamily: 'GlobalFonts',
                                    color: GREY,
                                    fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10,),
                          loading
                              ? CircularProgressIndicator()
                              : Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "$CURRENCY${double.parse(orderProcessClass.orderDetails[0].totalPrice).toStringAsFixed(2)}",
                                style: TextStyle(
                                    fontFamily: 'GlobalFonts',
                                    color: BLACK,
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold),),
                              InkWell(
                                onTap: (){
                                  deliveredDialog();
                                },
                                child: Container(
                                  height: 25,
                                  width: 100,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(13),
                                      border: Border.all(color: GREY, width: 0.5)
                                  ),
                                  child: Center(
                                    child: Text(
                                      payMethod.toUpperCase(),
                                      style: TextStyle(
                                          fontFamily: 'GlobalFonts',
                                          color: GREY,
                                          fontSize: 10,
                                          fontWeight: FontWeight.w900
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                          SizedBox(height: 15,),
                          Text(orderProcessClass.orderDetails[0].address,style: TextStyle(
                              fontFamily: 'GlobalFonts',
                              color: GREY,
                              fontSize: 12,
                          ),),
                        ],
                      ),
                    ),
                    SizedBox(height: 20,),
                    Container(
                      decoration: BoxDecoration(
                        color: LIGHT_GREY,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(name,
                                      style: TextStyle(
                                        fontFamily: 'GlobalFonts',
                                        color: BLACK,
                                        fontWeight: FontWeight.w900,
                                        fontSize: 13,
                                      ),
                                    ),
                                    SizedBox(height: 15,),
                                    Text(orderProcessClass.orderDetails[0].contact,
                                      style: TextStyle(
                                          fontFamily: 'GlobalFonts',
                                          color: GREY,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 11,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    InkWell(
                                      onTap: (){
                                        launch("tel://${orderProcessClass.orderDetails[0].contact}");
                                      },
                                      child: Image.asset(
                                        'assets/deliveryBoyIcons/call.png',
                                        height: 60,
                                        width: 60,
                                      ),
                                    ),
                                    SizedBox(width: 10,),
                                    InkWell(
                                      onTap: (){
                                        Navigator.push(context,
                                          MaterialPageRoute(builder: (context)=> DeliveryBoyMap(
                                            lat, lng))
                                        );
                                      },
                                      child: Image.asset(
                                        'assets/deliveryBoyIcons/View-map.png',
                                        height: 60,
                                        width: 60,
                                      ),
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                          Divider(
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
                                                locale: Locale.fromSubtags(),
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
                            padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(SHIPPING_CHARGE,style: TextStyle(
                                    fontFamily: 'GlobalFonts',
                                    color: BLACK,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16
                                ),),
                                Text("$CURRENCY${double.parse(orderProcessClass.orderDetails[0].deliveryCharges).toStringAsFixed(2)}",style: TextStyle(
                                    fontFamily: 'GlobalFonts',
                                    fontWeight: FontWeight.w900,
                                    color: GREY.withOpacity(0.7),
                                    fontSize: 14
                                ),)
                              ],
                            ),
                          ),
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
                      color: BLACK,
                    ),
                  ),
                  SizedBox(width: 10,),
                  Text(ORDER_DETAILS,style: TextStyle(
                      fontFamily: 'GlobalFonts',
                      color: BLACK,fontWeight: FontWeight.bold,fontSize: 23),),
                ],
              ),
            ),

            Visibility(
              visible: loading ? false : !isDelivered,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    color: WHITE,
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        children: [
                          Expanded(
                            child: FlatButton(
                              color: THEME_COLOR,
                              onPressed: (){
                                isCanceled ? null : isDelivered ? null : isPickedUp ? deliveredDialog() : pickedDialog();
                              },
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                isCanceled ? CANCELLED : isDelivered ? COMPLETED : isPickedUp ? DELIVERED : PICKED,
                                style: TextStyle(
                                    fontFamily: 'GlobalFonts',
                                    color: BLACK,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 10,),
                          Expanded(
                            child: FlatButton(
                              color: THEME_COLOR,
                              onPressed: (){
                                Navigator.pop(context);
                              },
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                CLOSED,
                                style: TextStyle(
                                    fontFamily: 'GlobalFonts',
                                    color: BLACK,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),

          ],
        ),
      ),
    );
  }

  void picked() async{
    String url = "$SERVER_ADDRESS/api/order_pick?order_id=${widget.id}";
    final response = await get(url);
    if(response.statusCode == 200){
      final jsonResponse = jsonDecode(response.body);
      if(jsonResponse['success'] == "1"){
        messageDialog(SUCCESSFUL, ORDER_HAS_BEEN_PICKED_UP_SUCCESSFULLY);
      }
    }
  }

  void orderCancel() async{
    String url = "$SERVER_ADDRESS/api/order_cancel?order_id=${widget.id}";
    final response = await get(url);
    if(response.statusCode == 200){
      final jsonResponse = jsonDecode(response.body);
      if(jsonResponse['success'] == "1"){
        messageDialog(SUCCESSFUL, ORDER_HAS_BEEN_CLOSED_SUCCESSFULLY);
      }
    }
  }

  deliverOrder() async{
    String url = "$SERVER_ADDRESS/api/order_complete?order_id=${widget.id}";
    final response = await get(url);
    if(response.statusCode == 200){
      final jsonResponse = jsonDecode(response.body);
      if(jsonResponse['success'] == "1"){
        messageDialog(SUCCESSFUL, ORDER_HAS_BEEN_DELIVERED_SUCCESSFULLY);
      }
    }
  }

  pickedDialog(){
    return showDialog(
        context: context,
        builder: (context){
          return AlertDialog(
            title: Text(PICK,style: TextStyle(
              fontFamily: 'GlobalFonts',
              color: BLACK,
              fontWeight: FontWeight.bold,
            ),),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(ARE_YOU_SURE_TO_PICK_THIS_ORDER,style: TextStyle(
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
                  color: THEME_COLOR,
                  fontWeight: FontWeight.w900,
                ),),
              ),
              FlatButton(
                onPressed: (){
                  Navigator.pop(context);
                  Toast.show(PROCESSING, context);
                  picked();
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

  closedDialog(){
    return showDialog(
        context: context,
        builder: (context){
          return AlertDialog(
            title: Text(CLOSE,style: TextStyle(
              fontFamily: 'GlobalFonts',
              color: BLACK,
              fontWeight: FontWeight.bold,
            ),),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(ARE_YOU_SURE_TO_CANCEL_THIS_ORDER,style: TextStyle(
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
                  color: THEME_COLOR,
                  fontWeight: FontWeight.w900,
                ),),
              ),
              FlatButton(
                onPressed: (){
                  Navigator.pop(context);
                  Toast.show(PROCESSING, context);
                  orderCancel();
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

  deliveredDialog(){
    return showDialog(
        context: context,
        builder: (context){
          return AlertDialog(
            title: Text(DELIVERED,style: TextStyle(
              fontFamily: 'GlobalFonts',
              color: BLACK,
              fontWeight: FontWeight.bold,
            ),),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(ARE_YOU_SURE_TO_MARK_THIS_ORDER_AS_DELIVERED,style: TextStyle(
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
                  color: THEME_COLOR,
                  fontWeight: FontWeight.w900,
                ),),
              ),
              FlatButton(
                onPressed: (){
                  Navigator.pop(context);
                  Toast.show(PROCESSING, context);
                  deliverOrder();
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

  messageDialog(String s1, String s2){
    getOrderStatus();
    return showDialog(
        context: context,
        builder: (context){
          return AlertDialog(
            title: Text(s1,style: TextStyle(
              fontFamily: 'GlobalFonts',
              color: BLACK,
              fontWeight: FontWeight.bold,
            ),),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(s2,style: TextStyle(
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
                color: THEME_COLOR,
                child: Text(OK,style: TextStyle(
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
