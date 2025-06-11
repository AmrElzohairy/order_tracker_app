import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:order_tracker_app/core/constants/user_data.dart';
import 'package:order_tracker_app/features/auth/data/repo/auth_repo.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit(this._authRepo) : super(AuthInitial());
  final AuthRepo _authRepo;

  Future<void> login({required String email, required String password}) async {
    emit(AuthLoading());

    final result = await _authRepo.loginUser(email: email, password: password);

    result.fold((error) => emit(AuthError(error)), (userModel) {
      UserData.user = userModel;
      emit(AuthSuccess("Login successful"));
    });
  }

  Future<void> registerUser({
    required String username,
    required String email,
    required String password,
  }) async {
    emit(AuthLoading());
    final result = await _authRepo.registerUser(
      username: username,
      email: email,
      password: password,
    );
    result.fold((error) => emit(AuthError(error)), (userModel) {
      emit(AuthSuccess("Registration successful"));
    });
  }
}
