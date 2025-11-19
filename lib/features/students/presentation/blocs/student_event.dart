part of 'student_bloc.dart';

abstract class StudentEvent {
  const StudentEvent();
}

class LoadStudentsEvent extends StudentEvent {
  final StudentFilter filter;
  final int page;

  const LoadStudentsEvent({required this.filter, this.page = 0});
}

class UpdateFilterEvent extends StudentEvent {
  final StudentFilter filter;

  const UpdateFilterEvent(this.filter);
}

class ChangePageEvent extends StudentEvent {
  final int page;

  const ChangePageEvent(this.page);
}

class RefreshStudentsEvent extends StudentEvent {
  const RefreshStudentsEvent();
}

class StudentAddEvent extends StudentEvent {
  final Student student;
  StudentAddEvent(this.student);
}
