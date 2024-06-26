import 'package:flutter/material.dart';
import 'package:phishing_framework/attack.dart';
import 'package:phishing_framework/app_scheme.dart';
import 'package:phishing_framework/helpers/network_helper.dart';
import 'package:phishing_framework/phishing_homepage.dart';
import 'package:phishing_framework/victim.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Phishing Framework',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch(
          brightness: Brightness.dark,
          backgroundColor: AppScheme.backgroundColor,
          cardColor: AppScheme.backgroundColor,
        ),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // final List<PhishingAttack> _phishingAttacks = [];

  @override
  void initState() {
    AttackManager.instance.loadAllAttacks().then((value) {
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    AttackManager manager = AttackManager.instance;

    return Scaffold(
      appBar: AppBar(),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: AppScheme.primaryColor,
              ),
              child: Text(
                'More Options',
                style: TextStyle(
                  color: AppScheme.headlineColor,
                  fontSize: 24,
                ),
              ),
            ),
            // Add a button that when clicked on will open an alert dialog
            ListTile(
              title: const Text('Add Template'),
              onTap: () => showDialog(
                context: context,
                builder: (BuildContext context) {
                  final TextEditingController templateNameController =
                      TextEditingController();
                  final TextEditingController templateHtmlController =
                      TextEditingController();

                  return AlertDialog(
                    title: const Text("New Template"),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextField(
                          decoration: const InputDecoration(labelText: "Template Name"),
                          controller: templateNameController,
                        ),
                        SingleChildScrollView(
                          child: TextField(
                            decoration: const InputDecoration(labelText: "Template HTML"),
                            controller: templateHtmlController,
                            keyboardType: TextInputType.multiline,
                            maxLines: 10,
                          ),
                        ),
                      ],
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text("Cancel"),
                      ),
                      TextButton(
                        onPressed: () {
                          setState(
                            () {
                              Session.instance.createNewTemplate(templateNameController.text, templateHtmlController.text);
                            },
                          );
                          Navigator.pop(context);
                        },
                        child: const Text("Create"),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
      body: ListView(
        padding: EdgeInsets.only(
          top: 20,
          left: MediaQuery.of(context).size.width / 3,
          right: MediaQuery.of(context).size.width / 3,
          bottom: 20,
        ),
        children: [
          Text(
            "Aditya's Phishing Framework",
            style: AppScheme.headlineStyle,
          ),
          Row(
            children: [
              Container(
                width: 30,
                height: 30,
                margin: const EdgeInsets.all(10.0),
                child: FloatingActionButton(
                  heroTag: "add_attack",
                  backgroundColor: AppScheme.primaryColor,
                  onPressed: () => showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      final TextEditingController attackNameontroller =
                          TextEditingController();
                      final TextEditingController attackDescController =
                          TextEditingController();
                      final TextEditingController attackRedirectUrl =
                          TextEditingController();
                      String templateName = "";

                      return AlertDialog(
                        title: const Text("New Attack"),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TextField(
                              decoration: const InputDecoration(
                                  labelText: "Attack Name"),
                              controller: attackNameontroller,
                            ),
                            TextField(
                              decoration: const InputDecoration(
                                  labelText: "Attack Description"),
                              controller: attackDescController,
                            ),
                            // Add a dropdown for templates
                            DropdownButtonFormField(
                              decoration: const InputDecoration(
                                  labelText: "Attack Template"),
                              items: manager.templateNames
                                  .map(
                                    (e) => DropdownMenuItem(
                                      value: e,
                                      child: Text(e),
                                    ),
                                  )
                                  .toList(),
                              onChanged: (String? value) {
                                templateName = value ?? "";
                              },
                            ),
                            TextField(
                              decoration: const InputDecoration(
                                  labelText: "Redirect URL"),
                              controller: attackRedirectUrl,
                            ),
                          ],
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text("Cancel"),
                          ),
                          TextButton(
                            onPressed: () {
                              setState(
                                () {
                                  AttackManager.instance.addAttack(
                                    PhishingAttack.create(
                                      attackNameontroller.text,
                                      attackDescController.text,
                                      templateName,
                                      attackRedirectUrl.text,
                                    ),
                                  );
                                },
                              );
                              Navigator.pop(context);
                            },
                            child: const Text("Create"),
                          ),
                        ],
                      );
                    },
                  ),
                  child: const Icon(Icons.add),
                ),
              ),
              Container(
                width: 30,
                height: 30,
                margin: const EdgeInsets.all(10.0),
                child: FloatingActionButton(
                  heroTag: "sync",
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
              Container(
                width: 30,
                height: 30,
                margin: const EdgeInsets.all(10.0),
                child: FloatingActionButton(
                  heroTag: "delete_all_attacks",
                  backgroundColor: AppScheme.primaryColor,
                  onPressed: () => {
                    setState(() {
                      // _phishingAttacks.clear();
                      AttackManager.instance.deleteAllAttacks();
                    })
                  },
                  child: const Icon(Icons.dangerous),
                ),
              ),
            ],
          ),
          Column(
            children: AttackManager.instance.attacks
                .map(
                  (e) => InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PhishingHomePage(
                            attack: e,
                          ),
                        ),
                      );
                    },
                    child: ListTile(
                      leading: CircleAvatar(
                        // backgroundColor: AppScheme.primaryColor,
                        // foregroundColor: AppScheme.paragraphColor,
                        // Make background colour image background from image at './assets/gradient1.jpeg'
                        backgroundImage: const AssetImage(
                          'assets/images/g2.jpeg',
                        ),
                        child: Text(e.name.characters.first.toUpperCase(),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            )),
                      ),
                      title: Text(e.name),
                      subtitle: Text(e.description),
                      trailing: const Icon(Icons.favorite_rounded),
                    ),
                  ),
                )
                .toList(),
          )
        ],
      ),
    );
  }
}
