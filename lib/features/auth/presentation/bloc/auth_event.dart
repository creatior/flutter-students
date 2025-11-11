part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class AuthLoginEvent extends AuthEvent {
  final String username;
  final String password;

  const AuthLoginEvent(this.username, this.password);

  @override
  List<Object?> get props => [username, password];
}

class AuthLogoutEvent extends AuthEvent {}

class AuthRefreshEvent extends AuthEvent {}
