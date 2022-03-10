import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../responsive/responsive_layout.dart';
import '../screens/stream_interface.dart';
import 'colors_styles.dart';

class appUser {
  final String firstName;
  final String lastName;
  List<String> userStatuses;

  appUser(this.firstName, this.lastName, this.userStatuses);
}


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