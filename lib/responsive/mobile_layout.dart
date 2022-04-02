import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:moood/utils/colors_styles.dart';
import 'package:moood/screens/map_screen.dart';
import 'package:moood/screens/my_friends.dart';
import 'package:moood/screens/profile.dart';
import 'package:moood/utils/helper_functions.dart';

import '../screens/new_post_screen.dart';
import '../screens/setting_screen.dart';
import '../screens/stream_interface.dart';

class MobileLayout extends StatefulWidget {
  final String uid;
  const MobileLayout({Key? key, required this.uid}) : super(key: key);
  @override
  State<MobileLayout> createState() => _MobileLayoutState();
}

class _MobileLayoutState extends State<MobileLayout> {
  String username = "";
  final PageController _pageController = PageController();
  int _bottomIndex = 0;
  int keyCount = 0;
  DateTime priorTime = DateTime(0);
  List<Widget> _screens = [
    StreamInterface(),
    myFriends(),
    Profile(),
    Setting(),
  ];



  @override
  void initState() {
    super.initState();
    _screens.insert(2,MapScreen(uid: widget.uid,));
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
          goToPage(NewPost(onFinished: (res)=>showSnackBar(res, context),), 2, context);
        },
        backgroundColor: michiganBlue,
      ),

      // body: StreamInterface(),
      body: IndexedStack(
        index: _bottomIndex,
        children: _screens,

      ),

      bottomNavigationBar: CurvedNavigationBar(

        height: 60,
        backgroundColor: Colors.yellow,
        color: michiganYellow,
        animationDuration: Duration(milliseconds: 200),
        index: _bottomIndex,
        items: <Widget>[
          Icon(Icons.feed, size: 30),
          Icon(Icons.people, size: 30),
          Icon(Icons.map, size: 30),
          Icon(Icons.account_circle, size: 30),
          Icon(Icons.settings, size: 30,),
        ],
        onTap: (index) {
          //Handle button tap

          // print("bottomindex: ${_bottomIndex}");
          // reclick on feed againn to refresh
          if(index==0 && _bottomIndex==0) {
            setState(() {
              keyCount = keyCount+1;
              _screens[0] = StreamInterface(key: Key("${keyCount}"),);
              // print(keyCount);
            });
          }

          // reclick on friends again to refresh
          if(index==1) {
            setState(() {
              keyCount = keyCount+1;
              _screens[1] = myFriends(key: Key("${keyCount}"),);
              // print(keyCount);
            });
          }

          // refresh map every 15 minutes
          if(index==2) {
            if(DateTime.now().difference(priorTime).inMinutes>5) {
              priorTime = DateTime.now();
              setState(() {
                keyCount = keyCount + 1;
                _screens[2] =
                    MapScreen(key: Key("${keyCount}"), uid: widget.uid,);
                // print(keyCount);
              });
            }
          }

          setState(() {
            _bottomIndex = index;
          });

        },
      ),
    );
  }
}
