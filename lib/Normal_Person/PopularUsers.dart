import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:secretchatting/Login.dart';
import 'package:secretchatting/auth_methods_chat/Online_dot_indicator.dart';
import 'package:secretchatting/auth_methods_chat/createButton.dart';
import 'package:secretchatting/Raw/user.dart';

class PopularUsers extends StatefulWidget {
  @override
  _PopularUsersState createState() => _PopularUsersState();
}

class _PopularUsersState extends State<PopularUsers>
    with AutomaticKeepAliveClientMixin<PopularUsers> {
  Future<QuerySnapshot> futuresearchResult;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    ControlSearching();
    // displaySearchResult();
  }

  ControlSearching() {
    Future<QuerySnapshot> allUsers =
        usersRefrance.where("isUserPopular", isEqualTo: true).getDocuments();
    setState(() {
      futuresearchResult = allUsers;
    });
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
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: Text("Popular Users"),
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

  String checkRequestState = "Send Chat Request";
  int currentDiamond;
  bool alreadySend = false;

  // @override
  // void initState(context) {
  //   alreadySendRequest(context);
  // }

  // createBtnTitleAndFunction({String title, Function performFunction}) {
  //   return Container(
  //     child: FlatButton(
  //       onPressed: performFunction,
  //       child: Container(
  //         width: 230.0,
  //         height: 30.0,
  //         child: Text(
  //           title,
  //           style: TextStyle(
  //               color: Colors.red, fontSize: 18.0, fontWeight: FontWeight.w500),
  //         ),
  //         alignment: Alignment.center,
  //         decoration: BoxDecoration(
  //           color: Colors.lightBlue,
  //           borderRadius: BorderRadius.circular(20.0),
  //           border: Border.all(color: Colors.red),
  //         ),
  //       ),
  //     ),
  //   );
  // }

  // alreadySendRequest(context) {
  //   acceptRequestRefrance
  //       .document(currentUser.id)
  //       .collection('acceptRequest')
  //       .getDocuments()
  //       .then((doc) {
  //     if (doc.documents.length > 1) {
  //       alreadySend = true;
  //       (context as Element).markNeedsBuild();
  //     }
  //   });
  // }

  // createButton(context) {
  //   if (!alreadySend) {
  //     return createBtnTitleAndFunction(
  //       title: "Send Chat Request",
  //       performFunction: doesUserHaveDiamonds(context),
  //     );
  //   } else {
  //     return createBtnTitleAndFunction(
  //       title: "Message",
  //       performFunction: sendMsg,
  //     );
  //   }
  // }

  // sendMsg() {}

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Card(
              color: Colors.black12,
              child: Container(
                  alignment: Alignment.bottomRight,
                  height: 150.0,
                  width: 150.0,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: NetworkImage(eachUser.url),
                          fit: BoxFit.cover)),
                  child: OnlineDotIndicator(userId: eachUser.id)),
            ),
            Expanded(
              child: Container(
                color: Colors.black12,
                alignment: Alignment.center,
                height: 150.0,
                // padding: EdgeInsets.only(left: 50.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Text(
                      eachUser.username,
                      style: TextStyle(color: Colors.black, fontSize: 18.0),
                    ),
                    Container(
                      height: 5.0,
                    ),
                    Text(
                      eachUser.intrest,
                      style: TextStyle(color: Colors.black, fontSize: 18.0),
                    ),
                    Container(
                      height: 10.0,
                    ),
                    createButton(
                      senderuserId: currentUser.id,
                      receiverid: eachUser.id,
                      toWhome: eachUser.username,
                      url: currentUser.url,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
