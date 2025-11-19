import 'package:dartz/dartz.dart';
import 'package:students_list/features/students/domain/entities/student_filter.dart';
import 'package:students_list/features/students/domain/repositories/student_repository.dart';
import 'package:students_list/res/failures/failure.dart';

class StudentCountUsecase {
  final StudentRepository repository;
  StudentCountUsecase({required this.repository});

  Future<Either<Failure, int>> execute(StudentFilter filter) async {
    return await repository.getStudentsCount(filter);
  }
}
