import 'package:dartz/dartz.dart';
import 'package:students_list/features/auth/domain/entities/auth_tokens.dart';
import 'package:students_list/features/auth/domain/repositories/auth_repository.dart';
import 'package:students_list/res/failures/failure.dart';

class LoginUsecase {
  final AuthRepository repository;
  LoginUsecase({required this.repository});

  Future<Either<Failure, AuthTokens>> execute(
    String username,
    String password,
  ) async {
    return await repository.login(username, password);
  }
}
