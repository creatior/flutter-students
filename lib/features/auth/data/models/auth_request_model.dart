class AuthRequestModel {
  final String username;
  final String password;

  const AuthRequestModel({required this.username, required this.password});

  Map<String, dynamic> toJson() => {'username': username, 'password': password};
}
