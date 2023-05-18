
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:food_delivery/AllText.dart';
import 'package:food_delivery/modals/AddedLocations.dart';
import 'package:food_delivery/modals/CartItems.dart';
import 'package:food_delivery/views/AllLocations.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hive/hive.dart';
import 'package:search_map_place/search_map_place.dart';
import 'package:toast/toast.dart';
import 'package:geolocator/geolocator.dart' as geo;

import '../main.dart';


class ChooseLocation extends StatefulWidget {

  @override
  _ChooseLocationState createState() => _ChooseLocationState();
}

class _ChooseLocationState extends State<ChooseLocation> {

  GoogleMapController mapController;
  final Map<String, Marker> _markers = {};
  String addressLine = "";
  String error = "";
  LatLng _center;
  AddedLocations addedLocations = AddedLocations();

  bool isHome = true;
  bool isWork = false;
  bool isOffice = false;
  bool isOther = false;
  String type = HOME;
  String lati = "";
  String longi = "";



  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  addLocationToDatabase() async {
    Toast.show(ADDING, context, duration: 2);
    if(addressLine != "") {
      await addedLocations.addToDataBase(
          AddedLocations.constructor(type, addressLine, lati, longi));
      Navigator.pop(context, true);
      Toast.show(LOCATION_ADDED_SUCCESSFULLY, context, duration: 2);
    }else {
      //_getLocationStart();
      //addLocationToDatabase();
      _getLocationStart();
      Toast.show(UNABLE_TO_GET_LOCATION, context, duration: 2);
    }

  }
  
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //_getLocation(LatLng(31.11114, 70.22222));
    _getLocationStart();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _center != null  
          ? SafeArea(
            child: Stack(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height/2+100,
                  child: GoogleMap(
                    onMapCreated: _onMapCreated,
                    initialCameraPosition: CameraPosition(
                      target: _center,
                      zoom: 15.0,
                    ),
                    onTap: (latLang){
                      //Toast.show(latLang.toString(), context,duration: 2);
                      setState(() {
                        _getLocation(latLang);
                      });
                    },
                    buildingsEnabled: true,
                    compassEnabled: true,
                    markers: _markers.values.toSet(),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // IconButton(icon: Icon(Icons.arrow_back_ios ,size: 15,),
                    //     onPressed: (){
                    //   Navigator.pop(context,false);
                    // }),
                    Expanded(
                      child: SearchMapPlaceWidget(
                        apiKey: MAP_API_KEY,
                        icon: null,
                        onSearch: (places){
                          print(places);
                        },
                      ),
                    ),
                  ],
                ),
                sheeet(),
              ],
            ),
          ) 
          : Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation(THEME_COLOR),
        ),
      ),

      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.my_location),
        backgroundColor: THEME_COLOR,
        onPressed: (){
          _getLocationStart();
        },
      ),
    );
  }

  sheeet(){
    return DraggableScrollableSheet(
      initialChildSize: 0.5,
        minChildSize: 0.4,
        maxChildSize: 0.7,
        builder:(context,scrollController){
          return Container(
            decoration: BoxDecoration(
              color: WHITE,
              borderRadius: BorderRadius.only(topRight: Radius.circular(15), topLeft: Radius.circular(15))
            ),
            height: MediaQuery.of(context).size.height/2 - 30,
            child: SingleChildScrollView(
              controller: scrollController,
              child: Padding(
                padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: 4,
                          width: 80,
                          decoration: BoxDecoration(
                            color: LIGHT_GREY,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: 20,),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(ADDRESS,
                          style: TextStyle(
                            fontFamily: 'GlobalFonts',
                            color: GREY,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),),
                        SizedBox(height: 5,),
                        Container(
                          child: Text(addressLine == "" ? LOADING : addressLine,
                            style: TextStyle(
                              fontFamily: 'GlobalFonts',
                              color: BLACK,
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),),
                        ),
                        Divider(
                          height: 20,
                          color: GREY,
                        ),
                      ],
                    ),
                    Container(
                      child: TextField(
                        decoration: InputDecoration(
                          border: UnderlineInputBorder(),
                          labelText: FLOOR_TOWER,
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: GREY),
                          ),
                          labelStyle: TextStyle(
                            fontFamily: 'GlobalFonts',
                            color: GREY,
                            //color: Colors.grey.shade600,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 25,),
                    Text(SAVE_ADDRESS_AS,style: TextStyle(
                        fontFamily: 'GlobalFonts',
                        color: GREY,
                        fontWeight: FontWeight.w900,
                        fontSize: 12
                    ),),
                    SizedBox(height: 10,),
                    Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: (){
                              setState(() {
                                type = HOME;
                                isHome = true;
                                isWork = false;
                                isOffice = false;
                                isOther = false;
                              });
                            },
                            child: Container(
                              height: 35,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(17),
                                  border: Border.all(color: GREY, width: 0.5),
                                  color: isHome ? THEME_COLOR : WHITE
                              ),
                              child: Center(
                                child: Text(HOME, style:TextStyle(
                                    fontFamily: 'GlobalFonts',
                                    color: BLACK,fontSize: 12),),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 10,),
                        Expanded(
                          child: InkWell(
                            onTap: (){
                              setState(() {
                                type = WORK;
                                isHome = false;
                                isWork = true;
                                isOffice = false;
                                isOther = false;
                              });
                            },
                            child: Container(
                              height: 35,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(17),
                                  border: Border.all(color: GREY, width: 0.5),
                                  color: isWork ? THEME_COLOR : WHITE
                              ),
                              child: Center(
                                child: Text(WORK, style: TextStyle(
                                    fontFamily: 'GlobalFonts',
                                    color: BLACK,fontSize: 12),),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 10,),
                        Expanded(
                          child: InkWell(
                            onTap: (){
                              setState(() {
                                type = OFFICE;
                                isHome = false;
                                isWork = false;
                                isOffice = true;
                                isOther = false;
                              });
                            },
                            child: Container(
                              height: 35,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(17),
                                  border: Border.all(color: GREY, width: 0.5),
                                  color: isOffice ? THEME_COLOR : WHITE
                              ),
                              child: Center(
                                child: Text(OFFICE, style: TextStyle(
                                    fontFamily: 'GlobalFonts',
                                    color: BLACK,fontSize: 12),),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 10,),
                        Expanded(
                          child: InkWell(
                            onTap: (){
                              type = OTHER;
                              setState(() {
                                isHome = false;
                                isWork = false;
                                isOffice = false;
                                isOther = true;
                              });
                            },
                            child: Container(
                              height: 35,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(17),
                                  border: Border.all(color: GREY, width: 0.5),
                                  color: isOther ? THEME_COLOR : WHITE
                              ),
                              child: Center(
                                child: Text(OTHER, style: TextStyle(
                                    fontFamily: 'GlobalFonts',
                                    color: BLACK,fontSize: 12),),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: RaisedButton(
                            elevation: 0,
                            padding: EdgeInsets.all(12),
                            onPressed: () {
                              addLocationToDatabase();
                            },
                            child: Text(ADD_ADDRESS,
                                style: TextStyle(
                                  fontFamily: 'GlobalFonts',
                                  color: BLACK,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                )),
                            color: THEME_COLOR,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                45,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20,),
                  ],
                ),
              ),
            ),
          );
        }
    );
  }

  void _getLocationStart() async {
    print('Started');
    await geo.Geolocator.getCurrentPosition(desiredAccuracy: geo.LocationAccuracy.low)
    .then((value){
      setState(() {
        _center = LatLng(value.latitude, value.longitude);
        _getLocation(_center);
      });
    })
        .catchError((e){
          Toast.show(e.toString(), context,duration: 3);
    });
  }

  void _getLocation(LatLng latLng) async {
    setState(() {
      _center = LatLng(latLng.latitude, latLng.longitude);
      _markers.clear();
      lati = latLng.latitude.toString();
      longi = latLng.longitude.toString();
      final marker = Marker(
        markerId: MarkerId("curr_loc"),
        position: LatLng(latLng.latitude, latLng.longitude),
        infoWindow: InfoWindow(title: 'Your Location'),
      );
      _markers["Current Location"] = marker;
    });
    //currentLocation = myLocation;
    final coordinates = new Coordinates(latLng.latitude, latLng.longitude);
    var addresses = await Geocoder.local.findAddressesFromCoordinates(coordinates);
    var first = addresses.first;
    print(addresses);
    print("${first.addressLine}");
    setState(() {
      addressLine = first.addressLine;
      // mapController.(CameraUpdate.newCameraPosition(CameraPosition(target: _center,zoom: 15 ))).catchError((e){
      //   Toast.show(e, context);
      // });
    });
    print(first);
  }


}
