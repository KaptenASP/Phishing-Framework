import 'package:phishing_framework/helpers/file_helper.dart';
import 'package:phishing_framework/helpers/network_consts.dart';
import 'package:phishing_framework/helpers/network_helper.dart';
import 'package:phishing_framework/victim.dart';

String idGenerator() {
  final now = DateTime.now();
  return now.microsecondsSinceEpoch.toString();
}

class PhishingAttack {
  String name;
  late String url;
  String description;
  String template;
  String redirect_url;
  String status = "offline";
  late String id;

  final List<Victim> _emailed = [];
  final List<Victim> _clicked = [];
  final List<Victim> _victims = [];

  PhishingAttack.create(
      this.name, this.description, this.template, this.redirect_url) {
    id = idGenerator();
    url = NetworkConsts.getAttackUrl(id);
    Session.instance.addTemplateToAttack(id, template, redirect_url);
  }

  PhishingAttack.createExisting(this.name, this.url, this.description, this.id,
      this.template, this.redirect_url);

  List<Victim> get emailed => _emailed;
  List<Victim> get clicked => _clicked;
  List<Victim> get victims => _victims;

  static PhishingAttack fromJson(MapEntry<String, dynamic> json) =>
      PhishingAttack.createExisting(
        json.value['name'] as String,
        json.value['url'] as String,
        json.value['description'] as String,
        json.value['id'] as String,
        json.value['template'] as String,
        json.value['redirect_url'] as String,
      );

  Map<String, dynamic> toJson() => {
        'name': name,
        'url': url,
        'description': description,
        'id': id,
        'template': template,
        'redirect_url': redirect_url,
      };
}

class AttackManager {
  final List<String> _templateNames = [];

  AttackManager._privateConstructor() {
    getSavedTemplates();
  }

  static final AttackManager instance = AttackManager._privateConstructor();

  Future<void> getSavedTemplates() async {
    Map<String, dynamic> templates =
        Map<String, dynamic>.from(await Session.instance.getTemplates());

    // Create list string from templates['templates']
    List<dynamic> templateNames = templates['templates'];

    for (String templateName in templateNames) {
      _templateNames.add(templateName);
    }
  }

  List<String> get templateNames => _templateNames;

  Future<void> saveAllAttacks(List<PhishingAttack> attacks) async {
    Map<String, dynamic> m = {};

    for (final attack in attacks) {
      m[attack.id] = attack.toJson();
    }

    Storage.instance.saveToStorage('attacks', m);
  }

  Future<List<PhishingAttack>> loadAllAttacks() async {
    final Map<String, dynamic>? m =
        await Storage.instance.loadFromStorage('attacks');

    if (m == null) {
      return [];
    }

    final List<PhishingAttack> attacks = [];

    for (final entry in m.entries) {
      attacks.add(PhishingAttack.fromJson(entry));
    }

    return attacks;
  }
}
