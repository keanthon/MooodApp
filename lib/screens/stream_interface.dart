import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:moood/screens/profile.dart';

import '../utils/colors_styles.dart';
import '../utils/helper_functions.dart';
import '../widgets/input_decoration.dart';


class StreamInterface extends StatefulWidget {
  final User user = FirebaseAuth.instance.currentUser!;
  StreamInterface({Key? key}) : super(key: key);

  @override
  StreamInterfaceState createState() {
    return StreamInterfaceState(user: this.user,);
  }
}

class StreamInterfaceState extends State<StreamInterface> {
  final User user;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController statusController = TextEditingController();
  final maxStatusCount = 20;

  StreamInterfaceState({Key? key, required this.user}) {
    List<String>? split = user.displayName?.split(" ");
    firstName = split![0];
    lastName = split[1];
  }

  String firstName = "";
  String lastName = "";
  String userStatus = "";

  Future<void> getUserStatus() async {
    _firestore.collection("users").doc(user.uid).get().then((value) {
      setState(() {
        userStatus = value.get("status");
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    requireFunc(value) {
      if (value == null || value.isEmpty) {
        return 'Required';
      }
      return null;
    }

    getUserStatus();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: secondaryColor,
        centerTitle: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              "App",
              style: TextStyle(
                color: primaryColor
              )
            ),
          ],
        ),
        actions: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: IconButton(
              icon: const Icon(Icons.account_circle, color: primaryColor, size: 30),
              onPressed: () {
                Route route = MaterialPageRoute(builder: (context) => Profile(user: appUser(firstName, lastName, userStatus)));
                Navigator.push(context, route);
              },
            )
          ),
        ],
      ),
      body: Center (
          child: Column (
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
              ),
              Text(
                "Hi ${firstName}! How are you doing?",
                style: TextStyle(
                  color: secondaryColor,
                  fontSize: 24,
                )
              ),
              // these are suggested statuses
              Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10.0))),
                  margin: EdgeInsets.all(5),
                  child: Row (
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      redCenteredContainer("good"),
                      redCenteredContainer("bad"),
                      redCenteredContainer("at the UGLI"),
                      redCenteredContainer("meh"),
                      redCenteredContainer("thoughtful")
                    ]
                  )
              ),
              Container(
                margin: EdgeInsets.only(left: 10, top: 10, right: 10, bottom: 0),
                child: TextFormField(
                  validator: requireFunc,
                  controller: statusController,
                  keyboardType: TextInputType.text,
                  obscureText: false,
                  maxLength: maxStatusCount,
                  buildCounter: (_, {required currentLength, maxLength, required isFocused}) => Padding(
                    padding: const EdgeInsets.only(left: 16.0),
                    child: Text(
                        (maxLength! - currentLength).toString() + " characters left!!",
                        style: TextStyle(
                          color: secondaryColor,
                          fontSize: 18
                        ),
                    ),
                  ),
                  decoration: TextInputDecoration(
                      '... What a mood',
                      Colors.redAccent[100]).decorate(),
                ),
              ),
              // FIXME bug with text form not working when going back on stream and retrying
              Material(
                child: InkWell(
                  onTap: () {
                    _firestore.collection("users").doc(user.uid).update({"status": statusController.text});
                    setState(() {
                      userStatus = statusController.text;
                      statusController.text = "";
                    });
                  },
                  splashColor: secondaryColor,
                  child: Container(
                      padding: EdgeInsets.all(10),
                      child: const Text(
                        "Post",
                        style: TextStyle(
                            fontSize: 18
                        ),
                      )
                  ),
                )
              ),
              // previously saved status
              Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    color: tertiaryColor,
                  ),
                  padding: EdgeInsets.all(10),
                  margin: EdgeInsets.all(20),
                  child: Text(
                      userStatus,
                      style: TextStyle(
                        fontSize: 18,
                        color: primaryColor,
                      )
                  )
              ),
            ]
        )
      )
    );
  }
}