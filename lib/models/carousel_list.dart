class CarouselList {
  String? message;
  List<Carousel?>? carousel;

  CarouselList({this.message, this.carousel});

  CarouselList.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    if (json['carousel'] != null) {
      carousel = [];
      json['carousel'].forEach((v) {
        carousel?.add(Carousel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['message'] = message;
    if (carousel != null) {
      data['carousel'] = carousel?.map((v) => v?.toJson()).toList();
    }
    return data;
  }
}

class Carousel {
  String? sId;
  List<String>? images;
  String? header;
  int? index;
  int? iV;

  Carousel({this.sId, this.images, this.header, this.index, this.iV});

  Carousel.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    images = json['images'].cast<String>();
    header = json['header'];
    index = json['index'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['_id'] = sId;
    data['images'] = images;
    data['header'] = header;
    data['index'] = index;
    data['__v'] = iV;
    return data;
  }
}
