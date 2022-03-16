import 'dart:async';
import 'dart:convert';
import 'dart:ffi';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:sound_stream/sound_stream.dart';

class PostCard extends StatefulWidget {
  final snap;
  final List<Uint8List> recorderInput;
  const PostCard({Key? key, required this.snap, required this.recorderInput}) : super(key: key);

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  final PlayerStream _player = PlayerStream();
  bool currentlyPlaying = false;
  bool parsedRecording = false;

  late StreamSubscription _playerStatus;

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
  void dispose() {
    _playerStatus.cancel();
    super.dispose();
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
            padding: EdgeInsets.only(left: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.snap["status"],
                  style: TextStyle(
                    fontSize: 24,
                  )
                ),
                IconButton(
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
              ]
            ),
          ),
        ],
      ),
    );
  }
}
