import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:students_list/features/students/domain/entities/student_filter.dart';
import 'package:students_list/features/students/domain/entities/student.dart';
import 'package:students_list/features/students/domain/usecases/student_count_usecase.dart';
import 'package:students_list/features/students/domain/usecases/student_create_usecase.dart';
import 'package:students_list/features/students/domain/usecases/student_get_usecase.dart';
import 'package:students_list/res/failures/failure.dart';
part 'student_state.dart';
part 'student_event.dart';

class StudentBloc extends Bloc<StudentEvent, StudentState> {
  final StudentGetUsecase studentGetUsecase;
  final StudentCountUsecase studentCountUsecase;
  final StudentCreateUsecase studentCreateUsecase;
  final int pageSize;

  StudentFilter _currentFilter = const StudentFilter();
  int _currentPage = 0;
  bool _isLastPage = false;

  StudentBloc({
    required this.studentGetUsecase,
    required this.studentCreateUsecase,
    required this.studentCountUsecase,
    this.pageSize = 10,
  }) : super(StudentInitial()) {
    on<LoadStudentsEvent>(_onLoadStudents);
    on<UpdateFilterEvent>(_onUpdateFilter);
    on<ChangePageEvent>(_onChangePage);
    on<RefreshStudentsEvent>(_onRefresh);
    on<StudentAddEvent>(_onAddStudent);
  }

  Future<void> _onLoadStudents(
    LoadStudentsEvent event,
    Emitter<StudentState> emit,
  ) async {
    if (_isLastPage && event.page > _currentPage) return;

    emit(const StudentLoading());

    try {
      _currentFilter = event.filter;
      _currentPage = event.page;
      final countResult = await studentCountUsecase.execute(_currentFilter);

      int totalCount = 0;

      countResult.fold((failure) {
        emit(StudentError(failure));
        return;
      }, (count) => totalCount = count);

      final result = await studentGetUsecase.execute(
        StudentFilter(
          offset: _currentPage * pageSize,
          limit: pageSize,
          firstName: _currentFilter.firstName,
          lastName: _currentFilter.lastName,
          middleName: _currentFilter.middleName,
          telegramState: _currentFilter.telegramState,
          telegramValue: _currentFilter.telegramValue,
          emailState: _currentFilter.emailState,
          emailValue: _currentFilter.emailValue,
          phoneNumberState: _currentFilter.phoneNumberState,
          phoneNumberValue: _currentFilter.phoneNumberValue,
          gitState: _currentFilter.gitState,
          gitValue: _currentFilter.gitValue,
        ),
      );

      result.fold((failure) => emit(StudentError(failure)), (students) {
        _isLastPage = _currentPage * pageSize + students.length >= totalCount;

        if (students.isEmpty && _currentPage == 0) {
          emit(StudentEmpty(_currentFilter));
        } else {
          emit(
            StudentSuccess(
              students: students,
              currentPage: _currentPage,
              filter: _currentFilter,
              isLastPage: _isLastPage,
            ),
          );
        }
      });
    } catch (e) {
      emit(StudentError(UnknownFailure(e.toString())));
    }
  }

  Future<void> _onUpdateFilter(
    UpdateFilterEvent event,
    Emitter<StudentState> emit,
  ) async {
    _currentFilter = event.filter;
    _currentPage = 0;
    _isLastPage = false;
    add(LoadStudentsEvent(filter: _currentFilter, page: 0));
  }

  Future<void> _onChangePage(
    ChangePageEvent event,
    Emitter<StudentState> emit,
  ) async {
    if (_isLastPage && event.page > _currentPage) return;
    add(LoadStudentsEvent(filter: _currentFilter, page: event.page));
  }

  Future<void> _onRefresh(
    RefreshStudentsEvent event,
    Emitter<StudentState> emit,
  ) async {
    add(LoadStudentsEvent(filter: _currentFilter, page: _currentPage));
  }

  Future<void> _onAddStudent(
    StudentAddEvent event,
    Emitter<StudentState> emit,
  ) async {
    emit(StudentCreateLoading());

    try {
      final result = await studentCreateUsecase.execute(event.student);
      result.fold((failure) => emit(StudentCreateError(failure.toString())), (
        student,
      ) {
        emit(StudentCreateSuccess(student));
        add(RefreshStudentsEvent());
      });
    } catch (e) {
      emit(StudentCreateError(e.toString()));
    }
  }
}
