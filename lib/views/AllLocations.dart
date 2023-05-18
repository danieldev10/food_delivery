import 'package:flutter/material.dart';
import 'package:food_delivery/AllText.dart';
import 'package:food_delivery/modals/AddedLocations.dart';
import 'package:food_delivery/modals/CartItems.dart';
import 'package:food_delivery/views/ChooseLocation.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:toast/toast.dart';

import '../main.dart';

class AllLocations extends StatefulWidget {

  @override
  _AllLocationsState createState() => _AllLocationsState();
}

class _AllLocationsState extends State<AllLocations> {

  AddedLocations addedLocations = AddedLocations();
  List<AddedLocations> list = List();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    read();
  }

  read() async{
    setState(() {
      list.clear();
    });
    await addedLocations.readingDatabase().then((value){
      setState(() {
        list.addAll(value);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 50,),
                    Row(
                      children: [
                        Expanded(
                          child: TextButton(
                            onPressed: () async{
                              bool refresh = false;
                              refresh = await Navigator.push(context,
                                MaterialPageRoute(builder: (context) => ChooseLocation()),
                              );
                              if(refresh){
                                read();
                                //Toast.show("Needs Refresh", context);
                              }
                            },
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Icon(Icons.add, size: 20, color: Colors.black,),
                                  Text(' $ADD_ADDRESS',
                            style: TextStyle(
                                fontFamily: 'GlobalFonts',
                                color: BLACK,
                                  fontWeight: FontWeight.bold,
                            ),),
                                ],
                              ),
                          ),
                        ),
                      ],
                    ),
                    Divider(
                      height: 10,
                      thickness: 1,
                    ),
                    addedLocations == null
                        ? Container()
                        : ListView.builder(
                      itemCount: list.length,
                      shrinkWrap: true,
                      physics: ClampingScrollPhysics(),
                      itemBuilder: (context, index){
                        return Column(
                          children: [
                            SizedBox(height: 15,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: InkWell(
                                    onTap : (){
                                      Navigator.pop(context,list[index]);
                                    },
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(list[index].type,
                                          style: TextStyle(
                                            fontFamily: 'GlobalFonts',
                                            color: BLACK,
                                              fontWeight: FontWeight.bold,
                                            fontSize: 20,
                                          ),),
                                        SizedBox(height: 5,),
                                        Container(
                                          child: Text(list[index].addressLine,
                                            style: TextStyle(
                                              fontFamily: 'GlobalFonts',
                                                fontWeight: FontWeight.bold,
                                                color: GREY,
                                              fontSize: 12,
                                            ),),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                IconButton(
                                    icon: Image.asset('assets/icons/delete.png',height: 21, width: 21, color: BLACK,),
                                    onPressed: (){
                                      addedLocations.removeFromFavourites(list[index].lat+list[index].long)
                                      .then((value){
                                        read();
                                      });
                                    })
                              ],
                            ),
                            Divider(
                              height: 35,
                              thickness: 1,
                            ),
                          ],
                        );
                      },
                    ),
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
                  Text(MY_ADDRESS,style: TextStyle(
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
