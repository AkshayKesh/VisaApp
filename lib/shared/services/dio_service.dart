import 'dart:developer';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:logger/logger.dart';
import 'package:register_visa_web_app/core/constants/api_end_points.dart';
import 'package:register_visa_web_app/core/constants/app_constant.dart';
import 'package:register_visa_web_app/shared/services/response_model.dart';

class ApiManager {
  static final ApiManager _instance = ApiManager._internal();

  factory ApiManager() => _instance;

  ApiManager._internal();

  static final Dio _dio = Dio();

  static Future<ResponseAPI> post({
    required String methodName,
    required Map<String, dynamic> params,
  }) async {
    try {
      await _checkConnectivity();
      String url = ApiEndpoints.baseUrl + methodName;

      await refreshTotken();

      Options options = _header();
      log("==request URL == $url");
      log("==params PARAM== $params");

      Response response = await _dio.post(url, data: params, options: options);
      log("==response DATA== ${response.data}");
      log("==statuCode STATUS CODE== ${response.statusCode}");
      return ResponseAPI(response.statusCode ?? 0, response.data);
    } catch (error) {
      log("==error==$error");
      return _handleError(error);
    }
  }

  static Future<ResponseAPI> put({
    required String methodName,
    required Map<String, dynamic> params,
  }) async {
    try {
      await _checkConnectivity();
      String url = ApiEndpoints.baseUrl + methodName;

      await refreshTotken();

      Options options = _header();
      log("==request URL== $url");
      log("==params PARM== $params");
      Response response = await _dio.put(url, data: params, options: options);
      log("==response DATA== ${response.data}");
      return ResponseAPI(response.statusCode ?? 0, response.data);
    } catch (error) {
      log("==error==$error");
      return _handleError(error);
    }
  }

  static Future<ResponseAPI> get({required String methodName}) async {
    try {
      await _checkConnectivity();
      String url = ApiEndpoints.baseUrl + methodName;

      await refreshTotken();

      Options options = _header();
      log("==request== $url");
      Response response = await _dio.get(url, options: options);
      var logger = Logger(
        level: Level.info,
        printer: PrettyPrinter(methodCount: 0, noBoxingByDefault: false),
      );
      logger.i("==response== ${response.data}");
      return ResponseAPI(response.statusCode ?? 0, response.data);
    } catch (error) {
      return _handleError(error);
    }
  }

  static Future<ResponseAPI> mapGetAPI({required String url}) async {
    try {
      await _checkConnectivity();
      log("==MAP API request== $url");
      Response response = await _dio.get(url);
      log("==MAP API response== ${response.data}");
      return ResponseAPI(response.statusCode ?? 0, response.data);
    } catch (error) {
      log("==error==$error");
      return _handleError(error);
    }
  }

  static Future<ResponseAPI> multipartAPI({
    required Map<String, dynamic> params,
    required String methodName,
  }) async {
    try {
      await _checkConnectivity();
      String url = ApiEndpoints.baseUrl + methodName;

      await refreshTotken();

      Options options = _header();
      log("==request== $url");
      final formData = FormData.fromMap(params);

      final response = await _dio.post(
        url,
        data: formData,
        options: options,
        onSendProgress: (int sent, int total) {
          log('==progress==$sent $total');
        },
      );
      var logger = Logger(
        level: Level.info,
        printer: PrettyPrinter(methodCount: 0, noBoxingByDefault: false),
      );
      logger.i("==response== ${response.data}");
      return ResponseAPI(response.statusCode ?? 0, response.data);
    } catch (error) {
      return _handleError(error);
    }
  }

  static Future<void> _checkConnectivity() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult.contains(ConnectivityResult.mobile) &&
        connectivityResult.contains(ConnectivityResult.wifi)) {
      throw ApiError(1, "No internet");
    }
  }

  static ResponseAPI _handleError(dynamic error) {
    var logger = Logger(level: Level.error);
    logger.e("Error== $error");
    return ResponseAPI(
      0,
      {"error": error},
      isError: true,
      error: ApiError(0, error.toString()),
    );
  }

  static Options _header() {
    Map<String, dynamic> map = {'Content-Type': 'application/json'};
    if (AppConstants.authToken != "") {
      map['Authorization'] = 'Bearer ${AppConstants.authToken}';
    }
    return Options(headers: map);
  }

  /// Refreshes the authentication token if it has expired.
  ///
  /// Checks if [AppConstants.authToken] is not empty, and uses [JwtDecoder.isExpired]
  /// to verify if the token has expired. If expired, it sends a PUT request to
  /// [ApiEndpoints.refreshToken] to obtain a new token and updates [AppConstants.authToken].
  static Future<void> refreshTotken() async {
    try {
      if (AppConstants.authToken != "") {
        bool hasExpired = JwtDecoder.isExpired(AppConstants.authToken);
        if (hasExpired) {
          String url = ApiEndpoints.baseUrl + ApiEndpoints.refreshToken;
          final response = await _dio.put(
            url,
            options: Options(
              headers: {
                'Authorization': 'Bearer ${AppConstants.authToken}',
                'Content-Type': 'application/json',
              },
            ),
          );

          AppConstants.authToken = response.data["authToken"];
        }
      }
    } catch (e) {
      // Optionally log or handle error here
      Logger(level: Level.error).e("Error refreshing token: $e");
      // Depending on app requirements, you might want to rethrow or handle differently
    }
  }
}
