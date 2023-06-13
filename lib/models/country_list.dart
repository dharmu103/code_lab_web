import 'country_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'country_list.g.dart';

@JsonSerializable()
class CountryList {
  String? message;
  List<CountryModel>? countryList;
  CountryList({this.message, this.countryList});
  factory CountryList.fromJson(Map<String, dynamic> json) =>
      _$CountryListFromJson(json);

  Map<String, dynamic> toJson() => _$CountryListToJson(this);
}
