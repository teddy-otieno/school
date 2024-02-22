// ignore_for_file: non_constant_identifier_names

import 'dart:developer';

import 'package:shulesmart/repository/conn_client.dart';

Future<void> send_parent_information(Map<String, dynamic> body) async {
  try {
    var response = await client.post(
      create_path("/api/parents/signup"),
      body: body,
    );

    log(response.statusCode.toString());
  } catch (e) {
    log(e.toString());
  }
}
