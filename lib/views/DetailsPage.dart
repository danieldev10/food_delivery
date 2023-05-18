
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery/AllText.dart';
import 'package:food_delivery/main.dart';
import 'package:food_delivery/modals/CartItems.dart';
import 'package:food_delivery/modals/DetailsPageClass.dart';
import 'package:food_delivery/modals/Favourite.dart';
import 'package:food_delivery/modals/Toppings.dart';
import 'package:food_delivery/views/CartPage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'dart:convert' as convert;

import 'package:share/share.dart';
import 'package:toast/toast.dart';

class DetailsPage extends StatefulWidget {

  String name;
  String image;
  String price;
  String description;
  int id;


  DetailsPage(this.name, this.image, this.price, this.description, this.id);

  @override
  _DetailsPageState createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {

  List<bool> options = List<bool>();
  List<Toppings> toppingData = List<Toppings>();
  List<Toppings> toppingTitle = List<Toppings>();
  bool isLoadingToppings = true;
  int titleLength = 0;
  List<int> toppingLength = List<int>();
  int quantity = 1;
  double actualPrice;
  bool downloadingError = false;
  double _progress = 0.0;
  String imagePath = "";
  Favourites favourites = Favourites();
  bool isLiked = false;
  CartITems cartITems = CartITems();
  List<Toppings> addedToppings = List();
  DetailsPageClass detailsPageClass;
  bool isDeleted = false;
  bool isLoading = true;

  fetchToppings() async{
    toppingData.clear();
    toppingTitle.clear();
    isLoadingToppings = true;
    print(widget.id);
    String url = "$SERVER_ADDRESS/api/gettopping?menu_id=${widget.id}";
    var response = await http.get(url);
    if(response.statusCode == 200){
      final jsonRespone = convert.jsonDecode(response.body);
      if(response.body != null){
        var jsonResponse = convert.jsonDecode(response.body);
        setState(() {
          titleLength = jsonResponse['data'].length;
        });
        for(int i=0; i<jsonResponse['data'].length; i++){
          setState(() {
            toppingTitle.add(Toppings.title(jsonResponse['data'][i]['name']));
            toppingLength.add(jsonResponse['data'][i]['topping'].length);
          });
          for(int j=0; j<jsonResponse['data'][i]['topping'].length; j++){
            toppingData.add(Toppings(
              jsonResponse['data'][i]['topping'][j]['id'].toString(),
              jsonResponse['data'][i]['topping'][j]['top_cat_id'].toString(),
              jsonResponse['data'][i]['topping'][j]['name'],
              jsonResponse['data'][i]['topping'][j]['price'],
            ),);
            //print(toppingData[j].toppingName);
            options.add(false);
          }
        }
        setState(() {
          isLoadingToppings = false;
        });
        for(int i=0; i<toppingData.length; i++){
          print(toppingData[i].toppingName);
        }
        print(jsonResponse['data'][0]['topping'].length);
      }
      else{
        print("\n\n\nError : $isDeleted\n\n\n");
      }
    }
  }

  fetchItemDetails() async{
    setState(() {
      isLoading = true;
    });
    final response = await http.get("$SERVER_ADDRESS/api/viewitem/${widget.id}");
    final jsonResponse = convert.jsonDecode(response.body);

    print(response.body);

    if(response.statusCode == 200 && jsonResponse["success"] == "1"){
      detailsPageClass = DetailsPageClass.fromJson(jsonResponse);
      if(detailsPageClass.success == "1"){
        setState(() {
          widget.name = detailsPageClass.order.menuName;
          widget.image = detailsPageClass.order.menuImage;
          widget.price = detailsPageClass.order.price;
          widget.description = detailsPageClass.order.description;
          isLoading = false;
          isDeleted = false;
        });
        actualPrice = double.parse(widget.price);
        fetchToppings();
        chkFavourite();
        downloadImage();
      }

    }
    else{
      setState(() {
        isDeleted = true;
        isLoading = false;
      });
    }

  }

  // fetchOrderDetails() async{
  //   final response = await http.get("https://freaktemplate.com/fooddelivery_app/api/subcategory?category=${widget.id}");
  //   if(response.statusCode == 200){
  //     final jsonResponse = convert.jsonDecode(response.body);
  //     detailsPageClass = DetailsPageClass.fromJson(jsonResponse);
  //     if(detailsPageClass.success == "1"){
  //
  //     }
  //   }
  // }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchItemDetails();
  }

  chkFavourite() async{
    await favourites.chkIfAlreadyInDatabase(widget.id)
        .then((value){
      setState(() {
        isLiked = value;
      });
    });
  }


  downloadImage() async{
    //downloadingError ? null :Toast.show("Loading...", context, duration: 2);
    try{
      setState(() {
        downloadingError = false;
      });
      String dir = (await getExternalStorageDirectory()).path + "/shareimage" +".png";
      print("path is: $dir");
      setState(() {
        imagePath = dir;
      });
      File file = File(dir);
      await Dio().download(widget.image.replaceAll("\\", ""), dir,onReceiveProgress: showDownloadProgress);
    }catch(e){
      setState(() {
        downloadingError = true;
      });
      Toast.show("Slow internet connection", context,duration: 1);
    }
  }

  showDownloadProgress(received, total){
    if(total != -1){
      var percentage = (received/total * 100);
      if(percentage < 100){
        setState(() {
          _progress = percentage;
          //print(_progress);
        });
      }else {
        setState(() {
          _progress = percentage;
        });
        print("Downloaded Successfully");
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? Center(
        child: CircularProgressIndicator(),
      )
          : Stack(
        children: [
          SafeArea(
            child: isDeleted
                ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("!",
                    style: TextStyle(
                        fontFamily: 'GlobalFonts',
                        color: BLACK,
                        fontSize: 150
                    ),
                  ),
                  Text(REQUESTED_ITEM_NOT_AVAILABLE,
                      style: TextStyle(
                        fontFamily: 'GlobalFonts',
                        color: BLACK,
                      )
                  ),
                ],
              ),
            )
                : Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Column(
                children: [
                  Container(
                    //height: 275,
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            InkWell(
                                onTap: (){
                                  Navigator.pop(context);
                                },
                                child: Image.asset("assets/detailsPageIcons/back.png", height: 15, width: 15, fit: BoxFit.contain, color: BLACK,)),
                            InkWell(
                                onTap: (){
                                  imagePath == null
                                      ? downloadImage()
                                      : Share.shareFiles([imagePath], text: widget.name + "\n\nThis part will contain application download link");
                                },
                                child: Image.asset("assets/detailsPageIcons/menu-res.png", height: 15, width: 15, fit: BoxFit.contain, color: BLACK,)),
                          ],
                        ),
                        Container(
                          margin: EdgeInsets.fromLTRB(0, 20, 0, 20),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: CachedNetworkImage(
                              imageUrl : widget.image.replaceAll("\\", ""),
                              height: 200,
                              placeholder: (context, url) => Icon(Icons.image, color: LIGHT_GREY,),
                              errorWidget: (context, url, error) => Icon(Icons.error),
                              width: MediaQuery.of(context).size.width -50,
                              fit: BoxFit.cover,),
                          ),
                        ),
                        SizedBox(height: 40,),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.fromLTRB(0, 0, 0, 60),
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(widget.name,
                                    style: TextStyle(
                                      fontFamily: 'GlobalFonts',
                                      color: BLACK,
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  height: 40,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(color: GREY.withOpacity(0.5), width: 1)
                                  ),
                                  child: Row(
                                    children: [
                                      IconButton(
                                          padding: EdgeInsets.zero,
                                          icon: Image.asset(
                                            "assets/detailsPageIcons/Minus.png",
                                            height: 12,
                                            width: 12,
                                            fit: BoxFit.contain,
                                            color: BLACK,
                                          ),
                                          onPressed:() {
                                            setState(() {
                                              if(quantity > 1) {
                                                quantity -= 1;
                                                widget.price =  (double.parse(widget.price) - double.parse(widget.price)/(quantity+1)).toString();
                                              }
                                            });
                                          }),
                                      Text(quantity.toString(),
                                        style: TextStyle(
                                          fontFamily: 'GlobalFonts',
                                          color: BLACK,
                                          fontSize: 17,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      IconButton(
                                          padding: EdgeInsets.zero,
                                          icon: Image.asset(
                                            "assets/detailsPageIcons/Plus.png",
                                            height: 12,
                                            width: 12,
                                            fit: BoxFit.contain,
                                            color: BLACK,
                                          ),
                                          onPressed:() {
                                            setState(() {
                                              quantity+=1;
                                              widget.price =  (double.parse(widget.price) + double.parse(widget.price)/(quantity-1)).toString();
                                            });
                                          }),
                                    ],
                                  ),
                                ),
                                Text("$CURRENCY${double.parse(widget.price).toStringAsFixed(2)}",
                                  style: TextStyle(
                                    fontFamily: 'GlobalFonts',
                                    color: BLACK,
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Text(widget.description,
                              style: TextStyle(
                                  fontFamily: 'GlobalFonts',
                                  color: GREY,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  height: 1.5
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Visibility(
                              visible: isLoadingToppings,
                              child: Row(
                                children: [
                                  Text(EXTRA_CHOOSE_A_TOPPING,
                                    style:TextStyle(
                                      fontFamily: 'GlobalFonts',
                                      color: BLACK,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ) ,
                            SizedBox(
                              height: 20,
                            ),
                            !isLoadingToppings
                                ? SingleChildScrollView(
                              child: Column(
                                children: List.generate(titleLength, (i){
                                  return Column(
                                    children: [
                                      Row(
                                        children: [
                                          Text(toppingTitle[i].title,
                                            style: TextStyle(
                                              fontFamily: 'GlobalFonts',
                                              color: BLACK,
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Container(
                                        child: GridView.count(
                                          shrinkWrap: true,
                                          physics: ClampingScrollPhysics(),
                                          crossAxisCount: 2,
                                          childAspectRatio: 3,
                                          crossAxisSpacing: 5,
                                          mainAxisSpacing: 10,
                                          children: List.generate( toppingLength[i], (index){
                                            //print(toppingData[index+(i==0?0:toppingLength[i-1])].toppingName);
                                            int toppingIndex = 0;
                                            for(int x=0; x<i; x++){
                                              toppingIndex = toppingIndex + toppingLength[x];
                                            }
                                            return optionsMenu(toppingData[index+toppingIndex].toppingName, index + toppingIndex);
                                          }),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                    ],
                                  );
                                }),
                              ),
                            )
                                : Container(child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation(THEME_COLOR),
                            ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          isDeleted
              ? Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 60,
              color: WHITE,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
                child: Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () async{
                          await favourites.removeFromFavourites(widget.id);
                          Navigator.pop(context, true);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: THEME_COLOR,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Center(
                            child: Text(REMOVE_FROM_FAVOURITES,
                              style: TextStyle(
                                fontFamily: 'GlobalFonts',
                                color: BLACK,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
              : Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 60,
              color: WHITE,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
                child: Row(
                  children: [
                    InkWell(
                        onTap: (){
                          isLiked
                              ? favourites.removeFromFavourites(widget.id).then((value){
                            setState(() {
                              isLiked = value;
                            });
                          })
                              : favourites.addToDataBase(Favourites.constuctor(widget.id, widget.name, widget.price,widget.image,widget.description),)
                              .then((value){
                            Toast.show(ADDED_TO_FAVOURITES, context,duration: 1);
                            setState(() {
                              isLiked = value;
                            });
                          });
                        },
                        child: isLiked
                            ? Image.asset("assets/detailsPageIcons/Like.png",color: DEEP_ORANGE_COLOR)
                            : Image.asset("assets/detailsPageIcons/Like.png")
                    ),
                    SizedBox(width: 10,),
                    Expanded(
                      child: InkWell(
                        onTap: (){
                          String toppingString = "";
                          // for(int i=0; i<addedToppings.length; i++) {
                          //   toppingString = toppingString + addedToppings[i].toppingName + "*";
                          // }
                          print(toppingString);
                          showdialog(false);
                          cartITems.addToCart(
                              CartITems.constructor(
                                quantity.toString(),
                                widget.name,
                                widget.price,
                                widget.image.replaceAll("\\", ""),
                                addedToppings,
                                actualPrice.toString(),
                                widget.id.toString(),
                              )
                          ).then((value){

                            Navigator.pop(context);
                            showdialog(true);
                            //Toast.show('Added to cart', context, duration: 2);
                          });

                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: THEME_COLOR,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Center(
                            child: Text(ADD_TO_CART,
                              style: TextStyle(
                                fontFamily: 'GlobalFonts',
                                color: BLACK,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  optionsMenu(String option,int index){
    return InkWell(
      onTap: (){
        setState(() {
          options[index] = !options[index];
          if(options[index]) {
            addedToppings.add(Toppings(
              toppingData[index].id,
              toppingData[index].top_cat_id,
              toppingData[index].toppingName,
              toppingData[index].toppingPrice,
            ));
            print('added\n $addedToppings');
            for(int i=0; i<addedToppings.length; i++){
              print(addedToppings[i].toppingName);
            }
          }
          else {
            print(addedToppings.length);
            print("index : $index");
            for(int i=0; i<addedToppings.length; i++){
              if(addedToppings[i].id == toppingData[index].id){
                addedToppings.removeAt(i);
                print('removed');
              }
            }
          }
          options[index]
              ? widget.price =  (double.parse(widget.price) + (quantity*double.parse(toppingData[index].toppingPrice))).toString()
              : widget.price =  (double.parse(widget.price) - (quantity*double.parse(toppingData[index].toppingPrice))).toString();
        });
      },
      borderRadius: BorderRadius.circular(20),
      child: Container(
        height: 30,
        margin: EdgeInsets.fromLTRB(0, 0, 10, 0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          border: Border.all(color: GREY.withOpacity(0.5), width: 1),
        ),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(width: 15,),
              Image.asset(
                !options[index]
                    ? "assets/detailsPageIcons/radio.png"
                    : "assets/detailsPageIcons/radio_active.png" ,height: 15, width: 15, fit: BoxFit.contain, color: DEEP_ORANGE_COLOR,),
              SizedBox(width: 5,),
              Text(
                option,
                style: TextStyle(
                    fontFamily: 'GlobalFonts',
                    color: BLACK,
                    fontSize: 12
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  showdialog(bool isAdded){
    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context){
          return WillPopScope(
            onWillPop: (){},
            child: AlertDialog(
              title: Text(isAdded ? ADDED : PROCESSING,style: TextStyle(
                fontFamily: 'GlobalFonts',
                color: BLACK,
                fontWeight: FontWeight.bold,
              ),),
              content: isAdded
                  ? Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('$quantity ${widget.name}, $SUCCESSFULLY_ADDED_TO_CART_FOR_PRICE $CURRENCY${widget.price}'
                      ' $CLICK_CHECKOUT_TO_GO_TO_CART',style: TextStyle(
                    fontFamily: 'GlobalFonts',
                    color: BLACK,
                    fontSize: 15,
                  ),)
                ],
              )
                  : Container(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
              actions: isAdded ? [
                FlatButton(
                  onPressed: (){
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                  child: Text(ADD_MORE,style: TextStyle(
                    fontFamily: 'GlobalFonts',
                    color: THEME_COLOR,
                    fontWeight: FontWeight.w900,
                  ),),
                ),
                FlatButton(
                  onPressed: (){
                    Navigator.pop(context);
                    Navigator.pop(context);
                    Navigator.push(context, MaterialPageRoute(builder: (context) => CartPage()));
                  },
                  color: THEME_COLOR,
                  child: Text(CHECKOUT,style: TextStyle(
                    fontFamily: 'GlobalFonts',
                    color: BLACK,
                    fontWeight: FontWeight.w900,
                  ),),
                ),
              ] : null,
            ),
          );
        }
    );
  }
}
