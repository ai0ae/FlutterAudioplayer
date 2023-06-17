import 'package:flutter/material.dart';

class GlobalVariables {
  // COLORS

  //DARK THEME
  static const darkAppBarGradient = LinearGradient(
    colors: [
      Color.fromARGB(255, 90, 83, 102),
      Color.fromARGB(255, 54, 50, 57),
    ],
    stops: [0.5, 1.0],
  );
  static const darkSecondaryColor = Color(0xff3700b3);
  static const darkBackgroundColor = Color.fromARGB(255, 39, 38, 41);
  static const darkGreyBackgroundCOlor = Color.fromARGB(255, 53, 54, 54);
  Color darkSelectedNavBarColor = Colors.purple.shade200;
  static const darkButtonBackgroundCOlor = Color.fromARGB(255, 90, 83, 102);

  //PINK THEME
  static const pinkAppBarGradient = LinearGradient(
    colors: [
      Color(0xffFFC0CB),
      Color.fromARGB(255, 220, 181, 186),
    ],
    stops: [0.5, 1.0],
  );
  static const pinkSecondaryColor = Color.fromARGB(255, 234, 201, 206);
  static const pinkBackSecondaryColor = Color.fromARGB(255, 244, 233, 235);
  static const pinkBackgroundColor = Color(0xffFFC0CB);
  static const pinkGreyBackgroundCOlor = Color.fromARGB(255, 220, 181, 186);

  //LIGHT THEME
  static const appBarGradient = LinearGradient(
    colors: [
      Color.fromARGB(255, 29, 201, 192),
      Color.fromARGB(255, 125, 221, 216),
    ],
    stops: [0.5, 1.0],
  );
  static const lightSecondaryColor = Color.fromRGBO(255, 153, 0, 1);
  static const lightBackgroundColor = Colors.white;
  static const lightGreyBackgroundCOlor = Color(0xffebecee);
  static var lightSelectedNavBarColor = Colors.cyan[800]!;
  static const lightUnselectedNavBarColor = Colors.black87;

}