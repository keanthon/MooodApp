import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:moood/models/user_class.dart';
import 'package:moood/providers/user_provider.dart';
import 'package:moood/screens/profile.dart';
import 'package:moood/utils/colors_styles.dart';
import 'package:moood/utils/helper_functions.dart';
import 'package:provider/provider.dart';

import '../screens/new_post_screen.dart';
import '../screens/stream_interface.dart';

class MobileLayout extends StatefulWidget {
  const MobileLayout({Key? key}) : super(key: key);

  @override
  State<MobileLayout> createState() => _MobileLayoutState();
}

class _MobileLayoutState extends State<MobileLayout> {
  String username = "";
  final PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    UserClass? user = Provider.of<UserProvider>(context).getUser;
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          goToPage(NewPost(), 2, context);
        },
      ),
      body: PageView(
        controller: _pageController,

        children: [
          StreamInterface(),
          Profile(user: user),
          Text('Search', style: TextStyle(color: Colors.blue),),
          Text('Map'),
          Text('Home'),
        ],
      ),
      // bottomNavigationBar: CurvedNavigationBar(
      //   backgroundColor: Colors.purpleAccent,
      //   color: Colors.deepPurpleAccent,
      //     items: <Widget>[
      //       Icon(Icons.add, size: 30),
      //       Icon(Icons.list, size: 30),
      //       Icon(Icons.compare_arrows, size: 30),
      //     ],
      //     onTap: (index) {
      //       //Handle button tap
      //     },
      // ),

    );
  }
}
