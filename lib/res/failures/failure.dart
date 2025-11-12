import 'dart:convert';

abstract class Failure {
  final String message;
  const Failure(this.message);

  @override
  String toString() => message;
}

class ServerFailure extends Failure {
  const ServerFailure(super.message);

  factory ServerFailure.fromResponse(String responseBody) {
    try {
      final decoded = jsonDecode(responseBody);
      if (decoded is Map && decoded.containsKey('error')) {
        return ServerFailure(decoded['error'] ?? "Unknown server error");
      }
      return const ServerFailure('Unknown server error');
    } catch (_) {
      return const ServerFailure('Invalid error format');
    }
  }
}

class NetworkFailure extends Failure {
  const NetworkFailure([super.message = 'Network error']);
}

class UnknownFailure extends Failure {
  const UnknownFailure([super.message = 'Unknown error']);
}
