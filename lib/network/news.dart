class APIItems {
  List<Newsrss>? newsrss;

  APIItems({this.newsrss});

  APIItems.fromJson(Map<String, dynamic> json) {
    if (json['newsrss'] != null) {
      newsrss = <Newsrss>[];
      json['newsrss'].forEach((v) {
        newsrss!.add(new Newsrss.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.newsrss != null) {
      data['newsrss'] = this.newsrss!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Newsrss {
  String? title;
  String? desc;
  String? sdimage;
  String? type;
  String? streamUrl;
  String? feedUrl;

  Newsrss(
      {this.title,
        this.desc,
        this.sdimage,
        this.type,
        this.streamUrl,
        this.feedUrl});

  Newsrss.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    desc = json['desc'];
    sdimage = json['sdimage'];
    type = json['type'];
    streamUrl = json['stream_url'];
    feedUrl = json['feed_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['desc'] = this.desc;
    data['sdimage'] = this.sdimage;
    data['type'] = this.type;
    data['stream_url'] = this.streamUrl;
    data['feed_url'] = this.feedUrl;
    return data;
  }
}
