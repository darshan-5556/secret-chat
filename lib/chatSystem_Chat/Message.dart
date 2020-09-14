import 'dart:async';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:secretchatting/Login.dart';
import 'package:secretchatting/Chat_Methods/TypingState.dart';
import 'package:secretchatting/auth_methods_chat/Online_dot_indicator.dart';
import 'package:secretchatting/auth_methods_chat/diamondPopUp.dart';
import 'package:secretchatting/auth_methods_chat/utility.dart';
import 'package:secretchatting/chatSystem_Chat/FullPhoto.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:visibility_detector/visibility_detector.dart';

class Message extends StatelessWidget {
  final String receiverId;
  final String reciverUserName;
  final String receiverUrl;
  final int receiverDiamond;

  Message(
      {@required this.receiverId,
      @required this.receiverUrl,
      @required this.reciverUserName,
      @required this.receiverDiamond});

  @override
  _MessageState createState() => _MessageState(
      receiverId: receiverId,
      receiverUrl: receiverUrl,
      reciverUserName: reciverUserName,
      receiverDiamond: receiverDiamond);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          Padding(
            padding: EdgeInsets.all(10.0),
            child: CircleAvatar(
              backgroundColor: Colors.black,
              backgroundImage: NetworkImage(receiverUrl),
              child: Align(
                alignment: Alignment.bottomRight,
                child: Container(
                    height: 15.0,
                    width: 10.0,
                    child: OnlineDotIndicator(userId: receiverId)),
              ),
            ),
          ),
        ],
        title: Container(
          child: Column(
            children: <Widget>[
              Text(
                reciverUserName,
                style: TextStyle(color: Colors.white, fontSize: 20.0),
              ),
              TypingState(
                userId: receiverId,
              ),
            ],
          ),
        ),
        centerTitle: true,
        automaticallyImplyLeading: true,
      ),
      body: Messges(
        receiverUrl: receiverUrl,
        receiverId: receiverId,
        receiverDiamond: receiverDiamond,
      ),
    );
  }
}

class Messges extends StatefulWidget {
  final String receiverUrl;
  final String receiverId;
  final int receiverDiamond;

  Messges({
    Key key,
    @required this.receiverId,
    @required this.receiverUrl,
    @required this.receiverDiamond,
  }) : super(key: key);

  @override
  _MessageState createState() => _MessageState(
        receiverUrl: receiverUrl,
        receiverId: receiverId,
        receiverDiamond: receiverDiamond,
      );
}

class _MessageState extends State<Messges> {
  final String receiverId;
  final String reciverUserName;
  final String receiverUrl;
  final int receiverDiamond;

  _MessageState(
      {Key key,
      @required this.receiverId,
      @required this.receiverUrl,
      @required this.reciverUserName,
      @required this.receiverDiamond});

  final TextEditingController MessageController = new TextEditingController();
  final FocusNode focusNode = FocusNode();
  final ScrollController listScrollController = new ScrollController();

  bool isDisplayStiker;
  bool isLoading;

  File imageFile;
  String imgUrl;

  String chatId;
  SharedPreferences preferences;
  String id;
  bool doesUserRecharge = false;
  var listMessage;
  bool userIsWorthy = false;
  int dataLength;
  Timer timer;

  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    focusNode.addListener(onFocusChange);

    isDisplayStiker = false;
    isLoading = false;

    chatId = "";
    readLocal();
    configureNotification();
  }

  configureNotification() {
    // timer = Timer.periodic(Duration(milliseconds: 200), (timer) {
    _firebaseMessaging.getToken().then((token) {
      Firestore.instance
          .collection("messages")
          .document(chatId)
          .setData({"androidNotificationToken": token});
    });
    // timer.cancel();
    //  });
    _firebaseMessaging.configure(onMessage: (Map<String, dynamic> msg) async {
      final String recipientId = msg['data']['recipient'];
      final String body = msg['notification']['body'];
      print("ok");
      if (recipientId == currentUser.id) {
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

  isUserWerthy() async {
    usersRefrance
        .document(currentUser.id)
        .collection('chattingWith')
        .document(receiverId)
        .get()
        .then((data) {
      if (!data.exists) {
        diamondPopUp.showPopUp(context,
            receiverId: receiverId, receiverDiamond: receiverDiamond);
        print("no");
      } else {
        onSendMessage(MessageController.text, 0);
      }
    });
    // await processData();
  }

  @override
  void dispose() {
    super.dispose();
  }

  readLocal() async {
    //id = preferences.getString("id") ?? "";
    id = currentUser.id;
    if (id.hashCode <= receiverId.hashCode) {
      chatId = '$id-$receiverId';
    } else {
      chatId = '$receiverId-$id';
    }

    usersRefrance.document(currentUser.id).updateData({
      'chattingWith': receiverId,
    });
    setState(() {});
  }

  onFocusChange() {
    //Hide stikers when keypad appears
    if (focusNode.hasFocus) {
      setState(() {
        isDisplayStiker = false;
      });
    }
  }

  void getStiker() {
    focusNode.unfocus();
    setState(() {
      isDisplayStiker = !isDisplayStiker;
    });
  }

  isUserWerthy1(String msg) async {
    if (currentUser.isUserPopular) {
      onSendMessage(msg, 2);
    } else {
      usersRefrance
          .document(currentUser.id)
          .collection('chattingWith')
          .document(receiverId)
          .get()
          .then((data) {
        if (!data.exists) {
          diamondPopUp.showPopUp(context,
              receiverId: receiverId, receiverDiamond: receiverDiamond);
          print("no");
        } else {
          onSendMessage(msg, 2);
        }
      });
    }
    // await processData();
  }

  isUserWerthy2() async {
    usersRefrance
        .document(currentUser.id)
        .collection('chattingWith')
        .document(receiverId)
        .get()
        .then((data) {
      if (!data.exists) {
        diamondPopUp.showPopUp(context,
            receiverId: receiverId, receiverDiamond: receiverDiamond);
        print("no");
      } else {
        getImage();
      }
    });
    // await processData();
  }

  createTypingMethods() {
    utility.setTypingState(isTyping: true, userId: id);
  }

  createNotTypingMethods() {
    utility.setTypingState(isTyping: false, userId: id);
  }

  createInputField() {
    return Container(
      child: Row(
        children: <Widget>[
          //For sending image

          Material(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 1.0),
              child: IconButton(
                icon: Icon(Icons.image),
                color: Colors.lightBlueAccent,
                onPressed: () {
                  if (currentUser.isUserPopular) {
                    getImage();
                  } else {
                    isUserWerthy2();
                  }
                },
              ),
            ),
            color: Colors.white,
          ),

          //for sending emoji

          Material(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 1.0),
              child: IconButton(
                icon: Icon(Icons.face),
                color: Colors.lightBlueAccent,
                onPressed: () => getStiker(),
              ),
            ),
            color: Colors.white,
          ),

          Flexible(
            child: Container(
                child: TextField(
              style: TextStyle(color: Colors.black, fontSize: 18.0),
              controller: MessageController,
              onChanged: (val) {
                if (MessageController.text != null) {
                  Future.delayed(Duration(milliseconds: 500), () {
                    createNotTypingMethods();
                  });
                  print("check");
                  //  createTypingMethods();
                } else {
                  Future.delayed(Duration(milliseconds: 500), () {
                    createNotTypingMethods();
                  });
                  print("no");
                  createNotTypingMethods();
                }
              },
              decoration: InputDecoration.collapsed(
                  hintText: "Message..",
                  hintStyle: TextStyle(
                    color: Colors.grey,
                  )),
              focusNode: focusNode,
            )),
          ),

          //Send icon
          Material(
              child: Container(
            child: IconButton(
                icon: Icon(Icons.send),
                color: Colors.orangeAccent,
                onPressed: () {
                  if (currentUser.isUserPopular != true) {
                    isUserWerthy();
                  } else {
                    onSendMessage(MessageController.text, 0);
                  }
                }),
          )),
        ],
      ),
      width: double.infinity,
      height: 55.0,
      decoration: BoxDecoration(
          border: Border(
              top: BorderSide(
            color: Colors.grey,
            width: 0.5,
          )),
          color: Colors.white),
    );
  }

  void onSendMessage(String content, int type) {
    print("working");
    if (content != "") {
      MessageController.clear();

      Firestore.instance
          .collection("messages")
          .document(chatId)
          .collection(chatId)
          .document(DateTime.now().millisecondsSinceEpoch.toString())
          .setData({
        "idFrom": id,
        "idTo": receiverId,
        "Time": DateTime.now().millisecondsSinceEpoch.toString(),
        "content": content,
        "type": type,
        "url": currentUser.url,
        "username": currentUser.username,
      });

      listScrollController.animateTo(0.0,
          duration: Duration(microseconds: 300), curve: Curves.bounceIn);
    } else {
      Fluttertoast.showToast(msg: "Empty message. Can't be send.");
    }
  }

  createListMessages() {
    return Flexible(
      child: chatId == ""
          ? Center(child: CircularProgressIndicator())
          : VisibilityDetector(
              key: Key('1'),
              onVisibilityChanged: (visibilityInfo) {
                var visiblePercentage = visibilityInfo.visibleFraction * 100;
                print(visiblePercentage.toString());
                if (visiblePercentage == 100) {
                  //  getUnreadMsg(passValue: true,);
                  print("value is true");
                } else {
                  //  getUnreadMsg(passValue: false,);
                  print("value is false");
                }
              },
              child: StreamBuilder(
                stream: Firestore.instance
                    .collection("messages")
                    .document(chatId)
                    .collection(chatId)
                    .orderBy("Time", descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    listMessage = snapshot.data.documents;
                    return ListView.builder(
                      padding: EdgeInsets.all(10.0),
                      itemBuilder: (context, index) =>
                          createItom(index, snapshot.data.documents[index]),
                      itemCount: snapshot.data.documents.length,
                      reverse: true,
                      controller: listScrollController,
                    );
                  }
                },
              ),
            ),
    );
  }

  Widget createItom(int index, DocumentSnapshot document) {
    //my messsages - rightside
    if (document['idFrom'] == currentUser.id) {
      return Row(
        children: <Widget>[
          //for text msg
          document['type'] == 0
              ? Column(
                  children: <Widget>[
                    Container(
                      child: Text(
                        document['content'],
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.w400),
                      ),
                      padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 15.0),
                      width: 200.0,
                      decoration: BoxDecoration(
                        color: Colors.orangeAccent,
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      margin: EdgeInsets.only(left: 10.0),
                    ),
                    Container(
                      height: 30.0,
                      width: 80.0,
                      alignment: Alignment.centerRight,
                      child: Text(
                        DateFormat.jm().format(
                            DateTime.fromMillisecondsSinceEpoch(
                                int.parse(document["Time"]))),
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 13.0,
                            fontStyle: FontStyle.italic),
                      ),
                    ),
                  ],
                )
//              Container(
//                  child: Text(
//                    document['content'],
//                    style: TextStyle(
//                        color: Colors.white,
//                        fontSize: 16.0,
//                        fontWeight: FontWeight.w500),
//                  ),
//                  padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 15.0),
//                  width: 200.0,
//                  decoration: BoxDecoration(
//                    color: Colors.orangeAccent,
//                    borderRadius: BorderRadius.circular(15.0),
//                  ),
//                  margin: EdgeInsets.only(
//                      bottom: isLastMsgRight(index) ? 20.0 : 10.0, right: 10.0),
//                )
              //for image file
              : document['type'] == 1
                  ? Column(
                      children: <Widget>[
                        Container(
                          child: FlatButton(
                            child: Material(
                              child: CachedNetworkImage(
                                placeholder: (context, url) => Container(
                                  child: CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.deepOrange),
                                  ),
                                  width: 200.0,
                                  height: 200.0,
                                  padding: EdgeInsets.all(70.0),
                                  decoration: BoxDecoration(
                                    color: Colors.grey,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10.0)),
                                  ),
                                ),
                                errorWidget: (context, url, error) => Material(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10.0)),
                                  child: Image.asset(
                                    "assets/images/errorImg.png",
                                    width: 200.0,
                                    height: 200.0,
                                    fit: BoxFit.cover,
                                  ),
                                  clipBehavior: Clip.hardEdge,
                                ),
                                imageUrl: document['content'],
                                width: 200.0,
                                height: 200.0,
                                fit: BoxFit.cover,
                              ),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0)),
                              clipBehavior: Clip.hardEdge,
                            ),
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          FullPhoto(url: document['content'])));
                            },
                          ),
                        ),
                        Container(
                          height: 30.0,
                          width: 80.0,
                          alignment: Alignment.centerRight,
                          child: Text(
                            DateFormat.jm().format(
                                DateTime.fromMillisecondsSinceEpoch(
                                    int.parse(document["Time"]))),
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 13.0,
                                fontStyle: FontStyle.italic),
                          ),
                        )
                      ],
                    )
                  //for stikers
                  : Column(
                      children: <Widget>[
                        Container(
                          child: Image.asset(
                            "assets/images/gifs/${document['content']}.gif",
                            width: 100.0,
                            height: 100.0,
                            fit: BoxFit.cover,
                          ),
                          margin: EdgeInsets.only(bottom: 10.0, right: 10.0),
                        ),
                        Container(
                          height: 30.0,
                          width: 80.0,
                          alignment: Alignment.centerRight,
                          child: Text(
                            DateFormat.jm().format(
                                DateTime.fromMillisecondsSinceEpoch(
                                    int.parse(document["Time"]))),
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 13.0,
                                fontStyle: FontStyle.italic),
                          ),
                        )
                      ],
                    ),
        ],
        mainAxisAlignment: MainAxisAlignment.end,
      );
    } //receiver side
    else {
      return Container(
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                //Display Receiver profile img
                GestureDetector(
                  child: Material(
                    child: CachedNetworkImage(
                      placeholder: (context, url) => Container(
                        child: CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.deepOrange),
                        ),
                        width: 35.0,
                        height: 35.0,
                        padding: EdgeInsets.all(10.0),
                      ),
                      imageUrl: document['url'],
                      width: 35.0,
                      height: 35.0,
                      fit: BoxFit.cover,
                    ),
                    borderRadius: BorderRadius.all(
                      Radius.circular(18.0),
                    ),
                    clipBehavior: Clip.hardEdge,
                  ),
                ),
                //displayMessages
                document['type'] == 0
                    ? Column(
                        children: <Widget>[
                          Container(
                            child: Text(
                              document['content'],
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w400),
                            ),
                            padding:
                                EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 15.0),
                            width: 200.0,
                            decoration: BoxDecoration(
                              color: Colors.lightBlueAccent,
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            margin: EdgeInsets.only(left: 10.0),
                          ),
                          Container(
                            height: 30.0,
                            width: 80.0,
                            alignment: Alignment.centerLeft,
                            child: Text(
                              DateFormat.jm().format(
                                  DateTime.fromMillisecondsSinceEpoch(
                                      int.parse(document["Time"]))),
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 13.0,
                                  fontStyle: FontStyle.italic),
                            ),
                          )
                        ],
                      )
                    : document['type'] == 1
                        ? Column(
                            children: <Widget>[
                              Container(
                                child: FlatButton(
                                  child: Material(
                                    child: CachedNetworkImage(
                                      placeholder: (context, url) => Container(
                                        child: CircularProgressIndicator(
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                  Colors.deepOrange),
                                        ),
                                        width: 200.0,
                                        height: 200.0,
                                        padding: EdgeInsets.all(70.0),
                                        decoration: BoxDecoration(
                                          color: Colors.grey,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10.0)),
                                        ),
                                      ),
                                      errorWidget: (context, url, error) =>
                                          Material(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10.0)),
                                        child: Image.asset(
                                          "assets/images/errorImg.png",
                                          width: 200.0,
                                          height: 200.0,
                                          fit: BoxFit.cover,
                                        ),
                                        clipBehavior: Clip.hardEdge,
                                      ),
                                      imageUrl: document['content'],
                                      width: 200.0,
                                      height: 200.0,
                                      fit: BoxFit.cover,
                                    ),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10.0)),
                                    clipBehavior: Clip.hardEdge,
                                  ),
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => FullPhoto(
                                                url: document['content'])));
                                  },
                                ),
                                margin: EdgeInsets.only(left: 10.0),
                              ),
                              Container(
                                height: 30.0,
                                width: 80.0,
                                alignment: Alignment.centerRight,
                                child: Text(
                                  DateFormat.jm().format(
                                      DateTime.fromMillisecondsSinceEpoch(
                                          int.parse(document["Time"]))),
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 13.0,
                                      fontStyle: FontStyle.italic),
                                ),
                              )
                            ],
                          )
                        : Column(
                            children: <Widget>[
                              Container(
                                child: Image.asset(
                                  "assets/images/gifs/${document['content']}.gif",
                                  width: 100.0,
                                  height: 100.0,
                                  fit: BoxFit.cover,
                                ),
                                margin:
                                    EdgeInsets.only(bottom: 10.0, right: 10.0),
                              ),
                              Container(
                                height: 30.0,
                                width: 80.0,
                                alignment: Alignment.centerRight,
                                child: Text(
                                  DateFormat.jm().format(
                                      DateTime.fromMillisecondsSinceEpoch(
                                          int.parse(document["Time"]))),
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 13.0,
                                      fontStyle: FontStyle.italic),
                                ),
                              )
                            ],
                          ),
              ],
            ),
            //Message time
//            isLastMsgLeft(index)
//                ? Container(
//                    child: Text(
//                      DateFormat("dd MM KK:mm").format(
//                          DateTime.fromMillisecondsSinceEpoch(
//                              int.parse(document["Time"]))),
//                      style: TextStyle(
//                          color: Colors.black,
//                          fontSize: 13.0,
//                          fontStyle: FontStyle.italic),
//                    ),
//                    margin: EdgeInsets.only(left: 50.0, top: 20.0, bottom: 5.0),
//                  )
//                : Container(),
          ],
          crossAxisAlignment: CrossAxisAlignment.start,
        ),
        margin: EdgeInsets.only(bottom: 10.0),
      );
    }
  }

  createStikers() {
    return Container(
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              FlatButton(
                onPressed: () => isUserWerthy1('tenor9'),
                child: Image.asset(
                  "assets/images/gifs/tenor9.gif",
                  width: 50.0,
                  height: 50.0,
                  fit: BoxFit.cover,
                ),
              ),
              FlatButton(
                onPressed: () => isUserWerthy1('tenor10'),
                child: Image.asset(
                  "assets/images/gifs/tenor10.gif",
                  width: 50.0,
                  height: 50.0,
                  fit: BoxFit.cover,
                ),
              ),
              FlatButton(
                onPressed: () => isUserWerthy1('tenor11'),
                child: Image.asset(
                  "assets/images/gifs/tenor11.gif",
                  width: 50.0,
                  height: 50.0,
                  fit: BoxFit.cover,
                ),
              )
            ],
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          ),
          Row(
            children: <Widget>[
              FlatButton(
                onPressed: () => isUserWerthy1('tenor'),
                child: Image.asset(
                  "assets/images/gifs/tenor.gif",
                  width: 50.0,
                  height: 50.0,
                  fit: BoxFit.cover,
                ),
              ),
              FlatButton(
                onPressed: () => isUserWerthy1('tenor1'),
                child: Image.asset(
                  "assets/images/gifs/tenor1.gif",
                  width: 50.0,
                  height: 50.0,
                  fit: BoxFit.cover,
                ),
              ),
              FlatButton(
                onPressed: () => isUserWerthy1('tenor2'),
                child: Image.asset(
                  "assets/images/gifs/tenor2.gif",
                  width: 50.0,
                  height: 50.0,
                  fit: BoxFit.cover,
                ),
              )
            ],
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          ),
          Row(
            children: <Widget>[
              FlatButton(
                onPressed: () => isUserWerthy1('tenor3'),
                child: Image.asset(
                  "assets/images/gifs/tenor3.gif",
                  width: 50.0,
                  height: 50.0,
                  fit: BoxFit.cover,
                ),
              ),
              FlatButton(
                onPressed: () => isUserWerthy1('tenor4'),
                child: Image.asset(
                  "assets/images/gifs/tenor4.gif",
                  width: 50.0,
                  height: 50.0,
                  fit: BoxFit.cover,
                ),
              ),
              FlatButton(
                onPressed: () => isUserWerthy1('tenor5'),
                child: Image.asset(
                  "assets/images/gifs/tenor5.gif",
                  width: 50.0,
                  height: 50.0,
                  fit: BoxFit.cover,
                ),
              )
            ],
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          ),
          Row(
            children: <Widget>[
              FlatButton(
                onPressed: () => isUserWerthy1('tenor6'),
                child: Image.asset(
                  "assets/images/gifs/tenor6.gif",
                  width: 50.0,
                  height: 50.0,
                  fit: BoxFit.cover,
                ),
              ),
              FlatButton(
                onPressed: () => isUserWerthy1('tenor7'),
                child: Image.asset(
                  "assets/images/gifs/tenor7.gif",
                  width: 50.0,
                  height: 50.0,
                  fit: BoxFit.cover,
                ),
              ),
              FlatButton(
                onPressed: () => isUserWerthy1('tenor8'),
                child: Image.asset(
                  "assets/images/gifs/tenor8.gif",
                  width: 50.0,
                  height: 50.0,
                  fit: BoxFit.cover,
                ),
              )
            ],
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          ),
        ],
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      ),
      decoration: BoxDecoration(
          border: Border(top: BorderSide(color: Colors.grey, width: 0.5)),
          color: Colors.white),
      padding: EdgeInsets.all(5.0),
      height: 250.0,
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Stack(
        children: <Widget>[
          Column(
            children: <Widget>[
              createListMessages(),
              //show Stikers
              (isDisplayStiker ? createStikers() : Container()),
              createInputField(),
            ],
          ),
          createLoading(),
        ],
      ),
      onWillPop: onBackPress,
    );
  }

  createLoading() {
    return Positioned(
      child: isLoading ? CircularProgressIndicator() : Container(),
    );
  }

  Future<bool> onBackPress() {
    if (isDisplayStiker) {
      setState(() {
        isDisplayStiker = false;
      });
    } else {
      Navigator.pop(context);
    }
    return Future.value(false);
  }

  Future getImage() async {
    // ignore: deprecated_member_use
    imageFile = await ImagePicker.pickImage(source: ImageSource.gallery);
    if (imageFile != null) {
      isLoading = true;
    }
    uploadingFile();
  }

  uploadingFile() async {
    //String filename = reciverUserName.toString();
    StorageReference storageReference = FirebaseStorage.instance
        .ref()
        .child("Images")
        .child(currentUser.username);

    StorageUploadTask storageUploadTask = storageReference.putFile(imageFile);
    StorageTaskSnapshot storageTaskSnapshot =
        await storageUploadTask.onComplete;

    storageTaskSnapshot.ref.getDownloadURL().then((downloadUrl) {
      imgUrl = downloadUrl;
      setState(() {
        isLoading = false;
        onSendMessage(imgUrl, 1);
      });
    }, onError: (error) {
      setState(() {
        isLoading = false;
      });
      Fluttertoast.showToast(msg: "error: " + error);
    });
  }
}
