// ignore_for_file: non_constant_identifier_names

import 'package:json_annotation/json_annotation.dart';

part "student.g.dart";

@JsonEnum()
enum StudentAccountStatus {
  @JsonValue("LOW")
  low,
  @JsonValue("OK")
  ok,
}

@JsonSerializable()
class Student {
  int id;
  String first_name, last_name, balance;
  StudentAccountStatus status;
  String? image;

  Student({
    required this.id,
    required this.first_name,
    required this.last_name,
    required this.balance,
    required this.status,
    this.image
  });

  factory Student.fromJson(Map<String, dynamic> json) =>
      _$StudentFromJson(json);
}


@JsonSerializable(explicitToJson: true)
class StudentBalanceData {
  int id;
  String name, balance;
  StudentAccountStatus status;

  StudentBalanceData({
    required this.id,
    required this.name,
    required this.balance,
    required this.status,
  });

  factory StudentBalanceData.fromJson(Map<String, dynamic> json) =>
      _$StudentBalanceDataFromJson(json);

  Map<String, dynamic> toJson() => _$StudentBalanceDataToJson(this);
}
