import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../screens/stream_interface.dart';
import 'colors_styles.dart';

class appUser {
  final String firstName;
  final String lastName;
  List<String> userStatuses;

  appUser(this.firstName, this.lastName, this.userStatuses);
}

void go_to_stream (BuildContext context) {
  Route route = MaterialPageRoute(builder: (context) => StreamInterface());
  Navigator.pushAndRemoveUntil(context, route, (route) => false);
}

Container redCenteredContainer(String text) {
  return Container(
      decoration: BoxDecoration(
          color: secondaryColor,
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

Widget generate_posts(List<String> input) {
  return Column(children: input.reversed.map((value) {
    return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
          color: tertiaryColor,
        ),
        padding: EdgeInsets.all(10),
        margin: EdgeInsets.all(20),
        child: Text(
            value,
            style: TextStyle(
              fontSize: 18,
              color: primaryColor,
            )
        )
    );
  }).toList());
}