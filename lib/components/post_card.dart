import 'dart:async';
import 'dart:convert';
import 'dart:ffi';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:moood/utils/helper_functions.dart';
import 'package:sound_stream/sound_stream.dart';

import '../screens/comments.dart';

class PostCard extends StatefulWidget {
  final snap;
  final List<Uint8List> recorderInput;
  final postID;
  const PostCard({Key? key,
    required this.snap,
    required this.recorderInput,
    required this.postID,}) : super(key: key);

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  final PlayerStream _player = PlayerStream();
  late List<Uint8List> recorderInput;
  bool currentlyPlaying = false;

  @override
  void initState() {
    super.initState();
    recorderInput = (jsonDecode(widget.snap["recorderInput"]) as List).map((e) {
      return Uint8List.fromList(e.cast<int>());
    }).toList();
    _player.initialize();
  }

  void _play() async {
    await _player.start();

    if (recorderInput.isNotEmpty) {
      for (var chunk in recorderInput) {
        await _player.writeChunk(chunk);
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              CircleAvatar(
                child: Text(widget.snap["emoji"], style: TextStyle(fontSize: 60),),
                radius: 40,
              ),
              Text("From ${widget.snap["fullName"]}"),
            ]
          ),
          Padding(
            padding: EdgeInsets.only(left: 10, top: 10, bottom: 10),
            child: Text(
              widget.snap["status"],
              style: TextStyle(
                  fontSize: 24,
                )
            ),
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
              IconButton(
                iconSize: 24.0,
                icon: const Icon(Icons.chat_bubble),
                onPressed: () => goToPage(
                    Comments(
                    recorderInput: widget.recorderInput,
                    snap: widget.snap,
                    postID: widget.postID,),
                    2, context),
              ),
            ]
          ),
        ],
      ),
    );
  }
}
