import 'package:flutter/material.dart';
import 'package:moood/components/fetch_posts.dart';
import 'package:provider/provider.dart';

import '../models/user_class.dart';
import '../providers/user_provider.dart';
import '../utils/colors_styles.dart';

class MyPosts extends StatefulWidget {
  final String uid;
  const MyPosts({
    Key? key,
    required this.uid,
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
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
                "Past Mooods",
                style: TextStyle(
                    color: Colors.black
                )
            ),
          ],
        ),
      ),
      body: FetchPosts(
        uid: widget.uid,
        feedOrPost: "posts",
      ),
    );
  }
}
