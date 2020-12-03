import 'dart:async';

import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:get/get.dart';

class PomodoroController extends GetxController {
  final _percent = 0.0.obs;
  final _timeInMinute = 25.obs;
  int _timeInSec = 0;
  final _seconds = 0.obs;
  final _working = false.obs;
  // final _breakTimeInMinutes = 5.obs; //for the future maybe
  Timer _timer;

  static PomodoroController get to => Get.find();
  double get percent => _percent.value;
  int get timeInMinute => _timeInMinute.value;
  int get seconds => _seconds.value;
  bool get working => _working.value;

  _initTimer() {
    _working.value = false;
    _percent.value = 0;
    _timeInMinute.value = 25;
    _timeInSec = _timeInMinute.value * 60 == 0 ? 60 : _timeInMinute.value * 60;
    _seconds.value = 0;
  }

  void startTimer() {
    _working.value = true;
    _timeInSec = _timeInMinute.value * 60 == 0 ? 60 : _timeInMinute.value * 60;
    final totalSeconds = _timeInSec.toDouble();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timeInSec > 0) {
        _timeInSec--;
        if (_seconds.value > 0) {
          _seconds.value--;
        }
        if (_seconds.value <= 1) {
          _seconds.value = 59;
          if (_timeInMinute.value > 0) _timeInMinute.value--;
        }

        _percent.value = 1 - (_timeInSec / totalSeconds);
      } else {
        FlutterRingtonePlayer.playAlarm(looping: false);

        _initTimer();
        _timer.cancel();
      }
      update(['pomodoro']);
    });
  }

  void stopTimer() {
    _initTimer();
    update(['pomodoro']);

    FlutterRingtonePlayer.stop();
    if (_timer != null) {
      _timer.cancel();
      _timer = null;
    }
  }
}
