// auth_cubit.dart
import 'package:delivery/features/login/data/repository/AuthRepository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'SessionManager.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository _authRepository;
  final SessionManager _sessionManager;

  AuthCubit({
    required AuthRepository authRepository,
    required SessionManager sessionManager,
  })  : _authRepository = authRepository,
        _sessionManager = sessionManager,
        super(AuthInitial()) {
    // Initialize session timer on creation
    // _sessionManager.(() {
    //   logout();
    // });
  }

  Future<void> login({
    required String deliveryNo,
    required String password,
    required String languageNo,
  }) async {
    emit(AuthLoading());

    try {
      final user = await _authRepository.login(
        deliveryNo: deliveryNo,
        password: password,
        languageNo: languageNo,
      );

      if (user != null) {
        // Start session timer
        // _sessionManager.startSessionTimer();
        emit(AuthSuccess(user));
      } else {
        emit(const AuthFailure('Invalid credentials'));
      }
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }

  void logout() {
    _authRepository.logout();
    _sessionManager.resetSessionTimer();
    emit(AuthInitial());
  }

  void resetSession() {
    _sessionManager.resetSessionTimer();
  }

  @override
  Future<void> close() {
    _sessionManager.dispose();
    return super.close();
  }
}