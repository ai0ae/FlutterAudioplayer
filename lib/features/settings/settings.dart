import 'package:flutter/material.dart';
import 'package:flutter_application_audioplayer/common/utils/translation.dart';
import 'package:flutter_application_audioplayer/features/settings/widgets/theme.dart';
import 'package:flutter_application_audioplayer/main.dart';
import 'package:flutter_application_audioplayer/models/language.dart';

import 'widgets/drop_down_menu.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);
  static const routeName = '/settings';

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(translation(context).settings),
      ),
      body: Column(
        children: [
          DropDownMenu(),
          ThemeSelector()
        ],
      ),
    );
  }
}
