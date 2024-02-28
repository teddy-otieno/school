// ignore_for_file: non_constant_identifier_names

import 'package:json_annotation/json_annotation.dart';

part "student.g.dart";

@JsonSerializable()
class Student {
  int id;
  String first_name, last_name, balance;

  Student({
    required this.id,
    required this.first_name,
    required this.last_name,
    required this.balance,
  });

  factory Student.fromJson(Map<String, dynamic> json) =>
      _$StudentFromJson(json);
}
