// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'deals_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DealsModel _$DealsModelFromJson(Map<String, dynamic> json) => DealsModel(
      id: json['_id'] as String?,
      index: json['index'] as int?,
      storeId: json['store'] as String?,
      name: json['name'] as String?,
      arabicName: json['name_arabic'] as String?,
      description: json['description'] as String?,
      arabicDescription: json['description_arabic'] as String?,
      coupon: json['coupon'] as String?,
      image: json['image'] as String?,
      lastused: json['last_used'] as String?,
      usedtimes: json['used_times'] as String?,
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
      'lastused': instance.lastused,
      'usedtimes': instance.usedtimes,
      'tags': instance.tags,
    };
