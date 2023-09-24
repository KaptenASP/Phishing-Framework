import 'package:phishing_framework/victim.dart';

class PhishingAttack {
  String name;
  String url;
  String description;

  final List<Victim> _victims = List.empty(growable: true);

  PhishingAttack(this.name, this.url, this.description);

  void addVictim(Victim victim) {
    victims.add(victim);
  }

  // get victims
  List<Victim> get victims => _victims;
}
