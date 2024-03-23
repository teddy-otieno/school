// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'student.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Student _$StudentFromJson(Map<String, dynamic> json) => Student(
      id: json['id'] as int,
      first_name: json['first_name'] as String,
      last_name: json['last_name'] as String,
      balance: json['balance'] as String,
      status: $enumDecode(_$StudentAccountStatusEnumMap, json['status']),
    );

Map<String, dynamic> _$StudentToJson(Student instance) => <String, dynamic>{
      'id': instance.id,
      'first_name': instance.first_name,
      'last_name': instance.last_name,
      'balance': instance.balance,
      'status': _$StudentAccountStatusEnumMap[instance.status]!,
    };

const _$StudentAccountStatusEnumMap = {
  StudentAccountStatus.low: 'LOW',
  StudentAccountStatus.ok: 'OK',
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
