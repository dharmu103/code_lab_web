// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'store_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StoreModel _$StoreModelFromJson(Map<String, dynamic> json) => StoreModel(
      id: json['_id'] as String?,
      country: json['country'] as String?,
      name: json['name'] as String?,
      arabicName: json['arabicName'] as String?,
      link: json['link'] as String?,
      logo: json['logo'] as String?,
      index: json['index'] as int?,
      tags: (json['tags'] as List<dynamic>?)?.map((e) => e as String?).toList(),
    );

Map<String, dynamic> _$StoreModelToJson(StoreModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'country': instance.country,
      'name': instance.name,
      'arabicName': instance.arabicName,
      'link': instance.link,
      'logo': instance.logo,
      'index': instance.index,
      'tags': instance.tags,
    };
