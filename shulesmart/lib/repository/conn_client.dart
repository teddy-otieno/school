import 'package:http/retry.dart';
import 'package:http/http.dart' as http;

final client = RetryClient(http.Client());

Uri create_path(String other) {
  return Uri.http('192.168.0.30:4000', other);
}
