import 'package:delivery/core/utils/app_toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../../core/utils/Global.dart';
import '../../data/model/User.dart';
import '../../data/repository/AuthRepository.dart';
import 'SessionManager.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository _authRepository;
  final SharedPreferences _sharedPreferences;
  final SessionManager _sessionManager;

  AuthCubit({
    required AuthRepository authRepository,
    required SharedPreferences sharedPreferences,
    required SessionManager sessionManager,
  })  : _authRepository = authRepository,
        _sharedPreferences = sharedPreferences,
        _sessionManager = sessionManager,
        super(AuthInitial()) {
    _loadSavedCredentials();
  }

  String? _deliveryNo;
  String? _languageNo;
  // String? _token;

  String? get deliveryNo => _deliveryNo;
  String get languageNo => _languageNo ?? '2'; // Default to Arabic

  Future<void> _loadSavedCredentials() async {
    _deliveryNo = _sharedPreferences.getString('deliveryNo');
    _languageNo = _sharedPreferences.getString('languageNo') ?? '2';
print('_languageNo: $_languageNo');
    if (_deliveryNo != null) {
      emit(AuthAuthenticated(_deliveryNo!));
      _sessionManager.start();
    }
  }

  Future<void> login({
    required String deliveryNo,
    required String password,
    required String languageNo,
    required BuildContext context,
  }) async {
    emit(AuthLoading());

    try {
      final user = await _authRepository.login(
        deliveryNo: deliveryNo,
        password: password,
        languageNo: languageNo,
      );

      if (user != null) {
        _deliveryNo = deliveryNo;
        _languageNo = languageNo;
        // _token = user.token; // Assuming user has a token property

        await _saveCredentials();
        await _updateAppLocale(context);

        emit(AuthAuthenticated(deliveryNo));
        Global.user = user;
        AppToast.success(context: context, message: 'Welcome back, ${user.name}');
        _sessionManager.start();
      } else {
        AppToast.error(context: context, message: 'Invalid credentials');
        emit(AuthFailure('Invalid credentials'));
      }
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }
  //getLoggedInUser
  Future<User?> getLoggedInUser() async {
    final user = await _authRepository.getLoggedInUser();
return user;
  }

  Future<void> _saveCredentials() async {
    await _sharedPreferences.setString('deliveryNo', _deliveryNo!);
    await _sharedPreferences.setString('languageNo', _languageNo!);
    // await _sharedPreferences.setString('token', _token!);
  }


  Future<void> changeLanguage(String languageNo, {BuildContext? context}) async {
    languageNo == 'ar'?
      languageNo = '1':
      languageNo = '2';
    _languageNo = languageNo;
    await _sharedPreferences.setString('languageNo', languageNo);

    if (context != null) {
      await _updateAppLocale(context);
    }

    emit(AuthLanguageChanged(languageNo));
  }

  Future<void> _updateAppLocale(BuildContext context) async {
    final localeCode = _languageNo == '2' ? 'en' : 'ar';
    await context.setLocale(Locale(localeCode));
  }

  Future<void> logout() async {
    await _sharedPreferences.clear();
    // _token = null;
    _sessionManager.resetSessionTimer();
    emit(AuthInitial());
  }

  @override
  Future<void> close() {
    _sessionManager.dispose();
    return super.close();
  }
}