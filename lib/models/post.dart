import 'package:cloud_firestore/cloud_firestore.dart';

class postData {
  final String status;
  final String emoji;
  // FIXME Add audio and location
  // final String audioClipDir;
  // Location

  const postData({
    required this.status,
    required this.emoji,
  });
}