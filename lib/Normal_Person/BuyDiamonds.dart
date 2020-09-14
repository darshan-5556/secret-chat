import 'package:flutter/material.dart';
import 'package:secretchatting/Login.dart';
import 'package:secretchatting/Normal_Person/MainPage.dart';
import 'package:secretchatting/Gatway/Payment.dart';

class BuyDiamonds extends StatefulWidget {
  @override
  _BuyDiamondsState createState() => _BuyDiamondsState();
}

class _BuyDiamondsState extends State<BuyDiamonds> {
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
        title: Text('Buy Diamonds'),
        centerTitle: true,
        backgroundColor: Colors.orange,
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Container(
              height: 10.0,
            ),
            Container(
              child: Text(
                "Your Current diamonds:- " + currentUser.userDiamond.toString(),
                style: TextStyle(
                  color: Colors.blue,
                  fontSize: 20.0,
                ),
              ),
            ),
            Container(
              height: 15.0,
            ),
            Container(
              child: Text(
                "Select Your Recharge Plan. ",
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 20.0,
                ),
              ),
            ),
            Container(
              height: 15.0,
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Payment(
                            amount: diamond.package1Value,
                            dimond: diamond.package1Diamonds)));
              },
              child: Container(
                height: 60.0,
                width: 350.0,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.0),
                  color: Colors.blue,
                ),
                child: Row(
                  children: <Widget>[
                    Container(
                      width: 20.0,
                    ),
                    Container(
                      alignment: Alignment.center,
                      height: 45.0,
                      width: 100.0,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.0),
                        color: Colors.orangeAccent,
                      ),
                      child: Text(diamond.package1Diamonds.toString(),
                          style: TextStyle(color: Colors.blue, fontSize: 20.0)),
                    ),
                    Container(
                      width: 50.0,
                    ),
                    Container(
                      // padding: EdgeInsets.only(left: 20.0),
                      child: Text("Rs. " + diamond.package1Value.toString(),
                          style: TextStyle(
                              color: Colors.orangeAccent, fontSize: 20.0)),
                    ),
                    Container(
                      width: 50.0,
                    ),
                    Container(
                      // padding: EdgeInsets.only(left: 20.0),
                      child: Text(diamond.package1Time.toString() + " min",
                          style: TextStyle(
                              color: Colors.orangeAccent, fontSize: 20.0)),
                    )
                  ],
                ),
              ),
            ),
            Container(
              height: 15.0,
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Payment(
                            amount: diamond.package2Value,
                            dimond: diamond.package2Diamonds)));
              },
              child: Container(
                height: 60.0,
                width: 350.0,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.0),
                  color: Colors.blue,
                ),
                child: Row(
                  children: <Widget>[
                    Container(
                      width: 20.0,
                    ),
                    Container(
                      alignment: Alignment.center,
                      height: 45.0,
                      width: 100.0,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.0),
                        color: Colors.orangeAccent,
                      ),
                      child: Text(diamond.package2Diamonds.toString(),
                          style: TextStyle(color: Colors.blue, fontSize: 20.0)),
                    ),
                    Container(
                      width: 50.0,
                    ),
                    Container(
                      child: Text("Rs " + diamond.package2Value.toString(),
                          style: TextStyle(
                              color: Colors.orangeAccent, fontSize: 20.0)),
                    ),
                    Container(
                      width: 50.0,
                    ),
                    Container(
                      // padding: EdgeInsets.only(left: 20.0),
                      child: Text(diamond.package2Time.toString() + " min",
                          style: TextStyle(
                              color: Colors.orangeAccent, fontSize: 20.0)),
                    )
                  ],
                ),
              ),
            ),
            Container(
              height: 15.0,
            ),
          ],
        ),
      ),
    );
  }
}
