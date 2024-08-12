import 'package:flutter/material.dart';

class Global {
  static setWidth(context, double s) {
    return MediaQuery.of(context).size.width *
        s; //to adjust the size of a box or any object in the screen
  }

  static setHeight(context, double s) {
    return MediaQuery.of(context).size.height *
        s; //to adjust the size of a box or any object in the screen
  }

  static customColor() {
    return const Color.fromARGB(255, 37, 94, 99);
  }

  static setStyle(Color c) {
    return TextStyle(
      color: c,
      fontSize: 20.0,
      fontWeight: FontWeight.bold,
      fontStyle: FontStyle.italic,
      letterSpacing: 12.5,
      wordSpacing: 5.0,
      // decoration: TextDecoration.underline,
      decorationColor: const Color.fromARGB(255, 37, 94, 99),
      decorationStyle: TextDecorationStyle.dashed,
    );
  }
}
