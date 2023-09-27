import 'package:flutter/material.dart';
import 'package:phishing_framework/attack.dart';
import 'package:phishing_framework/app_scheme.dart';

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
      backgroundColor: AppScheme.backgroundColor,
      appBar: AppBar(),
      body: ListView(
        padding: EdgeInsets.only(
          top: 20,
          left: MediaQuery.of(context).size.width / 3,
          right: MediaQuery.of(context).size.width / 3,
          bottom: 20,
        ),
        children: [
          Text(
            widget.attack.name,
            style: AppScheme.headlineStyle,
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width,
            child: AppScheme.infoCard(widget.attack.description),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              AppScheme.metricCard(
                "Emailed",
                widget.attack.emailed.length,
                "ppl",
              ),
              AppScheme.metricCard(
                "Clicked",
                widget.attack.clicked.length,
                "ppl",
              ),
              AppScheme.metricCard(
                "Victims",
                widget.attack.victims.length,
                "ppl",
              ),
            ],
          ),
        ],
      ),
    );
  }
}
