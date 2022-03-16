import 'package:flutter/material.dart';
import 'package:moood/components/fetch_posts.dart';
import 'package:provider/provider.dart';

import '../models/user_class.dart';
import '../providers/user_provider.dart';

class MyPosts extends StatefulWidget {
  const MyPosts({Key? key,}) : super(key: key);

  @override
  State<MyPosts> createState() => _MyPostsState();
}

class _MyPostsState extends State<MyPosts> {
  @override
  Widget build(BuildContext context) {
    UserClass? user = Provider.of<UserProvider>(context).getUser;
    return FetchPosts(uid: user!.uid, feedOrPost: "posts",);
  }
}
