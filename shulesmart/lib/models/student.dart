import 'package:json_annotation/json_annotation.dart';

part "student.g.dart";

@JsonSerializable()
class Student {
  int id;
  String first_name, last_name;

  Student({
    required this.id,
    required this.first_name,
    required this.last_name,
  });

  factory Student.fromJson(Map<String, dynamic> json) =>
      _$StudentFromJson(json);
}
