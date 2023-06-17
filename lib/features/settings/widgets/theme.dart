import 'package:flutter/material.dart';
import 'package:flutter_application_audioplayer/common/themes/themes.dart';
import 'package:flutter_application_audioplayer/common/widgets/custom_widget.dart';
import 'package:flutter_application_audioplayer/providers/theme_provider.dart';
import 'package:provider/provider.dart';

class ThemeSelector extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        themeSwitcher(themeProvider, ThemeType.light, "light", Icon(Icons.light, color: Colors.yellow,) ),
        themeSwitcher(themeProvider, ThemeType.dark,"dark", Icon(Icons.nights_stay_sharp, color: Colors.black,)),
        themeSwitcher(themeProvider, ThemeType.orange,"orange", Icon(Icons.brightness_7, color: Colors.orange,)),
        
      ],
    );
  }

  Widget themeSwitcher(ThemeProvider themeProvider, ThemeType type, String text, Icon icon) {
    return Column(
      children: [
        IconButton(
            icon:icon,
            onPressed: () => themeProvider.setTheme(type),
          ),
          CustomText(text: text, color: Colors.black,)
      ],
    );
  }
}