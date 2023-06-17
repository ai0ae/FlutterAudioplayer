
import 'package:flutter/material.dart';
import 'package:flutter_application_audioplayer/common/utils/translation.dart';
import 'package:flutter_application_audioplayer/main.dart';
import 'package:flutter_application_audioplayer/models/language.dart';

class DropDownMenu extends StatelessWidget {
  const DropDownMenu({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButton<Language>(
      iconSize: 30,
      hint: Text(translation(context).changeLanguage),
      onChanged: (Language? language) async {
    if (language != null) {
      Locale _locale = await setLocale(language.languageCode);
      if (context.mounted) MyApp.setLocale(context, _locale);
    }
      },
      items: Language.languageList()
      .map<DropdownMenuItem<Language>>(
        (e) => DropdownMenuItem<Language>(
          value: e,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Text(
                e.flag,
                style: const TextStyle(fontSize: 30),
              ),
              Text(e.name)
            ],
          ),
        ),
      )
      .toList(),
    );
  }
}
