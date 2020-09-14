import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:secretchatting/Raw/user.dart';
import 'package:secretchatting/auth_methods_chat/users_state.dart';
import 'package:secretchatting/auth_methods_chat/utility.dart';
import 'package:secretchatting/auth_methods_chat/utils.dart';

class OnlineDotIndicator extends StatelessWidget {
  final String userId;

  final utility _authMethods = utility();

  OnlineDotIndicator({
    @required this.userId,
  });

  @override
  Widget build(BuildContext context) {
    GetColour(int state) {
      switch (Utils.numToState(state)) {
        case UsersState.Offline:
          return Colors.red;

        case UsersState.Online:
          return Colors.green;

        default:
          return Colors.orangeAccent;
      }
    }

    return StreamBuilder<DocumentSnapshot>(
      stream: utility.getUsersInfo(userId: userId),
      builder: (context, snapshot) {
        User user;

        if (snapshot.hasData && snapshot.data != null) {
          user = User.fromDocument(snapshot.data);
        }

        return Container(
          height: 10.0,
          width: 30.0,
          decoration: BoxDecoration(
              shape: BoxShape.circle, color: GetColour(user?.state)),
        );
      },
    );
  }
}
