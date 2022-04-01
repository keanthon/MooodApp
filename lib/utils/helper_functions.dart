import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:moood/utils/globals.dart';
import 'package:intl/intl.dart';
import 'colors_styles.dart';

// 1 for push replace, 2 for push, 3 for pushandremoveuntil
void goToPage(Widget page, int pushReplace, BuildContext context ) {
  Route route = MaterialPageRoute(builder: (context) => page);
  if(pushReplace==1) {
    Navigator.pushReplacement(context, route);
  } else if (pushReplace==2) {
    Navigator.push(context, route);
  } else {
    Navigator.pushAndRemoveUntil(context, route, (route) => false);
  }

}

Container redCenteredContainer(String text, bool selected) {
  return Container(
      decoration: BoxDecoration(
          color: selected ? Colors.white: secondaryColor,
          borderRadius: BorderRadius.all(Radius.circular(10.0))),
      padding: EdgeInsets.all(10),
      child: Center (
          child: Text(
            text,
            textAlign: TextAlign.center,
          )
      )
  );
}

String getShortUID(String uid) {
  return uid.substring(0, maxIDSize);
}

List<Map<String, String>> castIntoListMap(dynamic value) {
  return (value as List).map((e) {
    return (e as Map<String, dynamic>).map((key, value) => MapEntry(key, value!.toString()));
  }).toList();
}

Set<String> castIntoUIDSet(dynamic value) {
  Set<String> s = {};
  for (var e in (value as List)) {
    s.add((e as Map<String, dynamic>)["UID"]);
  }
  return s;
}

showSnackBar(String content, BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(content),
    ),
  );
}

String? requireFunc(String? value) {
  if (value == null || value.isEmpty) {
    return 'Required';
  }
  return null;
}

pickImage(ImageSource source) async {
  final ImagePicker _imagePicker = ImagePicker();
  XFile? _file = await _imagePicker.pickImage(source: source, maxHeight: 400, maxWidth: 400);
  if (_file != null) {
    return await _file.readAsBytes();
  }
  print('No Image Selected');
}

Future<Position> getGeoLocationPosition() async {
  bool serviceEnabled;
  LocationPermission permission;

  // Test if location services are enabled.
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    // Location services are not enabled don't continue
    // accessing the position and request users of the
    // App to enable the location services.
    await Geolocator.openLocationSettings();
    return Future.error('Location services are disabled.');
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {

      return Future.error('Location permissions are denied');
    }
  }

  if (permission == LocationPermission.deniedForever) {
    // Permissions are denied forever, handle appropriately.
    return Future.error(
        'Location permissions are permanently denied, we cannot request permissions.');
  }

  // When we reach here, permissions are granted and we can
  // continue accessing the position of the device.
  return await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
}

Future<Uint8List> getBytesFromAsset(String path, int width) async {
  ByteData data = await rootBundle.load(path);
  ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(), targetWidth: width);
  ui.FrameInfo fi = await codec.getNextFrame();
  return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!.buffer.asUint8List();
}

String getDate(DateTime date) {
  Duration diff = DateTime.now().difference(date);
  if(diff.inHours<24) {
    if(diff.inMinutes<60) {
      if(diff.inSeconds<60) {
        return "Just Now";
      }
      return "${diff.inMinutes} minutes ago";
    }
    return "${diff.inHours} hours ago";
  }
  return DateFormat.yMMMMd().format(date);
}

Future<bool> showAlertDialog(BuildContext context, String identifier) async {
  bool ret = false;
  String message = "";
  if(identifier=="post") {
    message = "report this post";
  }
  if(identifier=="user") {
    message = "block this user";
  }

  await showDialog<bool>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(

        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(32.0))),
        content: Text("Are you sure you want to ${message}?"),
        actions: <Widget>[
          TextButton(
            child: const Text('Cancel'),
            onPressed: () {
              Navigator.of(context).pop();
              ret = false;
            },
          ),
          TextButton(
            child: const Text('Confirm'),
            onPressed: () {
              Navigator.of(context).pop();
              ret = true;
            },
          ),
        ],
      );
    },
  );

  return ret;

}