import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import "package:flutter/material.dart";
import 'package:moood/models/post.dart';
import 'package:moood/models/user_class.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../providers/user_provider.dart';
import '../utils/helper_functions.dart';


// Firebase Authentication Methods
class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<UserClass> getUserDetails() async {
    User currentUser = _auth.currentUser!;
    DocumentSnapshot snap = await _firestore.collection('users').doc(currentUser.uid).get();
    // print(snap.data());
    return UserClass.fromSnap(snap);
  }

  // sign up user
  Future<String> signUpUser({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required String username,
    required Uint8List file,
  }) async {
    String res = "Error occurred";

    try{
      if(email.isNotEmpty || password.isNotEmpty || firstName.isNotEmpty ||
          lastName.isNotEmpty || username.isNotEmpty ) {
        // register user

        UserCredential cred = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);

        // get profphotourl
        String photoUrl =
        await uploadImageToStorage('profilePics', file, false);

        await _auth.currentUser?.updateDisplayName(firstName + " " + lastName);

        // add user info to database

        UserClass usr = UserClass(
            uid: cred.user!.uid,
            username: username,
            firstName: firstName,
            lastName: lastName,
            fullName: "$firstName $lastName#${getShortUID(cred.user!.uid)}",
            insensitiveFullName: "$firstName $lastName#${getShortUID(cred.user!.uid)}".toLowerCase(),
            email: email,
            bio: '',
            friends: [],
            photoUrl: photoUrl,
            blocked: [],
        );

        _firestore.collection('users').doc(cred.user!.uid).set(usr.toJson());

        res = "success";
        // print(res);
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
    required List friends,
    required List<Uint8List> recorderInput,
    required String fullName,
    required String proUrl,
    required List<double> location,
    required BuildContext context,
  }) async {


    String res = "Error";

    try {

      List<WriteBatch> batchArray = [];
      batchArray.add(_firestore.batch());
      int operationCount =0, batchIndex = 0;

      var pos = PostData(uid: uid, status: status, emoji: emoji, date: Timestamp.fromDate(DateTime.now()),
          recorderInput: recorderInput, fullName: fullName, proUrl: proUrl, location: location).toJson();

      // put in allPost collection as a place holder to avoid collision
      var ref = _firestore.collection("allPost").doc();
      // Just sending data data so it's faster
      batchArray[batchIndex].set(ref, {'date':pos['date']});

      // put in my posts
      ref = _firestore.collection("userfeed").doc(uid).collection("posts").doc(ref.id);
      batchArray[batchIndex].set(ref, pos);
      
      // put in my feed
      ref = _firestore.collection("userfeed").doc(uid).collection("feed").doc(ref.id);
      batchArray[batchIndex].set(ref, pos);

      // put in my friends feed using batch array
      for(var friend in friends) {
        var friendRef = _firestore.collection("userfeed").doc(friend["UID"]).collection("feed").doc(ref.id);
        batchArray[batchIndex].set(friendRef, pos);
        operationCount++;
        if(operationCount==490) {
          batchArray.add(_firestore.batch());
          batchIndex++;
          operationCount = 0;
        }
      }

      for(var b in batchArray) {
        await b.commit();
      }
      res = "success";

      if(res=="success") {
        Provider.of<UserProvider>(context, listen: false).setLastPostInfo(pos, ref.id);
      }
    } catch(err) {

    }

    return res;
  }

  // Delete post
  Future<String> deletePost(String uid, String pid, List friends) async {
    String res = "Error";
    try {
      List<WriteBatch> batchArray = [];
      batchArray.add(_firestore.batch());
      int operationCount =0, batchIndex = 0;

      // delete from universal
      var ref = _firestore.collection("allPost").doc(pid);
      batchArray[batchIndex].delete(ref);

      // delete from my post and feed
      ref = _firestore.collection("userfeed").doc(uid).collection("posts").doc(pid);
      batchArray[batchIndex].delete(ref);

      ref = _firestore.collection("userfeed").doc(uid).collection("feed").doc(pid);
      batchArray[batchIndex].delete(ref);

      // Delete from my friends feed using batch array
      for(var friend in friends) {
        var friendRef = _firestore.collection("userfeed").doc(friend["UID"]).collection("feed").doc(pid);
        batchArray[batchIndex].delete(friendRef);
        operationCount++;
        if(operationCount==490) {
          batchArray.add(_firestore.batch());
          batchIndex++;
          operationCount = 0;
        }
      }

      for(var b in batchArray) {
        await b.commit();
      }

      res = "success";

    }
    catch(err) {
      res = err.toString();
    }
    return res;
  }

  Future<void> signOut() async {
    _auth.signOut();
    _firestore.clearPersistence();
  }

  Future<List<dynamic>> lastPost(uid) async {
    var snapshot =  await
        _firestore
        .collection('userfeed')
        .doc(uid)
        .collection("posts")
        .orderBy('date', descending: true)
        .limit(1).get();

    if(snapshot.docs.length==0) {
      return [null, null];
    }
    else {
      return [snapshot.docs[0].id, snapshot.docs[0].data()];
    }

  }

  // adding image to firebase storage
  Future<String> uploadImageToStorage(String childName, Uint8List file, bool isPost) async {
    // creating location to our firebase storage

    Reference ref =
    _storage.ref().child(childName).child(_auth.currentUser!.uid);
    if(isPost) {
      String id = const Uuid().v1();
      ref = ref.child(id);
    }

    // putting in uint8list format -> Upload task like a future but not future
    UploadTask uploadTask = ref.putData(
        file
    );

    TaskSnapshot snapshot = await uploadTask;
    String downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  Future<String> reportPost(snap) async {
    String res = "error";
    try {
      await _firestore.collection("reported").doc(snap["uid"]).collection("posts").add(snap);
      res = "success";
    }
    catch(err) {
      res = err.toString();
    }
    return res;
  }

  void blockFriend(String uid, Map<String, dynamic> friend) {
    _firestore.collection("users").doc(uid).update({
      "blocked": FieldValue.arrayUnion([friend]),
    });
  }

  void removeFriend(String uid, String proUrl, String fullName, Map<String, dynamic> friend) {
    // remove from each other's friend lists
    _firestore.collection("users").doc(uid).update({
      "friends": FieldValue.arrayRemove([friend]),
    });

    _firestore.collection("users").doc(friend["UID"]).update({
      "friends": FieldValue.arrayRemove([{
        "UID": uid,
        "fullName": fullName,
        "proUrl": proUrl,
      }]),
    });

    // remove content from each other's feeds
    _firestore.collection("userfeed").doc(uid).collection("feed")
        .where("fullName", isEqualTo: friend["fullName"])
        .get()
        .then((value) {
      value.docs.forEach((element) {
        element.reference.delete();
      });
    });

    _firestore.collection("userfeed").doc(friend["UID"]).collection("feed")
        .where("fullName", isEqualTo: fullName)
        .get()
        .then((value) {
      value.docs.forEach((element) {
        element.reference.delete();
      });
    });
  }

  Future<void> deleteAccount(List friends) async {
    // get all his post
    String uid = _auth.currentUser!.uid;
    var snapshots = await _firestore.collection("userfeed").doc(uid).collection("posts").get();

    // delete from all friends
    for (var doc in snapshots.docs) {
      deletePost(uid, doc.id, friends);
      // remove from all posts
      _firestore.collection("allPost").doc(doc.id).delete();
    }
    _auth.currentUser!.delete();
  }

  Future<void> resetPassword(String email) async {
    _auth.sendPasswordResetEmail(email: email);
  }
}
