part of 'auth_bloc.dart';

abstract class AuthState extends Equatable {
  const AuthState();
  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoggedOut extends AuthState {}

// login
class AuthLoginLoading extends AuthState {}

class AuthLoginSuccess extends AuthState {
  final AuthTokens tokens;
  const AuthLoginSuccess(this.tokens);

  @override
  List<Object?> get props => [tokens];
}

class AuthLoginFailure extends AuthState {
  final String message;
  const AuthLoginFailure(this.message);

  @override
  List<Object?> get props => [message];
}

// Logout
class AuthLogoutLoading extends AuthState {}

class AuthLogoutSuccess extends AuthState {}

class AuthLogoutFailure extends AuthState {
  final String message;
  const AuthLogoutFailure(this.message);

  @override
  List<Object?> get props => [message];
}
