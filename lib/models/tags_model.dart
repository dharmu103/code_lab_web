// ignore_for_file: unnecessary_new

class TagsList {
  String? message;
  List<Categories>? categories;

  TagsList({this.message, this.categories});

  TagsList.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    if (json['categories'] != null) {
      categories = <Categories>[];
      json['categories'].forEach((v) {
        categories!.add(new Categories.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['message'] = message;
    if (categories != null) {
      data['categories'] = categories!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Categories {
  String? sId;
  String? name;
  String? nameArabic;
  int? index;
  int? iV;

  Categories({this.sId, this.name, this.nameArabic, this.index, this.iV});

  Categories.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    nameArabic = json['name_arabic'];
    index = json['index'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['name'] = name;

    data['index'] = index;
    data['__v'] = iV;
    return data;
  }
}
