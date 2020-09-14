import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:secretchatting/Login.dart';
import 'package:secretchatting/auth_methods_chat/users_state.dart';
import 'package:secretchatting/auth_methods_chat/utils.dart';

class utility {
  String userId = currentUser.id;

  bool isTyping = false;

  static void setTypingState({@required isTyping, @required userId}) {
    usersRefrance.document(userId).updateData({
      "TypingState": isTyping,
    });
  }

  Stream<DocumentSnapshot> getUsersTypingState({@required userId}) =>
      usersRefrance.document(userId).snapshots();

  static void setUserState(
      {@required String userId, @required UsersState userState}) {
    int stateNum = Utils.stateToNum(userState);

    print(stateNum);
    usersRefrance.document(userId).updateData({
      "state": stateNum,
    });
  }

  static Stream<DocumentSnapshot> getUsersInfo({@required userId}) =>
      usersRefrance.document(userId).snapshots();

  static Stream<QuerySnapshot> userNotification({@required userId}) =>
      chatRequestRefrance
          .document(userId)
          .collection('chatRequest')
          .snapshots();

  static Stream<QuerySnapshot> normaluserNotification({@required userId}) =>
      activityFeedRefrance.document(userId).collection('feed').snapshots();
}
