// ignore_for_file: non_constant_identifier_names

import 'dart:convert';
import 'dart:developer';

import 'package:shulesmart/models/user_session.dart';
import 'package:shulesmart/repository/conn_client.dart';
import 'package:shulesmart/utils/utils.dart';

Future<bool> send_parent_information(Map<String, dynamic> body) async {
  var client = ApiClient.get_instance();

  try {
    var response = await client.post(
      "/api/parents/signup",
      body,
    );

    log(response.statusCode.toString());
    return true;
  } catch (e) {
    log(e.toString());
    return false;
  }
}

Future<Result<UserSession, String>> send_login_information(
  Map<String, dynamic> body,
) async {
  var client = ApiClient.get_instance();

  try {
    var response = await client.post("/api/login", body);
    log(response.body);

    if (response.statusCode == 200) {
      return Result.ok(UserSession.fromJson(jsonDecode(response.body)["data"]));
    }

    return Result.err(jsonDecode(response.body)["message"]);
  } catch (e) {
    log(e.toString());
    return Result.err("Unreachable");
  }
}
