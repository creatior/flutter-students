import 'package:dartz/dartz.dart';
import 'package:students_list/features/students/domain/entities/create_student.dart';
import 'package:students_list/features/students/domain/entities/student.dart';
import 'package:students_list/features/students/domain/entities/student_filter.dart';
import 'package:students_list/features/students/domain/entities/student_list.dart';
import 'package:students_list/res/failures/failure.dart';

abstract class StudentRepository {
  Future<StudentList> getStudents(StudentFilter filter);
  Future<Either<Failure, int>> getStudentsCount(StudentFilter filter);
  Future<Either<Failure, Student>> createStudent(CreateStudent student);
}
