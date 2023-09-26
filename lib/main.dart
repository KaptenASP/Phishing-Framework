import 'package:flutter/material.dart';
import 'package:phishing_framework/attack.dart';
import 'package:phishing_framework/colours.dart';
import 'package:phishing_framework/phishing_homepage.dart';

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
  final List<PhishingAttack> _phishing_attacks = [];

  @override
  void initState() {
    _phishing_attacks.addAll(loadAllAttacks());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Aditya's Phishing Framework",
          style: AppScheme.headlineStyle,
        ),
        actions: [
          FloatingActionButton(
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
                        decoration:
                            const InputDecoration(labelText: "Attack Name"),
                        controller: attackNameontroller,
                      ),
                      TextField(
                        decoration:
                            const InputDecoration(labelText: "Attack URL"),
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
                            _phishing_attacks.add(PhishingAttack.create(
                              attackNameontroller.text,
                              attackURLController.text,
                              attackDescController.text,
                            ));

                            saveAllAttacks(_phishing_attacks);
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
        ],
      ),
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
      body: ListView(
        children: _phishing_attacks
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
      ),
    );
  }
}
