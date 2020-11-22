import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../widgets/custom_text.dart';
import '../../controllers/theme_controller.dart';

final List<String> prefrencesColorsDark = [
  '0xFF76DC58',
  '0xFFF9435E',
  '0xFFF8B32A',
  '0xFF80D8FF',
];
final List<String> prefrencesColorsLight = [
  '0xFF54B169',
  '0xFFC02F1D',
  '0xFFFF6D00',
  '0xFFCC6462',
];

class SettingsTap extends StatelessWidget {
  const SettingsTap();
  @override
  Widget build(BuildContext context) {
    return GetX<SettingsController>(
        init: SettingsController(),
        builder: (s) {
          String selectedColor = s.prefColor.value;
          bool isDark = s.themeMode == ThemeMode.dark ? true : false;

          return Scaffold(
            appBar: AppBar(
              elevation: 0,
              title: const CustomText(text: 'Settings'),
            ),
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: const CustomText(
                      text: 'Preferences', iprefText: true, fontSize: 18),
                ),
                SettingsCard(
                  children: <Widget>[
                    const CustomText(text: 'Color'),
                    Row(
                      children: (isDark
                              ? prefrencesColorsDark
                              : prefrencesColorsLight)
                          .map((hexColor) => InkWell(
                                onTap: () => s.setPrefColor(hexColor),
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
                                            ? Border.all(
                                                width: 2,
                                                color: Theme.of(context)
                                                    .canvasColor)
                                            : null,
                                        borderRadius:
                                            BorderRadius.circular(50)),
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
                    const CustomText(text: 'Dark Theme'),
                    Switch(
                        value: isDark,
                        activeColor: Color(int.parse(selectedColor)),
                        onChanged: (_) {
                          if (isDark) {
                            final index = prefrencesColorsDark
                                    .indexWhere((pf) => pf == selectedColor) ??
                                0;
                            s.setPrefColor(prefrencesColorsLight[index]);
                          } else {
                            final index = prefrencesColorsLight
                                    .indexWhere((pf) => pf == selectedColor) ??
                                0;
                            s.setPrefColor(prefrencesColorsDark[index]);
                          }
                          s.setThemeMode(
                              isDark ? ThemeMode.light : ThemeMode.dark);
                        }),
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
                          value: s.locale.languageCode == 'ar'
                              ? 'Arabic'
                              : 'English',
                          iconSize: 0,
                          underline: Container(),
                          icon: Container(),
                          isExpanded: true,
                          items:
                              ['English', 'Arabic'].map((dropDownStringItem) {
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
                                if (s.locale.languageCode != 'ar')
                                  s.setLocale(Locale('ar'));
                                break;
                              case 'English':
                                if (s.locale.languageCode != 'en')
                                  s.setLocale(Locale('en'));
                                break;
                              default:
                                s.setLocale(Locale('en'));
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
        });
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
