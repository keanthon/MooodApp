import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:moood/resources/auth_methods.dart';
import 'package:moood/screens/profile.dart';

import '../utils/colors_styles.dart';
import '../utils/helper_functions.dart';
import '../utils/input_decoration.dart';

class NewPost extends StatefulWidget {
  const NewPost({Key? key}) : super(key: key);

  @override
  State<NewPost> createState() => _NewPostState();
}

class _NewPostState extends State<NewPost> {
  final User user = FirebaseAuth.instance.currentUser!;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController statusController = TextEditingController();
  String _emoji="";
  final maxStatusCount = 20;
  bool select1=false, select2=false, select3=false, select4=false, select5=false;
  List<String> userStatuses = [];

  @override
  Widget build(BuildContext context) {
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
              // FIXME friends
              Material(
                child: InkWell(
                  onTap: () {
                    AuthMethods().sendPost(uid: user.uid, status: statusController.text, emoji: _emoji);
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
