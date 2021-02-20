import 'package:flutter/material.dart';

// Мои файлы
import 'package:wave_test/post.dart';
import 'package:wave_test/post_details.dart';
import 'package:wave_test/nyt_api.dart';
import 'dart:convert';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<HomePage> {
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
        child: !_isRequestSent
        //  Request has not been sent, let's show a progress indicator
            ? new CircularProgressIndicator()

        // Request has been sent but did it fail?
            : _isRequestFailed
        // Yes, it has failed. Show a retry UI
            ? _showRetryUI()
        // No it didn't fail. Show the data
            : new Container(
          child: new ListView.builder(
              itemCount: postList.length,
              scrollDirection: Axis.vertical,
              itemBuilder: (BuildContext context, int index) {
                return _getPostWidgets(index);
              }),
        ),
      ),
    );
  }

  void sendRequest() async {
    String url = "${NYT.url+NYT.apiKey}";
    try {
      http.Response response = await http.get(url);
      // Did request succeeded?
      if (response.statusCode == HttpStatus.ok) {
        // We're expecting a Json object as the result
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

  Widget _getPostWidgets(int index) {
    var post = postList[index];
    return new GestureDetector(
      onTap: () {
        openDetailsUI(post);
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



  void parseResponse(Map response) {
    List results = response["results"];
    for (var jsonObject in results) {
      var post = Post.getPostFrmJSONPost(jsonObject);
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

  Widget _showRetryUI() {
    return new Container(
      child: new Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          new Text(
            'Ошибка запроса',
            style: new TextStyle(fontSize: 16.0),
          ),
          new Padding(
            padding: new EdgeInsets.only(top: 10.0),
            child: new RaisedButton(
              onPressed: retryRequest,
              child: new Text(
                'Повторить',
                style: new TextStyle(color: Colors.white),
              ),
              color: Theme.of(context).accentColor,
              splashColor: Colors.deepOrangeAccent,
            ),
          )
        ],
      ),
    );
  }

  void retryRequest() {
    setState(() {
      // Let's just reset the fields.
      _isRequestSent = false;
      _isRequestFailed = false;
    });
  }

  openDetailsUI(Post post) {
    Navigator.push(
        context,
        new MaterialPageRoute(
            builder: (BuildContext context) => new PostDetails(post)));
  }


}
