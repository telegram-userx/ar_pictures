import 'package:dio/dio.dart';

class DioHttpClient {
  DioHttpClient({
    BaseOptions? baseOptions,
    List<Interceptor>? interceptors,
  }) : _dio = Dio(baseOptions ?? BaseOptions()) {
    if (interceptors != null) {
      _dio.interceptors.addAll(interceptors);
    }
  }

  final Dio _dio;

  Future<Response> request({
    required String url,
    Object? data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  }) =>
      _dio.request(
        url,
        data: data,
        queryParameters: queryParameters,
        options: Options(
          headers: headers,
        ),
      );

  Future<Response> get({
    required String url,
    Object? data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    bool fromCache = true,
  }) =>
      _dio.get(
        url,
        data: data,
        queryParameters: queryParameters,
        options: Options(
          headers: headers,
        ),
      );

  Future<Response> post({
    required String url,
    Object? data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  }) =>
      _dio.post(
        url,
        data: data,
        queryParameters: queryParameters,
        options: Options(
          headers: headers,
        ),
      );

  Future<Response> put({
    required String url,
    Object? data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  }) =>
      _dio.put(
        url,
        data: data,
        queryParameters: queryParameters,
        options: Options(
          headers: headers,
        ),
      );

  Future<Response> delete({
    required String url,
    Object? data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  }) =>
      _dio.delete(
        url,
        data: data,
        queryParameters: queryParameters,
        options: Options(
          headers: headers,
        ),
      );
}
