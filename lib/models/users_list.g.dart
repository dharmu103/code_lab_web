// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'users_list.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UsersList _$UsersListFromJson(Map<String, dynamic> json) => UsersList(
      message: json['message'] as String?,
      users: (json['users'] as List<dynamic>?)
          ?.map((e) => UserModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$UsersListToJson(UsersList instance) => <String, dynamic>{
      'message': instance.message,
      'users': instance.users,
    };
