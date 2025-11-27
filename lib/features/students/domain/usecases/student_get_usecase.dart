import 'package:students_list/features/students/domain/entities/student_filter.dart';
import 'package:students_list/features/students/domain/entities/student_list.dart';
import 'package:students_list/features/students/domain/repositories/student_repository.dart';

class StudentGetUsecase {
  final StudentRepository repository;
  StudentGetUsecase({required this.repository});

  Future<StudentList> execute(StudentFilter filter) async {
    return await repository.getStudents(filter);
  }
}
