import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:phishing_framework/app_scheme.dart';
import 'package:phishing_framework/helpers/file_helper.dart';

class EmailSelector extends StatefulWidget {
  const EmailSelector({super.key});

  @override
  State<EmailSelector> createState() => _EmailSelectorState();
}

class _EmailSelectorState extends State<EmailSelector> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            "Email Template Gallery",
            style: AppScheme.headlineStyle,
          ),
          GridView.builder(
            shrinkWrap: true,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
            ),
            itemCount: EmailTemplateManager.instance.templates.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  // return alert dialogue EmailTemplatePage();
                  showDialog(
                    context: context,
                    builder: (context) {
                      return EmailTemplatePage(
                          EmailTemplateManager.instance.templates[index]);
                    },
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.white,
                      width: 2,
                    ),
                  ),
                  child: Card(
                    color: AppScheme.successColor,
                    child: Column(
                      children: [
                        Expanded(
                          child: Image.asset(
                            EmailTemplateManager
                                .instance.templates[index].imgPath,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Text(
                          EmailTemplateManager.instance.templates[index].name,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class EmailTemplatePage extends StatefulWidget {
  final EmailTemplate template;
  const EmailTemplatePage(this.template, {super.key});

  @override
  State<EmailTemplatePage> createState() => _EmailTemplatePageState();
}

class _EmailTemplatePageState extends State<EmailTemplatePage> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: AppScheme.successCard(
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(widget.template.name, style: AppScheme.headlineStyle),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Image.asset(
                      widget.template.imgPath,
                      width: MediaQuery.of(context).size.width / 3,
                    ),
                  ),
                  // A form with the fields
                  Expanded(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: widget.template.fields.length,
                      itemBuilder: (context, index) {
                        return TextFormField(
                          decoration: InputDecoration(
                            labelText:
                                widget.template.fields.keys.toList()[index],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text("Close"),
        ),
      ],
    );
  }
}

class EmailTemplate {
  String name;
  String imgPath;
  HashMap<String, String> fields = HashMap();

  EmailTemplate(this.name, this.imgPath, this.fields);

  static EmailTemplate fromJson(MapEntry<String, dynamic> json) =>
      EmailTemplate(
        json.value['name'] as String,
        json.value['imgPath'] as String,
        json.value['fields'],
      );

  Map<String, dynamic> toJson() => {
        'name': name,
        'imgPath': imgPath,
        'fields': fields,
      };
}

class EmailTemplateManager {
  List<EmailTemplate> templates = [
    EmailTemplate(
      "Gmail",
      "assets/images/gmail_phishing.png",
      HashMap.from({
        "from_name": "",
        "from_email": "",
        "document_name": "",
      }),
    )
  ];

  EmailTemplateManager._privateConstructor() {
    loadFromStorage();
  }

  static final EmailTemplateManager instance =
      EmailTemplateManager._privateConstructor();

  void addTemplate(EmailTemplate template) {
    templates.add(template);
    saveToStorage();
  }

  void deleteFromStorage() async {
    await Storage.instance.deleteFromStorage("email_templates");
  }

  void loadFromStorage() async {
    Map<String, dynamic>? json =
        await Storage.instance.loadFromStorage("email_templates");

    if (json == null) {
      return;
    }

    for (var element in json.entries) {
      templates.add(EmailTemplate.fromJson(element));
    }
  }

  void saveToStorage() async {
    Map<String, dynamic> json = {};
    for (var element in templates) {
      json[element.name] = element.toJson();
    }
    await Storage.instance.saveToStorage("email_templates", json);
  }
}
