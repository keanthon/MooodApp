import 'package:cloud_firestore/cloud_firestore.dart';

class UserClass {
  final String uid;
  final String username;
  final String firstName;
  final String lastName;
  final String email;
  final String bio;
  final List followers;
  final List following;

  const UserClass({
    required this.uid,
    required this.username,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.bio,
    required this.followers,
    required this.following,
  });

  Map<String, dynamic> toJson() => {
    'username': username,
    'firstName': firstName,
    'lastName': lastName,
    'uid': uid,
    'email': email,
    'bio': bio,
    'followers': followers,
    'following': following,
  };

  // function to decode the json from snapshot
  static UserClass fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return UserClass(
        uid: snapshot['uid'],
        username: snapshot['username'],
        firstName: snapshot['firstName'],
        lastName: snapshot['lastName'],
        email: snapshot['email'],
        bio: snapshot['bio'],
        followers: snapshot['followers'],
        following: snapshot['following'],
    );
  }
}