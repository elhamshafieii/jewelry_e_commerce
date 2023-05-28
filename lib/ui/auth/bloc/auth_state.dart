part of 'auth_bloc.dart';

abstract class AuthState extends Equatable {
  final bool isLoginMode;
  const AuthState({required this.isLoginMode});

  @override
  List<Object> get props => [];
}

class AuthInitial extends AuthState {
  const AuthInitial({required super.isLoginMode});
}

class AuthError extends AuthState {
  final String error;
  const AuthError({required this.error, required super.isLoginMode});
}

class AuthLoading extends AuthState {
  const AuthLoading({required super.isLoginMode});
}

class AuthSuccess extends AuthState {
  const AuthSuccess({required super.isLoginMode});
}
