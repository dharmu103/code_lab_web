// ignore_for_file: unnecessary_new

class BannerList {
  String? message;
  List<Banner>? banner;

  BannerList({this.message, this.banner});

  BannerList.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    if (json['banner'] != null) {
      banner = [];
      json['banner'].forEach((v) {
        banner?.add(new Banner.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['message'] = message;
    if (banner != null) {
      data['banner'] = banner?.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Banner {
  String? sId;
  String? image;
  int? index;
  String? store;
  String? storeName;
  String? country;

  Banner(
      {this.sId,
      this.image,
      this.index,
      this.store,
      this.storeName,
      this.country});

  Banner.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    image = json['image'];
    index = json['index'];
    store = json['store'];
    country = json['country'];
    storeName = json['store_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['image'] = image;
    data['index'] = index;
    data['store'] = store;
    data['store_name'] = storeName;
    return data;
  }
}
