import 'package:flutter/material.dart';
import 'package:phishing_framework/attack.dart';
import 'package:phishing_framework/colours.dart';

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
      appBar: AppBar(
        title: Text(
          widget.attack.name,
          style: AppScheme.headlineStyle,
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Attack Details",
                style: AppScheme.secondaryHeader,
              ),
              Row(
                children: [
                  const Icon(Icons.link),
                  Text(
                    "  URL: ",
                    style: AppScheme.tertiaryHeader,
                  ),
                  Text(
                    widget.attack.url,
                    style: AppScheme.paragraphStyle,
                  ),
                ],
              ),
              Row(
                children: [
                  const Icon(Icons.description_outlined),
                  Text(
                    "  Description: ",
                    style: AppScheme.tertiaryHeader,
                  ),
                  Text(
                    widget.attack.description,
                    style: AppScheme.paragraphStyle,
                  ),
                ],
              ),
              Text(
                "Current Statistics",
                style: AppScheme.secondaryHeader,
              ),
            ],
          )
        ],
      ),
    );
  }
}
