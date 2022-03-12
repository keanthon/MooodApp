import 'package:flutter/material.dart';

class PostCard extends StatefulWidget {
  final snap;
  const PostCard({Key? key, required this.snap}) : super(key: key);

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Row(
        children: [
          CircleAvatar(
            child: Text(widget.snap["emoji"], style: TextStyle(fontSize: 60),),
            radius: 40,
          ),
          Text(widget.snap["status"]),
        ],
      ),
    );
  }
}
