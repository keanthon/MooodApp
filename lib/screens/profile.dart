import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:moood/models/user_class.dart';
import 'package:moood/screens/login_screen.dart';
import '../resources/auth_methods.dart';
import '../utils/colors_styles.dart';
import '../utils/helper_functions.dart';

class Profile extends StatelessWidget {
  UserClass? user;
  Profile({Key? key, required this.user}) : super(key: key);

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
        body: Center (
            child: Column (
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 20),
                  ),
                  // FIXME need custom profile pic
                  CircleAvatar(
                    radius: 100,
                    backgroundImage: AssetImage('assets/images/logo.jpg'),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 20),
                  ),
                  Text(
                      "Hi " + user!.firstName + " " + user!.lastName + "!",
                      style: TextStyle(
                        fontSize: 24,
                        color: secondaryColor,
                      )
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 10),
                  ),
                  Container(
                      height: 150,
                      width: 450,
                      decoration: BoxDecoration(
                          color: secondaryColor,
                          borderRadius: BorderRadius.all(Radius.circular(10.0))),
                      child: Column (
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            const Padding(
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
                  ElevatedButton(
                    child: Text("Sign Out"),
                    onPressed: () async {
                      AuthMethods().signOut();
                      goToPage(LoginScreen(), 1, context);
                    },
                  ),
                ]
            )
        )
    );
  }
}