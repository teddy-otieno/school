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

StudentBalanceData _$StudentBalanceDataFromJson(Map<String, dynamic> json) =>
    StudentBalanceData(
      id: json['id'] as int,
      name: json['name'] as String,
      balance: json['balance'] as String,
      status: $enumDecode(_$StudentAccountStatusEnumMap, json['status']),
    );

Map<String, dynamic> _$StudentBalanceDataToJson(StudentBalanceData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'balance': instance.balance,
      'status': _$StudentAccountStatusEnumMap[instance.status]!,
    };

const _$StudentAccountStatusEnumMap = {
  StudentAccountStatus.low: 'LOW',
  StudentAccountStatus.ok: 'OK',
};

ParentInformaticData _$ParentInformaticDataFromJson(
        Map<String, dynamic> json) =>
    ParentInformaticData(
      student_balances: (json['student_balances'] as List<dynamic>)
          .map((e) => StudentBalanceData.fromJson(e as Map<String, dynamic>))
          .toList(),
      learner_count: json['learner_count'] as int,
      overall_balance: json['overall_balance'] as String,
    );

Map<String, dynamic> _$ParentInformaticDataToJson(
        ParentInformaticData instance) =>
    <String, dynamic>{
      'student_balances':
          instance.student_balances.map((e) => e.toJson()).toList(),
      'learner_count': instance.learner_count,
      'overall_balance': instance.overall_balance,
    };
