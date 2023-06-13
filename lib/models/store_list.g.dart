// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'store_list.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StoreList _$StoreListFromJson(Map<String, dynamic> json) => StoreList(
      message: json['message'] as String?,
      stores: (json['store'] as List<dynamic>?)
          ?.map((e) => StoreModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      deals: (json['deals'] as List<dynamic>?)
          ?.map((e) => DealsModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$StoreListToJson(StoreList instance) => <String, dynamic>{
      'message': instance.message,
      'stores': instance.stores,
      'deals': instance.deals,
    };
