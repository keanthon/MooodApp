import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:moood/resources/auth_methods.dart';
import 'package:provider/provider.dart';
import '../models/user_class.dart';
import '../providers/user_provider.dart';
import '../utils/colors_styles.dart';
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
  final maxStatusCount = 20;
  bool select1=false, select2=false, select3=false, select4=false, select5=false;
  List<String> userStatuses = [];

  late Timer _timer;
  int _totalRecording = 5;
  bool _counterVisible = false;

  final RecorderStream _recorder = RecorderStream();

  List<Uint8List> recorderInput = [];
  bool _isRecording = false;

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
        body: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
              ),
              Text("Hi ! How are you doing?",
                  style: TextStyle(
                    color: secondaryColor,
                    fontSize: 24,
                  )),
              // these are suggested statuses
              Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10.0))),
                  margin: EdgeInsets.all(5),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        InkWell(
                          child: redCenteredContainer("😀", select1),
                          onTap: (){
                            setState(() {
                              select1 = true; select2=false; select3=false; select4=false; select5=false;
                            });
                            _emoji = "😀";
                          },
                        ),
                        InkWell(
                          child: redCenteredContainer("😔", select2),
                          onTap: (){
                            setState(() {
                              select1 = false; select2=true; select3=false; select4=false; select5=false;
                            });
                            _emoji = "😔";
                          },
                        ),
                        InkWell(
                          child: redCenteredContainer("😂", select3),
                          onTap: (){
                            setState(() {
                              select1 = false; select2=false; select3=true; select4=false; select5=false;
                            });
                            _emoji = "😂";
                          },
                        ),
                        InkWell(
                          child: redCenteredContainer("😭", select4),
                          onTap: (){
                            setState(() {
                              select1 = false; select2=false; select3=false; select4=true; select5=false;
                            });
                            _emoji = "😭";
                          },
                        ),
                        InkWell(
                          child: redCenteredContainer("🥰", select5),
                          onTap: (){
                            setState(() {
                              select1 = false; select2=false; select3=false; select4=false; select5=true;
                            });
                            _emoji = "🥰";
                          },
                        ),

                      ])),
              GestureDetector(
                onLongPressStart: (_) async {
                  _recorder.start();
                  recorderInput.clear();
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
                  label: const Text("Hold to record audio"),
                  icon: const Icon(Icons.mic),
                ),
              ),
              Visibility(
                visible: _counterVisible,
                child: Padding(
                  padding: EdgeInsets.all(25),
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
                margin:
                EdgeInsets.only(left: 10, top: 10, right: 10, bottom: 0),
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
                      ),
                  decoration: TextInputDecoration(
                      '... What a mood', Colors.redAccent[100])
                      .decorate(),
                ),
              ),
              Material(
                child: InkWell(
                  onTap: () {
                    AuthMethods().sendPost(
                        uid: user.uid,
                        status: statusController.text,
                        emoji: _emoji,
                        friends: user.friends,
                        recorderInput: recorderInput,
                        fullName: user.fullName,
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
            ],
          ),
        ),
      ),
    );
  }
}
