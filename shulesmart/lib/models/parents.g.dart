// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'parents.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Transaction _$TransactionFromJson(Map<String, dynamic> json) => Transaction(
      id: json['id'] as int,
      inserted_at: DateTime.parse(json['inserted_at'] as String),
      updated_at: DateTime.parse(json['updated_at'] as String),
      comment: json['comment'] as String,
      debit: json['debit'] as String,
      credit: json['credit'] as String,
      type: $enumDecode(_$TransactionTypeEnumMap, json['type']),
    );

Map<String, dynamic> _$TransactionToJson(Transaction instance) =>
    <String, dynamic>{
      'id': instance.id,
      'inserted_at': instance.inserted_at.toIso8601String(),
      'updated_at': instance.updated_at.toIso8601String(),
      'comment': instance.comment,
      'debit': instance.debit,
      'credit': instance.credit,
      'type': _$TransactionTypeEnumMap[instance.type]!,
    };

const _$TransactionTypeEnumMap = {
  TransactionType.debit: 'DEBIT',
  TransactionType.credit: 'CREDIT',
};

ParentProfile _$ParentProfileFromJson(Map<String, dynamic> json) =>
    ParentProfile(
      transactions: (json['transactions'] as List<dynamic>)
          .map((e) => Transaction.fromJson(e as Map<String, dynamic>))
          .toList(),
      name: json['name'] as String,
    );

Map<String, dynamic> _$ParentProfileToJson(ParentProfile instance) =>
    <String, dynamic>{
      'transactions': instance.transactions.map((e) => e.toJson()).toList(),
      'name': instance.name,
    };
