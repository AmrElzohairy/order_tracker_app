part of 'auth_cubit.dart';

@immutable
sealed class AuthState {}

final class AuthInitial extends AuthState {}

final class AuthLoading extends AuthState {}

final class AuthSuccess extends AuthState {
  final String errMessage;
  AuthSuccess(this.errMessage);
}

final class AuthError extends AuthState {
  final String errMessage;
  AuthError(this.errMessage);
}
