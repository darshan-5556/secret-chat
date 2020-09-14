import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:secretchatting/Login.dart';
import 'package:secretchatting/Normal_Person/MainPage.dart';
import 'package:secretchatting/Raw/Diamonds.dart';
import 'package:secretchatting/Chat_Methods/addDiamond.dart';
import 'package:secretchatting/GatWay/Payment.dart';
import 'package:secretchatting/Chat_Methods/SendRequest.dart';

// ignore: camel_case_types
class diamondPopUp {
  static String receiverId;
  static int diamonds;

  static void showPopUp(context,
      {@required receiverId, @required receiverDiamond}) {
    Alert(
      style: AlertStyle(animationType: AnimationType.shrink),
      desc: "Your time is over, please recharge to continue.",
      context: context,
      title: "Please Recharge",
      content: Column(
        children: <Widget>[
          Container(
            height: 10.0,
          ),
          GestureDetector(
            onTap: () {
              usersRefrance.document(currentUser.id).get().then((doc) {
                diamonds = doc.data['userDiamond'];
                print(diamonds.toString());
              });
              if (diamonds >= diamond.package1Diamonds) {
                addDiamond.getData(
                  receiverId: receiverId,
                  package: diamond.package1Diamonds,
                );
                sendChatRequest.deductTenDiamond(
                    userId: currentUser.id, package: diamond.package1Diamonds);
                usersRefrance
                    .document(currentUser.id)
                    .collection("chattingWith")
                    .document(receiverId)
                    .setData({
                  "userId": receiverId,
                  "currentUserId": currentUser.id,
                  "time": diamond.package1Time,
                });
                Navigator.pop(context, true);
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
            onTap: () {
              usersRefrance.document(currentUser.id).get().then((doc) {
                diamonds = doc.data['userDiamond'];
              });
              if (diamonds >= diamond.package2Diamonds) {
                addDiamond.getData(
                  receiverId: receiverId,
                  package: diamond.package2Diamonds,
                );
                sendChatRequest.deductTenDiamond(
                    userId: currentUser.id, package: diamond.package2Diamonds);
                usersRefrance
                    .document(currentUser.id)
                    .collection("chattingWith")
                    .document(receiverId)
                    .setData({
                  "userId": receiverId,
                  "currentUserId": currentUser.id,
                  "time": diamond.package2Time,
                });

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
