import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:secretchatting/Login.dart';
import 'package:secretchatting/chatSystem_Chat/Message.dart';

class NormalNotification extends StatefulWidget {
  @override
  _NormalNotificationState createState() => _NormalNotificationState();
}

class _NormalNotificationState extends State<NormalNotification> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Notifications'),
        centerTitle: true,
        backgroundColor: Colors.orange,
      ),
      body: StreamBuilder(
          stream: activityFeedRefrance
              .document(currentUser.id)
              .collection('feed')
              .snapshots(),
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
                            title: doc['doesAccepted'] != true
                                ? Text(
                                    doc['username'] +
                                        " Reject Your Chat Request.",
                                    style: TextStyle(
                                        fontSize: 18.0, color: Colors.black),
                                  )
                                : Text(
                                    doc['username'] +
                                        " Accept Your Chat Request.",
                                    style: TextStyle(
                                        fontSize: 16.0, color: Colors.black),
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
                            trailing: IconButton(
                                padding: EdgeInsets.only(bottom: 15.0),
                                icon: Icon(Icons.delete),
                                onPressed: () {
                                  activityFeedRefrance
                                      .document(currentUser.id)
                                      .collection('feed')
                                      .document(doc['userId'])
                                      .get()
                                      .then((doc) {
                                    if (doc.exists) {
                                      doc.reference.delete();
                                    }
                                  });
                                }),
                          ),
                          Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                doc['doesAccepted'] != false
                                    ? GestureDetector(
                                        onTap: () {
                                          // currentUser.doesUserRecharge = true;
                                          // (context as Element).markNeedsBuild();
                                          // usersRefrance
                                          //     .document(currentUser.id)
                                          //     .updateData({
                                          //   "doesUserRecharge": true,
                                          // });
                                          // TimerTest.startCounter(context);
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) => Message(
                                                        receiverId:
                                                            doc['userId'],
                                                        receiverUrl: doc['url'],
                                                        reciverUserName:
                                                            doc['username'],
                                                        receiverDiamond:
                                                            doc['userDiamond'],
                                                      )));
                                        },
                                        child: Container(
                                          height: 40.0,
                                          width: 150.0,
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                            color: Colors.blue[300],
                                            borderRadius:
                                                BorderRadius.circular(20.0),
                                          ),
                                          child: Text(
                                            "Chat",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 18.0),
                                          ),
                                        ),
                                      )
                                    : Container(),
                                Container(
                                  width: 30.0,
                                ),
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
