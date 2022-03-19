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

import '../screens/friend_requests.dart';
import '../screens/new_post_screen.dart';
import '../screens/search.dart';
import '../screens/stream_interface.dart';

class MobileLayout extends StatefulWidget {
  const MobileLayout({Key? key}) : super(key: key);

  @override
  State<MobileLayout> createState() => _MobileLayoutState();
}

class _MobileLayoutState extends State<MobileLayout> {
  String username = "";
  final PageController _pageController = PageController();
  int _bottomIndex = 0;
  int keyCount = 0;
  List<Widget> _screens = [
    StreamInterface(),
    Profile(),
  ];

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
    // UserClass? user = Provider.of<UserProvider>(context).getUser;
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          goToPage(NewPost(), 2, context);
        },
      ),

      // body: StreamInterface(),
      body: IndexedStack(
        index: _bottomIndex,
        children: _screens,

      ),

      bottomNavigationBar: CurvedNavigationBar(
        height: 60,
        backgroundColor: Colors.purpleAccent,
        color: Colors.deepPurpleAccent,
        animationDuration: Duration(milliseconds: 200),
        index: _bottomIndex,
        items: <Widget>[
          Icon(Icons.feed, size: 30),
          Icon(Icons.account_circle, size: 30),
        ],
        onTap: (index) {
          //Handle button tap

          print("bottomindex: ${_bottomIndex}");
          // reclick on feed againn to refresh
          if(index==0 && _bottomIndex==0) {
            setState(() {
              keyCount = keyCount+1;
              _screens[0] = StreamInterface(key: Key("${keyCount}"),);
              print(keyCount);
            });
          }

          setState(() {
            _bottomIndex = index;
          });

        },
      ),
    );
  }
}
