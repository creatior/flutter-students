import 'package:dartz/dartz.dart';
import 'package:students_list/features/students/domain/entities/create_student.dart';
import 'package:students_list/features/students/domain/entities/student.dart';
import 'package:students_list/features/students/domain/repositories/student_repository.dart';
import 'package:students_list/res/failures/failure.dart';

class StudentCreateUsecase {
  final StudentRepository repository;
  StudentCreateUsecase({required this.repository});

  Future<Either<Failure, Student>> execute(CreateStudent student) async {
    return await repository.createStudent(student);
  }
}
