import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:moood/resources/auth_methods.dart';
import 'package:provider/provider.dart';
import '../models/user_class.dart';
import '../providers/user_provider.dart';
import '../utils/colors_styles.dart';
import '../utils/globals.dart';
import '../utils/helper_functions.dart';
import '../utils/input_decoration.dart';
import 'package:sound_stream/sound_stream.dart';

class NewPost extends StatefulWidget {
  const NewPost({Key? key}) : super(key: key);

  @override
  State<NewPost> createState() => _NewPostState();
}

class _NewPostState extends State<NewPost> {
  final TextEditingController statusController = TextEditingController();
  String _emoji="";
  bool select1=false, select2=false, select3=false, select4=false, select5=false;
  List<String> userStatuses = [];

  late Timer _timer;
  int _totalRecording = 5;
  bool _counterVisible = false;

  final RecorderStream _recorder = RecorderStream();
  List<Uint8List> recorderInput = [];
  bool _isRecording = false;
  bool alreadyRecorded = false;

  ScrollController sc = ScrollController();

  late StreamSubscription _recorderStatus;

  void startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (mounted) {
          if (_totalRecording == 0) {
            stopRecording();
          } else {
            setState(() {
              _totalRecording--;
            });
          }
        }
      },
    );
  }

  void stopRecording() {
    if (_isRecording) {
      _recorder.stop();
    }
    setState(() {
      _timer.cancel();
      _counterVisible = false;
      _totalRecording = 5;
      alreadyRecorded = true;
    });
  }

  Future<void> initializeRecorder() async {
    _recorderStatus = _recorder.status.listen((status) {
      if (mounted)
        setState(() {
          _isRecording = status == SoundStreamStatus.Playing;
        });
    });

    _recorder.audioStream.listen((data) {
      recorderInput.add(data);
    });

    await _recorder.initialize();
  }

  @override
  void initState() {
    super.initState();
    initializeRecorder();
  }

  @override
  void dispose() {
    _recorderStatus.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    UserClass? user = Provider.of<UserProvider>(context).getUser;
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          reverse: true,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
              ),
              const Text("How's it going?",
                  style: TextStyle(
                    color: secondaryColor,
                    fontSize: 24,
                  )),
              Row(
                  children: <Widget>[
                    Column(
                        children: [
                          for (var i = 0; i < 7; ++i)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                for (var j = i * 5 + 1; j <= i * 5 + 5; ++j)
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.all(Radius.circular(40)),
                                      border: Border.all(
                                        width: 1,
                                        color: _emoji == "assets/images/${j.toString()}.png" ? red : Colors.transparent,
                                        style: BorderStyle.solid,
                                      ),
                                    ),
                                    child: IconButton(
                                      icon: Image.asset("assets/images/$j.png"),
                                      iconSize: 60,
                                      splashColor: pink,
                                      onPressed: () {
                                        setState(() {
                                          _emoji = "assets/images/${j.toString()}.png";
                                        });
                                      },
                                      splashRadius: 50,
                                    ),
                                  ),
                              ],
                            )
                        ],
                    ),
                  ],
                ),
              GestureDetector(
                onLongPressStart: (_) async {
                  recorderInput.clear();
                  _recorder.start();
                  setState(() {
                    startTimer();
                    _counterVisible = true;
                  });
                },
                onLongPressEnd: (_) {
                  stopRecording();
                },
                child: ElevatedButton.icon(
                  onPressed: () {},
                  label: alreadyRecorded ? const Text("Re-record audio!") : const Text("Hold to record audio!"),
                  icon: const Icon(Icons.mic),
                  style: ElevatedButton.styleFrom(
                    primary: alreadyRecorded ? secondaryColor : michiganBlue,
                  ),
                )
              ),
                Visibility(
                  visible: _counterVisible,
                  child: Padding(
                    padding: const EdgeInsets.all(25),
                    child: Text(
                      _totalRecording.toString(),
                      style: const TextStyle(
                        color: secondaryColor,
                        fontSize: 60,
                      )
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(left: 10, top: 10, right: 10, bottom: 10),
                  child: TextFormField(
                    validator: requireFunc,
                    controller: statusController,
                    keyboardType: TextInputType.text,
                    obscureText: false,
                    maxLength: maxStatusCount,
                    buildCounter: (_,
                        {required currentLength,
                          maxLength,
                          required isFocused}) =>
                        Padding(
                          padding: const EdgeInsets.only(left: 16.0),
                          child: Text(
                            (maxLength! - currentLength).toString() +
                                " characters left!!",
                            style: TextStyle(color: secondaryColor, fontSize: 18),
                          ),
                        )
                  )
              ),
                Material(
                  child: InkWell(
                    onTap: () async {
                      // refresh to get the latest friend list
                      await Provider.of<UserProvider>(context, listen: false).refreshUser();
                      user = Provider.of<UserProvider>(context, listen: false).getUser;
                      print("in inkwell post button");

                      String res = await AuthMethods().sendPost(
                          uid: user!.uid,
                          status: statusController.text,
                          emoji: _emoji,
                          friends: user!.friends,
                          recorderInput: recorderInput,
                          fullName: user!.fullName,
                          proUrl: user!.photoUrl,
                          context: context,
                      );

                      Navigator.pop(context);

                    },
                    splashColor: secondaryColor,
                    child: Container(
                      padding: EdgeInsets.all(10),
                      child: const Text(
                        "Post",
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 25),
                ),
              ]
            ),
          ),
        ),
      );
  }
}

