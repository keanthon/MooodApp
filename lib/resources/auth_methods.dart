import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import "package:flutter/material.dart";

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // sign up user
  Future<String> signUpUser({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required String username,

  }) async {
    String res = "Some error occurred";

    try{
      if(email.isNotEmpty || password.isNotEmpty || firstName.isNotEmpty ||
          lastName.isNotEmpty || username.isNotEmpty ) {
        // register user

        UserCredential cred = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);

        print(cred.user!.uid);
        // add user info to database
        _firestore.collection('users').doc(cred.user!.uid).set({
          'username': username,
          'firstName': firstName,
          'lastName': lastName,
          'uid': cred.user!.uid,
          'email': email,
          'bio': '',
          'followers': [],
          'following': [],
        });

        //

        res = "success";
      }
    } catch(err) {
      res = err.toString();
    }

    return res;
  }
}