import 'package:students_list/features/students/common/enums/field_state.dart';

class StudentFilter {
  final int? offset;
  final int? limit;
  final String? firstName;
  final String? lastName;
  final String? middleName;

  final FieldState? telegramState;
  final String? telegramValue;
  final FieldState? emailState;
  final String? emailValue;
  final FieldState? phoneNumberState;
  final String? phoneNumberValue;
  final FieldState? gitState;
  final String? gitValue;

  const StudentFilter({
    this.offset,
    this.limit,
    this.firstName,
    this.lastName,
    this.middleName,
    this.telegramState,
    this.telegramValue,
    this.emailState,
    this.emailValue,
    this.phoneNumberState,
    this.phoneNumberValue,
    this.gitState,
    this.gitValue,
  });
}
