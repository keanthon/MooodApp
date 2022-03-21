import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sound_stream/sound_stream.dart';

import '../models/user_class.dart';
import '../providers/user_provider.dart';
import '../utils/colors_styles.dart';
import '../utils/globals.dart';

class Comments extends StatefulWidget {
  const Comments({Key? key,
    required this.snap,
    required this.recorderInput,
    required this.postID,}) : super(key: key);

  final dynamic snap;
  final List<Uint8List> recorderInput;
  final String postID;

  @override
  State<Comments> createState() => CommentsState();
}

class CommentsState extends State<Comments> {
  CommentsState({Key? key});

  final PlayerStream _player = PlayerStream();
  final TextEditingController inputCont = TextEditingController();
  final ScrollController commentsCont = ScrollController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  bool currentlyPlaying = false;
  bool sentMessage = false;
  int currentLength = 0;

  List<dynamic> posts = [];

  void _play() async {
    await _player.start();

    if (widget.recorderInput.isNotEmpty) {
      for (var chunk in widget.recorderInput) {
        await _player.writeChunk(chunk);
      }
    }
  }

  void getComments() async {
    _firestore.collection("comments").doc(widget.postID).get()
      .then((value) {
        if (value.exists) {
          setState(() {
            posts = (value.get("comments") as List);
          });
        }
    });
  }

  @override
  void initState() {
    super.initState();
    getComments();
    _player.initialize();
  }

  @override
  Widget build(BuildContext context) {
    UserClass? user = Provider.of<UserProvider>(context).getUser;

    if (sentMessage) {
      getComments();
      print("here");
      sentMessage = false;
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: secondaryColor,
        centerTitle: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: const <Widget>[
            Text("Comments", style: TextStyle(color: primaryColor)),
          ],
        ),
      ),
      body: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Card(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          CircleAvatar(
                            child: Image.asset(widget.snap["emoji"]),
                            radius: 60,
                          ),
                          Text("From ${widget.snap["fullName"]}"),
                        ]
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10, top: 10, bottom: 10),
                        child: Text(
                            widget.snap["status"],
                            style: const TextStyle(
                              fontSize: 24,
                            )
                        ),
                      ),
                      Visibility(
                        visible: widget.recorderInput.isNotEmpty,
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
                        )
                      ],
                    ),
                  ),
                  Expanded(
                    child: RefreshIndicator(
                      onRefresh: () async {
                        getComments();
                      },
                      child: SingleChildScrollView(
                        controller: commentsCont,
                        scrollDirection: Axis.vertical,
                        physics: const AlwaysScrollableScrollPhysics(),
                        child: Wrap(
                          direction: Axis.horizontal,
                          children: [
                            if (posts.isNotEmpty)
                              for (var post in posts.reversed)
                                Card(
                                  child: Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: Row(
                                      children: [
                                        Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                  "${post["fullName"]} :",
                                                  style: const TextStyle(
                                                    fontSize: 18,
                                                    color: secondaryColor,
                                                  )
                                              ),
                                              Text(
                                                  "${post["comment"]}",
                                                  style: const TextStyle(
                                                    fontSize: 18,
                                                  )
                                                ),
                                            ]
                                        ),
                                      ],
                                    ),
                                  )
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                TextFormField(
                  controller: inputCont,
                  keyboardType: TextInputType.emailAddress,
                  onChanged: (value) {
                    setState(() {
                      currentLength = value.length;
                    });
                  },
                  obscureText: false,
                  maxLength: maxStatusCount,
                  decoration: InputDecoration(
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.send),
                      onPressed: () async {
                        commentsCont.animateTo(
                          commentsCont.position.minScrollExtent,
                          duration: Duration(milliseconds: 500),
                          curve: Curves.ease,
                        );

                        await _firestore.collection("comments").doc(widget.postID).set({
                          "comments": FieldValue.arrayUnion([{
                            "comment": inputCont.text,
                            "fullName": user?.fullName,
                          }]),
                        }, SetOptions(merge: true));

                        inputCont.clear();

                        setState(() {
                          currentLength = 0;
                          sentMessage = true;
                        });
                        },
                      ),
                      fillColor: secondaryColor,
                      hintStyle: const TextStyle(fontWeight: FontWeight.bold),
                      filled: true,
                      contentPadding: const EdgeInsets.all(20),
                      suffixText: "${maxStatusCount - currentLength} characters left!! :o",
                      counterText: "",
                    ),
                  ),
                ]
              ),
    );
  }
}