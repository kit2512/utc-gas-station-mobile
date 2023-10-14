import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:utc_gas_station/config/dio_config.dart';
import 'package:utc_gas_station/config/errors/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:utc_gas_station/config/errors/network_exception.dart';
import 'package:utc_gas_station/models/admin_info.dart';

class ApiService {
  final DioClient _dioClient;

  const ApiService(this._dioClient);

  Future<Either<Failure, bool>> login({required String username, required int password}) async {
    try {
      final Response<Map<String, dynamic>> response = await _dioClient.sendRequest.post(
        '/getuser.php',
        data: {
          'user': username,
          'pwd': password,
        },
      );
      return const Right(true);
    } on DioException catch (e) {
      final exception = NetworkException.getDioException(e);
      return Left(NetworkFailure(exception));
    } catch (e, stackTrace) {
      log('🐞Error: $e', stackTrace: stackTrace);
      return Left(NetworkFailure(const NetworkException.unexpectedError()));
    }
  }

  Future<Either<Failure, bool>> updateSystem({
    required bool isAuto,
    int? manual
  }) async {
    try {
      final data = {
        'auto': isAuto ? 1 : 0,
        'manual': manual,
      };
      print(jsonEncode(data));
      final Response<Map<String, dynamic>> response = await _dioClient.sendRequest.post(
        '/getsystem.php',
        data: data,
      );
      return const Right(true);
    } on DioException catch (e) {
      final exception = NetworkException.getDioException(e);
      return Left(NetworkFailure(exception));
    } catch (e, stackTrace) {
      rethrow;
      log('🐞Error: $e', stackTrace: stackTrace);
      return Left(NetworkFailure(const NetworkException.unexpectedError()));
    }
  }

  Future<Either<Failure, AdminInfo>> getInfo() async {
    try {
      final Response<Map<String, dynamic>> response = await _dioClient.sendRequest.get(
        '/getinfor.php',
      );
      return Right(AdminInfo.fromJson(response.data!));
    } on DioException catch (e) {
      final exception = NetworkException.getDioException(e);
      return Left(NetworkFailure(exception));
    } catch (e, stackTrace) {
      log('🐞Error: $e', stackTrace: stackTrace);
      return Left(NetworkFailure(const NetworkException.unexpectedError()));
    }
  }

  Future<Either<Failure, bool>> checkQR(String payload) async {
    try {
      final Response<dynamic> response = await _dioClient.sendRequest.post(
        '/uploadqr.php',
        data: payload,
      );
      return Right(true);
    } on DioException catch (e) {
      final exception = NetworkException.getDioException(e);
      return Left(NetworkFailure(exception));
    } catch (e, stackTrace) {
      log('🐞Error: $e', stackTrace: stackTrace);
      return Left(NetworkFailure(const NetworkException.unexpectedError()));
    }
  }
}