// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map<String, dynamic> json) => UserModel(
      sId: json['sId'] as String?,
      firstName: json['firstName'] as String?,
      lastName: json['lastName'] as String?,
      email: json['email'] as String?,
      countryCode: json['countryCode'] as String?,
      phoneNumber: json['phoneNumber'] as String?,
      referrer: json['referrer'] as String?,
      referralCode: json['referralCode'] as String?,
      referralPoints: json['referralPoints'] as int?,
      emailVerified: json['emailVerified'] as bool?,
      phoneNumberVerified: json['phoneNumberVerified'] as bool?,
      profileImage: json['profileImage'] as String?,
      iV: json['iV'] as int?,
    );

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
      'sId': instance.sId,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'email': instance.email,
      'countryCode': instance.countryCode,
      'phoneNumber': instance.phoneNumber,
      'referrer': instance.referrer,
      'referralCode': instance.referralCode,
      'referralPoints': instance.referralPoints,
      'emailVerified': instance.emailVerified,
      'phoneNumberVerified': instance.phoneNumberVerified,
      'profileImage': instance.profileImage,
      'iV': instance.iV,
    };
