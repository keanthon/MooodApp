import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/user_class.dart';
import '../providers/user_provider.dart';
import '../utils/colors_styles.dart';

class myFriends extends StatefulWidget {
  const myFriends({Key? key}) : super(key: key);

  @override
  State<myFriends> createState() => myFriendsState();
}

class myFriendsState extends State<myFriends> {
  myFriendsState({Key? key});

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<dynamic> friends = [];

  void getFriends(String uid) {
    _firestore.collection("users").doc(uid).get()
      .then((value) {
        if (value.exists) {
          if (friends.length != (value.data()!["friends"] as List).length) {
            setState(() {
              friends = value.data()!["friends"];
            });
          }
        }
    });
  }

  @override
  Widget build(BuildContext context) {
    UserClass user = Provider.of<UserProvider>(context, listen: false).getUser!;
    getFriends(user.uid);

    return Scaffold(
        appBar: AppBar(
          backgroundColor: grey,
          centerTitle: true,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: const <Widget>[
              Text(
                  "Friends",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 24
                  )
              ),
            ],
          ),
        ),
        body: RefreshIndicator(
          onRefresh: () async {
            getFriends(user.uid);
          },
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  child: Column (
                    children: [
                      for (var friend in friends)
                        Card(
                        color: postCardColor,
                        shape:  OutlineInputBorder(
                          borderRadius: BorderRadius.circular(40),
                          borderSide: BorderSide(width: 0, color: Colors.white70),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(15),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  CircleAvatar(
                                    child: Text("Pro Pic"),
                                    radius: 25,
                                  ),
                                  Padding(padding: const EdgeInsets.only(right: 10)),
                                  Text(
                                    friend["fullName"],
                                    style: TextStyle(
                                      fontSize: 24,
                                    )
                                  ),
                                ],
                              )
                            )
                          ],
                        ),
                      ),
                    ]
                  ),
                ),
              ),
            ]
          ),
        ),
    );
  }
}