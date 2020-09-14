import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:secretchatting/Login.dart';
import 'package:secretchatting/Raw/user.dart';
import 'package:secretchatting/auth_methods_chat/Online_dot_indicator.dart';
import 'package:secretchatting/chatSystem_chat/Message.dart';

class OnlineUsers extends StatefulWidget {
  @override
  _OnlineUsersState createState() => _OnlineUsersState();
}

class _OnlineUsersState extends State<OnlineUsers>
    with AutomaticKeepAliveClientMixin<OnlineUsers> {
  Future<QuerySnapshot> futuresearchResult;

  ControlSearching() {
    Future<QuerySnapshot> allUsers = usersRefrance
        .where("state", isEqualTo: 1)
        .where('isUserPopular', isEqualTo: false)
        .getDocuments();
    setState(() {
      futuresearchResult = allUsers;
    });
  }

  void initState() {
    super.initState();
    ControlSearching();
    displayUsersFoundscreen();
  }

  Container displaySearchResult() {
    final Orientation orientation = MediaQuery.of(context).orientation;
    return Container(
      child: Center(
        child: ListView(
          shrinkWrap: true,
          children: <Widget>[
            Icon(
              Icons.group,
              color: Colors.grey,
              size: 130.0,
            ),
            Text(
              "Search Users",
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.white70,
                  fontSize: 30,
                  fontWeight: FontWeight.w500),
            )
          ],
        ),
      ),
    );
  }

  displayUsersFoundscreen() {
    return FutureBuilder(
      future: futuresearchResult,
      builder: (context, dataSnapshot) {
        if (!dataSnapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        List<UserResult> searchResult = [];
        dataSnapshot.data.documents.forEach((document) {
          User eachUser = User.fromDocument(document);
          UserResult userResult = UserResult(eachUser);
          searchResult.add(userResult);
        });
        return ListView(children: searchResult);
      },
    );
  }

  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Currently Online Users"),
        backgroundColor: Colors.orange,
      ),
      backgroundColor: Colors.white,
      body: futuresearchResult == null
          ? displaySearchResult()
          : displayUsersFoundscreen(),
    );
  }
}

class UserResult extends StatelessWidget {
  final User eachUser;
  UserResult(this.eachUser);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(3.0),
      child: Card(
        color: Colors.orange[300],
        child: Container(
          // color: Colors.white70,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(20.0)),
          child: Column(
            children: <Widget>[
              Stack(
                children: <Widget>[
                  GestureDetector(
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.black,
                        backgroundImage: NetworkImage(eachUser.url),
                        child: Align(
                          alignment: Alignment.bottomRight,
                          child: Container(
                              height: 15.0,
                              width: 10.0,
                              child: OnlineDotIndicator(userId: eachUser.id)),
                        ),
                      ),
                      title: Text(
                        eachUser.username,
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        eachUser.whyHere,
                        style: TextStyle(color: Colors.black, fontSize: 13.0),
                      ),
                      trailing: eachUser.id != currentUser.id
                          ? GestureDetector(
                              onTap: () async {
                                await acceptRequestRefrance
                                    .document(eachUser.id)
                                    .collection("acceptRequest")
                                    .document(currentUser.id)
                                    .setData({
                                  //"canMessage": canMessage,
                                  "username": currentUser.username,
                                  "userDiamond": currentUser.userDiamond,
                                  "Time": DateTime.now()
                                      .millisecondsSinceEpoch
                                      .toString(),
                                  "userId": currentUser.id,
                                  "url": currentUser.url,
                                  "user": eachUser.username,
                                });

                                await acceptRequestRefrance
                                    .document(currentUser.id)
                                    .collection("acceptRequest")
                                    .document(eachUser.id)
                                    .setData({
                                  //"canMessage": canMessage,
                                  "username": eachUser.username,
                                  "Time": DateTime.now()
                                      .millisecondsSinceEpoch
                                      .toString(),
                                  "userId": eachUser.id,
                                  "userDiamond": currentUser.userDiamond,
                                  "url": eachUser.url,
                                  "user": currentUser.username,
                                });

                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Message(
                                            receiverId: eachUser.id,
                                            receiverUrl: eachUser.url,
                                            reciverUserName:
                                                eachUser.username)));
                              },
                              child: Container(
                                height: 50,
                                width: 70.0,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: Colors.blue,
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                                child: Text(
                                  'Chat',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 18.0),
                                ),
                              ),
                            )
                          : Container(
                              width: 0.0,
                              height: 0.0,
                            ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
