import 'package:flutter/material.dart';


class Message{
  String message;


  Message({
    this.message,

  });

  Message.fromMap(Map<String, dynamic> map) {
    this.message = map['content'];
  }

}