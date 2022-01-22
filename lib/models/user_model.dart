import 'package:algolia/algolia.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String? uid;
  String? imgUrl;
  String? fcmToken;
  DateTime modified;
  DateTime created;
  String username;
  int coins;
  bool isAdmin;
  bool isOnline;

  UserModel({
    required this.uid,
    required this.imgUrl,
    required this.modified,
    required this.created,
    required this.username,
    this.fcmToken,
    required this.coins,
    required this.isAdmin,
    required this.isOnline,
  });

  factory UserModel.fromDoc({required DocumentSnapshot data}) {
    return UserModel(
      imgUrl: data['imgUrl'],
      created: data['created'].toDate(),
      modified: data['modified'].toDate(),
      uid: data['uid'],
      username: data['username'],
      fcmToken: data['fcmToken'],
      coins: data['coins'],
      isAdmin: data['isAdmin'],
      isOnline: data['isOnline'],
    );
  }

  factory UserModel.fromAlgolia(AlgoliaObjectSnapshot aob) {
    Map<String, dynamic> data = aob.data;
    return UserModel(
      imgUrl: data['imgUrl'],
      created: DateTime.now(), //TODO: Convert properly...
      modified: DateTime.now(), //TODO: Convert properly...
      uid: data['uid'],
      username: data['username'],
      fcmToken: data['fcmToken'],
      coins: data['coins'],
      isAdmin: data['isAdmin'],
      isOnline: data['isOnline'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'imgUrl': imgUrl,
      'created': created,
      'modified': modified,
      'uid': uid,
      'username': username,
      'fcmToken': fcmToken,
      'coins': coins,
      'isAdmin': isAdmin,
      'isOnline': isOnline,
    };
  }
}
