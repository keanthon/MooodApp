import 'package:flutter/material.dart';
import 'package:moood/components/post_card.dart';
import 'package:moood/models/post.dart';

class FetchPosts extends StatefulWidget {
  final String uid;
  const FetchPosts({Key? key, required this.uid}) : super(key: key);

  String get getUID => uid;
  @override
  State<FetchPosts> createState() => _FetchPostsState();
}

class _FetchPostsState extends State<FetchPosts> {
  final scrollController = ScrollController();
  late PostsModel posts;

  @override
  void initState() {
    posts = PostsModel(uid: super.widget.getUID);
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
          return Center(child: Text('Much Lonely, Add Friends'));
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
                  return PostCard(snap: _snapshot.data[index].data());
                } else if (posts.hasMore) {
                  return Padding(
                    padding: EdgeInsets.symmetric(vertical: 32.0),
                    child: Center(child: CircularProgressIndicator()),
                  );
                } else {
                  return Padding(
                    padding: EdgeInsets.symmetric(vertical: 32.0),
                    child: Center(child: Text('nothing more to load!')),
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
