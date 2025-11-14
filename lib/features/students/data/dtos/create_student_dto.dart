import 'package:students_list/features/students/domain/entities/student.dart';

class CreateStudentDto {
  final String firstName;
  final String lastName;
  final String? middleName;
  final String? email;
  final String? phoneNumber;
  final String? telegram;
  final String? git;

  CreateStudentDto({
    required this.firstName,
    required this.lastName,
    this.middleName,
    this.email,
    this.phoneNumber,
    this.telegram,
    this.git,
  });

  factory CreateStudentDto.fromEntity(Student student) {
    return CreateStudentDto(
      firstName: student.firstName,
      lastName: student.lastName,
      middleName: student.middleName,
      email: student.email,
      phoneNumber: student.phoneNumber,
      telegram: student.telegram,
      git: student.git,
    );
  }

  Map<String, dynamic> toJson() => {
    'first_name': firstName,
    'last_name': lastName,
    'middle_name': middleName,
    'email': email,
    'phone_number': phoneNumber,
    'telegram': telegram,
    'git': git,
  };
}
