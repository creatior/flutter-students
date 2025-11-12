import 'package:students_list/features/students/common/enums/field_state.dart';
import 'package:students_list/features/students/domain/entities/student_filter.dart';

class StudentFilterDto {
  final StudentFilter filter;

  StudentFilterDto(this.filter);

  Map<String, dynamic>? toQueryParameters() {
    final params = <String, dynamic>{};

    if (filter.offset != null) {
      params['offset'] = filter.offset.toString();
    }
    if (filter.limit != null) {
      params['limit'] = filter.limit.toString();
    }
    if (filter.firstName?.isNotEmpty ?? false) {
      params['first_name'] = filter.firstName;
    }
    if (filter.lastName?.isNotEmpty ?? false) {
      params['last_name'] = filter.lastName;
    }
    if (filter.middleName?.isNotEmpty ?? false) {
      params['middle_name'] = filter.middleName;
    }

    if (filter.telegramState != null) {
      params['telegram_state'] = filter.telegramState!.apiValue;
    }
    if (filter.telegramValue?.isNotEmpty ?? false) {
      params['telegram_value'] = filter.telegramValue;
    }

    if (filter.emailState != null) {
      params['email_state'] = filter.emailState!.apiValue;
    }
    if (filter.emailValue?.isNotEmpty ?? false) {
      params['email_value'] = filter.emailValue;
    }

    if (filter.phoneNumberState != null) {
      params['phone_number_state'] = filter.phoneNumberState!.apiValue;
    }
    if (filter.phoneNumberValue?.isNotEmpty ?? false) {
      params['phone_number_value'] = filter.phoneNumberValue;
    }

    if (filter.gitState != null) {
      params['git_state'] = filter.gitState!.apiValue;
    }
    if (filter.gitValue?.isNotEmpty ?? false) {
      params['git_value'] = filter.gitValue;
    }
    return params;
  }
}
