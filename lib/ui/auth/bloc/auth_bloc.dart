import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jewelry_e_commerce/data/repoditory/auth_repository.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final IAuthRepository authRepository;
  bool isLoginMode;

  AuthBloc({
    required this.authRepository,
    this.isLoginMode = true,
  }) : super(const AuthInitial(isLoginMode: true)) {
    on<AuthEvent>((event, emit) async {
      if (event is AuthButtonIsClicked) {
        try {
          emit(AuthLoading(isLoginMode: isLoginMode));
          if (isLoginMode) {
            await authRepository.login(event.username, event.password);
            emit(AuthSuccess(isLoginMode: isLoginMode));
          } else {
            await authRepository.signUp(event.username, event.password);
            emit(AuthSuccess(isLoginMode: isLoginMode));
          }
        } on FirebaseAuthException catch (e) {
          if (e.code.toString() == 'user-not-found') {
            emit(AuthError(
                error: 'کاربری با این مشخصات وجود ندارد',
                isLoginMode: isLoginMode));
          } else if (e.code.toString() == 'wrong-password') {
            emit(AuthError(
                error: 'رمز عبور معتبر نمی باشد', isLoginMode: isLoginMode));
          } else if (e.code.toString() == 'email-already-in-use') {
            emit(AuthError(
                error: 'این آدرس ایمیل قبلا ثبت شده است',
                isLoginMode: isLoginMode));
          } else if (e.code.toString() == 'invalid-email') {
            emit(AuthError(
                error: 'آدرس ایمیل معتبر نمی باشد', isLoginMode: isLoginMode));
          } else if (e.code.toString() == 'weak-password') {
            emit(
                AuthError(error: 'پسورد مناسب نیست', isLoginMode: isLoginMode));
          } else {
            emit(AuthError(error: 'خطای نامشخص', isLoginMode: isLoginMode));
          }
          emit(AuthError(error: e.toString(), isLoginMode: isLoginMode));
        }
      } else if (event is AuthModeChangeIsClicked) {
        isLoginMode = !isLoginMode;
        emit(AuthInitial(isLoginMode: isLoginMode));
      }
    });
  }
}
