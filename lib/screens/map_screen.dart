import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:moood/utils/helper_functions.dart';


class MapScreen extends StatefulWidget {
  final String uid;
  const MapScreen({Key? key, required this.uid}) : super(key: key);
  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  Completer<GoogleMapController> _controller = Completer();
  Position? _userPos;
  // Future<CameraPosition>? _initCamFuture;

  @override
  void initState() {
    // TODO: implement initState
    // _initCamFuture = getCurrentLocation();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();

  }

  Future<Set<Marker>> getMarkers() async {
    DateTime targetTime = DateTime.now().subtract(Duration(hours: 24));
    print(targetTime);
    QuerySnapshot snapshots = await FirebaseFirestore.instance
        .collection('userfeed')
        .doc(widget.uid)
        .collection('feed').where('date', isGreaterThan: targetTime).get();
    // print(snapshots.docs);
    Set<Marker> _markers = {};
    int id=0;
    for (var doc in snapshots.docs) {
      id++;
      var snap = doc.data() as Map<String, dynamic>;

      BitmapDescriptor markerbitmap = await BitmapDescriptor.fromBytes(
      await getBytesFromAsset(snap["emoji"], 110)
      );

      // print("After image conversion");
      // print(snap["location"][0]);
      // print(snap["location"][1]);
      if(snap["location"] != null) {
        Marker m = Marker(
          markerId: MarkerId("${id}"),
          position: LatLng(snap["location"][0], snap["location"][1]),
          infoWindow: InfoWindow(
            title: snap["status"] ?? "",
            snippet: snap["fullName"],
          ),
          icon: markerbitmap,
        );
        // print("After making marker");
        _markers.add(m);
        // print("After adding marker");
      }
    }
    return _markers;
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
        future: Future.wait([getCurrentLocation(), getMarkers()]),
        builder: (BuildContext context,AsyncSnapshot snapshot){
          if(snapshot.connectionState != ConnectionState.done){
            return Center(child: CircularProgressIndicator()); // your widget while loading
          }

          if(!snapshot.hasData){
            // print(snapshot.data);
            return Center(child: Text("Some Error Occurred"),); //your widget when error happens
          }

          // final data = snapshot.data; //your Map<String,dynamic>
          return GoogleMap(
            mapType: MapType.normal,
            initialCameraPosition: snapshot.data[0],
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
            },
            markers: snapshot.data[1],

          ); //place your widget here
        },
      )

    );
  }
}
