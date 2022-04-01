import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../models/user_class.dart';
import '../utils/colors_styles.dart';
import '../utils/helper_functions.dart';


class FriendRequests extends StatefulWidget {
  const FriendRequests({Key? key, required this.user}) : super(key: key);
  final UserClass user;

  @override
  State<FriendRequests> createState() => FriendRequestsState(user: user);
}

class FriendRequestsState extends State<FriendRequests> {
  UserClass user;
  FriendRequestsState({Key? key, required this.user}) {
    user.blocked.forEach((element) {
      blockedSet.add(element["UID"]);
    });
  }

  Set<dynamic> blockedSet = {};

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Map<String, String>> friendRequests = [];
  bool startedAlready = false;

  void getFriendRequestList() {
    _firestore.collection("users").doc(user.uid)
        .get()
        .then((value) {
      if (value.exists) {
        if (value.data()!.containsKey("friendRequests")) {
          List revisedFriendRequests = [];
          (value.get("friendRequests") as List).forEach((element) {
            if (!blockedSet.contains(element["UID"])) {
              revisedFriendRequests.add(element);
            }
          });
          setState(() {
            friendRequests = castIntoListMap(revisedFriendRequests);
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
        "proUrl": req["proUrl"],
    }])});
  }

  Future<void> acceptFriendRequest(Map<String, String> req) async {
    // add to my friend list
    WriteBatch batch = _firestore.batch();
    var ref = _firestore.collection("users").doc(user.uid);
    batch.update(ref, {"friends": FieldValue.arrayUnion([{
        "UID": req["UID"],
        "fullName": req["fullName"],
        "proUrl": req["proUrl"]
      }])});

    // add to target friend list
    ref = _firestore.collection("users").doc(req["UID"]);
    batch.update(ref, {"friends": FieldValue.arrayUnion([{
        "UID": user.uid,
        "fullName": user.fullName,
        "proUrl": user.photoUrl,
      }])});

    await batch.commit();

    // remove from friend requests
    removeFriendRequest(req);


    List<WriteBatch> batchArray = [];
    batchArray.add(_firestore.batch());
    int operationCount =0, batchIndex = 0;

    // get my post and add to friends feed
    var snapshot = await _firestore.collection("userfeed").doc(user.uid).collection("posts").get();
    if(snapshot.docs.isNotEmpty) {
      for (var post in snapshot.docs) {
        ref = _firestore.collection("userfeed").doc(req["UID"]).collection("feed").doc(post.id);
        batchArray[batchIndex].set(ref, post.data());
        operationCount++;
        if (operationCount > 490) {
          batchArray.add(_firestore.batch());
          batchIndex++;
          operationCount = 0;
        }
      }
    }

    // get my friend's post and add to my feed
    snapshot = await _firestore.collection("userfeed").doc(req["UID"]).collection("posts").get();
    if(snapshot.docs.isNotEmpty) {
      for (var post in snapshot.docs) {
        ref = _firestore.collection("userfeed").doc(user.uid).collection("feed").doc(post.id);
        batchArray[batchIndex].set(ref, post.data());
        operationCount++;
        if (operationCount > 490) {
          batchArray.add(_firestore.batch());
          batchIndex++;
          operationCount = 0;
        }
      }
    }

    // print("in friend request");
    for(var b in batchArray) {
      await b.commit();
    }
  }

  List<Widget> displayFriendRequestList() {
    return friendRequests.reversed.map((req) {
      return Column(
        children: [
          Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
                color: blue,
              ),
              padding: EdgeInsets.all(10),
              margin: EdgeInsets.all(25),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                physics: const AlwaysScrollableScrollPhysics(),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      backgroundImage: NetworkImage(req["proUrl"]!),
                      radius: 25,
                    ),
                    Padding(padding: const EdgeInsets.only(right: 10)),
                    Text(
                        req["fullName"]!,
                        style: TextStyle(
                          fontSize: 24,
                        )
                    ),
                  ],
                ),
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
          backgroundColor: grey,
          centerTitle: true,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                  "Your friend requests",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 24,
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