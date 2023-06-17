// Theme 1
import 'package:flutter/material.dart';
import 'package:flutter_application_audioplayer/constansts/const.dart';
import 'package:flutter_application_audioplayer/constansts/global_var.dart';



ThemeData lightTheme = ThemeData(
    dialogBackgroundColor: backgroundColor,
  scaffoldBackgroundColor: scaffoldBackground,
          sliderTheme: SliderThemeData(
            overlayShape: SliderComponentShape.noOverlay,
            trackShape: CustomTrackShape(),
            thumbShape: RoundSliderThumbShape(enabledThumbRadius: 7),
          ),
  primaryColor: Colors.blue,
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: Colors.blueGrey
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ButtonStyle(
      padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
        EdgeInsets.symmetric(horizontal: 40.0,vertical: 20.0)
      ),
      shape: MaterialStateProperty.all<OutlinedBorder>(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0))
      ),
      backgroundColor: MaterialStateProperty.all<Color>(Colors.blueGrey)
    )
  ),
  inputDecorationTheme: InputDecorationTheme(
    hintStyle: const TextStyle(
                  color: hintColor, fontSize: 18, fontWeight: FontWeight.w400),
    fillColor: formFieldBackground,
          filled: true,
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(width: 1, color: Colors.red),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(width: 1, color: Colors.red),
          ),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide(width: 0, color: Colors.black12)),
          contentPadding: EdgeInsets.symmetric(horizontal: 30, vertical: 19),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(width: 0, color: Colors.black12),
          ),
  ),
  drawerTheme: DrawerThemeData(backgroundColor: Colors.white, ),
        secondaryHeaderColor: Colors.blue,
  snackBarTheme: SnackBarThemeData(
            backgroundColor: GlobalVariables.lightSelectedNavBarColor),
        appBarTheme: const AppBarTheme(elevation: 0),
        textTheme: TextTheme(titleSmall: TextStyle(color: Colors.black))
);

ThemeData darkTheme = ThemeData(  
  textTheme: TextTheme(titleSmall: TextStyle(color: Colors.white)),
  scaffoldBackgroundColor: scaffoldBackground,
  snackBarTheme:  const SnackBarThemeData(
          backgroundColor: GlobalVariables.darkButtonBackgroundCOlor,
          contentTextStyle: TextStyle(color: Colors.white)),
      radioTheme: const RadioThemeData(
          fillColor:
              MaterialStatePropertyAll(GlobalVariables.darkSecondaryColor)),
      colorScheme:
          const ColorScheme.dark(primary: GlobalVariables.darkSecondaryColor),
    
  switchTheme: SwitchThemeData(
    trackColor: MaterialStateProperty.all<Color>(Colors.grey),
    thumbColor: MaterialStateProperty.all<Color>(Colors.white),
  ),
  brightness: Brightness.dark,
    inputDecorationTheme: InputDecorationTheme(
      fillColor: Colors.black12,
          filled: true,
      border: InputBorder.none,
              hintStyle: const TextStyle(
                  color: Colors.white, fontSize: 18, fontWeight: FontWeight.w400),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(width: 1, color: Colors.red),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(width: 1, color: Colors.red),
          ),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide(width: 0, color: Colors.black12)),
          contentPadding: EdgeInsets.symmetric(horizontal: 30, vertical: 19),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(width: 0, color: Colors.black12),
          ),
    ),
        secondaryHeaderColor: Colors.black12,
  elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
          padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
              EdgeInsets.symmetric(horizontal: 40.0,vertical: 20.0)
          ),
          shape: MaterialStateProperty.all<OutlinedBorder>(
              RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0)
              )
          ),
          backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
        foregroundColor: MaterialStateProperty.all<Color>(Colors.black),
        overlayColor: MaterialStateProperty.all<Color>(Colors.black26)
      )
  ),
);



// Theme 3
final ThemeData theme3 = ThemeData(
  dialogBackgroundColor: Colors.orange,
  scaffoldBackgroundColor: scaffoldBackground,
          sliderTheme: SliderThemeData(
            overlayShape: SliderComponentShape.noOverlay,
            trackShape: CustomTrackShape(),
            thumbShape: RoundSliderThumbShape(enabledThumbRadius: 7),
          ),
  primaryColor: Colors.orangeAccent,
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: Colors.orangeAccent
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ButtonStyle(
      padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
        EdgeInsets.symmetric(horizontal: 40.0,vertical: 20.0)
      ),
      shape: MaterialStateProperty.all<OutlinedBorder>(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0))
      ),
      backgroundColor: MaterialStateProperty.all<Color>(Colors.orangeAccent)
    )
  ),
  inputDecorationTheme: InputDecorationTheme(
    hintStyle: const TextStyle(
                  color: hintColor, fontSize: 18, fontWeight: FontWeight.w400),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(width: 1, color: Colors.orangeAccent),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(width: 1, color: Colors.orangeAccent),
          ),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide(width: 0, color: Colors.orangeAccent)),
          contentPadding: EdgeInsets.symmetric(horizontal: 30, vertical: 19),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(width: 0, color: Colors.orangeAccent),
          ),
  ),
  snackBarTheme: SnackBarThemeData(
            backgroundColor: GlobalVariables.pinkBackgroundColor  ),
        appBarTheme: const AppBarTheme(elevation: 0, color: Colors.orangeAccent),
        drawerTheme: DrawerThemeData(backgroundColor: Colors.white, ),
        secondaryHeaderColor: Colors.orangeAccent,
        textTheme: TextTheme(titleSmall: TextStyle(color: Colors.black))
);


class CustomTrackShape extends RoundedRectSliderTrackShape {
  @override
  Rect getPreferredRect({
    required RenderBox parentBox,
    Offset offset = Offset.zero,
    required SliderThemeData sliderTheme,
    bool isEnabled = false,
    bool isDiscrete = false,
  }) {
    final double trackHeight = 1;
    final trackLeft = offset.dx;
    final trackTop = offset.dy + (parentBox.size.height - trackHeight) / 2;
    final trackWidth = parentBox.size.width;
    return Rect.fromLTWH(trackLeft, trackTop, trackWidth, trackHeight);
  }
}