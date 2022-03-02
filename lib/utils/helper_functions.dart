import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../screens/stream_interface.dart';
import 'colors_styles.dart';

class appUser {
  final String firstName;
  final String lastName;
  final String userStatus;

  appUser(this.firstName, this.lastName, this.userStatus);
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
