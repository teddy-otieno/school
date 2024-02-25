// ignore_for_file: non_constant_identifier_names

import 'dart:convert';
import 'dart:developer';

import 'package:json_annotation/json_annotation.dart';
import 'package:shulesmart/repository/conn_client.dart';
import 'package:shulesmart/utils/utils.dart';

part "parent_dash.g.dart";

@JsonSerializable()
class SchoolStudentSearchValue {
  String school_name;
  int student_id;
  String student_name;

  SchoolStudentSearchValue({
    required this.school_name,
    required this.student_id,
    required this.student_name,
  });

  factory SchoolStudentSearchValue.fromJson(Map<String, dynamic> json) =>
      _$SchoolStudentSearchValueFromJson(json);
}

Future<Result<List<SchoolStudentSearchValue>, String>> search_for_student(
  String school_name,
  String student_name,
) async {
  var client = ApiClient.get_instance();

  try {
    var response = await client.post_with_auth(
      "/api/parents/students/find_child",
      {"school_name": school_name, "student_name": student_name},
    );

    if (response.statusCode != 200) {
      return Result.err("Something went wrong please try again later");
    }

    return Result.ok(
      List.from(
        jsonDecode(response.body)["data"]
            .map(
              (x) => SchoolStudentSearchValue.fromJson(x),
            )
            .toList(),
      ),
    );
  } catch (e) {
    log(e.toString());
    return Result.err("Please check your internet connection");
  }
}

void assign_parent_to_id(int student_id) async {
  var client = ApiClient.get_instance();

  try {
    var response = await client.get_with_auth(
      "/api/parents/students/assign/$student_id",
    );

    log(response.body);
  } catch (e) {
    log(e.toString());
  }
}
