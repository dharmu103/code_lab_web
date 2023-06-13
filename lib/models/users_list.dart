import 'package:json_annotation/json_annotation.dart';

import 'user_model.dart';

part 'users_list.g.dart';

@JsonSerializable()
class UsersList {
  String? message;
  List<UserModel>? users;

  UsersList({
    this.message,
    this.users,
  });

  factory UsersList.fromJson(Map<String, dynamic> json) =>
      _$UsersListFromJson(json);

  Map<String, dynamic> toJson() => _$UsersListToJson(this);
}
