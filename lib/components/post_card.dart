import 'dart:async';
import 'dart:convert';
import 'dart:ffi';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:sound_stream/sound_stream.dart';

class PostCard extends StatefulWidget {
  final snap;
  const PostCard({Key? key, required this.snap}) : super(key: key);

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  final PlayerStream _player = PlayerStream();
  late List<Uint8List> recorderInput;
  bool currentlyPlaying = false;
  bool parsedRecording = false;

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
