// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_session.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserSession _$UserSessionFromJson(Map<String, dynamic> json) => UserSession(
      first_name: json['first_name'] as String,
      last_name: json['last_name'] as String,
      email: json['email'] as String,
      token: json['token'] as String,
      id: json['id'] as int,
      is_parent: json['is_parent'] as bool,
      is_vendor: json['is_vendor'] as bool,
    );

Map<String, dynamic> _$UserSessionToJson(UserSession instance) =>
    <String, dynamic>{
      'first_name': instance.first_name,
      'last_name': instance.last_name,
      'token': instance.token,
      'email': instance.email,
      'id': instance.id,
      'is_parent': instance.is_parent,
      'is_vendor': instance.is_vendor,
    };
