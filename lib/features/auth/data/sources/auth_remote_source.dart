import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:students_list/config/base_url.dart';
import 'package:students_list/features/auth/data/models/auth_request_model.dart';
import 'package:students_list/features/auth/data/models/auth_response_model.dart';
import 'package:students_list/features/auth/data/models/refresh_request_model.dart';
import 'package:students_list/res/failures/failure.dart';

class AuthRemoteSource {
  Future<AuthResponseModel> login(AuthRequestModel request) async {
    final response = await http.post(
      Uri.parse('$baseUrl$authLoginUrl/'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(request.toJson()),
    );
    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      return AuthResponseModel.fromJson(body);
    } else {
      throw ServerFailure.fromResponse(response.body);
    }
  }

  Future<void> logout(String refreshToken) async {
    final response = await http.post(
      Uri.parse('$baseUrl$authLogoutUrl/'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'refresh_token': refreshToken}),
    );

    if (response.statusCode != 200) {
      throw ServerFailure.fromResponse(response.body);
    }
  }

  Future<AuthResponseModel> refresh(RefreshRequestModel request) async {
    final response = await http.post(
      Uri.parse('$baseUrl$authRefreshUrl/'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(request.toJson()),
    );
    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      return AuthResponseModel.fromJson(body);
    } else {
      throw ServerFailure.fromResponse(response.body);
    }
  }
}
