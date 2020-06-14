import 'package:cloud_firestore/cloud_firestore.dart';

import 'User.dart';

class Thread {
  String uid;
  List<User> users;
  List<dynamic>
      userUids; //cause List<String> causes some error in fromMap constructo
  Map<String, dynamic> events;
  Timestamp createdAt;
  String type;
  Thread({this.uid, this.userUids, this.createdAt, this.events, this.type});

  hasUserWithId(userUid) {
    return this
            .userUids
            .firstWhere((uid) => uid == userUid, orElse: () => null) !=
        null;
  }

  toMap() {
    return {
      "uid": this.uid,
      "userUids": this.userUids,
      "createdAt": this.createdAt,
      "events": this.events,
      "type": this.type,
    };
  }

  Thread.fromMap(details) {
    this.uid = details['uid'];
    // this.userUids = details['userUids'].cast<List<String>>();
    // details['userUids']
    this.userUids = details['userUids'].map((uid) => uid as String).toList();
    this.createdAt = details['createdAt'];
    this.events = details['events'];
    this.type = details['type'];
  }

  List<dynamic> userNames() {
    return (this.users != null ? this.users : [])
        .map((e) => e.userName)
        .toList();
  }

  getOtherUserInOneOneThread(String selfId) {
    if (this.type != "one-to-one") return null;
    if (this.users == null || this.users.length == 0) return null;
    return this.users.where((user) => user.uid != selfId).first;
  }
}
