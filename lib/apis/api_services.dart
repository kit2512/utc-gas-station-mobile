import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:utc_gas_station/config/dio_config.dart';
import 'package:utc_gas_station/config/errors/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:utc_gas_station/config/errors/network_exception.dart';
import 'package:utc_gas_station/dependency_injection.dart';
import 'package:utc_gas_station/models/admin_info.dart';

class ApiService {
  final DioClient _dioClient;

  const ApiService(this._dioClient);

  String get baseUrl => _dioClient.baseUrl;

  set baseUrl(String baseUrl) {
    _dioClient.baseUrl = baseUrl;
  }

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

  Future<Either<Failure, bool>> updateSystem({required bool isAuto, int? manual}) async {
    try {
      final data = {
        'auto': isAuto ? 1 : 0,
        'number': manual,
      };
      final Response<String> response = await _dioClient.sendRequest.post(
        '/getsystem.php',
        data: data,
      );
      return const Right(true);
    } on DioException catch (e) {
      rethrow;
    } catch (e, stackTrace) {
      rethrow;
      log('🐞Error: $e', stackTrace: stackTrace);
      return Left(NetworkFailure(const NetworkException.unexpectedError()));
    }
  }

  Future<Either<Failure, AdminInfo>> getInfo() async {
    try {
      final Response<Map<String, dynamic>> response = await _dioClient.sendRequest.post(
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

  Future<void> checkQR(String payload) async {
    final Response<dynamic> response = await _dioClient.sendRequest.post(
      '/uploadqr.php',
      data: payload,
    );
  }

  Future<void> getLogin() async {
    final sharePreferences = getIt<SharedPreferences>();
    final username = sharePreferences.getString('username');
    final Response<dynamic> response = await _dioClient.sendRequest.post('/getlogin.php', data: {
      'user': username,
    });
  }
}
