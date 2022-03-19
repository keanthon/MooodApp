import 'dart:async';
import 'dart:convert';
import 'dart:ffi';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:moood/utils/helper_functions.dart';
import 'package:sound_stream/sound_stream.dart';

import '../screens/comments.dart';
import '../utils/colors_styles.dart';

class PostCard extends StatefulWidget {
  final snap;
  final List<Uint8List> recorderInput;
  final postID;
  const PostCard({Key? key,
    required this.snap,
    this.recorderInput = const [],
    this.postID,}) : super(key: key);

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  final PlayerStream _player = PlayerStream();
  bool currentlyPlaying = false;

  void _play() async {
    await _player.start();

    if (widget.recorderInput.isNotEmpty) {
      for (var chunk in widget.recorderInput) {
        await _player.writeChunk(chunk);
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _player.initialize();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: postCardColor,
      shape:  OutlineInputBorder(
          borderRadius: BorderRadius.circular(40),
          borderSide: BorderSide(width: 0, color: Colors.white70),
          // borderSide: BorderSide(color: Colors.green, width: 1)
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(15,15,0,0),
            child: Row(

              // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                CircleAvatar(
                  child: Text("Pro Pic"),
                  radius: 25,
                ),
                SizedBox(width: 10,),
                Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("${widget.snap["fullName"]}"),
                      Text("date"),
                    ],
                ),


                // CircleAvatar(
                //   child: Image.asset(widget.snap["emoji"]),
                //   radius: 40,
                // ),
                // Text("From ${widget.snap["fullName"]}"),
              ]
            ),
          ),

          Text(
            widget.snap["status"],
            style: TextStyle(
                fontSize: 20,
              )
          ),
          CircleAvatar(
            child: Image.asset(widget.snap["emoji"]),
            radius: 60,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Visibility(
                visible: widget.recorderInput.isNotEmpty,
                maintainSize: true,
                maintainState: true,
                maintainAnimation: true,
                child: IconButton(
                  iconSize: 24.0,
                  icon: Icon(currentlyPlaying ? Icons.pause : Icons.play_arrow),
                  onPressed: () {
                    if (currentlyPlaying) {
                      _player.stop();
                      setState(() {
                        currentlyPlaying = false;
                      });
                    } else {
                      _play();
                      setState(() {
                        currentlyPlaying = true;
                      });
                    }
                  },
                ),
              ),
              Visibility(
                visible: widget.postID != null,
                maintainSize: true,
                maintainState: true,
                maintainAnimation: true,
                child: IconButton(
                  iconSize: 24.0,
                  icon: const Icon(Icons.chat_bubble),
                  onPressed: () => goToPage(
                      Comments(
                      recorderInput: widget.recorderInput,
                      snap: widget.snap,
                      postID: widget.postID,),
                      2, context),
                ),
              ),
            ]
          ),
        ],
      ),
    );
  }
}
