import 'package:badges/badges.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:secretchatting/GroupChat.dart';
import 'package:secretchatting/Login.dart';
import 'package:secretchatting/Normal_Person/MyChats.dart';
import 'package:secretchatting/Normal_Person/NormalNotification.dart';
import 'package:secretchatting/Normal_Person/PopularUsers.dart';
import 'package:secretchatting/Raw/Diamonds.dart';
import 'package:secretchatting/auth_methods_chat/Profile.dart';
import 'package:secretchatting/auth_methods_chat/users_state.dart';
import 'package:secretchatting/auth_methods_chat/utility.dart';
import 'package:secretchatting/Raw/user.dart';
import 'package:secretchatting/Normal_Person/BuyDiamonds.dart';

diamonds diamond;

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
////// This Page is for Normal-Users///////////
  int docValue;
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    getPackageInfo();
    configurePushNotification();
    // PushNotification.configurePushNotification();
  }

  configurePushNotification() {
    final GoogleSignInAccount gUser = gSignIn.currentUser;

    _firebaseMessaging.getToken().then((token) {
      usersRefrance
          .document(gUser.id)
          .updateData({"androidNotificationToken": token});
    });
    _firebaseMessaging.configure(onMessage: (Map<String, dynamic> msg) async {
      final String recipientId = msg['data']['recipient'];
      final String body = msg['notification']['body'];

      if (recipientId == gUser.id) {
        SnackBar snackBar = SnackBar(
            backgroundColor: Colors.grey,
            content: Text(
              body,
              style: TextStyle(
                color: Colors.black,
                fontSize: 17.0,
              ),
              overflow: TextOverflow.ellipsis,
            ));
        _scaffoldKey.currentState.showSnackBar(snackBar);
      } else {
        print("no");
      }
    });
  }

  getPackageInfo() async {
    DocumentSnapshot documentSnapshot =
        await diamondPackageRefrance.document('diamonds').get();
    diamond = diamonds.fromDocument(documentSnapshot);
  }

  getRealTimeData() {
    return StreamBuilder(
      stream: utility.getUsersInfo(userId: currentUser.id),
      builder: (context, snapshot) {
        User user;
        if (snapshot.hasData && snapshot.data != null) {
          user = User.fromDocument(snapshot.data);
          return Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                  height: 20.0,
                ),
                Container(
                  height: 50.0,
                  child: Text(
                    "Welcome " + user.username,
                    style: TextStyle(
                        color: Colors.deepOrange,
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  height: 150.0,
                  width: 150.0,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.0),
                      image: DecorationImage(
                        image: NetworkImage(user.url),
                        fit: BoxFit.cover,
                      ),
                      color: Colors.orange),
                ),
                Container(
                  height: 20.0,
                ),
                Container(
                  height: 150.0,
                  width: 250.0,
                  decoration: BoxDecoration(
                    color: Colors.lightBlue,
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Column(
                    children: <Widget>[
                      Container(
                          padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                          child: Text(
                            "My Wallet",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20.0,
                            ),
                          )),
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              height: 50.0,
                              width: 50.0,
                              decoration: BoxDecoration(
                                color: Colors.orange,
                                borderRadius: BorderRadius.circular(10.0),
                                image: DecorationImage(
                                    image: AssetImage(
                                        'assets/images/diamond.png')),
                              ),
                            ),
                            Container(
                              width: 50.0,
                            ),
                            Container(
                                child: Text(
                              user.userDiamond.toString(),
                              style: TextStyle(
                                color: Colors.deepOrange,
                                fontSize: 25.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ))
                          ],
                        ),
                      ),
                      Container(
                        height: 10.0,
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => BuyDiamonds()));
                        },
                        child: Container(
                          height: 40.0,
                          width: 150.0,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              color: Colors.orangeAccent,
                              borderRadius: BorderRadius.circular(10.0)),
                          child: Text(
                            "Buy Diamonds",
                            style: TextStyle(
                                color: Colors.redAccent, fontSize: 18.0),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  height: 10.0,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => GroupChat()));
                  },
                  child: Container(
                    height: 40.0,
                    width: 200.0,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: Colors.lightBlueAccent,
                        borderRadius: BorderRadius.circular(20.0)),
                    child: Text(
                      "Group Chat",
                      style: TextStyle(
                          color: Colors.red,
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                Container(
                  height: 10.0,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => PopularUsers()));
                  },
                  child: Container(
                    height: 40.0,
                    width: 200.0,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: Colors.lightBlueAccent,
                        borderRadius: BorderRadius.circular(20.0)),
                    child: Text(
                      "Popular Users",
                      style: TextStyle(
                          color: Colors.red,
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                Container(
                  height: 10.0,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => MyChats()));
                  },
                  child: Container(
                    height: 40.0,
                    width: 200.0,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: Colors.lightBlueAccent,
                        borderRadius: BorderRadius.circular(20.0)),
                    child: Text(
                      "My Chat",
                      style: TextStyle(
                          color: Colors.red,
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                )
              ],
            ),
          );
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  openPop(context) {
    Alert(
      style: AlertStyle(animationType: AnimationType.shrink),
      context: context,
      title: "Options",
      content: Column(
        children: <Widget>[
          GestureDetector(
            onTap: () async {
              await Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Profile()));
              Navigator.pop(context, true);
            },
            child: Container(
              height: 50.0,
              width: 200.0,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: Colors.orange,
                  borderRadius: BorderRadius.circular(20.0)),
              child: Text("Profile",
                  style: TextStyle(color: Colors.blue, fontSize: 20.0)),
            ),
          ),
          Container(
            height: 30.0,
          ),
          GestureDetector(
            onTap: () {
              Navigator.pop(context, true);
              utility.setUserState(
                  userId: currentUser.id, userState: UsersState.Offline);
              gSignIn.signOut();
            },
            child: Container(
              height: 50.0,
              width: 200.0,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: Colors.red, borderRadius: BorderRadius.circular(20.0)),
              child: Text("Log Out",
                  style: TextStyle(color: Colors.blue, fontSize: 20.0)),
            ),
          )
        ],
      ),
    ).show();
  }

  // Widget _Dropdown() {
  //   return DropdownButton<String>(
  //     // value: dropdownValue,
  //     icon: Icon(Icons.arrow_downward),
  //     iconSize: 24,
  //     //elevation: 26,
  //     //  style: TextStyle(color: Colors.deepPurple),

  //     onChanged: (String newValue) {
  //       setState(() {
  //         dropdownValue = newValue;
  //       });
  //     },
  //     items: <String>['Female', 'Male']
  //         .map<DropdownMenuItem<String>>((String value) {
  //       return DropdownMenuItem<String>(
  //           value: value, child: GestureDetector(child: Text("Options")));
  //     }).toList(),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.orangeAccent,
        title: Text(
          "Secret Chat",
          style: TextStyle(
            color: Colors.red,
            fontSize: 20.0,
          ),
        ),
        automaticallyImplyLeading: false,
        actions: <Widget>[
          Badge(
            showBadge: docValue != null ? true : false,
            position: BadgePosition.bottomLeft(bottom: 30.0, left: 30.0),
            animationType: BadgeAnimationType.slide,
            badgeContent: StreamBuilder<QuerySnapshot>(
                stream: activityFeedRefrance
                    .document(currentUser.id)
                    .collection("feed")
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.data != null) {
                    docValue = snapshot.data.documents.length;
                    return Text(docValue.toString());
                  } else {
                    return Text("");
                  }
                }),
            child: IconButton(
              icon: Icon(
                Icons.notifications,
                size: 30.0,
                color: Colors.red,
              ),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => NormalNotification()));
              },
            ),
          ),
          IconButton(
              icon: Icon(
                Icons.more_vert,
                size: 30.0,
                color: Colors.red,
              ),
              onPressed: () {
                openPop(context);
              })
        ],
      ),
      body: getRealTimeData(),
    );
  }
}
