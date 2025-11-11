import 'package:students_list/features/students/data/enums/field_state.dart';

class StudentFilterDto {
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

  const StudentFilterDto({
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

  Map<String, dynamic> toQueryParameters() {
    final params = <String, dynamic>{};

    if (offset != null) params['offset'] = offset;
    if (limit != null) params['limit'] = limit;
    if (firstName?.isNotEmpty ?? false) params['first_name'] = firstName;
    if (lastName?.isNotEmpty ?? false) params['last_name'] = lastName;
    if (middleName?.isNotEmpty ?? false) params['middle_name'] = middleName;

    if (telegramState != null) {
      params['telegram_state'] = telegramState!.apiValue;
    }
    if (telegramValue?.isNotEmpty ?? false) {
      params['telegram_value'] = telegramValue;
    }

    if (emailState != null) {
      params['email_state'] = emailState!.apiValue;
    }
    if (emailValue?.isNotEmpty ?? false) {
      params['email_value'] = emailValue;
    }

    if (phoneNumberState != null) {
      params['phone_number_state'] = phoneNumberState!.apiValue;
    }
    if (phoneNumberValue?.isNotEmpty ?? false) {
      params['phone_number_value'] = phoneNumberValue;
    }

    if (gitState != null) {
      params['git_state'] = gitState!.apiValue;
    }
    if (gitValue?.isNotEmpty ?? false) {
      params['git_value'] = gitValue;
    }

    return params;
  }
}
