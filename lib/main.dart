import 'package:flutter/material.dart';
import 'package:students_list/di/di.dart';
import 'package:students_list/features/auth/presentation/pages/login_page.dart';
import 'package:students_list/features/auth/presentation/pages/splash_page.dart';
import 'package:students_list/features/common/presentation/pages/main_tab_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupDi();
  runApp(const StudentsListApp());
}

class StudentsListApp extends StatelessWidget {
  const StudentsListApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        iconTheme: const IconThemeData(
          color: Color.fromARGB(255, 243, 255, 209),
        ),
        textTheme: const TextTheme(
          headlineLarge: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w700,
            fontSize: 18,
            fontFamily: 'Roboto',
          ),
          titleLarge: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w700,
            fontSize: 18,
            fontFamily: 'Roboto',
          ),
          titleMedium: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 14,
            letterSpacing: 1,
            fontFamily: 'Roboto-Thin',
          ),
        ),
        scaffoldBackgroundColor: const Color.fromARGB(255, 216, 216, 216),
      ),
      home: SplashPage(),
      initialRoute: '/splash',

      routes: {
        '/splash': (context) => const SplashPage(),
        '/login': (context) => const LoginPage(),
        '/main': (context) => const MainTabPage(),
      },
    );
  }
}
