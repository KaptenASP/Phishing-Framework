import 'package:flutter/material.dart';
import 'package:phishing_framework/attack.dart';
import 'package:phishing_framework/app_scheme.dart';
import 'package:phishing_framework/email_selector.dart';
import 'package:phishing_framework/helpers/network_helper.dart';
import 'package:phishing_framework/victim.dart';

class PhishingHomePage extends StatefulWidget {
  final PhishingAttack attack;

  const PhishingHomePage({Key? key, required this.attack}) : super(key: key);

  @override
  State<PhishingHomePage> createState() => _PhishingHomePageState();
}

class _PhishingHomePageState extends State<PhishingHomePage> {
  List<String> victimList = <String>[
    "victims",
    "targets",
    "emailed",
    "clicked"
  ];
  String dropdownValue = "victims";
  int idx = 0;

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
                    "Successfully Deployed! Demo URL:",
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
                "Targets",
                widget.attack.targets.length,
                "ppl",
              ),
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
                        builder: (context) => EmailSelector(widget.attack),
                      ),
                    );
                  },
                  backgroundColor: AppScheme.primaryColor,
                  child: const Icon(Icons.email),
                ),
              ),
              Container(
                width: 30,
                height: 30,
                margin: const EdgeInsets.all(10.0),
                child: FloatingActionButton(
                  heroTag: "addTarget",
                  backgroundColor: AppScheme.primaryColor,
                  // Add target
                  onPressed: () => showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      final TextEditingController emailController =
                          TextEditingController();
                      final TextEditingController nameController =
                          TextEditingController();

                      return AlertDialog(
                        title: const Text("Add Target"),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TextField(
                              controller: emailController,
                              decoration: const InputDecoration(
                                labelText: "Email",
                              ),
                            ),
                            TextField(
                              controller: nameController,
                              decoration: const InputDecoration(
                                labelText: "Name",
                              ),
                            ),
                          ],
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text("Cancel"),
                          ),
                          TextButton(
                            onPressed: () {
                              setState(() {
                                widget.attack.addVictim(
                                  Victim(
                                    emailController.text,
                                    nameController.text,
                                  ),
                                );
                                AttackManager.instance.saveAllAttacks();
                              });
                              Navigator.pop(context);
                            },
                            child: const Text("Add"),
                          ),
                        ],
                      );
                    }
                  ),
                  child: const Icon(Icons.contact_emergency),
                ),
              ),
              Container(
                width: 30,
                height: 30,
                margin: const EdgeInsets.all(10.0),
                child: FloatingActionButton(
                  // Add target
                  onPressed: () => setState(() {
                    widget.attack.removeAllVictims();
                  }),
                  backgroundColor: AppScheme.primaryColor,
                  child: const Icon(Icons.delete_forever_outlined),
                ),
              ),
              Container(
                width: 30,
                height: 30,
                margin: const EdgeInsets.all(10.0),
                child: FloatingActionButton(
                  heroTag: "sync_page",
                  backgroundColor: AppScheme.primaryColor,
                  onPressed: () async {
                    Map<String, dynamic> m = Map<String, dynamic>.from(
                      await Session.instance.getVictims(),
                    );

                    List<dynamic> victims = m["data"];
                    
                    setState(() {
                        AttackManager.instance.syncAttacks(victims);
                      });
                  },
                  child: const Icon(Icons.sync),
                ),
              ),
            ],
          ),
          DropdownMenu<String>(
            initialSelection: victimList.first,
            onSelected: (String? value) {
              // This is called when the user selects an item.
              setState(() {
                idx = victimList.indexOf(value!);
                dropdownValue = value;
              });
            },
            dropdownMenuEntries:
                victimList.map<DropdownMenuEntry<String>>((String value) {
              return DropdownMenuEntry<String>(value: value, label: value);
            }).toList(),
          ),
          createVictimList(
            // lambda expression where VictimViewer.idx is used
            idx == 0
                ? widget.attack.victims
                : idx == 1
                    ? widget.attack.targets
                    : idx == 2
                        ? widget.attack.emailed
                        : widget.attack.clicked,
          )
        ],
      ),
    );
  }
}

SizedBox createVictimList(List<Victim> victims) {
  return SizedBox(
    height: 200,
    child: ListView.builder(
      scrollDirection: Axis.vertical,
      itemCount: victims.length,
      itemBuilder: (context, index) {
        return createVictimTile(victims[index], context);
      },
    ),
  );
}

Card createVictimTile(Victim victim, context) {
  return Card(
    // child is a listtile that expands
    child: ExpansionTile(
      title: Text(victim.name),
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width,
          child: AppScheme.infoCard(
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Email",
                  style: TextStyle(
                    color: AppScheme.headlineColor,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  victim.email,
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
          child: AppScheme.infoCard(
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Password",
                  style: TextStyle(
                    color: AppScheme.headlineColor,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  victim.password,
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
          child: AppScheme.infoCard(
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "IP Details",
                  style: TextStyle(
                    color: AppScheme.headlineColor,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  victim.ipDetails.toString(),
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
          child: AppScheme.infoCard(
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Device Info",
                  style: TextStyle(
                    color: AppScheme.headlineColor,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  victim.deviceDetails,
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
          child: AppScheme.infoCard(
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Other Info",
                  style: TextStyle(
                    color: AppScheme.headlineColor,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  victim.otherInfo,
                  style: TextStyle(
                    color: AppScheme.paragraphColor,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}

Padding tableText(String text) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Text(text),
  );
}