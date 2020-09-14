import 'package:badges/badges.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:secretchatting/Login.dart';
import 'package:secretchatting/Chat_Methods/LastMsg.dart';
import 'package:secretchatting/auth_methods_chat/Online_dot_indicator.dart';
import 'package:secretchatting/chatSystem_Chat/FullPhoto.dart';
import 'package:secretchatting/chatSystem_Chat/Message.dart';

class PopularMyChats extends StatefulWidget {
  @override
  _PopularMyChatsState createState() => _PopularMyChatsState();
}

class _PopularMyChatsState extends State<PopularMyChats>
    with AutomaticKeepAliveClientMixin<PopularMyChats> {
  TextEditingController searchTextEditingcontroller =
      new TextEditingController();
  Future<QuerySnapshot> futuresearchResult;

  String currentId;

  void initState() {
    super.initState();
    currentId = currentUser.id;
    AlreadySearch();
  }

  AlreadySearch() {
    Future<QuerySnapshot> allUsers = acceptRequestRefrance
        .document(currentId)
        .collection("acceptRequest")
        .getDocuments();
    setState(() {
      futuresearchResult = allUsers;
      print(currentId);
    });
  }

  ControlSearching(String str) {
    Future<QuerySnapshot> allUsers = acceptRequestRefrance
        .document(currentId)
        .collection("acceptRequest")
        .where("username", isGreaterThanOrEqualTo: str)
        .getDocuments();
    setState(() {
      futuresearchResult = allUsers;
      print(currentId);
    });
  }

  emptyTheText() {
    searchTextEditingcontroller.clear();
  }

  AppBar searchPageHeader() {
    return AppBar(
      automaticallyImplyLeading: true,
      backgroundColor: Colors.orange,
      title: TextFormField(
        style: TextStyle(fontSize: 18.0, color: Colors.white),
        controller: searchTextEditingcontroller,
        decoration: InputDecoration(
            hintText: "Search here..",
            hintStyle: TextStyle(color: Colors.white),
            enabledBorder: UnderlineInputBorder(
              borderRadius: BorderRadius.circular(20.0),
              // borderSide: BorderSide(color: Colors.white70),
            ),
            filled: true,
            fillColor: Colors.blue,
            prefixIcon:
                Icon(Icons.person_pin, color: Colors.white70, size: 30.0),
            suffixIcon:
                IconButton(icon: Icon(Icons.clear), onPressed: emptyTheText)),
        onFieldSubmitted: ControlSearching,
      ),
    );
  }

  Container displaySearchResult() {
    if (futuresearchResult == 0) {
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
    } else {
      displayUsersFoundscreen();
    }
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
          searchResult.add(UserResult.fromDocument(document));
        });
        return ListView(children: searchResult);
      },
    );
  }

  bool get wantKeepAlive => true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: searchPageHeader(),
      body: futuresearchResult == null
          ? displaySearchResult()
          : displayUsersFoundscreen(),
    );
  }
}

class UserResult extends StatelessWidget {
//   final User eachUser;
//  UserResult({this.eachUser});

  String id;

  final String username;
  final String userId;
  final String url;
  final String timestamp;
  // final bool canMessage;
  UserResult({
    this.username,
    this.userId,
    this.url,
    this.timestamp,
    // this.canMessage
  });

  factory UserResult.fromDocument(DocumentSnapshot documentSnapshot) {
    return UserResult(
      username: documentSnapshot["username"],
      userId: documentSnapshot["userId"],
      url: documentSnapshot["url"],
      timestamp: documentSnapshot["time"],
      // canMessage: documentSnapshot['canMessage'],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(5.0),
      child: Card(
        shadowColor: Colors.deepOrange,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            color: Colors.black26,
          ),
          child: Column(
            children: <Widget>[
              Stack(
                alignment: Alignment.bottomLeft,
                children: <Widget>[
                  GestureDetector(
                    onTap: () => goToMessage(context),
                    child: ListTile(
                      leading: GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => FullPhoto(url: url)));
                        },
                        child: CircleAvatar(
                          backgroundColor: Colors.black,
                          backgroundImage: NetworkImage(url),
                          child: Align(
                            alignment: Alignment.bottomRight,
                            child: Container(
                                height: 15.0,
                                width: 10.0,
                                child: OnlineDotIndicator(userId: userId)),
                          ),
                        ),
                      ),
                      title: Text(
                        username,
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold),
                      ),
                      subtitle: LastMessage(
                          senderId: currentUser.id, receiverId: userId),
                      //trailing: getUnreadMsg(passValue: true,),
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

  goToMessage(context) async {
    await acceptRequestRefrance
        .document(userId)
        .collection("acceptRequest")
        .document(currentUser.id)
        .setData({
      //"canMessage": canMessage,
      "username": currentUser.username,
      "Time": DateTime.now().millisecondsSinceEpoch.toString(),
      "userId": currentUser.id,
      "url": currentUser.url,
      "user": userId,
    });
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => Message(
                  receiverId: userId,
                  receiverUrl: url,
                  reciverUserName: username,
                )));
  }
}
