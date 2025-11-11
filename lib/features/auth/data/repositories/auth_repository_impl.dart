import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:students_list/features/auth/data/models/auth_request_model.dart';
import 'package:students_list/features/auth/data/models/refresh_request_model.dart';
import 'package:students_list/features/auth/data/sources/auth_local_source.dart';
import 'package:students_list/features/auth/data/sources/auth_remote_source.dart';
import 'package:students_list/features/auth/domain/entities/auth_tokens.dart';
import 'package:students_list/features/auth/domain/repositories/auth_repository.dart';
import 'package:students_list/res/failures/failure.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthLocalSource localSource;
  final AuthRemoteSource remoteSource;

  AuthRepositoryImpl({required this.localSource, required this.remoteSource});

  @override
  Future<Either<Failure, AuthTokens>> login(
    String username,
    String password,
  ) async {
    try {
      final response = await remoteSource.login(
        AuthRequestModel(username: username, password: password),
      );
      return Right(
        AuthTokens(
          accessToken: response.accessToken,
          refreshToken: response.refreshToken,
        ),
      );
    } on Failure catch (f) {
      return Left(f);
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      final refreshToken = await localSource.getToken('refresh_token');
      if (refreshToken == null) {
        return Left(ServerFailure('No refresh token found'));
      }

      await remoteSource.logout(refreshToken);
      await localSource.clearTokens();

      return const Right(null);
    } on Failure catch (f) {
      return Left(f);
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, AuthTokens>> refresh() async {
    try {
      final refreshToken = await localSource.getToken('refresh_token');
      if (refreshToken == null) {
        return Left(ServerFailure('No refresh token found'));
      }

      final response = await remoteSource.refresh(
        RefreshRequestModel(refreshToken: refreshToken),
      );
      await localSource.setToken('refresh_token', response.refreshToken);
      await localSource.setToken('access_token', response.accessToken);

      return Right(
        AuthTokens(
          accessToken: response.accessToken,
          refreshToken: response.refreshToken,
        ),
      );
    } on Failure catch (f) {
      return Left(f);
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }
}
