import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:moood/utils/helper_functions.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  Completer<GoogleMapController> _controller = Completer();
  Position? _userPos;
  Future<CameraPosition>? _initCamFuture;
  @override
  void initState() {
    // TODO: implement initState
    _initCamFuture = getCurrentLocation();
    super.initState();
  }

  Future<CameraPosition> getCurrentLocation() async {
    _userPos = await getGeoLocationPosition();
    return CameraPosition(
      target: LatLng(_userPos!.latitude, _userPos!.longitude),
      zoom: 15,
    );

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: _initCamFuture,
        builder: (BuildContext context,AsyncSnapshot snapshot){
          if(snapshot.connectionState != ConnectionState.done){
            return Center(child: CircularProgressIndicator()); // your widget while loading
          }

          if(!snapshot.hasData){
            return Center(child: Text("Some Error Occurred"),); //your widget when error happens
          }

          final data = snapshot.data; //your Map<String,dynamic>
          return GoogleMap(
            mapType: MapType.normal,
            initialCameraPosition: snapshot.data,
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
            },
          ); //place your widget here
        },
      )

    );
  }
}
