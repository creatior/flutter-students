import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:students_list/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:students_list/features/auth/data/sources/auth_local_source.dart';
import 'package:students_list/features/auth/data/sources/auth_remote_source.dart';
import 'package:students_list/features/students/data/sources/student_local_source.dart';
import 'package:students_list/features/students/data/sources/student_remote_source.dart';

final GetIt di = GetIt.instance;

void setupDi() async {
  final sharedPreferences = await SharedPreferences.getInstance();
  di.registerSingleton(sharedPreferences);

  // auth
  di.registerLazySingleton<AuthLocalSource>(
    () => AuthLocalSource(sharedPreferences),
  );
  di.registerLazySingleton<AuthRemoteSource>(() => AuthRemoteSource());
  di.registerLazySingleton<AuthRepositoryImpl>(
    () => AuthRepositoryImpl(
      localSource: di<AuthLocalSource>(),
      remoteSource: di<AuthRemoteSource>(),
    ),
  );

  // students
  di.registerLazySingleton<StudentLocalSource>(
    () => StudentLocalSource(sharedPreferences),
  );
  di.registerLazySingleton<StudentRemoteSource>(() => StudentRemoteSource());
}
