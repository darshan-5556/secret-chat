import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:secretchatting/Login.dart';
import 'package:secretchatting/Normal_Person/MainPage.dart';

class Payment extends StatefulWidget {
  final int amount;
  final int dimond;
  Payment({@required this.amount, @required this.dimond});
  @override
  _PaymentState createState() => _PaymentState(amount: amount, dimond: dimond);
}

class _PaymentState extends State<Payment> {
  final int amount;
  final int dimond;

  _PaymentState({@required this.amount, @required this.dimond});

  Razorpay _razorPay;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _razorPay = Razorpay();
    _razorPay.on(Razorpay.EVENT_PAYMENT_SUCCESS, handlePaymentSuccess);
    _razorPay.on(Razorpay.EVENT_PAYMENT_ERROR, handlePaymentError);
    //_razorPay.on(Razorpay.EVENT_EXTERNAL_WALLET, handleExternalWallet);
    //_razorPay.on(Razorpay.PAYMENT_CANCELLED, handleCancle);
    openCheckout();
  }

  void openCheckout() async {
    var options = {
      'key': 'xxxxxxxxxxxxxxxxxxx',
      'amount': amount * 100,
      'name': "Secret Chat",
      'Description': 'Safe and secure payment gatway.',
      'prefill': {'contact': '', 'email': ''},
      'external': {
        // 'wallets': ['paytm']
      }
    };

    try {
      _razorPay.open(options);
    } catch (e) {
      print(e);
    }
  }

  void handlePaymentSuccess(PaymentSuccessResponse response) {
    Fluttertoast.showToast(
        msg: "Payment Successful. $dimond added to your account");
    print('success');
    usersRefrance.document(currentUser.id).updateData({
      'userDiamond': currentUser.userDiamond + dimond,
    });
    setState(() {
      currentUser.userDiamond + dimond;
    });
    Navigator.pop(context, true);
    Navigator.pop(context, true);
  }

  void handlePaymentError(PaymentFailureResponse response) {
    Fluttertoast.showToast(msg: "Some error occured, please try again.");
    print('success');
    Navigator.pop(context);
  }

  // void handleExternalWallet(ExternalWalletResponse response) {
  //   Fluttertoast.showToast(msg: "External Wallet. Recharge Succesful");
  //   usersRefrance.document(currentUser.id).updateData({
  //     'userDiamond': currentUser.userDiamond + dimond,
  //   });
  //   setState(() {
  //     currentUser.userDiamond + dimond;
  //   });
  //   Navigator.pop(context);
  // }

  @override
  void dispose() {
    // TODO: implement dispose
    _razorPay.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
