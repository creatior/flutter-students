import 'package:dartz/dartz.dart';
import 'package:students_list/features/auth/domain/entities/auth_tokens.dart';
import 'package:students_list/features/auth/domain/repositories/auth_repository.dart';
import 'package:students_list/res/failures/failure.dart';

class RefreshUsecase {
  final AuthRepository repository;
  RefreshUsecase(this.repository);

  Future<Either<Failure, AuthTokens>> execute() async {
    return await repository.refresh();
  }
}
