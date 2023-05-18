import 'package:flutter/material.dart';
import 'package:food_delivery/AllText.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../main.dart';

class OrderDetails extends StatefulWidget {
  @override
  _OrderDetailsState createState() => _OrderDetailsState();
}

class _OrderDetailsState extends State<OrderDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Row(
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
              Text(ORDER_DETAILS,style: TextStyle(
                  fontFamily: 'GlobalFonts',
                  color: BLACK,fontWeight: FontWeight.bold,fontSize: 27),),
            ],
          ),
        ],
      ),
    );
  }
}
