import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:secretchatting/Raw/user.dart';
import 'package:secretchatting/auth_methods_chat/utility.dart';

class TypingState extends StatelessWidget {
  final String userId;

  final utility _utility = utility();

  String TypingStates = "";

  TypingState({
    @required this.userId,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: _utility.getUsersTypingState(userId: userId),
      builder: (context, snapshot) {
        User user;
        if (snapshot.hasData && snapshot.data != null) {
          user = User.fromDocument(snapshot.data);
          if (user.typingState != false) {
            TypingStates = "Typing..";
          } else {
            TypingStates = "";
          }
        }

        return Container(
          child: Text(
            TypingStates,
            style: TextStyle(color: Colors.white, fontSize: 12.0),
          ),
        );
      },
    );
  }
}
