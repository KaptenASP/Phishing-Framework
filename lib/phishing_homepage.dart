import 'package:flutter/material.dart';
import 'package:phishing_framework/attack.dart';
import 'package:phishing_framework/app_scheme.dart';
import 'package:phishing_framework/email_selector.dart';

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
            child: AppScheme.infoCard(
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Description",
                    style: TextStyle(
                      color: AppScheme.headlineColor,
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    widget.attack.description,
                    style: TextStyle(
                      color: AppScheme.paragraphColor,
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width,
            child: AppScheme.successCard(
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Successfully Deployed!",
                    style: TextStyle(
                      color: AppScheme.headlineColor,
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SelectableText(
                    widget.attack.url,
                    style: TextStyle(
                      color: AppScheme.paragraphColor,
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
            ),
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
          Row(
            children: [
              Container(
                width: 30,
                height: 30,
                margin: const EdgeInsets.all(10.0),
                child: FloatingActionButton(
                  onPressed: () {
                    // Navigate to EmailSelector()
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const EmailSelector(),
                      ),
                    );
                  },
                  backgroundColor: AppScheme.primaryColor,
                  child: const Icon(Icons.email),
                ),
              ),
            ],
          ),
          Text(
            "Victims",
            style: AppScheme.secondaryHeader,
          ),
          SizedBox(
            height: 200,
            child: ListView.builder(
              scrollDirection: Axis.vertical,
              itemCount: widget.attack.victims.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(
                    "email: ${widget.attack.victims[index].email}",
                  ),
                  subtitle: Text(
                    "password: ${widget.attack.victims[index].password}",
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
