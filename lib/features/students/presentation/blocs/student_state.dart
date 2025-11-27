part of 'student_bloc.dart';

abstract class StudentState {
  const StudentState();
}

class StudentInitial extends StudentState {
  const StudentInitial();
}

class StudentLoading extends StudentState {
  const StudentLoading();
}

class StudentSuccess extends StudentState {
  final List<Student> students;
  final int currentPage;
  final StudentFilter filter;
  final bool isLastPage;
  final Failure? error;

  const StudentSuccess({
    required this.students,
    required this.currentPage,
    required this.filter,
    this.isLastPage = false,
    this.error,
  });
}

class StudentError extends StudentState {
  final Failure failure;
  const StudentError(this.failure);
}

class StudentEmpty extends StudentState {
  final StudentFilter filter;
  const StudentEmpty(this.filter);
}

class StudentCreateLoading extends StudentState {}

class StudentCreateSuccess extends StudentState {
  final Student student;
  StudentCreateSuccess(this.student);
}

class StudentCreateError extends StudentState {
  final String message;
  StudentCreateError(this.message);
}
