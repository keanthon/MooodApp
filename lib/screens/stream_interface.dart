import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  @override
  Widget build(BuildContext context) {
    UserClass? user = Provider.of<UserProvider>(context).getUser;

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
                goToPage(Search(user: user), 2, context);
              },
            );
          },
        ),
        actions: [
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.group,
                    color: primaryColor, size: 30),
                onPressed: () {
                  goToPage(FriendRequests(user: user), 2, context);
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
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
            ),
            Text(
              "Hi ${user?.firstName}! How are you doing?",
              style: TextStyle(
                color: secondaryColor,
                fontSize: 24,
              ),
            ),
            StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('userfeeds')
                  .doc(user!.uid)
                  .collection('feed').orderBy('date', descending: true)
                  .snapshots(),
              builder: (context,
                  AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) =>
                      PostCard(snap: snapshot.data!.docs[index].data()),
                );
              },
            ),
            // these are suggested statuses
          ],
        ),
      ),
    );
  }
}
