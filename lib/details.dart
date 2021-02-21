import 'package:flutter/material.dart';
import 'package:wave_test/post.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';


class PostDetails extends StatefulWidget {
  PostDetails(this.post);
  final Post post;

  @override
  State<StatefulWidget> createState() => new _PostDetailsState(post);
}

class _PostDetailsState extends State<PostDetails> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final Post post;

  _PostDetailsState(this.post);

  @override
  Widget build(BuildContext context) => new Scaffold(
    body: new Scaffold(
      key: _scaffoldKey,
      body: SafeArea(
        child: SingleChildScrollView(
          child: new Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Stack(
                children: [
                  Container(
                    child: new CachedNetworkImage(
                      width: double.infinity,
                      imageUrl: post.thumbUrl,
                      fit: BoxFit.cover,

                    ),
                  ),
                  IconButton(icon: Icon(Icons.arrow_back,color: Colors.white,), onPressed: (){
                    Navigator.pop(context);
                  })
                ],
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(10,10,5,5),
                child: new Text(
                  post.title,
                  textAlign: TextAlign.left,
                  style: new TextStyle(
                      color: Colors.black,
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(10,10,5,5),
                child: new Text(
                  getTime(),
                  textAlign: TextAlign.left,
                  style: new TextStyle(
                      color: Colors.black54,
                      fontSize: 14.0,
                      fontWeight: FontWeight.normal),
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(10.0),
                child: new Text(
                  post.summary,
                  style: new TextStyle(
                    fontSize: 16.0,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(10,10,5,5),
                child: new Text(
                  post.byline,
                  textAlign: TextAlign.left,
                  style: new TextStyle(
                      color: Colors.black54,
                      fontSize: 14.0,
                      fontWeight: FontWeight.normal),
                ),
              ),
            ],
          ),
        ),
      )
    )
  );



  String getTime() {
    var timeStamp = new DateTime.fromMillisecondsSinceEpoch(post.timeStamp);
    var formatter = new DateFormat('dd MMM, yyyy. HH:mm');
    return formatter.format(timeStamp);
  }


}