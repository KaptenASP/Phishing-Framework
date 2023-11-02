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
  String redirectUrl;
  String status = "offline";
  late String id;

  final Map<int, Victim> _victims = {};

  PhishingAttack.create(
      this.name, this.description, this.template, this.redirectUrl) {
    id = idGenerator();
    url = NetworkConsts.getAttackUrl(id);
    Session.instance.addTemplateToAttack(id, template, redirectUrl);
  }

  PhishingAttack.createExisting(
    this.name,
    this.url,
    this.description,
    this.id,
    this.template,
    this.redirectUrl,
    victims,
  ) {

    for (var element in victims) {
      Victim v = Victim.fromJson(element);
      _victims[v.ident] = v;
    }
  }

  List<Victim> get targets => _victims.values.where((e) => e.state == VictimState.target).toList();
  List<Victim> get emailed => _victims.values.where((e) => e.state == VictimState.emailed).toList();
  List<Victim> get clicked => _victims.values.where((e) => e.state == VictimState.clicked).toList();
  List<Victim> get victims => _victims.values.where((e) => e.state == VictimState.victim).toList();

  // Add target
  void addVictim(Victim victim) {
    _victims[victim.ident] = victim;
  }

  // Remove target
  void removeVictim(int id) {
    _victims.remove(id);
  }

  Victim getVictim(int id) {
    return _victims[id]!;
  }

  void removeAllVictims() {
    _victims.clear();
  }

  static PhishingAttack fromJson(MapEntry<String, dynamic> json) =>
      PhishingAttack.createExisting(
        json.value['name'] as String,
        json.value['url'] as String,
        json.value['description'] as String,
        json.value['id'] as String,
        json.value['template'] as String,
        json.value['redirect_url'] as String,
        json.value['victims'] as List<dynamic>,
      );

  Map<String, dynamic> toJson() => {
        'name': name,
        'url': url,
        'description': description,
        'id': id,
        'template': template,
        'redirect_url': redirectUrl,
        'victims': _victims.values.map((e) => e.toJson()).toList(),
      };
}

class AttackManager {
  final List<String> _templateNames = [];
  final List<PhishingAttack> _attacks = [];

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
  List<PhishingAttack> get attacks => _attacks;

  Future<void> addAttack(PhishingAttack attack) async {
    _attacks.add(attack);
    await saveAllAttacks();
  }

  Future<void> deleteAllAttacks() async {
    _attacks.clear();
    await saveAllAttacks();
  }

  Future<void> saveAllAttacks() async {
    Map<String, dynamic> m = {};

    for (final attack in _attacks) {
      m[attack.id] = attack.toJson();
    }

    Storage.instance.saveToStorage('attacks', m);
  }

  Future<void> loadAllAttacks() async {
    final Map<String, dynamic>? m =
        await Storage.instance.loadFromStorage('attacks');

    if (m == null) {
      return;
    }

    for (final entry in m.entries) {
      _attacks.add(PhishingAttack.fromJson(entry));
    }
  }
}
