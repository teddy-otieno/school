// ignore_for_file: non_constant_identifier_names

import 'package:json_annotation/json_annotation.dart';

part "user_session.g.dart";

@JsonSerializable()
class UserSession {
  final String first_name, last_name, token, email;
  final int id;
  final bool is_parent, is_vendor;

  UserSession({
    required this.first_name,
    required this.last_name,
    required this.email,
    required this.token,
    required this.id,
    required this.is_parent,
    required this.is_vendor,
  });

  factory UserSession.fromJson(Map<String, dynamic> json) =>
      _$UserSessionFromJson(json);

  Map<String, dynamic> toJson() => _$UserSessionToJson(this);
}
