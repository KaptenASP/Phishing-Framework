import 'package:flutter/material.dart';
import 'package:phishing_framework/attack.dart';
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
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
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
  final List<PhishingAttack> _pages = List.empty(growable: true);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Aditya's Phishing Framework")),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'More Options',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            FloatingActionButton.extended(
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
                                    _pages.add(
                                      PhishingAttack(
                                          attackNameontroller.text,
                                          attackDescController.text,
                                          attackURLController.text),
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
                label: const Text("New Attack")),
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
        children: _pages
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
                  leading: CircleAvatar(child: Text(e.name.characters.first)),
                  title: Text(e.name),
                  subtitle: Text('Click to navigate to ${e.name}'),
                  trailing: const Icon(Icons.favorite_rounded),
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}
