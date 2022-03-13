import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:moood/utils/globals.dart';
import '../models/user_class.dart';
import '../responsive/responsive_layout.dart';
import '../screens/stream_interface.dart';
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

Widget displayFriends(List<Map<String, String>> friendRequests) {
  return Column(
    children: friendRequests.reversed.map((req) {
      return (
        Container(
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
            color: tertiaryColor,
          ),
          padding: const EdgeInsets.all(10),
          margin: const EdgeInsets.all(25),
          child: Text(
            req["fullName"]!,
            style: const TextStyle(
              fontSize: 18,
              color: primaryColor,
            )
          )
        )
      );
    }).toList(),
  );
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