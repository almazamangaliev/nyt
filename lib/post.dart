import 'dart:convert';

List<Post> postFromJson(String str) =>
    List<Post>.from(json.decode(str).map((x) => Post.fromJson(x)));

String postToJson(List<Post> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Post {
  String title;
  String summary;
  String thumbUrl;
  int timeStamp;
  String url;
  String byline;

  Post(this.title, this.summary, this.thumbUrl, this.timeStamp, this.url,this.byline);

  static Post fromJson(dynamic jsonObject) {
    String title = jsonObject['title'];
    String url = jsonObject['url'];
    String byline = jsonObject['byline'];
    String summary = jsonObject['abstract'];
    List multiMediaList = jsonObject['multimedia'];
    String thumbUrl = multiMediaList.length > 4? multiMediaList[4]['url'] : "";
    int timeStamp = DateTime.parse(jsonObject['created_date']).millisecondsSinceEpoch;
    return new Post(title, summary, thumbUrl, timeStamp, url, byline);
  }

  @override
  String toString() {
    return "title = $title;"
           "summary = $summary;"
           "thumbnail = $thumbUrl;"
           "timeStamp = $timeStamp;"
           "url = $url,"
           "byline = $byline";
  }



  Map<String, dynamic> toJson() => {
    "title": title,
    "summary": summary,
    "thumbUrl": thumbUrl,
    "timeStamp": timeStamp,
    "url": url,
    "byline": byline,
  };

}