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

  Future<void> addTemplateToAttack(
      String attackId, String templateName, String redirect_url) async {
    http.Response res = await post(
      NetworkConsts.addTemplateToAttackUrl,
      {
        "attack_id": attackId,
        "template_name": templateName,
        "redirect_url": redirect_url,
        "operation": ""
      },
    );

    print(res.statusCode);
    print(res.body);
  }

  Future<void> createNewTemplate(String name, String html) async {
    http.Response res = await post(
      NetworkConsts.createNewTemplateUrl,
      {
        "name": name,
        "html": html,
      },
    );
    print(res.statusCode);
    print(res.body);
  }

  Future<void> sendEmail(
    List<Map<String, String>> victims, 
    String fromName, 
    String fromEmail, 
    String subject, 
    String html, 
    List<Map<String, String>> fields,
    String phishingLink
  ) async {
    http.Response res = await post(
      NetworkConsts.emailSendUrl,
      {
        "victims": victims,
        "from": fromName,
        "from_email": fromEmail,
        "subject": subject,
        "phishing_link": phishingLink,
        "html": html,
        "additional_fields": fields,
      },
    );

    print(res.statusCode);
    print(res.body);
  }
}
