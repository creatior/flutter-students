import 'package:dartz/dartz.dart';
import 'package:students_list/features/students/domain/entities/student.dart';
import 'package:students_list/features/students/domain/entities/student_filter.dart';
import 'package:students_list/features/students/domain/repositories/student_repository.dart';
import 'package:students_list/res/failures/failure.dart';

class StudentGetUsecase {
  final StudentRepository repository;
  StudentGetUsecase({required this.repository});

  Future<Either<Failure, List<Student>>> execute(StudentFilter filter) async {
    return await repository.getStudents(filter);
  }
}
