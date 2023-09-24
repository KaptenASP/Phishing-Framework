import 'package:flutter/material.dart';

class PhishingHomePage extends StatefulWidget {
  final String title;

  const PhishingHomePage({Key? key, required this.title}) : super(key: key);

  @override
  State<PhishingHomePage> createState() => _PhishingHomePageState();
}

class _PhishingHomePageState extends State<PhishingHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: const Text("Hello World!"),
    );
  }
}
