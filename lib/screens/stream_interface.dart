import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:moood/components/fetch_posts.dart';
import 'package:moood/components/post_card.dart';
import 'package:moood/screens/profile.dart';
import 'package:moood/screens/search.dart';
import 'package:provider/provider.dart';

import '../models/user_class.dart';
import '../providers/user_provider.dart';
import '../utils/colors_styles.dart';
import '../utils/helper_functions.dart';
import '../utils/input_decoration.dart';
import 'friend_requests.dart';

class StreamInterface extends StatefulWidget {
  const StreamInterface({Key? key}) : super(key: key);

  @override
  StreamInterfaceState createState() {
    return StreamInterfaceState();
  }
}

class StreamInterfaceState extends State<StreamInterface> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    UserClass? user = Provider.of<UserProvider>(context).getUser;
    
    // listen for changes to friends array
    _firestore.collection("users").doc(user?.uid).snapshots().listen((DocumentSnapshot ds) {
      if (ds.exists) {
        List myPostsDB = [];
        List friendsList = [];

        // status changed
        if ((ds.get("posts") as List).isNotEmpty) {
          if (user!.posts.isEmpty || (ds.get("posts") as List).last.toString() != user.posts.last.toString()) {
            myPostsDB = (ds.get("posts") as List);
          }
        }

        // new friend added
        if ((ds.get("friends") as List).isNotEmpty) {
          if (user!.friends.isEmpty || (ds.get("friends") as List).last.toString() != user.friends.last.toString()) {
            friendsList = (ds.get("friends") as List);

            // batch new posts to new friend
            if (user.posts.isNotEmpty) {
              var batch = _firestore.batch();
              for (var i = user.friends.length; i < friendsList.length; ++i) {
                user.posts.forEach((element) {
                  var ref = _firestore.collection("userfeeds").doc(friendsList[i]["UID"]).collection("feed").doc();
                  batch.set(ref, element);
                });
              }
              batch.commit();
            }
          }
        }

        if (myPostsDB.isNotEmpty || friendsList.isNotEmpty) {
          setState(() {
            user!.posts = myPostsDB.isNotEmpty ? myPostsDB : user.posts;
            user.friends = friendsList.isNotEmpty ? friendsList : user.friends;
          });
        }
      }
    });

    return Scaffold(
      appBar: AppBar(
        backgroundColor: secondaryColor,
        centerTitle: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text("App", style: TextStyle(color: primaryColor)),
          ],
        ),
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                goToPage(Search(user: user!), 2, context);
              },
            );
          },
        ),
        actions: [
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.group, color: primaryColor, size: 30),
                onPressed: () {
                  goToPage(FriendRequests(user: user!), 2, context);
                },
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: IconButton(
                  icon: const Icon(Icons.account_circle,
                      color: primaryColor, size: 30),
                  onPressed: () {
                    goToPage(Profile(user: user), 2, context);
                  },
                ),
              ),
            ],
          ),
        ],
      ),
      body: FetchPosts(uid: user.uid),
    );
  }
}
