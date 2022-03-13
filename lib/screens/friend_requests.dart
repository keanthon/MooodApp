import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../models/user_class.dart';
import '../utils/colors_styles.dart';
import '../utils/helper_functions.dart';
import 'package:collection/collection.dart';


class FriendRequests extends StatefulWidget {
  const FriendRequests({Key? key, required this.user}) : super(key: key);
  final UserClass user;

  @override
  State<FriendRequests> createState() => FriendRequestsState(user: user);
}

class FriendRequestsState extends State<FriendRequests> {
  UserClass user;
  FriendRequestsState({Key? key, required this.user});

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Map<String, String>> friendRequests = [];
  bool startedAlready = false;

  void getFriendRequestList() {
    _firestore.collection("users").doc(user.uid)
        .get()
        .then((value) {
      if (value.exists) {
        if (value.data()!.containsKey("friendRequests")) {
          setState(() {
            friendRequests = castIntoListMap(value.get("friendRequests"));
          });
        }
      }
    });
  }

  void removeFriendRequest(Map<String, String> req) {
    // remove from friend requests
    _firestore.collection("users").doc(user.uid)
      .update({"friendRequests": FieldValue.arrayRemove([{
        "UID": req["UID"],
        "fullName": req["fullName"],
    }])});
  }

  void acceptFriendRequest(Map<String, String> req) {
    // add to my friend list
    _firestore.collection("users").doc(user.uid)
      .update({"friends": FieldValue.arrayUnion([{
        "UID": req["UID"],
        "fullName": req["fullName"],
      }])});

    // add to target friend list
    _firestore.collection("users").doc(req["UID"])
      .update({"friends": FieldValue.arrayUnion([{
        "UID": user.uid,
        "fullName": user.fullName,
    }])});

    // remove from friend requests
    removeFriendRequest(req);
  }

  List<Widget> displayFriendRequestList() {
    return friendRequests.reversed.map((req) {
      return Column(
        children: [
          Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
                color: tertiaryColor,
              ),
              padding: EdgeInsets.all(10),
              margin: EdgeInsets.all(25),
              child: Text(
                  req["fullName"]!,
                  style: TextStyle(
                    fontSize: 18,
                    color: primaryColor,
                  )
              )
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Material(
                child: InkWell(
                  onTap: () {
                    acceptFriendRequest(req);
                    setState(() {
                      friendRequests.remove(req);
                    });
                  },
                  splashColor: secondaryColor,
                  child: Container(
                    padding: EdgeInsets.all(10),
                    child: Text(
                      "Accept",
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ),
              ),
              Material(
                child: InkWell(
                  onTap: () {
                    removeFriendRequest(req);
                    setState(() {
                      friendRequests.remove(req);
                    });
                  },
                  splashColor: secondaryColor,
                  child: Container(
                    padding: EdgeInsets.all(10),
                    child: Text(
                      "Decline",
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ),
              ),
          ]),
        ],
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    if (!startedAlready) {
      startedAlready = true;
      getFriendRequestList();
    }

    return Scaffold(
        appBar: AppBar(
          backgroundColor: secondaryColor,
          centerTitle: true,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                  "Your friend requests",
                  style: TextStyle(
                      color: primaryColor
                  )
              ),
            ],
          ),
        ),
        body: SingleChildScrollView(
          child: Column (
            children: displayFriendRequestList(),
          ),
        )
    );
  }
}