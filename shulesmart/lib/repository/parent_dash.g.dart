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

JournalEntry _$JournalEntryFromJson(Map<String, dynamic> json) => JournalEntry(
      id: json['id'] as int,
      comment: json['comment'] as String,
    );

Map<String, dynamic> _$JournalEntryToJson(JournalEntry instance) =>
    <String, dynamic>{
      'id': instance.id,
      'comment': instance.comment,
    };

StudentTransaction _$StudentTransactionFromJson(Map<String, dynamic> json) =>
    StudentTransaction(
      id: json['id'] as int,
      comment: json['comment'] as String?,
      credit: json['credit'] as String,
      debit: json['debit'] as String,
      inserted_at: DateTime.parse(json['inserted_at'] as String),
      debit_entry: json['debit_entry'] == null
          ? null
          : JournalEntry.fromJson(json['debit_entry'] as Map<String, dynamic>),
      credit_entry: json['credit_entry'] == null
          ? null
          : JournalEntry.fromJson(json['credit_entry'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$StudentTransactionToJson(StudentTransaction instance) =>
    <String, dynamic>{
      'id': instance.id,
      'comment': instance.comment,
      'credit': instance.credit,
      'debit': instance.debit,
      'inserted_at': instance.inserted_at.toIso8601String(),
      'debit_entry': instance.debit_entry?.toJson(),
      'credit_entry': instance.credit_entry?.toJson(),
    };
