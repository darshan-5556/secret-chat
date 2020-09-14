import 'package:flutter/material.dart';
import 'package:secretchatting/Login.dart';
import 'package:secretchatting/Normal_Person/MainPage.dart';
import 'package:secretchatting/Popular_Person/PopularMainPage.dart';
import 'package:secretchatting/auth_methods_chat/users_state.dart';
import 'package:secretchatting/auth_methods_chat/utility.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  bool userIsPopular = false;

  @override
  void initState() {
    super.initState();
    utility.setUserState(userId: currentUser.id, userState: UsersState.Online);
    WidgetsBinding.instance.addObserver(this);
    getUserType();
  }

  getUserType() {
    if (currentUser.isUserPopular == true) {
      setState(() {
        userIsPopular = true;
      });
    } else {
      setState(() {
        userIsPopular = false;
      });
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    String currentUserId = currentUser.id;

    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.resumed:
        currentUserId != null
            ? utility.setUserState(
                userId: currentUserId, userState: UsersState.Online)
            : print("pause ");
        print("Online");
        break;
      case AppLifecycleState.inactive:
        currentUserId != null
            ? utility.setUserState(
                userId: currentUserId, userState: UsersState.Offline)
            : print("pause ");
        print("offline");
        break;
      case AppLifecycleState.paused:
        currentUserId != null
            ? utility.setUserState(
                userId: currentUserId, userState: UsersState.Waiting)
            : print("pause ");
        print("waiting");
        break;
      case AppLifecycleState.detached:
        currentUserId != null
            ? utility.setUserState(
                userId: currentUserId, userState: UsersState.Offline)
            : print("pause ");
        print("offline");
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          child: userIsPopular != false ? PopularMainPage() : MainPage(),
        ),
      ),
    );
  }
}
