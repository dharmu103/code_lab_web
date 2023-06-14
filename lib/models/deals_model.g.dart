// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'deals_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DealsModel _$DealsModelFromJson(Map<String, dynamic> json) => DealsModel(
      id: json['id'] as String?,
      storeId: json['storeId'] as String?,
      name: json['name'] as String?,
      arabicName: json['name_arabic'] as String?,
      description: json['description'] as String?,
      arabicDescription: json['description_arabic'] as String?,
      coupon: json['coupon'] as String?,
      image: json['image'] as String?,
      link: json['link'] as String?,
      tags: (json['tags'] as List<dynamic>?)?.map((e) => e as String?).toList(),
    );

Map<String, dynamic> _$DealsModelToJson(DealsModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'storeId': instance.storeId,
      'name': instance.name,
      'arabicName': instance.arabicName,
      'description': instance.description,
      'arabicDescription': instance.arabicDescription,
      'coupon': instance.coupon,
      'image': instance.image,
      'link': instance.link,
      'tags': instance.tags,
    };
