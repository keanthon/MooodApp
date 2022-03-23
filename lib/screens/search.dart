import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../models/user_class.dart';
import '../utils/colors_styles.dart';
import '../utils/helper_functions.dart';
import '../utils/input_decoration.dart';


class Search extends StatefulWidget {
  const Search({Key? key, required this.user}) : super(key: key);
  final UserClass user;

  @override
  State<Search> createState() => SearchState(user);
}

class SearchState extends State<Search> {
  SearchState(this.user, {Key? key}) {
    friendsSet = castIntoUIDSet(user.friends);
  }

  final TextEditingController searchCont = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final UserClass user;
  FocusNode focusNode = FocusNode();

  List<QueryDocumentSnapshot<Map<String, dynamic>>> suggestedProfiles = [];
  Map<String, List<dynamic>> UIDToColorText = {};
  Set<String> friendsSet = {};

  void sendFriendRequest(String uid) {
    _firestore.collection("users")
        .doc(uid)
        .update({"friendRequests": FieldValue.arrayUnion([{
          "UID": user.uid,
          "fullName": user.fullName,
        }])});
  }

  void getSuggestions(String input) {
    if (input == "") {
      setState(() {
        suggestedProfiles = [];
      });
    } else {
      _firestore.collection("users")
          .where("fullName", isGreaterThanOrEqualTo: input)
          .where("fullName", isLessThanOrEqualTo: input + "\uf8ff")
          .limit(5)
          .get()
          .then((value) {
        setState(() {
          suggestedProfiles = value.docs.toList();
          for (var value in suggestedProfiles) {
            if (friendsSet.contains(value.get("uid"))) {
              UIDToColorText[value.get("uid")] = [postCardColor, "Already friends"];
            }
            else if (!UIDToColorText.containsKey(value.get("uid"))) {
              UIDToColorText[value.get("uid")] = [postCardColor, "Send friend request"];
            }
          }
        });
      });
    }
  }

  Widget displaySuggestedProfiles(List<QueryDocumentSnapshot<Map<String, dynamic>>> suggestedProfiles, UserClass user) {
    List<Widget> withoutMe = [];
    suggestedProfiles.forEach((value) {
      if (value.get("uid") != user.uid) {
        String UID = value.get("uid");
        withoutMe.add(
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  color: blue,
                ),
                padding: EdgeInsets.all(10),
                margin: EdgeInsets.all(20),
                child: Text(
                    value.get("fullName"),
                    style: TextStyle(
                      fontSize: 18,
                      color: primaryColor,
                    )
                )
              ),
              Material(
                color: UIDToColorText[UID]![0],
                shape:  OutlineInputBorder(
                  borderRadius: BorderRadius.circular(40),
                  borderSide: const BorderSide(width: 0, color: Colors.white70),
                ),
                child: InkWell(
                  onTap: () {
                    if (!friendsSet.contains(UID) && UIDToColorText[UID]![1] == "Send friend request") {
                      setState(() {
                        UIDToColorText[UID]![0] = red;
                        UIDToColorText[UID]![1] = "Sent!!";
                        sendFriendRequest(UID);
                      });
                    }
                  },
                  splashColor: secondaryColor,
                  child: Container(
                    padding: EdgeInsets.all(10),
                    child: Text(
                      UIDToColorText[UID]![1],
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ),
              ),
            ],
          )
        );
      }
    });

    return Column(
      children: withoutMe,
    );
  }

  @override
  Widget build(BuildContext context) {
    FocusScope.of(context).requestFocus(focusNode);

    return Scaffold(
        appBar: AppBar(
          backgroundColor: grey,
          centerTitle: true,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: const <Widget>[
              Text(
                  "Search for people",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 24,
                  )
              ),
            ],
          ),
        ),
        body: SingleChildScrollView(
          child: Center (
              child: Column (
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    TextFormField(
                      focusNode: focusNode,
                      controller: searchCont,
                      keyboardType: TextInputType.emailAddress,
                      onChanged: getSuggestions,
                      obscureText: false,
                      decoration: TextInputDecoration(
                          '[First name] [last name]#[ID] ...',
                          Colors.redAccent[100]).decorate(),
                    ),
                    Column (
                      children: [
                        displaySuggestedProfiles(suggestedProfiles, user),
                      ]
                    ),
                  ]
              )
      ),
        )
    );
  }
}