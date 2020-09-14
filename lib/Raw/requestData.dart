import 'package:cloud_firestore/cloud_firestore.dart';

class requestData {
  String username;
  String toWhome;
  String time;
  bool doesAccepted;
  String url;
  String userId;

  requestData({
    this.username,
    this.toWhome,
    this.time,
    this.doesAccepted,
    this.url,
    this.userId,
  });

  Map toMap() {
    var map = Map<String, dynamic>();
    map['userId'] = this.userId;
    map['url'] = this.url;
    map['doesAccepted'] = this.doesAccepted;
    map['time'] = this.time;
    map['toWhome'] = this.toWhome;
    map['username'] = this.username;
    return map;
  }

  requestData.fromMap(Map<String, dynamic> map) {
    this.username = map['username'];
    this.toWhome = map['toWhome'];
    this.time = map['time'];
    this.doesAccepted = map['doesAccepted'];
    this.url = map['url'];
    this.userId = map['userId'];
  }
}
