import 'package:json_annotation/json_annotation.dart';

part 'store_model.g.dart';

@JsonSerializable()
class StoreModel {
  String? id;
  String? country;
  String? name;
  String? arabicName;
  String? link;
  String? logo;
  int? index;
  List<String?>? tags;

  StoreModel({
    this.id,
    this.country,
    this.name,
    this.arabicName,
    this.link,
    this.logo,
    this.index,
    this.tags,
  });

  factory StoreModel.fromJson(Map<String, dynamic> json) =>
      _$StoreModelFromJson(json);

  Map<String, dynamic> toJson() => _$StoreModelToJson(this);
}
