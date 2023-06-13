import 'package:json_annotation/json_annotation.dart';

part 'deals_model.g.dart';

@JsonSerializable()
class DealsModel {
  String? id;
  String? storeId;
  String? name;
  String? arabicName;
  String? description;
  String? arabicDescription;
  String? coupon;
  String? image;
  String? link;
  List<String?>? tags;

  DealsModel(
      {this.id,
      this.storeId,
      this.name,
      this.arabicName,
      this.description,
      this.arabicDescription,
      this.coupon,
      this.image,
      this.link,
      this.tags});

  factory DealsModel.fromJson(Map<String, dynamic> json) =>
      _$DealsModelFromJson(json);

  /// Connect the generated [_$PersonToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$DealsModelToJson(this);
}
