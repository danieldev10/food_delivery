import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery/AllText.dart';
import 'package:food_delivery/jsonobjects/FoodDescription.dart';
import 'package:food_delivery/modals/CartItems.dart';
import 'package:food_delivery/views/CheckOutPage.dart';
import 'package:food_delivery/views/login/LoginAsCustomer.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';

class CartPage extends StatefulWidget {
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {

  CartITems cartITems = CartITems();
  List<CartITems> list = List();
  double totalPrice = 0.0;
  bool isLoggedIn = false;
  FoodDescription description = FoodDescription.defaultc();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    read();
    SharedPreferences.getInstance().then((pref){
      setState(() {
        isLoggedIn = pref.getBool("isLoggedIn") ?? false;
      });
    });
  }

  read() async{
    setState(() {
      list.clear();
      totalPrice = 0;
    });
    await cartITems.readingCart().then((value){
      setState(() {
        list.addAll(value);
      });
    });
    for(int i=0; i<list.length; i++){
      setState(() {
        totalPrice = totalPrice + double.parse(list[i].itemTotalPrice);
      });
    }
    print(list);
  }


  @override
  Widget build(BuildContext context) {

    return SafeArea(
      child: Scaffold(
        backgroundColor: BLACK,
        body: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(15, 15, 15, 0),
              child: Stack(
                children: [
                  Container(
                    margin: EdgeInsets.fromLTRB(0, 0, 0, 120),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          SizedBox(height: 50,),
                          list == []
                              ?  Container(
                            child: Center(
                              child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation(THEME_COLOR),
                              ),
                            ),
                          )
                              : ListView.builder(
                            itemCount: list.length,
                            shrinkWrap: true,
                            physics: ClampingScrollPhysics(),
                            itemBuilder: (context, index){
                              return Dismissible(
                                key: UniqueKey(),
                                background: Container(
                                  color: THEME_COLOR,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('  $REMOVE',style: TextStyle(
                                          fontFamily: 'GlobalFonts',
                                          color: BLACK,
                                          fontWeight: FontWeight.bold
                                      ),),
                                      Text('$REMOVE  ',style: TextStyle(
                                          fontFamily: 'GlobalFonts',
                                          color: BLACK,
                                          fontWeight: FontWeight.bold
                                      ),),
                                    ],
                                  ),
                                ),
                                onDismissed: (direction){
                                  print(index);
                                  cartITems.removeFromCart(list[index].itemId).then((value){
                                    Scaffold.of(context).showSnackBar(
                                      SnackBar(content: Text(REMOVED_FROM_CART,style: TextStyle(
                                        fontFamily: 'GlobalFonts',
                                        color: BLACK,
                                      ),), backgroundColor: WHITE,),
                                    );
                                    read();
                                  });
                                },
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ListTile(
                                      title: Row(
                                        crossAxisAlignment : CrossAxisAlignment.center,
                                        children: [
                                          Text(
                                            list[index].itemQty,
                                            style: TextStyle(
                                                fontFamily: 'GlobalFonts',
                                                color: WHITE,
                                                fontSize: 13,
                                                fontWeight: FontWeight.bold
                                            ),
                                          ),
                                          SizedBox(
                                            width: 8,
                                          ),
                                          Icon(
                                            Icons.clear,
                                            color: WHITE,
                                            size: 15,
                                          ),
                                          SizedBox(
                                            width: 8,
                                          ),
                                          Expanded(
                                            child: Container(
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    list[index].itemName,
                                                    style: TextStyle(
                                                      fontFamily: 'GlobalFonts',
                                                      color: WHITE,
                                                      fontSize: 14,
                                                      wordSpacing: 1.5,
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                  ),
                                                  list[index].toppings.length == 0
                                                      ? Container()
                                                      : Container(
                                                    child: Wrap(
                                                      children: List.generate(list[index].toppings.length, (i){
                                                        return Text(
                                                          "${list[index].toppings[i].toppingName}${i<list[index].toppings.length-1 ? "," : ""}",style: TextStyle(
                                                          fontFamily: 'GlobalFonts',
                                                          color: THEME_COLOR,
                                                          fontSize: 10,
                                                          fontWeight: FontWeight.bold,
                                                          //color: Colors.deepOrange.shade100
                                                        ),) ;
                                                      }),
                                                      spacing: 2,
                                                      runSpacing: 0,
                                                      alignment: WrapAlignment.start,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),

                                        ],
                                      ),
                                      leading: Container(
                                        height: 40,
                                        width: 40,
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(20),
                                            color: WHITE
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(3),
                                          child: ClipRRect(
                                              borderRadius: BorderRadius.circular(20),
                                              child: Image.network(
                                                list[index].image,
                                                height: 40,
                                                width: 40,
                                                fit: BoxFit.fill,
                                              )),
                                        ),
                                      ),
                                      trailing: Text(
                                        "$CURRENCY${double.parse(list[index].itemTotalPrice).toStringAsFixed(2)}",
                                        style: TextStyle(
                                          fontFamily: 'GlobalFonts',
                                          color: WHITE,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w900,
                                        ),
                                      ),
                                      contentPadding: EdgeInsets.all(4),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                          ListTile(
                            contentPadding: EdgeInsets.all(5),
                            leading: CircleAvatar(
                              radius: 20,
                              backgroundColor: BLACK,
                              backgroundImage: AssetImage("assets/icons/delievery-icon.png"),
                            ),
                            title: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  DELIVERY,
                                  style: TextStyle(
                                      fontFamily: 'GlobalFonts',
                                      color: WHITE,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      height: 1.5
                                  ),
                                ),
                                Text(ALL_ORDERS_FOR_HOME_DELIVERY_WILL_COST_MORE + " $CURRENCY 10.00",
                                  style: TextStyle(
                                    fontFamily: 'GlobalFonts',
                                    color: THEME_COLOR,
                                    fontSize: 10,
                                    height: 1.4,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Container(
                                    width: 130,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(4),
                                      child: LinearProgressIndicator(
                                        value: totalPrice<40 ? totalPrice/40 : 1,
                                        valueColor: AlwaysStoppedAnimation(THEME_COLOR),
                                        backgroundColor: GREY,
                                      ),
                                    )),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("$TOTAL :",style: TextStyle(
                              fontFamily: 'GlobalFonts',
                              color: WHITE,
                              fontWeight: FontWeight.bold,
                              fontSize: 18
                          ),),
                          Text("$CURRENCY${totalPrice.toStringAsFixed(2)}",style:TextStyle(
                              fontFamily: 'GlobalFonts',
                              color: WHITE,
                              fontWeight: FontWeight.bold,
                              fontSize: 30
                          ),)
                        ],
                      ),
                      SizedBox(height: 20,),
                      Row(
                        children: [
                          Expanded(
                            child: RaisedButton(
                              padding: EdgeInsets.all(13),
                              onPressed: (){
                                List<FoodDescription> fdList = List();
                                int i = 0;
                                isLoggedIn
                                    ? list.length ==0 ? showdialog() : Navigator.push(context, MaterialPageRoute(builder: (context) => CheckOutPage(totalPrice,list)))
                                    : Navigator.push(context, MaterialPageRoute(builder: (context) => LoginAsCustomer()));
                              },
                              color: THEME_COLOR,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25),
                              ),
                              child: Text(isLoggedIn ? CHECKOUT : LOGIN_TO_PROCEED,
                                style: TextStyle(
                                    fontFamily: 'GlobalFonts',
                                    color: BLACK,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w900
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10,),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              color: BLACK,
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
                      color: WHITE,
                    ),
                  ),
                  SizedBox(width: 10,),
                  Text(CART,style: TextStyle(
                      fontFamily: 'GlobalFonts',
                      color: WHITE,fontWeight: FontWeight.bold,fontSize: 23),),
                ],
              ),
            ),
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
            title: Text(EMPTY_CART,style: TextStyle(
              fontFamily: 'GlobalFonts',
              color: BLACK,
              fontWeight: FontWeight.bold,
            ),),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(IN_ORDER_TO_PROCEED_YOU_NEED_TO_ADD_ITEMS_IN_CART,style: TextStyle(
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
                child: Text(OK,style: TextStyle(
                  fontFamily: 'GlobalFonts',
                  color: THEME_COLOR,
                  fontWeight: FontWeight.w900,
                  //color: Colors.deepOrange.shade200,
                ),),
              ),
            ],
          );
        }
    );
  }


}
