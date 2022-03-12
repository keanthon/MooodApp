import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:moood/models/user_class.dart';
import 'package:moood/utils/globals.dart';
import 'package:moood/screens/login_screen.dart';
import '../resources/auth_methods.dart';
import '../utils/colors_styles.dart';
import '../utils/helper_functions.dart';

class Profile extends StatelessWidget {
  UserClass? user;
  Profile({Key? key, required this.user}): super(key: key) {
    friendRequests = castIntoListMap(user.friends);
  }

  List<Map<String, String>> friendRequests = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: secondaryColor,
        centerTitle: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
                "Your profile",
                style: TextStyle(
                    color: primaryColor
                )
            ),
          ],
        ),
      ),
        body: SingleChildScrollView(
          child: Center(
            child: Column (
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  // FIXME need custom profile pic
                  CircleAvatar(
                    radius: 100,
                    backgroundImage: AssetImage('assets/images/logo.jpg'),
                  ),
                  Text(
                      "Hi ${user.firstName} ${user.lastName}!\n#${getShortUID(user.uid)}",
                      style: TextStyle(
                        fontSize: 24,
                        color: secondaryColor,
                      )
                  ),
                  Container(
                    height: 150,
                    width: 450,
                    decoration: const BoxDecoration(
                        color: secondaryColor,
                        borderRadius: BorderRadius.all(Radius.circular(10.0))),
                    child: Column (
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: const <Widget>[
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 5),
                          ),
                          Text(
                              "Your status",
                              style: TextStyle(
                                fontSize: 24,
                                color: primaryColor,
                              )
                          ),
                          Text(
                              //FIXME change to latest post
                              "Hello",
                              style: TextStyle(
                                fontSize: 24,
                                color: primaryColor,
                              )
                          ),
                        ]
                      )
                    ),
                  Text(
                    "Your friends",
                    style: TextStyle(
                      fontSize: 24,
                      color: secondaryColor,
                    )
                  ),
                  displayFriends(friendRequests),
                  ElevatedButton(
                    child: Text("Sign Out"),
                    onPressed: () async {
                      AuthMethods().signOut();
                      goToPage(LoginScreen(), 1, context);
                    },
                  ),
                ]
            ),
          ),
        )
    );
  }
}