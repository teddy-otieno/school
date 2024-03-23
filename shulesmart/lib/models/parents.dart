// ignore_for_file: non_constant_identifier_names

import 'package:json_annotation/json_annotation.dart';

part "parents.g.dart";

@JsonEnum()
enum TransactionType {
  @JsonValue("DEBIT")
  debit,
  @JsonValue("CREDIT")
  credit
}

@JsonSerializable()
class Transaction {
  int id;
  DateTime inserted_at, updated_at;
  String comment, debit, credit;
  TransactionType type;

  Transaction({
    required this.id,
    required this.inserted_at,
    required this.updated_at,
    required this.comment,
    required this.debit,
    required this.credit,
    required this.type,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) =>
      _$TransactionFromJson(json);

  Map<String, dynamic> toJson() => _$TransactionToJson(this);
}

@JsonSerializable(explicitToJson: true)
class ParentProfile {
  List<Transaction> transactions;

  ParentProfile({required this.transactions});

  factory ParentProfile.fromJson(Map<String, dynamic> json) =>
      _$ParentProfileFromJson(json);

  Map<String, dynamic> toJson() => _$ParentProfileToJson(this);
}
