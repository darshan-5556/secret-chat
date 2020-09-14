import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:secretchatting/HomePage.dart';
import 'package:secretchatting/Login.dart';

class AboutUser extends StatefulWidget {
  @override
  _AboutUserState createState() => _AboutUserState();
}

class _AboutUserState extends State<AboutUser> {
  bool isLoading = false;
  String imgAvtar;
  File Image;
  String birthday = "Your Birthdate";
  DateTime _dateTime;
  String intrest;
  String whyHere;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    // imgAvtar = currentUser.url;
  }

  getImg() {
    return Container(
        alignment: Alignment.center,
        child: Stack(
          children: <Widget>[
            Container(
              alignment: Alignment.center,
              child: CircleAvatar(
                radius: 70.0,
                backgroundImage: imgAvtar != null
                    ? NetworkImage(imgAvtar)
                    : AssetImage('assets/images/userImg.png'),
              ),
            ),
            Container(
              height: 150.0,
              alignment: Alignment.bottomCenter,
              child: IconButton(
                  icon: Icon(Icons.camera_alt,
                      size: 30.0, color: Colors.orangeAccent),
                  onPressed: () => ChangeImageProfile(context)),
            )
          ],
        ));
  }

  getDateIme() {
    return showDatePicker(
        context: context,
        initialDate: DateTime(2000),
        firstDate: DateTime(1980),
        lastDate: DateTime(2021));
  }

  usersBirthdate() {
    return Container(
      height: 50.0,
      width: 200.0,
      decoration: BoxDecoration(
        color: Colors.orangeAccent,
      ),
      alignment: Alignment.center,
      child: FlatButton(
          onPressed: () {
            showDatePicker(
                    context: context,
                    initialDate: DateTime(2000, 1, 1),
                    firstDate: DateTime(1980, 1, 1),
                    lastDate: DateTime(2021, 1, 1))
                .then((value) {
              setState(() {
                _dateTime = value;
                birthday = value.toString();
              });
            });
          },
          child: Text(
            birthday,
            style: TextStyle(color: Colors.white, fontSize: 18.0),
          )),
    );
  }

  ChangeImageProfile(BuildContext context) async {
    // ignore: deprecated_member_use
    var Image = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      Image = Image;
      isLoading = true;
    });
    StorageUploadTask mStorageUploadTask =
        storageReference.child("post_$Image.jpg").putFile(Image);
    StorageTaskSnapshot storageTaskSnapshot =
        await mStorageUploadTask.onComplete;
    String downloadUrl = await storageTaskSnapshot.ref.getDownloadURL();
    usersRefrance.document(currentUser.id).updateData({
      "url": downloadUrl,
    });

    setState(() {
      imgAvtar = downloadUrl;
      isLoading = false;
    });
  }

  Widget intrestField() {
    return Container(
      height: 80.0,
      padding: EdgeInsets.fromLTRB(10, 10, 10, 1),
      color: Colors.white,
      child: TextFormField(
        decoration: InputDecoration(
          labelText: 'Intrest',
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.grey),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white70),
          ),
          border: OutlineInputBorder(),
        ),
        maxLength: 100,
        validator: (String value) {
          if (value.isEmpty) {
            return 'This Field is Required';
          }

          return null;
        },
        onSaved: (String value) {
          intrest = value;
        },
      ),
    );
  }

  Widget whyHereField() {
    return Container(
      height: 80.0,
      padding: EdgeInsets.fromLTRB(10, 10, 10, 1),
      color: Colors.white,
      child: TextFormField(
        decoration: InputDecoration(
          labelText: 'Why are you here..',
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.grey),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white70),
          ),
          border: OutlineInputBorder(),
        ),
        maxLength: 100,
        validator: (String value) {
          if (value.isEmpty) {
            return 'This Field is Required';
          }

          return null;
        },
        onSaved: (String value) {
          whyHere = value;
        },
      ),
    );
  }

  submitValue() async {
    if (!_formKey.currentState.validate()) {
      return;
    }
    _formKey.currentState.save();
    await usersRefrance.document(currentUser.id).updateData({
      "birthdate": _dateTime,
      "intrest": intrest,
      "whyHere": whyHere,
      "userDiamond": 0,
      "isUserPopular": false,
      "doesUserRecharge": false,
      "TypingState": false,
    });

    Navigator.push(
        context, MaterialPageRoute(builder: (context) => HomePage()));
  }

  submitButton() {
    return GestureDetector(
      onTap: () => submitValue(),
      child: Container(
        height: 50.0,
        width: 300.0,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.blueAccent,
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Text(
          "Submit",
          style: TextStyle(color: Colors.white, fontSize: 18.0),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          "Fill Data",
          style: TextStyle(color: Colors.black, fontSize: 18.0),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
            child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              getImg(),
              Container(
                child: isLoading ? CircularProgressIndicator() : Container(),
              ),
              Container(
                height: 30.0,
              ),
              usersBirthdate(),
              Container(
                height: 30.0,
              ),
              intrestField(),
              Container(
                height: 30.0,
              ),
              whyHereField(),
              Container(
                height: 30.0,
              ),
              submitButton(),
            ],
          ),
        )),
      ),
    );
  }
}
