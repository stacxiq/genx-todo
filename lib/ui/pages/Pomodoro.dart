import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:percent_indicator/percent_indicator.dart';

import '../../ui/widgets/custom_text.dart';
import '../../models/clock_dail_painter.dart';
import '../../controllers/pomodoro_controller.dart';

class Pomodoro extends StatefulWidget {
  const Pomodoro();
  @override
  _PomodoroState createState() => _PomodoroState();
}

class _PomodoroState extends State<Pomodoro> {
  bool isWork = false;

  String toTwoDigits(int numb) {
    if (numb <= 9) return '0$numb';
    return numb.toString();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Column(
        children: [
          SafeArea(
            child: Container(
              padding: const EdgeInsets.only(top: 10),
              child: Align(
                alignment: Alignment.topCenter,
                child: GetBuilder<PomodoroController>(
                    id: 'pomodoro',
                    builder: (pc) {
                      return Container(
                        padding: const EdgeInsets.only(
                          left: 40,
                          right: 40,
                        ),
                        child: CircularPercentIndicator(
                          percent: pc.percent,
                          animation: true,
                          lineWidth: 15.0,
                          circularStrokeCap: CircularStrokeCap.square,
                          linearGradient: const LinearGradient(
                              colors: [Colors.green, Colors.blue]),
                          reverse: false,
                          backgroundColor: Colors.transparent,
                          animateFromLastPercent: true,
                          radius: MediaQuery.of(context).size.width - 40,
                          // progressColor: Theme.of(context).accentColor,
                          center: Stack(
                            children: [
                              Container(
                                padding: const EdgeInsets.only(top: 160),
                                // color: Colors.yellow,
                                child: Container(
                                  // pass double.infinity to prevent shrinking of the painter area to 0.
                                  width: double.infinity,
                                  height: size.height / 2,
                                  // color: Colors.yellow,
                                  child:
                                      CustomPaint(painter: ClockDialPainter()),
                                ),
                              ),
                              Center(
                                child: CustomText(
                                  text:
                                      "${toTwoDigits(pc.timeInMinute)} :${toTwoDigits(pc.seconds)}",
                                  fontSize: 50.0,
                                  textDirection: TextDirection.ltr,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
              ),
            ),
          ),
          const Spacer(),
          button('Start'),
          button('Stop', isPlay: false),
        ],
      ),
    );
  }

  Widget button(String text, {bool isPlay = true}) {
    final _pController = PomodoroController.to;
    return Obx(() {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: RaisedButton(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(100.0),
            ),
            color: isPlay ? Colors.green : const Color(0xffC02F1D),
            child: CustomText(
              text: text,
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
              textColor: Colors.white,
              fontSize: 18,
            ),
            onPressed: _pController.working && isPlay
                ? null
                : () {
                    isPlay
                        ? _pController.startTimer()
                        : _pController.stopTimer();
                  }),
      );
    });
  }
}
