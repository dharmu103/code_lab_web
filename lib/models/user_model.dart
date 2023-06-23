import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';

@JsonSerializable()
class UserModel {
  String? sId;
  String? firstName;
  String? lastName;
  String? email;
  String? countryCode;
  String? phoneNumber;

  String? referrer;
  String? referralCode;
  int? referralPoints;
  bool? emailVerified;

  bool? phoneNumberVerified;

  String? profileImage;
  int? iV;

  UserModel(
      {this.sId,
      this.firstName,
      this.lastName,
      this.email,
      this.countryCode,
      this.phoneNumber,
      this.referrer,
      this.referralCode,
      this.referralPoints,
      this.emailVerified,
      this.phoneNumberVerified,
      this.profileImage,
      this.iV});

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);
}
