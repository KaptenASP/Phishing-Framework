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
          brightness: Brightness.light,
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
  final List<PhishingAttack> _phishingAttacks = [];

  @override
  void initState() {
    _phishingAttacks.addAll(loadAllAttacks());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
            const ListTile(
              leading: Icon(Icons.message),
              title: Text('Messages'),
            ),
            const ListTile(
              leading: Icon(Icons.account_circle),
              title: Text('Profile'),
            ),
            const ListTile(
              leading: Icon(Icons.settings),
              title: Text('Settings'),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: EdgeInsets.only(
          top: 20,
          left: MediaQuery.of(context).size.width / 3,
          right: MediaQuery.of(context).size.width / 3,
          bottom: 20,
        ),
        child: Column(
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
                    backgroundColor: AppScheme.primaryColor,
                    onPressed: () => showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        final TextEditingController attackNameontroller =
                            TextEditingController();
                        final TextEditingController attackDescController =
                            TextEditingController();
                        final TextEditingController attackURLController =
                            TextEditingController();

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
                                    labelText: "Attack URL"),
                                controller: attackURLController,
                              ),
                              TextField(
                                decoration: const InputDecoration(
                                    labelText: "Attack Description"),
                                controller: attackDescController,
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
                                    _phishingAttacks.add(PhishingAttack.create(
                                      attackNameontroller.text,
                                      attackURLController.text,
                                      attackDescController.text,
                                    ));
                                    print(_phishingAttacks.last.id);
                                    saveAllAttacks(_phishingAttacks);
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
                    backgroundColor: AppScheme.primaryColor,
                    onPressed: () async {
                      Map<String, dynamic> m = Map<String, dynamic>.from(
                        await Session.instance.getVictims(),
                      );

                      List<dynamic> victims = m["data"];

                      for (var victim in victims) {
                        Map<String, String> v = Map<String, String>.from(
                          victim,
                        );

                        // Get the attack
                        for (PhishingAttack attack in _phishingAttacks) {
                          if (attack.id == v["Id"]) {
                            attack.victims.add(
                              Victim.withPassword(
                                v["Username"] ?? "",
                                v["Password"] ?? "",
                              ),
                            );
                          }
                        }

                        setState(() {});
                      }
                    },
                    child: const Icon(Icons.sync),
                  ),
                )
              ],
            ),
            Column(
              children: _phishingAttacks
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
                          backgroundColor: AppScheme.primaryColor,
                          foregroundColor: AppScheme.paragraphColor,
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
      ),
    );
  }
}
