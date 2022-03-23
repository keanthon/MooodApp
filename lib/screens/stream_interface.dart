import 'package:flutter/material.dart';
import 'package:moood/components/fetch_posts.dart';
import 'package:moood/screens/search.dart';
import 'package:provider/provider.dart';

import '../models/user_class.dart';
import '../providers/user_provider.dart';
import '../utils/helper_functions.dart';
import 'friend_requests.dart';

class StreamInterface extends StatefulWidget {
  const StreamInterface({Key? key}) : super(key: key);

  @override
  StreamInterfaceState createState() {
    return StreamInterfaceState();
  }
}

class StreamInterfaceState extends State<StreamInterface> {
  // cache emoji images
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    for (var i = 1; i <= 20; ++i) {
      precacheImage(AssetImage("assets/images/$i.png"), context);
    }
  }

  @override
  Widget build(BuildContext context) {
    Provider.of<UserProvider>(context).refreshUser();
    UserClass? user = Provider.of<UserProvider>(context).getUser;

    return (user==null) ? Center(child: CircularProgressIndicator()) : Scaffold(
      appBar: AppBar(
        // backgroundColor: secondaryColor,
        centerTitle: true,
        title: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Image.asset("assets/images/logoAppBar.png"),
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
                icon: const Icon(Icons.emoji_people, size: 30),
                onPressed: () {
                  goToPage(FriendRequests(user: user), 2, context);
                },
              ),
            ],
          ),
        ],
      ),
      body: FetchPosts(uid: user.uid, feedOrPost: 'feed',),
    );
  }
}
