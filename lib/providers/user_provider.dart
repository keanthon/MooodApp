import 'package:flutter/material.dart';
import 'package:moood/models/user_class.dart';
import 'package:moood/resources/auth_methods.dart';


// Provider essentially provides the data to components below the widget tree
// ChangeNotifier notify its listener when there is change
class UserProvider with ChangeNotifier {
  UserClass? _user;
  Map<String, dynamic>? _lastPost;
  String? _lastPID;
  final AuthMethods _authMethods = AuthMethods();

  // Syntatic sugar
  // same as UserClass getUser(){ return _user;}
  UserClass? get getUser => _user;
  Map<String, dynamic>? get getLastPost => _lastPost;
  String? get getLastPID => _lastPID;

  Future<void> refreshUser() async {
    // user data gets updated
    UserClass user = await _authMethods.getUserDetails();
    _user = user;
    // tell listeners to rebuild
    notifyListeners();
  }

  Future<void> refreshLastPost() async {
    List? postInfo = await _authMethods.lastPost(_user?.uid);
    _lastPID = postInfo[0];
    _lastPost = postInfo[1];
    notifyListeners();
  }

  void setLastPostInfo(Map<String, dynamic> pos, String pid) {
    _lastPost = pos;
    _lastPID = pid;
    notifyListeners();
  }
}