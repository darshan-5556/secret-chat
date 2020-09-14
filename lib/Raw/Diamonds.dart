import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class diamonds {
  final int package1Diamonds;
  final int package1Time;
  final int package1Value;
  final int package2Diamonds;
  final int package2Time;
  final int package2Value;
  final int package3Diamonds;
  final int package3Value;
  final int package4Diamonds;
  final int package4Value;
  final int package5Diamonds;
  final int package5Value;

  diamonds(
      {this.package1Diamonds,
      this.package1Time,
      this.package1Value,
      this.package2Diamonds,
      this.package2Time,
      this.package2Value,
      this.package3Diamonds,
      this.package3Value,
      this.package4Diamonds,
      this.package4Value,
      this.package5Diamonds,
      this.package5Value});

  factory diamonds.fromDocument(DocumentSnapshot doc) {
    return diamonds(
      package1Diamonds: doc['package1Diamonds'],
      package1Time: doc['package1Time'],
      package1Value: doc['package1Value'],
      package2Diamonds: doc['package2Diamonds'],
      package2Time: doc['package2Time'],
      package2Value: doc['package2Value'],
      package3Diamonds: doc['package3Diamonds'],
      package3Value: doc['package3Value'],
      package4Diamonds: doc['package4Diamonds'],
      package4Value: doc['package4Value'],
      package5Diamonds: doc['package5Diamonds'],
      package5Value: doc['package5Value'],
    );
  }
}
