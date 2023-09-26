import 'package:flutter/material.dart';

class AppScheme {
  // General Colours
  static Color backgroundColor = const Color.fromARGB(255, 254, 246, 228);
  static Color primaryColor = const Color.fromARGB(255, 243, 210, 193);
  static Color secondaryColor = const Color.fromARGB(255, 139, 211, 221);
  static Color tertiaryColor = const Color.fromARGB(255, 245, 130, 174);

  // Font Colours:
  static Color headlineColor = const Color.fromARGB(255, 0, 24, 88);
  static Color paragraphColor = const Color.fromARGB(255, 23, 44, 102);

  // Styles:
  static TextStyle headlineStyle = TextStyle(
    color: headlineColor,
    fontWeight: FontWeight.bold,
    fontSize: 30,
  );

  static TextStyle secondaryHeader = TextStyle(
    color: headlineColor,
    fontWeight: FontWeight.bold,
    fontSize: 20,
  );

  static TextStyle tertiaryHeader = TextStyle(
    color: headlineColor,
    fontWeight: FontWeight.bold,
    fontSize: 15,
  );

  static TextStyle paragraphStyle = TextStyle(
    color: paragraphColor,
    fontWeight: FontWeight.normal,
    fontSize: 15,
  );
}
