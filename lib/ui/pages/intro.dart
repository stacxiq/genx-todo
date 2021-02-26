import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:todolist/controllers/theme_controller.dart';
import 'package:todolist/ui/widgets/custom_text.dart';

import 'home_page.dart';
import 'package:get/get.dart';

class Introduction extends StatelessWidget {
  final introKey = GlobalKey<IntroductionScreenState>();

  void _onIntroEnd(context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => GenxTodo()),
    );
  }

  static TextStyle bodyStyle = TextStyle(fontSize: 19.0);
  var pageDecoration = PageDecoration(
    titleTextStyle: TextStyle(fontSize: 28.0, fontWeight: FontWeight.w700),
    bodyTextStyle: bodyStyle,
    descriptionPadding: EdgeInsets.fromLTRB(24.0, 0.0, 24.0, 16.0),
    imagePadding: EdgeInsets.all(32),
  );

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: GetBuilder<SettingsController>(builder: (s) {
        return Container(
          margin: EdgeInsets.only(top: height * 0.095),
          child: IntroductionScreen(
            key: introKey,
            pages: [
              PageViewModel(
                titleWidget: CustomText(
                  text: 'Task List'.tr,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                bodyWidget: Center(
                  child: CustomText(
                    text: "Create Task List and determine completed and"
                            "in review  and in testing process tasks"
                        .tr,
                    fontSize: 20,
                    textAlign: TextAlign.center,
                    fontWeight: FontWeight.normal,
                  ),
                ),
                image: Image(image: AssetImage('assets/images/1.png')),
                decoration: pageDecoration,
              ),
              PageViewModel(
                titleWidget: CustomText(
                  text: "Calander".tr,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                bodyWidget: CustomText(
                  text: "you can manage your tasks from calander"
                          "by adding and following your tasks"
                      .tr,
                  fontSize: 20,
                  textAlign: TextAlign.center,
                  fontWeight: FontWeight.normal,
                ),
                image: Image(image: AssetImage('assets/images/3.png')),
                decoration: pageDecoration,
              ),
              PageViewModel(
                titleWidget: CustomText(
                  text: 'Organize'.tr,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                bodyWidget: CustomText(
                  text: "group and organize your task by adding your"
                          "task inside specific list and set priority "
                      .tr,
                  fontSize: 20,
                  textAlign: TextAlign.center,
                  fontWeight: FontWeight.normal,
                ),
                image: Image(image: AssetImage('assets/images/5.png')),
                decoration: pageDecoration,
              ),
            ],
            onDone: () => _onIntroEnd(context),
            //onSkip: () => _onIntroEnd(context), // You can override onSkip callback
            showSkipButton: true,
            skipFlex: 0,
            nextFlex: 0,
            skip: CustomText(text: 'Skip'),
            next: const Icon(Icons.arrow_forward),
            done: CustomText(
              text: 'Done',
              fontWeight: FontWeight.w600,
            ),

            dotsDecorator: const DotsDecorator(
              size: Size(10.0, 10.0),
              color: Color(0xFFBDBDBD),
              activeSize: Size(22.0, 10.0),
              activeShape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(25.0)),
              ),
            ),
          ),
        );
      }),
    );
  }
}
