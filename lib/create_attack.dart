// import 'package:flutter/material.dart';
// import 'package:phishing_framework/app_scheme.dart';

// class CreateAttack extends StatelessWidget {
//   const CreateAttack({super.key});
//   @override
//   Widget build(BuildContext context) {
//     final TextEditingController attackNameontroller = TextEditingController();
//     final TextEditingController attackDescController = TextEditingController();
//     final TextEditingController attackRedirectUrl = TextEditingController();
//     String templateName = "";

//     return showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         final TextEditingController attackNameontroller =
//             TextEditingController();
//         final TextEditingController attackDescController =
//             TextEditingController();
//         final TextEditingController attackRedirectUrl = TextEditingController();
//         String templateName = "";

//         return AlertDialog(
//           title: const Text("New Attack"),
//           content: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               TextField(
//                 decoration: const InputDecoration(labelText: "Attack Name"),
//                 controller: attackNameontroller,
//               ),
//               TextField(
//                 decoration:
//                     const InputDecoration(labelText: "Attack Description"),
//                 controller: attackDescController,
//               ),
//               // Add a dropdown for templates
//               DropdownButtonFormField(
//                 decoration: const InputDecoration(labelText: "Attack Template"),
//                 items: manager.templateNames
//                     .map(
//                       (e) => DropdownMenuItem(
//                         value: e,
//                         child: Text(e),
//                       ),
//                     )
//                     .toList(),
//                 onChanged: (String? value) {
//                   templateName = value ?? "";
//                 },
//               ),
//               TextField(
//                 decoration: const InputDecoration(labelText: "Redirect URL"),
//                 controller: attackRedirectUrl,
//               ),
//             ],
//           ),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.pop(context),
//               child: const Text("Cancel"),
//             ),
//             TextButton(
//               onPressed: () {
//                 setState(
//                   () {
//                     _phishingAttacks.add(
//                       PhishingAttack.create(
//                         attackNameontroller.text,
//                         attackDescController.text,
//                         templateName,
//                         attackRedirectUrl.text,
//                       ),
//                     );
//                     AttackManager.instance.saveAllAttacks(_phishingAttacks);
//                   },
//                 );
//                 Navigator.pop(context);
//               },
//               child: const Text("Create"),
//             ),
//           ],
//         );
//       },
//     );
//   }
// }
