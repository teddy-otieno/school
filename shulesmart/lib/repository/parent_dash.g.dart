// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'parent_dash.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SchoolStudentSearchValue _$SchoolStudentSearchValueFromJson(
        Map<String, dynamic> json) =>
    SchoolStudentSearchValue(
      school_name: json['school_name'] as String,
      student_id: json['student_id'] as int,
      student_name: json['student_name'] as String,
    );

Map<String, dynamic> _$SchoolStudentSearchValueToJson(
        SchoolStudentSearchValue instance) =>
    <String, dynamic>{
      'school_name': instance.school_name,
      'student_id': instance.student_id,
      'student_name': instance.student_name,
    };
