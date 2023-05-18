import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class DeliveryBoyMap extends StatefulWidget {

  double lat;
  double lng;


  DeliveryBoyMap(this.lat, this.lng);

  @override
  _DeliveryBoyMapState createState() => _DeliveryBoyMapState();
}

class _DeliveryBoyMapState extends State<DeliveryBoyMap> {

  GoogleMapController mapController;
  LatLng _center;
  final Map<String, Marker> _markers = {};



  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _center = LatLng(widget.lat, widget.lng);
    final marker = Marker(
      markerId: MarkerId("curr_loc"),
      position: _center,
      infoWindow: InfoWindow(title: 'Delivery Location'),
    );
    _markers["Current Location"] = marker;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: GoogleMap(
          onMapCreated: _onMapCreated,
          initialCameraPosition: CameraPosition(
            target: _center,
            zoom: 15.0,
          ),
          onTap: (latLang){
            //Toast.show(latLang.toString(), context,duration: 2);
            setState(() {
              //_getLocation(latLang);
            });
          },
          buildingsEnabled: true,
          compassEnabled: true,
          markers: _markers.values.toSet(),
        ),
      ),
    );
  }
}
