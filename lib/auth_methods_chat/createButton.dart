import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:secretchatting/Login.dart';
import 'package:secretchatting/Normal_Person/MainPage.dart';
import 'package:secretchatting/auth_methods_chat/diamondPopUp.dart';
import 'package:secretchatting/chatSystem_Chat/Message.dart';
import 'package:secretchatting/Chat_Methods/SendRequest.dart';
import 'package:secretchatting/GatWay/Payment.dart';

class createButton extends StatelessWidget {
  final String senderuserId;
  final String toWhome;
  final String url;
  final String receiverid;
  int currentDiamond;
  bool isRequestSend = false;
  int diamonds;

  createButton({
    @required this.senderuserId,
    @required this.toWhome,
    @required this.url,
    @required this.receiverid,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: isRequestSend != false
          ? GestureDetector(
              onTap: null,
              child: Container(
                height: 32.0,
                width: 230.0,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.0),
                  color: Colors.blue,
                ),
                child: Text(
                  "Request Send",
                  style: TextStyle(color: Colors.white, fontSize: 18.0),
                ),
              ),
            )
          : GestureDetector(
              onTap: () => doesUserHaveDiamonds(context),
              child: Container(
                  height: 32.0,
                  width: 230.0,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.0),
                    color: Colors.orangeAccent,
                  ),
                  child: Text(
                    "Send Chat Request",
                    style: TextStyle(color: Colors.white, fontSize: 18.0),
                  )),
            ),
    );
  }

  doesUserHaveDiamonds(context) async {
    await usersRefrance.document(currentUser.id).get().then((doc) {
      diamonds = doc.data['userDiamond'];
      print(diamonds.toString());
    });

    Alert(
      style: AlertStyle(animationType: AnimationType.shrink),
      context: context,
      title: "Please Recharge",
      content: Column(
        children: <Widget>[
          Container(
              height: 50.0,
              width: 200.0,
              child: Text("Currently Diamonds:- " + diamonds.toString(),
                  style: TextStyle(
                    fontSize: 18.0,
                  ))),
          GestureDetector(
            onTap: () async {
              if (diamonds >= diamond.package1Diamonds) {
                sendChatRequest.deductTenDiamond(
                    userId: currentUser.id, package: diamond.package1Diamonds);
                sendChatRequest.sendRequst(
                  userId: currentUser.id,
                  toWhome: toWhome,
                  url: url,
                  id: receiverid,
                  packege: diamond.package1Diamonds,
                  time: diamond.package1Time,
                );
                Navigator.pop(context, true);
                isRequestSend = true;
                (context as Element).markNeedsBuild();
              } else {
                ///send him to recharge//////
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Payment(
                            amount: diamond.package1Value,
                            dimond: diamond.package1Diamonds)));
                print("garib");
              }
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.0),
                color: Colors.orange,
              ),
              height: 40.0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                      height: 30.0,
                      width: 30.0,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                        image: AssetImage('assets/images/diamond.png'),
                      ))),
                  Container(
                    width: 10.0,
                  ),
                  Container(
                    child: Text(diamond.package1Diamonds.toString()),
                  ),
                  Container(
                    width: 10.0,
                  ),
                  Container(
                    child: Text(diamond.package1Value.toString() + " Rs"),
                  ),
                  Container(
                    width: 10.0,
                  ),
                  Container(
                    child: Text(diamond.package1Time.toString() + " min"),
                  ),
                ],
              ),
            ),
          ),
          Container(
            height: 20.0,
          ),
          GestureDetector(
            onTap: () async {
              if (diamonds >= diamond.package2Diamonds) {
                sendChatRequest.deductTenDiamond(
                    userId: currentUser.id, package: diamond.package2Diamonds);
                sendChatRequest.sendRequst(
                  userId: currentUser.id,
                  toWhome: toWhome,
                  url: url,
                  id: receiverid,
                  packege: diamond.package2Diamonds,
                  time: diamond.package1Time,
                );
                Navigator.pop(context, true);
              } else {
                ///send him to recharge//////
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Payment(
                            amount: diamond.package2Value,
                            dimond: diamond.package2Diamonds)));
                print("garib");
              }
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.0),
                color: Colors.orange,
              ),
              height: 40.0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                      height: 30.0,
                      width: 30.0,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                        image: AssetImage('assets/images/diamond.png'),
                      ))),
                  Container(
                    width: 10.0,
                  ),
                  Container(
                    child: Text(diamond.package2Diamonds.toString()),
                  ),
                  Container(
                    width: 10.0,
                  ),
                  Container(
                    child: Text(diamond.package2Value.toString() + " Rs"),
                  ),
                  Container(
                    width: 10.0,
                  ),
                  Container(
                    child: Text(diamond.package2Time.toString() + " min"),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ).show();
  }
}
