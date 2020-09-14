import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:secretchatting/Login.dart';
import 'package:secretchatting/Normal_Person/MainPage.dart';
import 'package:secretchatting/auth_methods_chat/utility.dart';
import 'package:secretchatting/chatSystem_Chat/Message.dart';
import 'package:secretchatting/Chat_Methods/addDiamond.dart';

class NotificationPage extends StatefulWidget {
  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  bool isLoading = false;
  int value;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications'),
        centerTitle: true,
        backgroundColor: Colors.orange,
      ),
      body: StreamBuilder(
          stream: utility.userNotification(userId: currentUser.id),
          builder: (context, snapshot) {
            //requestData data;
            if (snapshot.hasData && snapshot.data != null) {
              // data = requestData.fromMap(snapshot.data);

              return ListView.builder(
                  itemCount: snapshot.data.documents.length,
                  itemBuilder: (context, index) {
                    DocumentSnapshot doc = snapshot.data.documents[index];
                    return Container(
                      color: Colors.orange[200],
                      child: Column(
                        children: <Widget>[
                          ListTile(
                            title: Text(
                              doc['username'],
                              style: TextStyle(
                                  fontSize: 18.0, color: Colors.black),
                            ),
                            leading: CircleAvatar(
                                backgroundImage: CachedNetworkImageProvider(
                              doc['url'],
                            )),
                            subtitle: Text(
                              DateFormat.jm().format(
                                  DateTime.fromMillisecondsSinceEpoch(
                                      int.parse(doc["time"]))),
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 13.0,
                                  fontStyle: FontStyle.italic),
                            ),
                          ),
                          Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                GestureDetector(
                                  onTap: () async {
                                    ///// creating activityFeedRefrance for receiver user/////
                                    await activityFeedRefrance
                                        .document(doc['userId'])
                                        .collection('feed')
                                        .document(currentUser.id)
                                        .setData({
                                      "doesAccepted": true,
                                      'userDiamond': currentUser.userDiamond,
                                      "userId": currentUser.id,
                                      "url": currentUser.url,
                                      "time": DateTime.now()
                                          .millisecondsSinceEpoch
                                          .toString(),
                                      "username": currentUser.username,
                                    });
                                    ////for adding diamonds//
                                    await usersRefrance
                                        .document(currentUser.id)
                                        .updateData({
                                      "userDiamond": currentUser.userDiamond +
                                          doc['package'],
                                    });
                                    setState(() {
                                      currentUser.userDiamond =
                                          currentUser.userDiamond +
                                              doc['package'];
                                    });
                                    ////creating timer for user///
                                    // await usersRefrance
                                    //     .document(doc['userId'])
                                    //     .collection("chattingWith")
                                    //     .document(currentUser.id)
                                    //     .setData({
                                    //   "userId": currentUser.id,
                                    //   "currentUserId": doc['userId'],
                                    //   "Time": doc['Time'],
                                    // });
                                    print(doc['userId']);
                                    usersRefrance
                                        .document(doc['userId'])
                                        .collection("chattingWith")
                                        .document(currentUser.id)
                                        .setData({
                                      "userId": currentUser.id,
                                      "currentUserId": doc['userId'],
                                      "time": doc['Time'],
                                    });
                                    ////creating refrance for receiver
                                    await acceptRequestRefrance
                                        .document(doc['userId'])
                                        .collection("acceptRequest")
                                        .document(currentUser.id)
                                        .setData({
                                      //"canMessage": canMessage,
                                      "username": currentUser.username,
                                      "Time": DateTime.now()
                                          .millisecondsSinceEpoch
                                          .toString(),
                                      "userId": currentUser.id,
                                      'userDiamond': currentUser.userDiamond,
                                      "url": currentUser.url,
                                      "user": doc['username'],
                                    });
                                    await acceptRequestRefrance
                                        .document(currentUser.id)
                                        .collection("acceptRequest")
                                        .document(doc['userId'])
                                        .setData({
                                      //"canMessage": canMessage,
                                      "username": doc['username'],
                                      "Time": DateTime.now()
                                          .millisecondsSinceEpoch
                                          .toString(),
                                      "userId": doc['userId'],
                                      "url": doc['url'],
                                      'userDiamond': currentUser.userDiamond,
                                      "user": currentUser.username,
                                    });

                                    await chatRequestRefrance
                                        .document(currentUser.id)
                                        .collection('chatRequest')
                                        .document(doc['userId'])
                                        .get()
                                        .then((document) {
                                      if (document.exists) {
                                        document.reference.delete();
                                      }
                                    });

                                    await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => Message(
                                                receiverId: doc['userId'],
                                                receiverUrl: doc['url'],
                                                reciverUserName:
                                                    doc['username'])));
                                  },
                                  child: Container(
                                    height: 40.0,
                                    width: 150.0,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      color: Colors.green,
                                      borderRadius: BorderRadius.circular(20.0),
                                    ),
                                    child: Text(
                                      "Accept",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 18.0),
                                    ),
                                  ),
                                ),
                                Container(
                                  width: 70.0,
                                ),
                                GestureDetector(
                                  onTap: () async {
                                    await activityFeedRefrance
                                        .document(doc['userId'])
                                        .collection('feed')
                                        .document(currentUser.id)
                                        .setData({
                                      "doesAccepted": false,
                                      "userId": currentUser.id,
                                      "url": currentUser.url,
                                      "time": DateTime.now()
                                          .millisecondsSinceEpoch
                                          .toString(),
                                      "username": currentUser.username,
                                    });
                                    ////////////problem is here/////////////
                                    // await usersRefrance
                                    //     .document(doc['userId'])
                                    //     .get()
                                    //     .then((doc) {
                                    //   if (doc.exists) {
                                    //     value = doc.data['userDiamond'];
                                    //     usersRefrance
                                    //         .document(doc["userId"])
                                    //         .updateData({
                                    //       "userDiamond": value + doc["package"],
                                    //     });
                                    //   }
                                    // });
                                    await addDiamond.getData(
                                        receiverId: doc['userId'],
                                        package: doc['package']);
                                    await chatRequestRefrance
                                        .document(currentUser.id)
                                        .collection('chatRequest')
                                        .document(doc['userId'])
                                        .get()
                                        .then((document) {
                                      if (document.exists) {
                                        document.reference.delete();
                                      }
                                    });
                                  },
                                  child: Container(
                                      height: 40.0,
                                      width: 150.0,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        color: Colors.red,
                                        borderRadius:
                                            BorderRadius.circular(20.0),
                                      ),
                                      child: Text(
                                        "Decline",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 18.0),
                                      )),
                                ),
                                Divider(
                                  color: Colors.black,
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  });
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          }),
    );
  }
}
