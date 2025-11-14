import 'package:dartz/dartz.dart';
import 'package:students_list/features/students/domain/entities/student.dart';
import 'package:students_list/features/students/domain/entities/student_filter.dart';
import 'package:students_list/res/failures/failure.dart';

abstract class StudentRepository {
  Future<Either<Failure, List<Student>>> getStudents(StudentFilter filter);
  Future<Either<Failure, Student>> createStudent(Student student);
}
