class CategoriesList {
  List<String>? categories;

  CategoriesList({this.categories});

  CategoriesList.fromJson(Map<String, dynamic> json) {
    categories = json['categories'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['categories'] = categories;
    return data;
  }
}
