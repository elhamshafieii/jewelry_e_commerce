part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class AuthStarted extends AuthEvent {}


class AuthButtonIsClicked extends AuthEvent {
  final String username;
  final String password;

  const AuthButtonIsClicked({required this.username, required this.password});
  @override
  List<Object> get props => [username, password];
}

class AuthModeChangeIsClicked extends AuthEvent {}
