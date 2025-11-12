import 'package:dartz/dartz.dart';
import 'package:students_list/features/auth/domain/repositories/auth_repository.dart';
import 'package:students_list/res/failures/failure.dart';

class LogoutUsecase {
  final AuthRepository repository;
  LogoutUsecase({required this.repository});

  Future<Either<Failure, void>> execute() async {
    return await repository.logout();
  }
}
