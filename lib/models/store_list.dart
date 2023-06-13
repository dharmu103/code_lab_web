import 'package:json_annotation/json_annotation.dart';

import 'deals_model.dart';
import 'store_model.dart';
part 'store_list.g.dart';

@JsonSerializable()
class StoreList {
  String? message;
  List<StoreModel>? stores;
  List<DealsModel>? deals;

  StoreList({this.message, this.stores, this.deals});

  factory StoreList.fromJson(Map<String, dynamic> json) =>
      _$StoreListFromJson(json);

  Map<String, dynamic> toJson() => _$StoreListToJson(this);
}
