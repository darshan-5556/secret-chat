import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:secretchatting/Raw/Message.dart';

class LastMessage extends StatelessWidget {
  final String senderId;
  final String receiverId;

  LastMessage({@required this.senderId, @required this.receiverId});

  String chatId;

  @override
  Widget build(BuildContext context) {
    if (senderId.hashCode <= receiverId.hashCode) {
      chatId = '$senderId-$receiverId';
    } else {
      chatId = '$receiverId-$senderId';
    }
    print(chatId);

    return StreamBuilder(
      stream: Firestore.instance
          .collection("messages")
          .document(chatId)
          .collection(chatId)
          .snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasData) {
          var docList = snapshot.data.documents;
          if (docList.isNotEmpty) {
            Message message = Message.fromMap(docList.last.data);
            return SizedBox(
              width: MediaQuery.of(context).size.width * 0.6,
              child: Text(
                message.message,
                style: TextStyle(color: Colors.black, fontSize: 14.0),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            );
          }
          return Text("");
        }
        return Text("....",
            style: TextStyle(color: Colors.black, fontSize: 14.0));
      },
    );
  }
}
