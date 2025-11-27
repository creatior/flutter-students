import 'package:dartz/dartz.dart';
import 'package:students_list/features/students/data/dtos/create_student_dto.dart';
import 'package:students_list/features/students/data/dtos/student_filter_dto.dart';
import 'package:students_list/features/students/data/sources/student_db_source.dart';
import 'package:students_list/features/students/data/sources/student_local_source.dart';
import 'package:students_list/features/students/data/sources/student_remote_source.dart';
import 'package:students_list/features/students/domain/entities/create_student.dart';
import 'package:students_list/features/students/domain/entities/student.dart';
import 'package:students_list/features/students/domain/entities/student_filter.dart';
import 'package:students_list/features/students/domain/entities/student_list.dart';
import 'package:students_list/features/students/domain/repositories/student_repository.dart';
import 'package:students_list/res/failures/failure.dart';

class StudentRepositoryImpl extends StudentRepository {
  final StudentLocalSource localSource;
  final StudentRemoteSource remoteSource;
  final StudentDbSource dbSource;

  StudentRepositoryImpl({
    required this.localSource,
    required this.remoteSource,
    required this.dbSource,
  });

  @override
  Future<StudentList> getStudents(StudentFilter filter) async {
    try {
      final response = await remoteSource.getStudents(StudentFilterDto(filter));
      final students = response.map((student) => student.toEntity()).toList();

      await dbSource.saveStudents(students);

      return StudentList(students: students);
    } on Failure catch (failure) {
      final students = await dbSource.getStudents(filter: filter);
      return StudentList(students: students, failure: failure);
    } catch (e) {
      final students = await dbSource.getStudents(filter: filter);
      return StudentList(
        students: students,
        failure: UnknownFailure(e.toString()),
      );
    }
  }

  @override
  Future<Either<Failure, int>> getStudentsCount(StudentFilter filter) async {
    try {
      final response = await remoteSource.getStudentsCount(
        StudentFilterDto(filter),
      );
      return Right(response);
    } on Failure catch (failure) {
      return Left(failure);
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Student>> createStudent(CreateStudent student) async {
    try {
      final token = await localSource.getToken('access_token');

      final response = await remoteSource.createStudent(
        CreateStudentDto.fromEntity(student),
        token,
      );
      return Right(response.toEntity());
    } on Failure catch (failure) {
      return Left(failure);
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }
}
