import 'dart:async';
import 'package:delivery/core/di/dependency_injection.dart';
import 'package:flutter/material.dart';

import '../../../../core/utils/Global.dart';
import '../../../order/presentation/manger/orders_cubit.dart';

class SessionManager with WidgetsBindingObserver {
  Timer? _sessionTimer;
  final Duration _sessionDuration = const Duration(minutes: 2);
  final VoidCallback? _onSessionExpired;

  SessionManager({VoidCallback? onSessionExpired})
      : _onSessionExpired = onSessionExpired;

  void start() {
    WidgetsBinding.instance.addObserver(this);
    _startSessionTimer();
  }

  void _startSessionTimer() {
    _sessionTimer?.cancel();
    _sessionTimer = Timer(_sessionDuration, () async {
      print('⏰ Session expired due to inactivity');
    await  _clearCache();
      _onSessionExpired?.call();
    });
  }
  _clearCache() async {

    _sessionTimer?.cancel();
    Global.user= null;
   await getIt<OrdersCubit>().clearOrders();
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
