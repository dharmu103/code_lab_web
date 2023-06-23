// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map<String, dynamic> json) => UserModel(
      sId: json['_Id'] as String?,
      firstName: json['first_name'] as String?,
      lastName: json['last_name'] as String?,
      email: json['email'] as String?,
      countryCode: json['country_code'] as String?,
      phoneNumber: json['phone_number'] as String?,
      referrer: json['referrer'] as String?,
      referralCode: json['referral_code'] as String?,
      referralPoints: json['referral_points'] as int?,
      emailVerified: json['email_verified'] as bool?,
      phoneNumberVerified: json['phone_number_nerified'] as bool?,
      profileImage: json['profile_image'] as String?,
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
