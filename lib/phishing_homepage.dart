import 'package:flutter/material.dart';
import 'package:phishing_framework/attack.dart';

class PhishingHomePage extends StatefulWidget {
  final PhishingAttack attack;

  const PhishingHomePage({Key? key, required this.attack}) : super(key: key);

  @override
  State<PhishingHomePage> createState() => _PhishingHomePageState();
}

class _PhishingHomePageState extends State<PhishingHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.attack.name)),
      body: const Text("Hello World!"),
    );
  }
}
