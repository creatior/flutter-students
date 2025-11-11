class StudentModel {
  final String firstName;
  final String lastName;
  final String? middleName;
  final String? email;
  final String? phoneNumber;
  final String? telegram;
  final String? git;

  String get fullName => [
    firstName,
    middleName,
    lastName,
  ].where((e) => e != null && e.isNotEmpty).join(' ');

  StudentModel({
    required this.firstName,
    required this.lastName,
    this.middleName,
    this.email,
    this.phoneNumber,
    this.telegram,
    this.git,
  });

  factory StudentModel.fromJson(Map<String, dynamic> json) {
    return StudentModel(
      firstName: json['first_name'] ?? '',
      lastName: json['last_name'] ?? '',
      middleName: json['middle_name'],
      email: json['email'],
      phoneNumber: json['phone_number'],
      telegram: json['telegram'],
      git: json['git'],
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
