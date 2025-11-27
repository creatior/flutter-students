import 'package:students_list/features/students/domain/entities/student.dart';

class StudentModel {
  final int id;
  final String firstName;
  final String lastName;
  final String? middleName;
  final String? email;
  final String? phoneNumber;
  final String? telegram;
  final String? git;
  final String fullName;

  StudentModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    this.middleName,
    this.email,
    this.phoneNumber,
    this.telegram,
    this.git,
    required this.fullName,
  });

  factory StudentModel.fromJson(Map<String, dynamic> json) {
    return StudentModel(
      id: json['id'],
      firstName: json['first_name'] ?? '',
      lastName: json['last_name'] ?? '',
      middleName: json['middle_name'],
      email: json['email'],
      phoneNumber: json['phone_number'],
      telegram: json['telegram'],
      git: json['git'],
      fullName: json['full_name'],
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
    'full_name': fullName,
  };

  Student toEntity() {
    return Student(
      id: id,
      firstName: firstName,
      lastName: lastName,
      fullName: fullName,
      middleName: middleName,
      email: email,
      phoneNumber: phoneNumber,
      telegram: telegram,
      git: git,
    );
  }
}
