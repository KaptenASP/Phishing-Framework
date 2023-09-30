import 'package:flutter/material.dart';

class AppScheme {
  // General Colours
  static Color backgroundColor = const Color.fromARGB(255, 255, 255, 255);
  static Color primaryColor = const Color.fromARGB(255, 243, 210, 193);
  static Color secondaryColor = const Color.fromARGB(255, 139, 211, 221);
  static Color tertiaryColor = const Color.fromARGB(255, 245, 130, 174);

  // Specific Colours:
  static Color infoColor = const Color.fromARGB(255, 232, 242, 252);
  static Color infoColorText = const Color.fromARGB(255, 0, 66, 128);
  static Color successColor = const Color.fromARGB(255, 232, 249, 238);
  static Color successColorText = const Color.fromARGB(255, 31, 54, 38);

  static Card infoCard(Widget w) => Card(
        color: infoColor,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: w,
        ),
      );

  static Card successCard(Widget w) => Card(
        color: successColor,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: w,
        ),
      );

  static Container metricCard(
          String metricName, int metricValue, String units) =>
      Container(
        margin: const EdgeInsets.only(top: 50, bottom: 50),
        child: Column(
          children: [
            Text(
              metricName,
              style: paragraphStyle,
            ),
            Text(
              "$metricValue $units",
              style: TextStyle(
                fontSize: 30,
                color: AppScheme.headlineColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      );

  // Font Colours:
  static Color headlineColor = const Color.fromARGB(255, 0, 24, 88);
  static Color paragraphColor = const Color.fromARGB(255, 23, 44, 102);

  // Styles:
  static TextStyle headlineStyle = TextStyle(
    color: headlineColor,
    fontWeight: FontWeight.bold,
    fontSize: 40,
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

  static TextStyle largeParagraph = TextStyle(
    color: paragraphColor,
    fontWeight: FontWeight.w100,
    fontSize: 30,
  );
}
