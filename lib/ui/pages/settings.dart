import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:todolist/models/theme_provider.dart';
import 'package:todolist/ui/widgets/custom_text.dart';

class SettingsTap extends StatefulWidget {
  SettingsTap({Key key}) : super(key: key);

  @override
  _SettingsTapState createState() => _SettingsTapState();
}

class _SettingsTapState extends State<SettingsTap> {
  List<String> prefrencesColors = [
    '0xFF76DC58',
    '0xFFF9435E',
    '0xFFF56C39',
    '0xFFF8B32A',
  ];
  // List<String> languageCodes = [];

  @override
  Widget build(BuildContext context) {
    ThemeProvider themeProvider = Provider.of<ThemeProvider>(context);
    String selectedColor = themeProvider.prefrencesColor;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: CustomText(text: 'Settings'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child:
                CustomText(text: 'Preferences', iprefText: true, fontSize: 18),
          ),
          SettingsCard(
            children: <Widget>[
              CustomText(text: 'Color'),
              Row(
                children: prefrencesColors
                    .map((hexColor) => InkWell(
                          onTap: () =>
                              themeProvider.changePrefrencesColor(hexColor),
                          child: Container(
                            margin: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                                border: selectedColor == hexColor
                                    ? Border.all(
                                        width: 3,
                                        color: Color(int.parse(hexColor)))
                                    : null,
                                borderRadius: BorderRadius.circular(50)),
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Color(int.parse(hexColor)),
                                  border: selectedColor == hexColor
                                      ? Border.all(width: 2)
                                      : null,
                                  borderRadius: BorderRadius.circular(50)),
                              width: 20,
                              height: 20,
                            ),
                          ),
                        ))
                    .toList(),
              )
            ],
          ),
          SettingsCard(
            children: <Widget>[
              CustomText(text: 'Theme'),
              Switch(
                  value: themeProvider.isLightTheme,
                  onChanged: (_) => themeProvider.toggleThemeData()),
            ],
          ),
          SettingsCard(
            children: <Widget>[
              CustomText(text: 'Language'),
              SizedBox(
                width: 90,
                child: ButtonTheme(
                  alignedDropdown: true,
                  child: DropdownButton<String>(
                    value: themeProvider.languageCode == 'ar'
                        ? 'Arabic'
                        : 'English',
                    iconSize: 0,
                    underline: Container(),
                    icon: Container(),
                    isExpanded: true,
                    items: ['English', 'Arabic'].map((dropDownStringItem) {
                      return DropdownMenuItem<String>(
                        value: dropDownStringItem,
                        child: SizedBox(
                            width: 200,
                            child: CustomText(
                              text: dropDownStringItem,
                              iprefText: true,
                            )),
                      );
                    }).toList(),
                    onChanged: (value) {
                      switch (value) {
                        case 'Arabic':
                          themeProvider.changeLocale(Locale('ar'));
                          break;
                        case 'English':
                          themeProvider.changeLocale(Locale('en'));
                          break;
                        default:
                          themeProvider.changeLocale(Locale('en'));
                      }
                    },
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}

class SettingsCard extends StatelessWidget {
  final List<Widget> children;
  SettingsCard({
    this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: SizedBox(
        height: 55,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: children,
          ),
        ),
      ),
    );
  }
}
