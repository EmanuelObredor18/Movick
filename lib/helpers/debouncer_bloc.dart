import 'dart:async';
import 'package:flutter/material.dart';

class Debouncer {
  final int milliseconds;
  VoidCallback? _onTimeout;
  Timer? _timer;

  Debouncer({required this.milliseconds});

  void run(VoidCallback onTimeout) {
    if (_timer != null) {
      _timer!.cancel();
    }

    _onTimeout = onTimeout;
    _timer = Timer(Duration(milliseconds: milliseconds), _onTimeout!);
  }

  void cancel() {
    if (_timer != null) {
      _timer!.cancel();
      _timer = null;
    }
  }
}
