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
    http.Response res =
        await post(NetworkConsts.victimUrl, NetworkConsts.victimBody);
    return json.decode(res.body);
  }

  Future<Map> getTemplates() async {
    http.Response res = await post(NetworkConsts.templateUrl, {});
    return json.decode(res.body);
  }

  Future<void> addTemplateToAttack(String attackId, String templateName) async {
    http.Response res = await post(
      NetworkConsts.addTemplateToAttackUrl,
      {
        "attack_id": attackId,
        "template_name": templateName,
      },
    );

    print(res.statusCode);
    print(res.body);
  }
}
