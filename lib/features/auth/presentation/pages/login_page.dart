import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:students_list/di/di.dart';
import 'package:students_list/features/auth/domain/usecases/login_usecase.dart';
import 'package:students_list/features/auth/domain/usecases/logout_usecase.dart';
import 'package:students_list/features/auth/domain/usecases/refresh_usecase.dart';
import 'package:students_list/features/auth/presentation/bloc/auth_bloc.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AuthBloc(
        loginUsecase: di<LoginUsecase>(),
        logoutUsecase: di<LogoutUsecase>(),
        refreshUsecase: di<RefreshUsecase>(),
      ),
      child: BlocConsumer<AuthBloc, AuthState>(
        builder: (context, state) {
          if (state is AuthLoginLoading) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }
          return Scaffold(
            appBar: AppBar(title: const Text('Login')),
            body: const _LoginForm(),
          );
        },
        listener: (context, state) {
          if (state is AuthLoginSuccess) {
            Navigator.pushReplacementNamed(context, '/students');
          } else if (state is AuthLoginFailure) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
      ),
    );
  }
}

class _LoginForm extends StatefulWidget {
  const _LoginForm();

  @override
  State<_LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<_LoginForm> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextField(
            controller: _usernameController,
            decoration: const InputDecoration(labelText: 'Username'),
          ),
          TextField(
            controller: _passwordController,
            decoration: const InputDecoration(labelText: 'Password'),
            obscureText: true,
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              final username = _usernameController.text.trim();
              final password = _passwordController.text.trim();

              context.read<AuthBloc>().add(AuthLoginEvent(username, password));
            },
            child: const Text("Login"),
          ),
        ],
      ),
    );
  }
}
