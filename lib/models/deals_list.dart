import 'package:json_annotation/json_annotation.dart';

import 'deals_model.dart';
part 'deals_list.g.dart';

@JsonSerializable()
class DealsList {
  String? message;
  List<DealsModel>? dealsList;

  DealsList({this.message, this.dealsList});

  factory DealsList.fromJson(Map<String, dynamic> json) =>
      _$DealsListFromJson(json);

  Map<String, dynamic> toJson() => _$DealsListToJson(this);
}
