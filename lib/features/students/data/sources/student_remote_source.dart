import 'dart:convert';
import 'package:students_list/config/base_url.dart';
import 'package:students_list/features/students/data/dtos/create_student_dto.dart';
import 'package:students_list/features/students/data/dtos/student_filter_dto.dart';
import 'package:students_list/features/students/data/models/student_model.dart';
import 'package:http/http.dart' as http;
import 'package:students_list/res/failures/failure.dart';

class StudentRemoteSource {
  Future<List<StudentModel>> getStudents(StudentFilterDto request) async {
    final uri = Uri.parse(
      '$baseUrl$studentsBaseUrl/',
    ).replace(queryParameters: request.toQueryParameters());

    final response = await http.get(
      uri,
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      if (response.body.isEmpty || response.body == 'null') {
        return [];
      }

      final body = jsonDecode(response.body);

      List<dynamic> studentsJson;

      if (body is List) {
        studentsJson = body;
      } else if (body is Map && body.containsKey('data')) {
        final data = body['data'];
        if (data is List) {
          studentsJson = data;
        } else {
          throw const ServerFailure(
            'Invalid response format: "data" is not a list',
          );
        }
      } else {
        throw const ServerFailure('Invalid response format');
      }

      return studentsJson.map((json) => StudentModel.fromJson(json)).toList();
    } else {
      throw ServerFailure.fromResponse(response.body);
    }
  }

  Future<int> getStudentsCount(StudentFilterDto request) async {
    final uri = Uri.parse(
      '$baseUrl$studentsBaseUrl$studentsCountUrl/',
    ).replace(queryParameters: request.toQueryParameters());

    final response = await http.get(
      uri,
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);

      if (body is Map && body.containsKey('count')) {
        return body['count'] as int;
      } else {
        throw const ServerFailure(
          'Invalid response format: "count" is missing',
        );
      }
    } else {
      throw ServerFailure.fromResponse(response.body);
    }
  }

  Future<StudentModel> createStudent(
    CreateStudentDto request,
    String? token,
  ) async {
    final uri = Uri.parse('$baseUrl$studentsBaseUrl/');

    try {
      final response = await http.post(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(request.toJson()),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final body = jsonDecode(response.body);
        return StudentModel.fromJson(body);
      } else {
        throw ServerFailure.fromResponse(response.body);
      }
    } on http.ClientException {
      throw const NetworkFailure('Failed to connect to server');
    } on ServerFailure {
      rethrow;
    } catch (e) {
      throw UnknownFailure(e.toString());
    }
  }
}
