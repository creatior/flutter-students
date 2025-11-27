import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:students_list/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:students_list/features/auth/data/sources/auth_local_source.dart';
import 'package:students_list/features/auth/data/sources/auth_remote_source.dart';
import 'package:students_list/features/auth/domain/usecases/login_usecase.dart';
import 'package:students_list/features/auth/domain/usecases/logout_usecase.dart';
import 'package:students_list/features/auth/domain/usecases/refresh_usecase.dart';
import 'package:students_list/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:students_list/features/students/data/db/app_database.dart';
import 'package:students_list/features/students/data/repositories/student_repository_impl.dart';
import 'package:students_list/features/students/data/sources/student_db_source.dart';
import 'package:students_list/features/students/data/sources/student_local_source.dart';
import 'package:students_list/features/students/data/sources/student_remote_source.dart';
import 'package:students_list/features/students/domain/usecases/student_count_usecase.dart';
import 'package:students_list/features/students/domain/usecases/student_create_usecase.dart';
import 'package:students_list/features/students/domain/usecases/student_get_usecase.dart';
import 'package:students_list/features/students/presentation/blocs/student_bloc.dart';

final GetIt di = GetIt.instance;

Future<void> setupDi() async {
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
  di.registerLazySingleton<LoginUsecase>(
    () => LoginUsecase(repository: di<AuthRepositoryImpl>()),
  );
  di.registerLazySingleton<LogoutUsecase>(
    () => LogoutUsecase(repository: di<AuthRepositoryImpl>()),
  );
  di.registerLazySingleton<RefreshUsecase>(
    () => RefreshUsecase(repository: di<AuthRepositoryImpl>()),
  );

  di.registerLazySingleton<AuthBloc>(
    () => AuthBloc(
      loginUsecase: di<LoginUsecase>(),
      logoutUsecase: di<LogoutUsecase>(),
      refreshUsecase: di<RefreshUsecase>(),
    ),
  );

  // students
  di.registerLazySingleton<StudentLocalSource>(
    () => StudentLocalSource(sharedPreferences),
  );
  di.registerLazySingleton<StudentRemoteSource>(() => StudentRemoteSource());

  di.registerLazySingleton<AppDatabase>(() => AppDatabase());

  di.registerLazySingleton<StudentDbSource>(
    () => StudentDbSource(di<AppDatabase>()),
  );

  di.registerLazySingleton<StudentRepositoryImpl>(
    () => StudentRepositoryImpl(
      localSource: di<StudentLocalSource>(),
      remoteSource: di<StudentRemoteSource>(),
      dbSource: di<StudentDbSource>(),
    ),
  );
  di.registerLazySingleton<StudentGetUsecase>(
    () => StudentGetUsecase(repository: di<StudentRepositoryImpl>()),
  );
  di.registerLazySingleton<StudentCreateUsecase>(
    () => StudentCreateUsecase(repository: di<StudentRepositoryImpl>()),
  );
  di.registerLazySingleton<StudentCountUsecase>(
    () => StudentCountUsecase(repository: di<StudentRepositoryImpl>()),
  );
  di.registerLazySingleton<StudentBloc>(
    () => StudentBloc(
      studentGetUsecase: di<StudentGetUsecase>(),
      studentCreateUsecase: di<StudentCreateUsecase>(),
      studentCountUsecase: di<StudentCountUsecase>(),
    ),
  );
}
