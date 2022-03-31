import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:moood/components/fetch_posts.dart';
import 'package:moood/screens/search.dart';
import 'package:provider/provider.dart';

import '../models/user_class.dart';
import '../providers/user_provider.dart';
import '../utils/colors_styles.dart';
import '../utils/helper_functions.dart';
import 'friend_requests.dart';

class Blocked extends StatefulWidget {
  Blocked({Key? key}) : super(key: key);

  @override
  BlockedState createState() {
    return BlockedState();
  }
}

class BlockedState extends State<Blocked> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void removeBlocked(String uid, dynamic friend) {
    _firestore.collection("users").doc(uid).update({
      "blocked": FieldValue.arrayRemove([friend]),
    });
  }

  List<dynamic> blocked = [];

  @override
  void initState() {
    super.initState();
    UserClass user = Provider.of<UserProvider>(context, listen: false).getUser!;
    blocked = user.blocked;
  }

  @override
  Widget build(BuildContext context) {
    UserClass user = Provider.of<UserProvider>(context, listen: false).getUser!;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: grey,
        centerTitle: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: const <Widget>[
            Text(
                "Blocked list",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 24
                )
            ),
          ],
        ),
      ),
      body: ListView (
          physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
          children: [
            for (var b in blocked)
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
                                    backgroundImage: NetworkImage(b["proUrl"]),
                                    radius: 25,
                                  ),
                                  Padding(padding: const EdgeInsets.only(right: 10)),
                                  Text(
                                    b["fullName"],
                                    style: TextStyle(
                                      fontSize: 14,
                                    )
                                  ),
                                ],
                              ),
                            ),
                          ),
                          IconButton(
                            padding: EdgeInsets.zero,
                            onPressed: () {
                              removeBlocked(user.uid, b);
                              user.blocked.remove(b);
                              setState(() {
                                blocked = user.blocked;
                              });
                            },
                            icon: Icon(Icons.add_box_rounded),
                          ),
                        ]
                    )
                ),
              ),
          ]
      ),
    );
  }
}
