import 'package:cloud_firestore/cloud_firestore.dart';

class UserClass {
  final String uid;
  final String username;
  final String firstName;
  final String lastName;
  final String fullName;
  final String email;
  final String bio;
  final List friends;

  const UserClass({
    required this.uid,
    required this.username,
    required this.firstName,
    required this.lastName,
    required this.fullName,
    required this.email,
    required this.bio,
    required this.friends,
  });

  Map<String, dynamic> toJson() => {
    'username': username,
    'firstName': firstName,
    'lastName': lastName,
    'fullName': fullName,
    'uid': uid,
    'email': email,
    'bio': bio,
    'friends': friends,
  };

  // function to decode the json from snapshot
  static UserClass fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return UserClass(
        uid: snapshot['uid'],
        username: snapshot['username'],
        firstName: snapshot['firstName'],
        lastName: snapshot['lastName'],
        fullName: snapshot['fullName'],
        email: snapshot['email'],
        bio: snapshot['bio'],
        friends: snapshot['friends'],
    );
  }
}