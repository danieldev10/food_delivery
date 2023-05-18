
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:food_delivery/AllText.dart';
import 'package:food_delivery/main.dart';
import 'package:food_delivery/views/DeliveryBoy/modals/OrderHistory.dart';
import 'package:food_delivery/views/OrderProgress.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'DeliveryBoyOrderDetails.dart';

class DeliveryBoyOrderHistory extends StatefulWidget {
  @override
  _DeliveryBoyOrderHistoryState createState() => _DeliveryBoyOrderHistoryState();
}

class _DeliveryBoyOrderHistoryState extends State<DeliveryBoyOrderHistory> {

  OrderHistory orderHistory;
  String id = "";
  bool loading = true;

  getOrderHistory() async{
    setState(() {
      loading = true;
    });
    await SharedPreferences.getInstance().then((pref){
      setState(() {
        id = pref.getString("userId");
      });
    });
    final response = await get("$SERVER_ADDRESS/api/order_history?deliverboy_id=$id");
    print(response.body);
    final jsonResponse = jsonDecode(response.body);
    orderHistory = OrderHistory.fromJson(jsonResponse);
    setState(() {
      loading = false;
    });

  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getOrderHistory();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [

            loading ? Container(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ) : Container(
              padding: EdgeInsets.fromLTRB(20, 60, 20, 0),
              child: ListView.builder(
                  itemCount: orderHistory.order.length,
                  shrinkWrap: true,
                  physics: ClampingScrollPhysics(),
                  itemBuilder: (context, index){
                    return InkWell(
                      onTap: (){
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => DeliveryBoyOrderDetails(orderHistory.order[index].orderNo.toString()))
                        );
                      },
                      child: Container(
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
                                  "$ORDER_NUMBER: "+orderHistory.order[index].orderNo.toString(),
                                  style: TextStyle(
                                    fontFamily: 'GlobalFonts',
                                    color: BLACK,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                                Text(
                                  orderHistory.order[index].date.toString(),
                                  style: TextStyle(
                                      fontFamily: 'GlobalFonts',
                                      color: GREY,
                                      fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 10,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "$CURRENCY${double.parse(orderHistory.order[index].totalAmount).toStringAsFixed(2)}",
                                  style: TextStyle(
                                      fontFamily: 'GlobalFonts',
                                      color: BLACK,
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold),),
                                Container(
                                  height: 25,
                                  width: 100,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(13),
                                      border: Border.all(color: GREY, width: 0.5)
                                  ),
                                  child: Center(
                                    child: Text(
                                      orderHistory.order[index].status.length > 9 ? orderHistory.order[index].status.substring(9) : "Process",
                                      style: TextStyle(
                                          fontFamily: 'GlobalFonts',
                                          fontSize: 12,
                                          color: GREY,
                                          fontWeight: FontWeight.w900
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                            SizedBox(height: 15,),
                            Text(orderHistory.order[index].address,style: TextStyle(
                                fontFamily: 'GlobalFonts',
                                color: GREY,
                                fontSize: 12,
                            ),),
                          ],
                        ),
                      ),
                    );
                  }),
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
                  Text(ORDER_HISTORY,style: TextStyle(
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
