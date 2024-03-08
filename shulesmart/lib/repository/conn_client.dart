// ignore_for_file: non_constant_identifier_names

import 'dart:convert';
import 'dart:developer';

import 'package:http/retry.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart' as http_parser;
import 'package:image_picker/image_picker.dart';

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

  Future<http.StreamedResponse> post_form(
    String url, {
    required Map<String, String> body,
    List<XFile>? files,
  }) async {
    var request = http.MultipartRequest('POST', create_path(url));
    request.fields.addAll(body);
    request.headers["Authorization"] = "Bearer $token";

    if (files != null) {
      request.files.addAll(
        await Future.wait(
          files.map(
            (e) async => http.MultipartFile.fromBytes(
              "product_image",
              await e.readAsBytes(),
              filename: e.name,
              contentType: http_parser.MediaType.parse(
                e.mimeType ?? "image/jpeg",
              ),
            ),
          ),
        ),
      );
    }

    return await request.send();
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
      body: jsonEncode(body),
      headers: {
        "Authorization": "Bearer ${token!}",
        "Content-Type": "application/json"
      },
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
