import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:students_list/features/auth/domain/entities/auth_tokens.dart';
import 'package:students_list/features/auth/domain/usecases/login_usecase.dart';
import 'package:students_list/features/auth/domain/usecases/logout_usecase.dart';
import 'package:students_list/features/auth/domain/usecases/refresh_usecase.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUsecase loginUsecase;
  final LogoutUsecase logoutUsecase;
  final RefreshUsecase refreshUsecase;

  AuthBloc({
    required this.loginUsecase,
    required this.logoutUsecase,
    required this.refreshUsecase,
  }) : super(AuthInitial()) {
    on<AuthLoginEvent>((event, emit) async {
      emit(AuthLoginLoading());
      final result = await loginUsecase.execute(event.username, event.password);

      result.fold(
        (failure) => emit(AuthLoginFailure(failure.message)),
        (tokens) => emit(AuthLoginSuccess(tokens)),
      );
    });

    on<AuthLogoutEvent>((event, emit) async {
      emit(AuthLogoutLoading());
      final result = await logoutUsecase.execute();

      result.fold(
        (failure) => emit(AuthLogoutFailure(failure.message)),
        (_) => emit(AuthLogoutSuccess()),
      );
    });

    on<AuthRefreshEvent>((event, emit) async {
      try {
        final result = await refreshUsecase.execute().timeout(
          const Duration(seconds: 5),
          onTimeout: () => throw Exception('Server timeout'),
        );
        result.fold(
          (_) => emit(AuthLoggedOut()),
          (tokens) => emit(AuthLoginSuccess(tokens)),
        );
      } catch (_) {
        emit(AuthLoggedOut());
      }
    });
  }
}
