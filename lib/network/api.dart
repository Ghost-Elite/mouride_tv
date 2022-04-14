class ApiService {
  List<Allitems>? allitems;
  String? date;
  String? error;

  ApiService.withError(String errorMessage){
    error = errorMessage;
  }

  ApiService.fromJson(Map<String, dynamic> json) {
    if (json['allitems'] != null) {
      allitems = <Allitems>[];
      json['allitems'].forEach((v) {
        allitems!.add(new Allitems.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.allitems != null) {
      data['allitems'] = this.allitems!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Allitems {
  String? title;
  String? des;
  String? type;
  String? logo;
  String? streamUrl;
  String? hlsUrl;
  String? feedUrl;

  Allitems(
      {this.title,
        this.des,
        this.type,
        this.logo,
        this.streamUrl,
        this.hlsUrl,
        this.feedUrl});

  Allitems.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    des = json['des'];
    type = json['type'];
    logo = json['logo'];
    streamUrl = json['stream_url'];
    hlsUrl = json['hls_url'];
    feedUrl = json['feed_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['des'] = this.des;
    data['type'] = this.type;
    data['logo'] = this.logo;
    data['stream_url'] = this.streamUrl;
    data['hls_url'] = this.hlsUrl;
    data['feed_url'] = this.feedUrl;
    return data;
  }
}
