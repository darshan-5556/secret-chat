import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String id;
  final String profileName;
  final String username;
  final String url;
  final String email;
  final String whyHere;
  final String intrest;
  final int state;
  final bool typingState;
  int userDiamond;
  bool isUserPopular;
  bool doesUserRecharge;
  String userRechargeFor;

  User({
    this.id,
    this.profileName,
    this.username,
    this.url,
    this.email,
    this.whyHere,
    this.intrest,
    this.state,
    this.typingState,
    this.userDiamond,
    this.isUserPopular,
    this.doesUserRecharge,
    this.userRechargeFor,
  });

  factory User.fromDocument(DocumentSnapshot doc) {
    return User(
      id: doc.documentID,
      email: doc['email'],
      username: doc['username'],
      url: doc['url'],
      profileName: doc['profileName'],
      whyHere: doc['whyHere'],
      intrest: doc['intrest'],
      state: doc['state'],
      typingState: doc['TypingState'],
      userDiamond: doc['userDiamond'],
      isUserPopular: doc['isUserPopular'],
      doesUserRecharge: doc['doesUserRecharge'],
      userRechargeFor: doc['userRechargeFor'],
    );
  }
}
