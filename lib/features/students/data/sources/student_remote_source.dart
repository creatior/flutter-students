import 'dart:convert';

import 'package:students_list/config/base_url.dart';
import 'package:students_list/features/students/data/dtos/student_filter_dto.dart';
import 'package:students_list/features/students/data/models/student_model.dart';
import 'package:http/http.dart' as http;
import 'package:students_list/res/failures/failure.dart';

class StudentRemoteSource {
  Future<List<StudentModel>> getStudents(StudentFilterDto request) async {
    final uri = Uri.parse(
      '$baseUrl$studentsBaseUrl/',
    ).replace(queryParameters: request.toQueryParameters());

    try {
      final response = await http.get(
        uri,
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);

        List<dynamic> studentsJson;
        if (body is List) {
          studentsJson = body;
        } else if (body is Map && body.containsKey('data')) {
          studentsJson = body['data'];
        } else {
          throw const ServerFailure('Invalid response format');
        }
        return studentsJson.map((json) => StudentModel.fromJson(json)).toList();
      } else {
        throw ServerFailure.fromResponse(response.body);
      }
    } on http.ClientException {
      throw const NetworkFailure('Failed to connect to server');
    } on ServerFailure catch (e) {
      rethrow;
    } catch (e) {
      throw UnknownFailure(e.toString());
    }
  }
}
