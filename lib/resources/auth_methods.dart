import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import "package:flutter/material.dart";
import 'package:moood/models/post.dart';
import 'package:moood/models/user_class.dart';

import '../utils/globals.dart';
import '../utils/helper_functions.dart';

// Firebase Authentication Methods
class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<UserClass> getUserDetails() async {
    User currentUser = _auth.currentUser!;
    DocumentSnapshot snap = await _firestore.collection('users').doc(currentUser.uid).get();

    return UserClass.fromSnap(snap);
  }

  // sign up user
  Future<String> signUpUser({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required String username,

  }) async {
    String res = "Error occurred";

    try{
      if(email.isNotEmpty || password.isNotEmpty || firstName.isNotEmpty ||
          lastName.isNotEmpty || username.isNotEmpty ) {
        // register user

        UserCredential cred = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);

        await _auth.currentUser?.updateDisplayName(firstName + " " + lastName);

        //print(cred.user!.uid);
        // add user info to database

        UserClass usr = UserClass(
            uid: cred.user!.uid,
            username: username,
            firstName: firstName,
            lastName: lastName,
            fullName: "$firstName $lastName#${getShortUID(cred.user!.uid)}",
            email: email,
            bio: '',
            friends: [],
        );

        await _firestore.collection('users').doc(cred.user!.uid).set(usr.toJson());


        res = "success";
      }
    } catch(err) {
      res = err.toString();
    }

    return res;
  }

  // Login user
  Future<String> loginUser({
      required String email,
      required String password
    }) async {
    String res = "Some error occurred";

    try {
      if(email.isNotEmpty || password.isNotEmpty) {
        await _auth.signInWithEmailAndPassword(email: email, password: password);
        res = "success";
      }
    } catch(err) {
      res = err.toString();
    }
    return res;
  }

  // Send post
  Future<String> sendPost({
    required String uid,
    required String status,
    required String emoji,
  }) async {
    postData pos = postData(uid: uid, status: status, emoji: emoji);
    String res = "Error";

    try {
      await _firestore.collection("posts").add(pos.toJson());
      res = "success";
    } catch(err) {
      res = err.toString();
    }
    return res;
  }
}