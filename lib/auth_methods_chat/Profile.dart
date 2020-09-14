import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:secretchatting/Login.dart';
import 'package:secretchatting/Raw/user.dart';
import 'package:secretchatting/auth_methods_chat/utility.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  bool isLoading = false;
  String imgAvter = currentUser.url;
  String username;
  String intrest = "";
  String whyHere = " ";
  final _formKey = GlobalKey<FormState>();

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
      imgAvter = downloadUrl;
      isLoading = false;
    });
  }

  data() {
    return StreamBuilder(
      stream: utility.getUsersInfo(userId: currentUser.id),
      builder: (context, snapshot) {
        User user;
        if (snapshot.hasData && snapshot.data != null) {
          user = User.fromDocument(snapshot.data);
          return Container(
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                  height: 10.0,
                ),
                Container(
                  height: 200.0,
                  width: 200.0,
                  alignment: Alignment.bottomRight,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.0),
                    image: DecorationImage(
                        image: NetworkImage(user.url), fit: BoxFit.cover),
                  ),
                  child: IconButton(
                      icon: Icon(
                        Icons.camera_alt,
                        size: 30.0,
                      ),
                      color: Colors.orange,
                      onPressed: () => ChangeImageProfile(context)),
                ),
                Container(
                  child: isLoading ? CircularProgressIndicator() : Container(),
                ),
                Container(
                  height: 30.0,
                ),
                Container(
                  child: Text(
                    user.username,
                    style: TextStyle(color: Colors.blue, fontSize: 20.0),
                  ),
                ),
                Container(
                  height: 30.0,
                ),
                Container(
                  child: Text(
                    user.intrest,
                    style: TextStyle(color: Colors.blue, fontSize: 20.0),
                  ),
                ),
                Container(
                  height: 30.0,
                ),
                Container(
                  child: Text(
                    user.whyHere,
                    style: TextStyle(color: Colors.blue, fontSize: 20.0),
                  ),
                ),
                Container(
                  height: 30.0,
                ),
                GestureDetector(
                  onTap: () => showContext(),
                  child: Container(
                    height: 50.0,
                    width: 200.0,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.0),
                      color: Colors.orange,
                    ),
                    child: Text("Change Profile",
                        style: TextStyle(color: Colors.white, fontSize: 20.0)),
                  ),
                )
              ],
            ),
          );
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  showContext() {
    Alert(
      style: AlertStyle(animationType: AnimationType.shrink),
      context: context,
      title: "Options",
      content: Column(
        children: <Widget>[
          Container(
            child: Form(
              key: _formKey,
              autovalidate: true,
              child: TextFormField(
                style: TextStyle(color: Colors.blue),
                validator: (val) {
                  if (val.trim().length < 4 || val.isEmpty) {
                    return "Username is very short";
                  } else if (val.trim().length > 20 || val.isEmpty) {
                    return "Username is very Long, Make it Short";
                  } else {
                    return null;
                  }
                },
                onChanged: (val) => username = val,
                decoration: InputDecoration(
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white70),
                  ),
                  border: OutlineInputBorder(),
                  labelText: "Username",
                  labelStyle: TextStyle(fontSize: 16.0),
                  hintText: "Must be at least 5 charactor",
                  hintStyle: TextStyle(color: Colors.grey),
                ),
              ),
            ),
          ),
          intrestField(),
          whyHereField(),
          Container(height: 5.0),
          GestureDetector(
            onTap: () => submitValue(),
            child: Container(
              height: 40.0,
              width: 230.0,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.orange,
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: Text("Done",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20.0,
                  )),
            ),
          )
        ],
      ),
    ).show();
  }

  submitValue() async {
    if (!_formKey.currentState.validate()) {
      return;
    }
    _formKey.currentState.save();
    await usersRefrance.document(currentUser.id).updateData({
      "intrest": intrest,
      "whyHere": whyHere,
      "username": username,
    });
    Navigator.pop(context, true);
  }

  Widget intrestField() {
    return Container(
      height: 80.0,
      // padding: EdgeInsets.fromLTRB(10, 10, 10, 1),
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
      //padding: EdgeInsets.fromLTRB(10, 10, 10, 1),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile"),
        backgroundColor: Colors.orange,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: data(),
      ),
    );
  }
}
