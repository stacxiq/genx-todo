import 'dart:async';

import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';

import '../../ui/widgets/custom_text.dart';
import '../../controllers/theme_controller.dart';

class Pomodoro extends StatefulWidget {
  @override
  _PomodoroState createState() => _PomodoroState();
}

class _PomodoroState extends State<Pomodoro> {
  double percent = 0;
  static int timeInMinute;
  int timeInSec;
  int seconds = 59;
  String timeSec;
  Timer timer;
  Color selectedColor;
  bool isWork = false;

  @override
  void initState() {
    super.initState();
    timeSec = "$seconds";
    timeInMinute = 24;
    timeInSec = timeInMinute * 60;
  }

  @override
  void dispose() {
    super.dispose();
    if (timer != null) {
      timer.cancel();
    }
    FlutterRingtonePlayer.stop();
  }

  void _startTimer() {
    setState(() {
      isWork = !isWork;
    });
    int time = timeInSec;
    double secPercent = (time / 100);
    if (timer != null) {
      timer.cancel();
      timer = null;
    } else {
      timer = Timer.periodic(Duration(seconds: 1), (timer) {
        setState(() {
          if (time > 0) {
            time--;
            if (seconds > 0) {
              seconds--;
            }
            if (seconds >= 10) {
              timeSec = "$seconds";
            } else {
              timeSec = "0$seconds";
            }
            if (seconds <= 1) {
              timeInMinute--;
              seconds = 60;
            }
            if (time % secPercent == 0) {
              if (percent < 1) {
                percent += 0.01;
              } else {
                percent = 1;
              }
            }
          } else {
            FlutterRingtonePlayer.playAlarm();
            percent = 0;
            timeInMinute = 1;
            seconds = 0;
            timeSec = "0$seconds";
            timer.cancel();
          }
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetX<SettingsController>(
      init: SettingsController(),
      builder: (s) {
        selectedColor = Color(int.parse(s.prefColor.value));
        return Scaffold(
          body: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(height: 30),
                Expanded(
                  child: CircularPercentIndicator(
                    percent: percent,
                    animation: true,
                    lineWidth: 10.0,
                    circularStrokeCap: CircularStrokeCap.round,
                    reverse: false,
                    animateFromLastPercent: true,
                    radius: 220.0,
                    progressColor: selectedColor,
                    center: CustomText(
                      text: "$timeInMinute : $timeSec",
                      fontSize: 50.0,
                      textDirection: TextDirection.ltr,
                    ),
                  ),
                ),
                Expanded(
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.only(
                          top: 30.0, left: 20.0, right: 20.0),
                      child: SingleChildScrollView(
                        child: Column(
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                infoBlock("Work Time", "25"),
                                infoBlock("Break Time", "5"),
                              ],
                            ),
                            Row(
                              children: [
                                button(true, !isWork ? "Start" : "Pause"),
                                SizedBox(width: 20),
                                button(false, "Stop"),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  Expanded button(bool isPlay, String text) {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 18.0),
        child: RaisedButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(100.0),
          ),
          color: isPlay ? Color(0xff00BFA5) : Color(0xffC02F1D),
          child: Padding(
            padding: EdgeInsets.all(20.0),
            child: CustomText(
              text: text,
              textColor: Colors.white,
              fontSize: 18,
            ),
          ),
          onPressed: () {
            isPlay ? _startTimer() : _stopTimer();
          },
        ),
      ),
    );
  }

  Expanded infoBlock(String text, String subText) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          CustomText(
            text: text,
            fontSize: 30.0,
          ),
          CustomText(text: subText, fontSize: 70.0)
        ],
      ),
    );
  }

  _stopTimer() {
    setState(() {
      percent = 0;
      timeInMinute = 25;
      seconds = 0;
      timeSec = "0$seconds";
      isWork = false;
      FlutterRingtonePlayer.stop();
      if (timer != null) {
        timer.cancel();
        timer = null;
      }
    });
  }
}
