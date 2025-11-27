class CreateStudent {
  final String firstName;
  final String lastName;
  final String? middleName;
  final String? email;
  final String? phoneNumber;
  final String? telegram;
  final String? git;
  final String fullName;

  CreateStudent({
    required this.firstName,
    required this.lastName,
    this.middleName,
    this.email,
    this.phoneNumber,
    this.telegram,
    this.git,
    required this.fullName,
  });
}
