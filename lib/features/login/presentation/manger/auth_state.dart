part of 'auth_cubit.dart';

sealed class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthAuthenticated extends AuthState {
  final String deliveryNo;

  AuthAuthenticated(this.deliveryNo);
}

class AuthLanguageChanged extends AuthState {
  final String languageNo;

  AuthLanguageChanged(this.languageNo);
}

class AuthFailure extends AuthState {
  final String message;

  AuthFailure(this.message);
}