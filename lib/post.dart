class Post {
  String title;
  String summary;
  String thumbUrl;
  int timeStamp;
  String url;
  String byline;

  Post(this.title, this.summary, this.thumbUrl, this.timeStamp, this.url,this.byline);

  static Post getPostFrmJSONPost(dynamic jsonObject) {
    String title = jsonObject['title'];
    String url = jsonObject['url'];
    String byline = jsonObject['byline'];
    String summary = jsonObject['abstract'];
    List multiMediaList = jsonObject['multimedia'];
    // We want an average-quality image or nothing
    String thumbUrl = multiMediaList.length > 4? multiMediaList[3]['url'] : "";

    int timeStamp = DateTime.parse(jsonObject['created_date']).millisecondsSinceEpoch;

    return new Post(title, summary, thumbUrl, timeStamp, url, byline);
  }

  @override
  String toString() {
    return "title = $title; summary = $summary; thumbnail = $thumbUrl; "
        "timeStamp = $timeStamp; url = $url, byline = $byline";
  }

  static fromJson(Map<String, dynamic> c) {}

  Map<String, dynamic> toJson() {}
}