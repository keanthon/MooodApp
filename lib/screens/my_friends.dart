import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:moood/resources/auth_methods.dart';
import 'package:moood/utils/helper_functions.dart';
import 'package:provider/provider.dart';

import '../models/user_class.dart';
import '../providers/user_provider.dart';
import '../utils/colors_styles.dart';
import 'blocked_screen.dart';

class myFriends extends StatefulWidget {
  const myFriends({Key? key}) : super(key: key);

  @override
  State<myFriends> createState() => myFriendsState();
}

class myFriendsState extends State<myFriends> {
  myFriendsState({Key? key});

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final AuthMethods _dbMethods = AuthMethods();

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
          child: ListView (
            physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
            children: [
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   children: [
              //     ElevatedButton(
              //       onPressed: () {
              //         goToPage(Blocked(), 2, context);
              //       },
              //       child: Text(
              //         "Blocked list",
              //       ),
              //     ),
              //   ]
              // ),
              for (var friend in friends)
                Card(
                  color: postCardColor,
                  shape:  OutlineInputBorder(
                    borderRadius: BorderRadius.circular(40),
                    borderSide: BorderSide(width: 0, color: Colors.white70),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            physics: const AlwaysScrollableScrollPhysics(),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  backgroundImage: NetworkImage(friend["proUrl"]),
                                  radius: 25,
                                ),
                                Padding(padding: const EdgeInsets.only(right: 10)),
                                Text(
                                  friend["fullName"],
                                  style: TextStyle(
                                    fontSize: 14,
                                  )
                                ),
                              ],
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            IconButton(
                              padding: EdgeInsets.zero,
                              onPressed: () async {
                                bool res = await showAreYouSureDialog(context, "removeFriend");
                                if(res) {
                                  _dbMethods.removeFriend(
                                      user.uid, user.photoUrl, user.fullName,
                                      friend);
                                  setState(() {
                                    friends.remove(friend);
                                  });
                                }
                              },
                              icon: Icon(Icons.remove),
                            ),
                            IconButton(
                              padding: EdgeInsets.zero,
                              onPressed: () async {
                                bool res = await showAreYouSureDialog(context, "blockUser");
                                if(res) {
                                  _dbMethods.removeFriend(
                                      user.uid, user.photoUrl, user.fullName,
                                      friend);
                                  _dbMethods.blockFriend(user.uid, friend);
                                  user.blocked.add(friend);

                                  setState(() {
                                    friends.remove(friend);
                                  });
                                }
                              },
                              icon: Icon(Icons.block),
                            ),
                          ],
                        )
                      ]
                    )
                  ),
              ),
            ]
          ),
        ),
    );
  }
}