import 'package:flutter/material.dart';
import 'package:moood/components/fetch_posts.dart';
import 'package:moood/screens/calendar_screen.dart';
import 'package:provider/provider.dart';

import '../models/user_class.dart';
import '../providers/user_provider.dart';

class MyPosts extends StatefulWidget {
  const MyPosts({
    Key? key,
  }) : super(key: key);

  @override
  State<MyPosts> createState() => _MyPostsState();
}

class _MyPostsState extends State<MyPosts> {
  final tab = TabBar(tabs: <Tab>[
    Tab(icon: Icon(Icons.list_alt)),
    Tab(icon: Icon(Icons.calendar_month)),
  ]);

  @override
  Widget build(BuildContext context) {
    UserClass? user = Provider.of<UserProvider>(context).getUser;
    return (user==null) ? Center(child: CircularProgressIndicator()) : SafeArea(
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            bottom: tab,
          ),
          body: TabBarView(
            children: [
              FetchPosts(
                uid: user.uid,
                feedOrPost: "posts",
              ),
              CalendarScreen(uid: user.uid,),
            ],
          ),
        ),
      ),
    );
  }
}
