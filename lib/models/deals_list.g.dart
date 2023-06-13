// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'deals_list.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DealsList _$DealsListFromJson(Map<String, dynamic> json) => DealsList(
      message: json['message'] as String?,
      dealsList: (json['deal'] as List<dynamic>?)
          ?.map((e) => DealsModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$DealsListToJson(DealsList instance) => <String, dynamic>{
      'message': instance.message,
      'dealsList': instance.dealsList,
    };
