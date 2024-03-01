// ignore_for_file: non_constant_identifier_names

import 'dart:developer';

import 'package:http/retry.dart';
import 'package:http/http.dart' as http;

class ApiClient {
  static ApiClient? _instance;
  String? token;

  final _client = RetryClient(http.Client());

  ApiClient._();

  static ApiClient get_instance() {
    if (_instance == null) {
      _instance = ApiClient._();
      return _instance!;
    }

    return _instance!;
  }

  void init(String? token) {
    log("Token has been set");
    this.token = token;
  }

  Future<http.Response> post(String url, Map<String, dynamic> body) async {
    var response = _client.post(create_path(url), body: body);

    return response;
  }

  Future<http.Response> get(String url) async {
    var response = _client.post(create_path(url));

    return response;
  }

  Future<http.Response> post_with_auth(
    String url,
    Map<String, dynamic> body,
  ) async {
    assert(token != null);
    var response = _client.post(
      create_path(url),
      body: body,
      headers: {"Authorization": "Bearer ${token!}"},
    );

    return response;
  }

  Future<http.Response> get_with_auth(String url) async {
    assert(token != null);
    var response = _client.get(
      create_path(url),
      headers: {"Authorization": "Bearer ${token!}"},
    );

    return response;
  }
}

Uri create_path(String other) {
  return Uri.http('192.168.0.15:4000', other);
}
