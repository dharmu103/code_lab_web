class CarouselList {
  String? message;
  List<Carousel>? carousel;

  CarouselList({this.message, this.carousel});

  CarouselList.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    if (json['carousel'] != null) {
      carousel = [];
      json['carousel'].forEach((v) {
        carousel?.add(new Carousel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    if (this.carousel != null) {
      data['carousel'] = this.carousel?.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Carousel {
  String? sId;
  List<Images>? images;
  String? header;
  int? index;
  int? iV;

  Carousel({this.sId, this.images, this.header, this.index, this.iV});

  Carousel.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    if (json['images'] != null) {
      images = [];
      json['images'].forEach((v) {
        images?.add(new Images.fromJson(v));
      });
    }
    header = json['header'];
    index = json['index'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    if (this.images != null) {
      data['images'] = this.images?.map((v) => v.toJson()).toList();
    }
    data['header'] = this.header;
    data['index'] = this.index;
    data['__v'] = this.iV;
    return data;
  }
}

class Images {
  String? link;
  String? store;

  Images({this.link, this.store});

  Images.fromJson(Map<String, dynamic> json) {
    link = json['link'];
    store = json['store'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['link'] = this.link;
    data['store'] = this.store;
    return data;
  }
}
