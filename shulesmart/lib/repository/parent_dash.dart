// ignore_for_file: non_constant_identifier_names

import 'dart:convert';
import 'dart:developer';

import 'package:json_annotation/json_annotation.dart';
import 'package:shulesmart/models/student.dart';
import 'package:shulesmart/repository/conn_client.dart';
import 'package:shulesmart/utils/utils.dart';
import 'package:fpdart/fpdart.dart' as fp;

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
  log("Searching student...");
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

Future<Result<String, String>> initiate_submit_deposit_to_student(
    int student_id, int amount) async {
  var client = ApiClient.get_instance();

  try {
    var response = await client.post_with_auth(
      "/api/parents/deposit",
      {
        "student": student_id.toString(),
        "amount": amount.toString(),
      },
    );

    if (response.statusCode == 200) {
      return Result.ok("");
    }

    return Result.err("");
  } catch (e, stack) {
    log(e.toString(), stackTrace: stack);
    return Result.err("");
  }
}

Future<Result<List<Student>, String>>
    fetch_students_belonging_to_parent() async {
  var client = ApiClient.get_instance();

  try {
    var response = await client.get_with_auth("/api/parents/students/");

    if (response.statusCode != 200) {
      return Result.err("Something went wrong");
    }

    log(response.body);
    return Result.ok(
      List.from(
        jsonDecode(response.body)["data"].map((e) {
          var x = Student.fromJson(e);
          return x;
        }).toList(),
      ),
    );
  } catch (e) {
    log(e.toString());
    return Result.err("No Internet Connection");
  }
}

@JsonSerializable()
class JournalEntry {
  int id;
  String comment;

  JournalEntry({required this.id, required this.comment});

  factory JournalEntry.fromJson(Map<String, dynamic> json) =>
      _$JournalEntryFromJson(json);

  Map<String, dynamic> toJson() => _$JournalEntryToJson(this);
}

@JsonSerializable(explicitToJson: true)
class StudentTransaction {
  int id;
  String? comment;
  String credit, debit;
  DateTime inserted_at;
  JournalEntry? debit_entry, credit_entry;
  StudentTransaction({
    required this.id,
    required this.comment,
    required this.credit,
    required this.debit,
    required this.inserted_at,
    required this.debit_entry,
    required this.credit_entry,
  });

  factory StudentTransaction.fromJson(Map<String, dynamic> json) =>
      _$StudentTransactionFromJson(json);

  Map<String, dynamic> toJson() => _$StudentTransactionToJson(this);
}

Future<Result<List<StudentTransaction>, String>>
    fetch_student_recent_transaction_history(
  int student_id,
) async {
  var client = ApiClient.get_instance();

  try {
    var response = await client
        .get_with_auth("/api/parents/students/transactions/$student_id");

    log(response.body);
    if (response.statusCode == 200) {
      return Result.ok(
        List.from(
          jsonDecode(response.body)["data"].map((x) {
            var e = StudentTransaction.fromJson(x);
            return e;
          }).toList(),
        ),
      );
    }

    return Result.err("Something went wront");
  } catch (e) {
    log(e.toString());
    return Result.err("Internet is unavailable");
  }
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

@JsonSerializable(explicitToJson: true)
class ParentInformaticData {
  List<StudentBalanceData> student_balances;
  int learner_count;
  String overall_balance;

  ParentInformaticData({
    required this.student_balances,
    required this.learner_count,
    required this.overall_balance,
  });

  factory ParentInformaticData.fromJson(Map<String, dynamic> json) =>
      _$ParentInformaticDataFromJson(json);

  Map<String, dynamic> toJson() => _$ParentInformaticDataToJson(this);
}

Future<fp.Either<String, ParentInformaticData>>
    fetch_parent_informatics() async {
  var client = ApiClient.get_instance();

  var response = await fp.TaskEither.tryCatch(
    () => client.get_with_auth("/api/parents/informatics/"),
    (e, s) => "Error: $e",
  ).run();

  return response.flatMap((a) {
    if (a.statusCode != 200) {
      log(a.body);
      return const fp.Left("Something went wrong.");
    }

    log(a.body);
    return fp.Right(ParentInformaticData.fromJson(jsonDecode(a.body)["data"]));
  });
}
