import 'package:flutter/material.dart';
import 'package:secretchatting/Login.dart';

class addDiamond {
  int diamond;
  static int data;
  static String receiverId;
  static void getData(
      {@required receiverId, @required package}) {
    var PopularData = usersRefrance.document(receiverId).get().then((doc) {
      data = doc.data['userDiamond'];
      print(data.toString());
      usersRefrance.document(receiverId).updateData({
        'userDiamond': data + package,
      });
    });
  }
}
