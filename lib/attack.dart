import 'package:phishing_framework/file_helper.dart';
import 'package:phishing_framework/victim.dart';

String idGenerator() {
  final now = DateTime.now();
  return now.microsecondsSinceEpoch.toString();
}

class PhishingAttack {
  String name;
  String url;
  String description;
  String status = "offline";
  late String id;

  final List<Victim> _emailed = [];
  final List<Victim> _clicked = [];
  final List<Victim> _victims = [];

  PhishingAttack.create(this.name, this.url, this.description) {
    id = idGenerator();
  }

  PhishingAttack.fromid(this.name, this.url, this.description, this.id);

  List<Victim> get emailed => _emailed;
  List<Victim> get clicked => _clicked;
  List<Victim> get victims => _victims;

  static PhishingAttack fromJson(MapEntry<String, dynamic> json) =>
      PhishingAttack.fromid(
        json.value['name'] as String,
        json.value['url'] as String,
        json.value['description'] as String,
        json.value['id'] as String,
      );

  Map<String, dynamic> toJson() => {
        'name': name,
        'url': url,
        'description': description,
        'id': id,
      };
}

Future<void> saveAllAttacks(List<PhishingAttack> attacks) async {
  Map<String, dynamic> m = {};

  for (final attack in attacks) {
    m[attack.id] = attack.toJson();
  }

  Storage.instance.saveToStorage('attacks', m);
}

List<PhishingAttack> loadAllAttacks() {
  final Map<String, dynamic>? m = Storage.instance.loadFromStorage('attacks');

  if (m == null) {
    return [];
  }

  final List<PhishingAttack> attacks = [];

  for (final entry in m.entries) {
    attacks.add(PhishingAttack.fromJson(entry));
  }

  return attacks;
}
