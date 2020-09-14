import 'dart:async';
import 'dart:ui';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/Material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:secretchatting/HomePage.dart';
import 'package:secretchatting/Raw/user.dart';

import 'CreateAccount.dart';

final DateTime timestamp = DateTime.now();
final GoogleSignIn gSignIn = GoogleSignIn();
final usersRefrance = Firestore.instance.collection("Users");
final chatRequestRefrance = Firestore.instance.collection("chatRequest");
final acceptRequestRefrance = Firestore.instance.collection("acceptRequest");
final activityFeedRefrance = Firestore.instance.collection("feed");
final diamondPackageRefrance = Firestore.instance.collection("diamonds");
final StorageReference storageReference =
    FirebaseStorage.instance.ref().child("posts pictures");
final groupChatRefrance = Firestore.instance.collection("GroupChat");

User currentUser;

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool LoaderOn = false;
  bool isSignin = false;
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    LoaderOn = true;
    getLoader();
    gSignIn.onCurrentUserChanged.listen((gSignInAccount) {
      controllSignIn(gSignInAccount);
    }, onError: (gerror) {
      print("Error by me" + gerror);
    });

    gSignIn.signInSilently(suppressErrors: false).then((gSignInAccount) {
      controllSignIn(gSignInAccount);
    }, onError: (gEROR) {
      print("Error by me" + gEROR);
    });
  }

  getLoader() {
    Timer(Duration(seconds: 10), () {
      setState(() {
        LoaderOn = false;
      });
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  controllSignIn(GoogleSignInAccount SignInAccount) async {
    if (SignInAccount != null) {
      await SaveUserInfoToFirestore();
      setState(() {
        isSignin = true;
      });

      configurePushNotification();
    } else {
      setState(() {
        isSignin = false;
      });
    }
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
      }
    });
  }

  SaveUserInfoToFirestore() async {
    // Prefrances = await SharedPreferences.getInstance();

    final GoogleSignInAccount gCurrentUser = gSignIn.currentUser;
    DocumentSnapshot documentSnapshot =
        await usersRefrance.document(gCurrentUser.id).get();
    if (!documentSnapshot.exists) {
      final username = await Navigator.push(context,
          MaterialPageRoute(builder: (context) => CreateAccountPage()));
      usersRefrance.document(gCurrentUser.id).setData({
        "id": gCurrentUser.id,
        "profileName": gCurrentUser.displayName,
        "username": username,
        "url": gCurrentUser.photoUrl,
        "email": gCurrentUser.email,
        "timestamp": timestamp,
        "doesUserRecharge": false,
      });
      documentSnapshot = await usersRefrance.document(gCurrentUser.id).get();
    }
    // documentSnapshot = await diamondPackageRefrance.document('diamonds').get();
    currentUser = User.fromDocument(documentSnapshot);
    // diamondPackage = diamonds.fromDocument(documentSnapshot);
  }

  UserLogin() {
    gSignIn.signIn();
  }

  Scaffold LoginScreen() {
    return Scaffold(
      body: Container(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          GestureDetector(
            onTap: UserLogin(),
            child: Container(
              alignment: Alignment.center,
              child: Text(
                "Login",
                style: TextStyle(
                    color: Colors.deepOrange,
                    fontWeight: FontWeight.bold,
                    fontSize: 25.0),
              ),
            ),
          ),
          Container(
            height: 10.0,
          ),
          Container(
            child: LoaderOn ? CircularProgressIndicator() : Container(),
          ),
        ],
      )),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isSignin) {
      return HomePage();
    } else {
      return LoginScreen();
    }
    //   Navigator.push(
    //       context, MaterialPageRoute(builder: (context) => AboutUser()));
    // }
  }
}
