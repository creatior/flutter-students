import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:students_list/features/students/domain/entities/student_filter.dart';
import 'package:students_list/features/students/domain/entities/student.dart';
import 'package:students_list/features/students/domain/usecases/student_get_usecase.dart';
import 'package:students_list/res/failures/failure.dart';
part 'student_state.dart';
part 'student_event.dart';

class StudentBloc extends Bloc<StudentEvent, StudentState> {
  final StudentGetUsecase studentGetUsecase;
  final int pageSize;

  StudentFilter _currentFilter = const StudentFilter();
  int _currentPage = 0;
  bool _isLastPage = false;

  StudentBloc({required this.studentGetUsecase, this.pageSize = 20})
    : super(StudentInitial()) {
    on<LoadStudentsEvent>(_onLoadStudents);
    on<UpdateFilterEvent>(_onUpdateFilter);
    on<ChangePageEvent>(_onChangePage);
    on<RefreshStudentsEvent>(_onRefresh);
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
        if (students.isEmpty && _currentPage == 0) {
          emit(StudentEmpty(_currentFilter));
        } else {
          _isLastPage = students.length < pageSize;
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
}
