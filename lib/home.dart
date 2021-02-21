import 'package:flutter/material.dart';
import 'package:wave_test/post.dart';
import 'package:wave_test/details.dart';
import 'package:wave_test/api.dart';
import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:http/http.dart' as http;


class Home extends StatefulWidget {

  Home({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomeState createState() => new _MyHomeState();
}

class _MyHomeState extends State<Home> {
  bool _isRequestSent = false;
  bool _isRequestFailed = false;
  List<Post> postList = [];

  @override
  Widget build(BuildContext context) {
    if (!_isRequestSent) {
      sendRequest();
    }
    return new Scaffold(
      backgroundColor: Colors.black,
      appBar: new AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        centerTitle: true,
        title: new Text(widget.title,style: new TextStyle(color: Colors.white, fontSize: 18.0,fontWeight: FontWeight.bold),),
      ),
      body: new Container(
        decoration: BoxDecoration(
            color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15),
            topRight: Radius.circular(15),
          )
        ),
        alignment: Alignment.center,
        child: !_isRequestSent ? new CircularProgressIndicator() :
        _isRequestFailed ? _retry() :
        new Container(
          child: new ListView.builder(
              itemCount: postList.length,
              scrollDirection: Axis.vertical,
              itemBuilder: (BuildContext context, int index) {
                return _get(index);
              }),
        ),
      ),
    );
  }

  void sendRequest() async {
    String url = "${NYT.url+NYT.apiKey}";
    try {
      http.Response response = await http.get(url);
      if (response.statusCode == 200) {
        Map decode = json.decode(response.body);
        parseResponse(decode);
      } else {
        print(response.statusCode);
        handleRequestError();
      }
    } catch (e) {
      print(e);
      handleRequestError();
    }
  }

  Widget _get(int index) {
    var post = postList[index];
    return new InkWell(
      onTap: () {
        Navigator.push(
            context,
            new MaterialPageRoute(
                builder: (BuildContext context) => new PostDetails(post)));
      },
      child: Container(
        height: MediaQuery.of(context).size.height/4,
        margin: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
        child: new Stack(
          children: <Widget>[
            Container(
              alignment: Alignment.center,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: new CachedNetworkImage(
                  width: double.infinity,
                  imageUrl: post.thumbUrl,
                  fit: BoxFit.fitWidth,
                ),
              ),
            ),
            Positioned.fill(
              child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black45,
                      borderRadius: BorderRadius.circular(15)
                    ),
                    height: MediaQuery.of(context).size.height/12,
                    width: MediaQuery.of(context).size.width,
                    
                    child: Row(
                      children: [
                        Expanded(
                          flex:8,
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(10,5,5,5),
                            child: new Text(
                              post.title,
                              style: new TextStyle(color: Colors.white, fontSize: 18.0,fontWeight: FontWeight.bold),
                              textAlign: TextAlign.left,
                            ),
                          ),
                        ),
                        Expanded(
                          flex:2,
                          child: IconButton(icon: Icon(Icons.bookmark_border_outlined,color: Colors.white,),
                              onPressed: (){}),

                        )
                      ],
                    )
                  )
              ),
            )

          ],
        ),
      )
    );
  }

  Widget _retry() {
    return new Container(
      child: new Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          new Text('Не удалось загрузить', style: new TextStyle(fontSize: 16.0),),
          new Padding(
            padding: new EdgeInsets.only(top: 10.0),
            child: new InkWell(
              onTap: (){
                setState(() {
                  _isRequestSent = false;
                  _isRequestFailed = false;
                });
              },
              child: new Text('Обновить', style: new TextStyle(color: Colors.white),
              ),
            ),
          )
        ],
      ),
    );
  }

  void parseResponse(Map response) {
    List results = response["results"];
    for (var jsonObject in results) {
      var post = Post.fromJson(jsonObject);
      postList.add(post);
      print(post);
    }
    setState(() => _isRequestSent = true);
  }

  void handleRequestError() {
    setState(() {
      _isRequestSent = true;
      _isRequestFailed = true;
    });
  }





}
