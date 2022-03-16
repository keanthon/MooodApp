import 'package:flutter/material.dart';
import 'package:moood/models/user_class.dart';
import 'package:moood/resources/auth_methods.dart';

// Provider essentially provides the data to components below the widget tree
// ChangeNotifier notify its listener when there is change
class UserProvider with ChangeNotifier {
  UserClass? _user;
  final AuthMethods _authMethods = AuthMethods();

  // Syntatic sugar
  // same as UserClass getUser(){ return _user;}
  UserClass? get getUser => _user!;

  Future<void> refreshUser() async {
    // user data gets updated
    UserClass user = await _authMethods.getUserDetails();
    _user = user;

    // tell listeners to rebuild
    notifyListeners();
  }
}