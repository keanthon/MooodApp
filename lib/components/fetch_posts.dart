import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:moood/components/post_card.dart';
import 'package:moood/models/post.dart';

import '../utils/colors_styles.dart';

class FetchPosts extends StatefulWidget {
  final String uid;
  final String feedOrPost;
  const FetchPosts({Key? key, required this.uid, required this.feedOrPost,}) : super(key: key);

  String get getUID => uid;

  @override
  State<FetchPosts> createState() => _FetchPostsState();
}

class _FetchPostsState extends State<FetchPosts> with AutomaticKeepAliveClientMixin {
  final scrollController = ScrollController();
  late PostsModel posts;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    posts = PostsModel(uid: super.widget.getUID, feedOrPost: super.widget.feedOrPost);
    scrollController.addListener(() {
      if (scrollController.position.maxScrollExtent ==
          scrollController.offset) {
        posts.loadMore();
      }
    });
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: posts.stream,
      builder: (BuildContext _context, AsyncSnapshot _snapshot) {
        if (!_snapshot.hasData) {
          return const Center(child: Text('Much Lonely, Add Friends', style: TextStyle(color: secondaryColor)));
        } else {
          return RefreshIndicator(
            onRefresh: posts.refresh,
            child: ListView.separated(
              physics: AlwaysScrollableScrollPhysics(),
              shrinkWrap: true,
              padding: EdgeInsets.symmetric(vertical: 8.0),
              controller: scrollController,
              separatorBuilder: (context, index) => Divider(),
              itemCount: _snapshot.data.length + 1,
              itemBuilder: (BuildContext _context, int index) {
                if (index < _snapshot.data.length) {
                  dynamic _snapData = _snapshot.data[index].data();
                  List<Uint8List> recorderInput = (jsonDecode(_snapData["recorderInput"]) as List).map((e) {
                    return Uint8List.fromList(e.cast<int>());
                  }).toList();
                  return PostCard(snap: _snapData, recorderInput: recorderInput, postID: _snapshot.data[index].id);
                } else if (posts.hasMore) {
                  return Padding(
                    padding: EdgeInsets.symmetric(vertical: 32.0),
                    child: Center(child: CircularProgressIndicator()),
                  );
                } else {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 32.0),
                    child: Center(child: Text('Nothing More to Show', style: TextStyle(color: secondaryColor))),
                  );
                }
              },
            ),
          );
        }
      },
    );
  }
}
