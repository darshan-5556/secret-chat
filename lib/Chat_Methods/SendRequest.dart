import 'package:flutter/material.dart';
import 'package:secretchatting/Login.dart';

class sendChatRequest {
  static int data;
  static void deductTenDiamond({@required userId, @required package}) =>
      // usersRefrance.document(userId).updateData({
      //   "userDiamond": currentUser.userDiamond - package,
      // });
      usersRefrance.document(userId).get().then((doc) {
        data = doc.data['userDiamond'];
        print(data.toString());
        usersRefrance.document(userId).updateData({
          'userDiamond': data - package,
        });
      });

  static void sendRequst(
          {@required userId,
          @required toWhome,
          @required url,
          @required id,
          @required packege,
          @required time}) =>
      chatRequestRefrance
          .document(id)
          .collection('chatRequest')
          .document(userId)
          .setData({
        "username": currentUser.username,
        "time": DateTime.now().millisecondsSinceEpoch.toString(),
        "to": toWhome,
        "url": url,
        "userId": userId,
        "doesAccepted": false,
        'package': packege,
        'Time': time,
      });
}
