import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:phishing_framework/helpers/network_consts.dart';

class Session {
  // Implement singleton
  Session._privateConstructor();
  static final Session instance = Session._privateConstructor();

  final http.Client _client = http.Client();

  Future<http.Response> get(String url) async {
    return _client.get(Uri.parse(url));
  }

  // Send json post request
  Future<http.Response> post(String url, Map<String, dynamic> body) async {
    return _client.post(
      Uri.parse(url),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(body),
    );
  }

  Future<Map> getVictims() async {
    http.Response res = await post(NetworkConsts.url, NetworkConsts.body);
    return json.decode(res.body);
  }
}
