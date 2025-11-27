import 'package:students_list/features/students/domain/entities/student.dart';
import 'package:students_list/res/failures/failure.dart';

class StudentList {
  final Failure? failure;
  final List<Student> students;

  StudentList({this.failure, required this.students});

  bool hasError() => failure == null;
}
