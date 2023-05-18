import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:food_delivery/main.dart';
import 'package:food_delivery/modals/CartItems.dart';
import 'package:food_delivery/modals/Categories.dart';
import 'package:food_delivery/modals/SelectedCategory.dart';
import 'package:food_delivery/modals/Toppings.dart';
import 'package:food_delivery/notificationHelper.dart';
import 'package:food_delivery/views/CartPage.dart';
import 'package:food_delivery/views/DetailsPage.dart';
import 'package:food_delivery/views/SideMenu.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:toast/toast.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

import '../AllText.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin{

  int selectedItemIndex = 0;
  List<bool> isSelected = List<bool>();
  AnimationController controller;
  Animation<Offset> slideAnimation;
  bool isDrawerOpen = false;
  List<Categories> categories = List<Categories>();
  List<SubCategory> selectedCat = List<SubCategory>();
  bool isCategoryLoaded = false;
  bool isSelectedCategoryLoaded = false;
  int categoryLength = 0;
  CartITems cartITems = CartITems();
  int totalCartItems = 0;
  String cartImage1 = "";
  String cartImage2 = "";
  String cartImage3 = "";
  List<Future> categoriesImage = List();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //controller = AnimationController(vsync: this, duration: Duration(seconds: 1));
    //slideAnimation = Tween<Offset>(begin: Offset(100,100), end: Offset(0,0)).animate(controller);
    fetchCategory();
    categorySelected(1);
    readCart();
    getMessages();
  }

  void getMessages(){
    FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
    print(_firebaseMessaging.getToken());
    NotificationHelper notificationHelper;
    _firebaseMessaging.configure(
      onMessage: (msg) async{
        print('On Message : $msg'); // here gets notification msg
        setState(() {
          //message = msg["notification"]['title'];
          if(Platform.isAndroid) {
            notificationHelper = NotificationHelper(
                msg["notification"]['title'], msg["notification"]['body'], null,
                NOTIFICATION_ID);
            // in andriod did we set deep linking?? yes it was here  in this method. did you removed some code ?
            // no i did not remove, but as new code was not installin in ios, i m using old code. OO ohk ohk. no worries we have code for that
            notificationHelper.initialize();
          }else if(Platform.isIOS){
            print( msg["aps"]['alert']['title']);
           notificationHelper = NotificationHelper(
                msg["aps"]['alert']['title'], msg["aps"]['alert']['body'], null,
                NOTIFICATION_ID);
            notificationHelper.initialize();
          }
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

  readCart() async{
    List<CartITems> list = List();
    await cartITems.readingCart().then((value){
      setState(() {
        cartImage1 = "";
        cartImage2 = "";
        cartImage3 = "";
        list.addAll(value);
        totalCartItems = list.length;
        if(list.length != 0) {
          cartImage1 = list.length > 0 ? list[0].image : "";
          cartImage2 = list.length > 1 ? list[1].image : "";
          cartImage3 = list.length > 2 ? list[2].image :"";
          //cartImage2 = list[1].image;
        }
      });
    });
  }

  fetchCategory() async{
    String url = "$SERVER_ADDRESS/api/menu_category";
    var response = await http.get(url);
    if(response.statusCode == 200){
      if(response.body != null) {
        var jsonResponse = convert.jsonDecode(response.body);
        setState(() {
          categoryLength = jsonResponse['menu_category'].length;
        });
        for (int i = 0; i < jsonResponse['menu_category'].length; i++) {
          categories.add(Categories(
              jsonResponse['menu_category'][i]['id'],
              jsonResponse['menu_category'][i]['cat_icon'],
              jsonResponse['menu_category'][i]['cat_name']));
        }
        setState(() {
          isCategoryLoaded = true;
        });
      }
      makeListEmpty();
    }
  }

  categorySelected(int category) async{
    setState(() {
      selectedCat.clear();
      isSelectedCategoryLoaded = false;
    });
    String url = "$SERVER_ADDRESS/api/subcategory?category=$category";
    var response = await http.get(url);
    if(response.statusCode == 200){
      if(response.body != null) {
        var jsonResponse = convert.jsonDecode(response.body);
        for (int i = 0; i < jsonResponse['subcategory'].length; i++) {
          selectedCat.add(SubCategory(
            jsonResponse['subcategory'][i]['id'],
            jsonResponse['subcategory'][i]['category'],
            jsonResponse['subcategory'][i]['menu_image'],
            jsonResponse['subcategory'][i]['menu_name'],
            jsonResponse['subcategory'][i]['price'],
            jsonResponse['subcategory'][i]['description'],
          ));
        }
        setState(() {
          isSelectedCategoryLoaded = true;
        });
      }
    }
  }

  Future<void> makeListEmpty() async{
    for(int i=0; i< categoryLength; i++) {
      isSelected.add(false);
    }
    setState(() {
      isSelected[0] = !isSelected[0];
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    //controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    readCart();
    return Scaffold(
      backgroundColor: BLACK,
      body: SafeArea(
        child: Builder(
          builder: (context){
            return Stack(
              children: [
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    color: BLACK,
                    height: 50,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              CART,
                              style: TextStyle(
                                fontFamily: 'GlobalFonts',
                                color: WHITE,
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Row(
                              children: [
                                cartImage1 == ""
                                    ? Container()
                                    : Container(
                                  height: 40,
                                  width: 40,
                                  decoration: BoxDecoration(
                                    color: LIGHT_GREY,
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  child: Center(
                                    child: Padding(
                                      padding: const EdgeInsets.all(3),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(20),
                                        child: CachedNetworkImage(
                                          imageUrl: cartImage1,
                                          height: 40,
                                          width: 40,
                                          placeholder: (context, url) => Icon(Icons.image, color: LIGHT_GREY,size: 35,),
                                          errorWidget: (context, url, error) => Icon(Icons.error, color: LIGHT_GREY,size: 35,),
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                    ),
                                  ),
                                ) ,
                                SizedBox(width: 5,),
                                cartImage2 == ""
                                    ? Container()
                                    : Container(
                                  height: 40,
                                  width: 40,
                                  decoration: BoxDecoration(
                                    color: LIGHT_GREY,
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  child: Center(
                                    child: Padding(
                                      padding: const EdgeInsets.all(3),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(20),
                                        child: CachedNetworkImage(
                                          imageUrl: cartImage2,
                                          height: 40,
                                          width: 40,
                                          placeholder: (context, url) => Icon(Icons.image, color: LIGHT_GREY,size: 35,),
                                          errorWidget: (context, url, error) => Icon(Icons.error, color: LIGHT_GREY,size: 35,),
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                    ),
                                  ),
                                ) ,
                                SizedBox(width: 5,),
                                cartImage3 == ""
                                    ? Container()
                                    : Container(
                                  height: 40,
                                  width: 40,
                                  decoration: BoxDecoration(
                                    color: LIGHT_GREY,
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  child: Center(
                                    child: Padding(
                                      padding: const EdgeInsets.all(3),
                                      child: ClipRRect(
                                          borderRadius: BorderRadius.circular(20),
                                          child: CachedNetworkImage(
                                            imageUrl: cartImage3,
                                            height: 40,
                                            width: 40,
                                            placeholder: (context, url) => Icon(Icons.image, color: LIGHT_GREY,size: 35,),
                                            errorWidget: (context, url, error) => Icon(Icons.error, color: LIGHT_GREY,size: 35,),
                                            fit: BoxFit.fill,
                                          )
                                      ),
                                    ),
                                  ),
                                ) ,
                              ],
                            ),
                            Row(
                              children: [
                                Container(
                                  height: 40,
                                  width: 40,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: THEME_COLOR,
                                  ),
                                  child: Center(
                                    child: Text(
                                      totalCartItems.toString(),
                                      style: TextStyle(
                                        fontFamily: 'GlobalFonts',
                                        fontWeight: FontWeight.w900,
                                        color: BLACK,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 5,),
                                InkWell(
                                  onTap: () async{
                                    Navigator.push(context,
                                        MaterialPageRoute(builder: (context) => CartPage())
                                    );
                                    //readCart();
                                  },
                                  child: Container(
                                    height: 40,
                                    width: 40,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: THEME_COLOR,
                                    ),
                                    child: Center(
                                      child: Icon(
                                        Icons.arrow_forward_ios,
                                        color: BLACK,
                                        size: 17,
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                categories.length == 0 ? Container(
                  color: WHITE,
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                ) :Container(
                  height: MediaQuery.of(context).size.height - (Platform.isIOS ? 130 : 90),
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      color: WHITE,
                      borderRadius: BorderRadius.only(bottomLeft: Radius.circular(25), bottomRight: Radius.circular(25))
                  ),
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          SizedBox(height: 65,),
                          Text(
                            FOOD,
                            style: TextStyle(
                                fontFamily: 'GlobalFonts',
                                fontSize: 35,
                                fontWeight: FontWeight.w900
                            ),
                          ),
                          Text(
                            EXPLORER,
                            style: TextStyle(
                                fontFamily: 'GlobalFonts',
                                fontSize: 40,
                                color: GREY
                            ),
                          ),
                          SizedBox(height: 15,),
                          Container(
                            height: 110,
                            child: ListView.builder(
                              itemCount: categories.length,
                              shrinkWrap: true,
                              physics: ClampingScrollPhysics(),
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, index){
                                return category(categories[index].cat_icon.replaceAll("\\",""), categories[index].cat_name, index, categories[index].id);
                              },
                            ),
                          ),
                          SizedBox(height: 15,),
                          Text(
                            POPULAR,
                            style: TextStyle(
                                fontFamily: 'GlobalFonts',
                                fontSize: 15,
                                color: BLACK,
                                fontWeight: FontWeight.w600
                            ),
                          ),
                          SizedBox(height: 5,),
                          selectedCat.length == 0
                              ? Container(
                            height: 150,
                            width: 150,
                            child: Padding(
                              padding: const EdgeInsets.all(80),
                              child: Center(
                                  child: FlareActor(
                                    "assets/Flare/loading.flr",
                                    fit: BoxFit.contain,
                                    animation: "loading",
                                  )
                              ),
                            ),
                          )
                              :GridView.count(
                            crossAxisCount: 2,
                            crossAxisSpacing: 2,
                            mainAxisSpacing: 5,
                            shrinkWrap: true,
                            childAspectRatio: 0.8,
                            physics: ClampingScrollPhysics(),
                            children: List.generate(selectedCat.length, (index){
                              return subCategoryCard(
                                selectedCat[index].id,
                                selectedCat[index].menu_name,
                                selectedCat[index].menu_image,
                                selectedCat[index].price,
                                selectedCat[index].description,
                              );
                            }),
                          )
                        ],
                      ),
                    ),),
                ),
                Container(
                  color: WHITE,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          child: Image.asset(
                            "assets/icons/menu.png",
                            width: 25,
                            height: 15,
                            color: BLACK,
                            fit: BoxFit.contain,
                          ),
                          onTap: (){
                            Scaffold.of(context).openDrawer();
                          },
                        ),
                        Row(
                          children: [
                            Visibility(
                              child: Image.asset(
                                "assets/icons/search.png",
                                height: 18,
                                width: 18,
                                fit: BoxFit.contain,
                              ),
                              visible: false,
                            ),
                            SizedBox(width: 15,),
                            CircleAvatar(
                              radius: 20,
                              backgroundColor: THEME_COLOR,
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: BLACK,
                                ),
                                child: Icon(Icons.account_circle, size: 25,color: THEME_COLOR,),
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
      drawer: Container(
          child: SideMenu()
      ),
    );
  }

  closeDrawer(BuildContext context){
    Scaffold.of(context).openEndDrawer();
  }

  Widget subCategoryCard(int id, String name, String image, String price, String description) {
    return InkWell(
      onTap: (){
        Navigator.push(context,
          MaterialPageRoute(
            builder: (context) => DetailsPage("", "", "", "", id),
          ),
        );
      },
      child: Card(
        color: LIGHT_GREY,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Container(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: CachedNetworkImage(
                        imageUrl: image.replaceAll("\\", ""),
                        fit: BoxFit.fill,
                        width: 200,
                        placeholder: (context, url) => Container(
                            color: WHITE,
                            child: Center(child: Icon(Icons.image, color: LIGHT_GREY,size: 35,))),
                        errorWidget: (context, url, error) => Container(
                            color: WHITE,
                            child: Center(child: Icon(Icons.error, color: LIGHT_GREY,size: 35,))),
                      ),
                    ),
                  ),
                  SizedBox(height: 15,),
                  Text(
                    "$CURRENCY${double.parse(price).toStringAsFixed(2)}",
                    style: TextStyle(
                        fontFamily: 'GlobalFonts',
                        fontSize: 24,
                        color: BLACK,
                        fontWeight: FontWeight.w800
                    ),
                  ),
                  SizedBox(height: 5,),
                  Text(
                    name,
                    style: TextStyle(
                        fontFamily: 'GlobalFonts',
                        color: BLACK,
                        fontSize: 12,
                        fontWeight: FontWeight.w900
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget category(String imagePath, String name, int index, int id){



    return isCategoryLoaded
        ? InkWell(
      onTap: (){
        setState(() {
          isSelected[selectedItemIndex] = false;
          selectedItemIndex = index;
          isSelected[index] = !isSelected[index];
          categorySelected(id);
        });
      },
      child: Container(
        margin: EdgeInsets.all(5),
        child: Stack(
          children: [
            Center(
              child: Image.asset(
                isSelected[index] ? "assets/icons/active.png" :"assets/icons/un_active.png",
                height: 120,
                width: 70,
                //color: isSelected[index] ? THEME_COLOR : Colors.transparent,
              ),
            ),
            Container(
              height: 120,
              width: 70,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CachedNetworkImage(
                      imageUrl: imagePath,
                      height: 25,
                      width: 25,
                      placeholder: (context, url) => Icon(Icons.image, color: LIGHT_GREY,),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        name,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontFamily: 'GlobalFonts',
                            color: BLACK,
                            fontSize: 11,
                            fontWeight: FontWeight.w900
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    )
        : CircularProgressIndicator();
  }

}
