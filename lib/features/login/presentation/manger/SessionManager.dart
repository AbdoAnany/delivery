import 'dart:async';
import 'package:flutter/material.dart';

class SessionManager with WidgetsBindingObserver {
  Timer? _sessionTimer;
  final Duration _sessionDuration = const Duration(seconds: 30);
  final VoidCallback? _onSessionExpired;

  SessionManager({VoidCallback? onSessionExpired})
      : _onSessionExpired = onSessionExpired;

  void start() {
    WidgetsBinding.instance.addObserver(this);
    _startSessionTimer();
  }

  void _startSessionTimer() {
    _sessionTimer?.cancel();
    _sessionTimer = Timer(_sessionDuration, () {
      print('⏰ Session expired due to inactivity');

      _onSessionExpired?.call();
    });
  }

  void resetSessionTimer() {
    _startSessionTimer();
  }

  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _sessionTimer?.cancel();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      // App went to background
      _startSessionTimer();
    } else if (state == AppLifecycleState.resumed) {
      // App resumed
      _startSessionTimer();
    }
  }
}
