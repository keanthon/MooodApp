import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:moood/models/user_class.dart';
import 'package:moood/providers/user_provider.dart';
import 'package:moood/utils/colors_styles.dart';
import 'package:provider/provider.dart';

class MobileLayout extends StatefulWidget {
  const MobileLayout({Key? key}) : super(key: key);

  @override
  State<MobileLayout> createState() => _MobileLayoutState();
}

class _MobileLayoutState extends State<MobileLayout> {
  String username = "";

  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    UserClass user = Provider.of<UserProvider>(context).getUser;
    return Scaffold(
      body: Center(
        child: Text(user.username),
      ),
      bottomNavigationBar:  CurvedNavigationBar(
        backgroundColor: Colors.deepPurpleAccent,
        buttonBackgroundColor: Colors.red,

        color: Colors.deepPurple,
        items: <Widget>[
          Icon(Icons.home, size: 30),
          Icon(Icons.search, size: 30),
          Icon(Icons.add, size: 30),
          Icon(Icons.feed, size: 30),
          Icon(Icons.phone, size: 30),
        ],
        onTap: (index) {
          //Handle button tap
        },
      ),
    );
  }
}
