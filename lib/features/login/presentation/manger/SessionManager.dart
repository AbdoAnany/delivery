import 'dart:async';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

// class SessionManager {
//   final int _timeoutSeconds = 120; // 2 minutes
//   Timer? _sessionTimer;
//   VoidCallback? _onSessionExpired;
//   DateTime? _lastActivityTime;
//   bool _isActive = true;
//
//   void init(VoidCallback onSessionExpired) {
//     _onSessionExpired = onSessionExpired;
//
//     // Initialize activity detection
//     SystemChannels.lifecycle.setMessageHandler((msg) async {
//       if (msg == AppLifecycleState.resumed.toString()) {
//         _checkSessionValidity();
//         _isActive = true;
//       } else if (msg == AppLifecycleState.paused.toString()) {
//         _lastActivityTime = DateTime.now();
//         _isActive = false;
//       }
//       return null;
//     });
//   }
//
//   void startSessionTimer() {
//     resetSessionTimer();
//     _sessionTimer = Timer.periodic(
//       const Duration(seconds: 5), // Check every 5 seconds
//           (_) => _checkSessionValidity(),
//     );
//   }
//
//   void resetSessionTimer() {
//     _sessionTimer?.cancel();
//     _lastActivityTime = DateTime.now();
//   }
//
//   void _checkSessionValidity() {
//     if (!_isActive || _lastActivityTime == null) return;
//
//     final now = DateTime.now();
//     final difference = now.difference(_lastActivityTime!).inSeconds;
//
//     if (difference >= _timeoutSeconds) {
//       _sessionTimer?.cancel();
//       _onSessionExpired?.call();
//     }
//   }
//
//   void userActivity() {
//     _lastActivityTime = DateTime.now();
//   }
//
//   void dispose() {
//     _sessionTimer?.cancel();
//     _onSessionExpired = null;
//   }
// }


class SessionManager {
  final int _timeoutSeconds = 120; // 2 minutes
  Timer? _sessionTimer;
  VoidCallback? _onSessionExpired;
  DateTime? _lastActivityTime;
  bool _isActive = true;

  void init(VoidCallback onSessionExpired) {
    _onSessionExpired = onSessionExpired;

    // Initialize activity detection
    SystemChannels.lifecycle.setMessageHandler((msg) async {
      if (msg == AppLifecycleState.resumed.toString()) {
        _checkSessionValidity();
        _isActive = true;
      } else if (msg == AppLifecycleState.paused.toString()) {
        _lastActivityTime = DateTime.now();
        _isActive = false;
      }
      return null;
    });
  }

  void startSessionTimer() {
    resetSessionTimer();
    _sessionTimer = Timer.periodic(
      const Duration(seconds: 5), // Check every 5 seconds
          (_) => _checkSessionValidity(),
    );
  }

  void resetSessionTimer() {
    _sessionTimer?.cancel();
    _lastActivityTime = DateTime.now();
  }

  void _checkSessionValidity() {
    if (!_isActive || _lastActivityTime == null) return;

    final now = DateTime.now();
    final difference = now.difference(_lastActivityTime!).inSeconds;

    if (difference >= _timeoutSeconds) {
      _sessionTimer?.cancel();
      _onSessionExpired?.call();
    }
  }

  void userActivity() {
    _lastActivityTime = DateTime.now();
  }

  void dispose() {
    _sessionTimer?.cancel();
    _onSessionExpired = null;
  }
}