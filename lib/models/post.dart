import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';

class PostData {
  final DateTime date;
  final String uid;
  final String status;
  final String emoji;
  final List<Uint8List> recorderInput;
  final String fullName;
  final String proUrl;
  final List<double> location;
  // FIXME Add audio and location
  // final String audioClipDir;
  // Location

  const PostData({
    required this.uid,
    required this.status,
    required this.emoji,
    required this.date,
    required this.recorderInput,
    required this.fullName,
    required this.proUrl,
    required this.location,
  });

  Map<String, dynamic> toJson() => {
    'uid': uid,
    'status': status,
    'emoji': emoji,
    'date': date,
    'recorderInput': jsonEncode(recorderInput),
    'fullName': fullName,
    'proUrl': proUrl,
    'location': location,
  };

}

class PostsModel {
  bool hasMore = true;
  final int limit = 7;
  late QueryDocumentSnapshot lastVisibile;
  bool _isLoading = false;
  List<QueryDocumentSnapshot> _data = [];
  final StreamController<List<QueryDocumentSnapshot>> _controller = StreamController.broadcast();
  late Stream<List<QueryDocumentSnapshot>> stream;

  final String uid;
  final String feedOrPost;

  PostsModel({required this.uid, required this.feedOrPost}) {
    stream = _controller.stream;
    refresh();
  }


  Future<void> refresh() {
    return loadMore(clearCachedData: true);
  }

  Future<void> loadMore({bool clearCachedData = false}) async {

    if (clearCachedData) {
      _data = [];
      hasMore = true;
    }
    if (_isLoading || !hasMore) {
      return Future.value();
    }
    _isLoading = true;
    QuerySnapshot snapshots;

    if(clearCachedData) {
      snapshots = await FirebaseFirestore.instance
          .collection('userfeed')
          .doc(uid)
          .collection(feedOrPost)
          .orderBy('date', descending: true)
          .limit(limit).get();
      if(snapshots.docs.isNotEmpty) {
        lastVisibile = snapshots.docs[snapshots.docs.length - 1];
      }
      _data = snapshots.docs;
      // print(_data);
    }
    else {
      // print("here1");
      snapshots = await FirebaseFirestore.instance
          .collection('userfeed')
          .doc(uid)
          .collection(feedOrPost)
          .orderBy('date', descending: true).startAfterDocument(lastVisibile)
          .limit(limit).get();
      // print("here");
      _data.addAll(snapshots.docs);
    }
    // print(uid);
    _isLoading = false;
    hasMore = (snapshots.docs.length == limit);
    _controller.add(_data);

  }
}