import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:moood/models/post.dart';

class UserClass {
  final String uid;
  final String username;
  final String firstName;
  final String lastName;
  final String fullName;
  final String insensitiveFullName;
  final String email;
  final String bio;
  final String photoUrl;
  List friends;
  List blocked;

  UserClass({
    required this.uid,
    required this.username,
    required this.firstName,
    required this.lastName,
    required this.fullName,
    required this.insensitiveFullName,
    required this.email,
    required this.bio,
    required this.photoUrl,
    required this.friends,
    required this.blocked,
  });

  Map<String, dynamic> toJson() => {
    'username': username,
    'firstName': firstName,
    'lastName': lastName,
    'fullName': fullName,
    'insensitiveFullName': insensitiveFullName,
    'uid': uid,
    'email': email,
    'bio': bio,
    'photoUrl': photoUrl,
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
        insensitiveFullName: snapshot['insensitiveFullName'],
        email: snapshot['email'],
        bio: snapshot['bio'],
        photoUrl: snapshot['photoUrl'],
        friends: snapshot['friends'],
        blocked: snapshot['blocked'] == null ? [] : snapshot['blocked'],
    );
  }
}