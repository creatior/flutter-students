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

  const StudentSuccess({
    required this.students,
    required this.currentPage,
    required this.filter,
    this.isLastPage = false,
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
