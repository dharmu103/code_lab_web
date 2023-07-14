class BannerList {
  String? message;
  List<Banner?>? banner;

  BannerList({this.message, this.banner});

  BannerList.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    if (json['banner'] != null) {
      banner = [];
      json['banner'].forEach((v) {
        banner?.add(Banner.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    // ignore: unnecessary_this
    data['message'] = this.message;
    if (banner != null) {
      data['banner'] = banner?.map((v) => v?.toJson()).toList();
    }
    return data;
  }
}

class Banner {
  String? sId;
  String? image;
  int? index;
  int? iV;

  Banner({this.sId, this.image, this.index, this.iV});

  Banner.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    image = json['image'];
    index = json['index'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['image'] = image;
    data['index'] = index;
    data['__v'] = iV;
    return data;
  }
}
