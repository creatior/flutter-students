import 'package:students_list/features/auth/domain/entities/auth_tokens.dart';
import 'package:students_list/res/failures/failure.dart';
import 'package:dartz/dartz.dart';

abstract class AuthRepository {
  Future<Either<Failure, AuthTokens>> login(String username, String password);
  Future<Either<Failure, void>> logout();
  Future<Either<Failure, AuthTokens>> refresh();
}
