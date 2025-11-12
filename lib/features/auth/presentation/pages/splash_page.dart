import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:students_list/di/di.dart';
import 'package:students_list/features/auth/domain/usecases/login_usecase.dart';
import 'package:students_list/features/auth/domain/usecases/logout_usecase.dart';
import 'package:students_list/features/auth/domain/usecases/refresh_usecase.dart';
import 'package:students_list/features/auth/presentation/bloc/auth_bloc.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AuthBloc(
        loginUsecase: di<LoginUsecase>(),
        logoutUsecase: di<LogoutUsecase>(),
        refreshUsecase: di<RefreshUsecase>(),
      )..add(AuthRefreshEvent()),
      child: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthLoginSuccess) {
            Navigator.pushReplacementNamed(context, '/students');
          } else if (state is AuthLoggedOut) {
            Navigator.pushReplacementNamed(context, '/login');
          }
        },
        child: const Scaffold(body: Center(child: CircularProgressIndicator())),
      ),
    );
  }
}
