import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class FullPhotos extends StatelessWidget {
  final String url;
  FullPhotos({this.url});


  @override
  _FullPhotoState createState() => _FullPhotoState();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: IconThemeData(
          color: Colors.white
        ),
      ),
      body: FullPhoto(url: url),
    );
  }
}

class FullPhoto extends StatefulWidget {
  final String url;
  FullPhoto({this.url});

  @override
  _FullPhotoState createState() => _FullPhotoState(url:url);
}

class _FullPhotoState extends State<FullPhoto> {
  final String url;
  _FullPhotoState({this.url});


  @override
  Widget build(BuildContext context) {
    return Container(
      child: PhotoView(imageProvider: NetworkImage(url)),
    );
  }
}
