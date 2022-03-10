import 'package:cloud_firestore/cloud_firestore.dart';

class postData {
  final String uid;
  final String status;
  final String emoji;
  // FIXME Add audio and location
  // final String audioClipDir;
  // Location

  const postData({
    required this.uid,
    required this.status,
    required this.emoji,
  });

  Map<String, dynamic> toJson() => {
    'uid': uid,
    'status': status,
    'emoji': emoji,
  };
}