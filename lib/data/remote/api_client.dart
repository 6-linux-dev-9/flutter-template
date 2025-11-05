import 'package:dio/dio.dart';

class ApiClient {
  final Dio _dio;
  //ApiClient(this._dio);
  ApiClient(this._dio) {
    _dio.options
      ..contentType = 'application/json'
      ..responseType = ResponseType.json
      ..receiveDataWhenStatusError = true
      ..validateStatus =
          (status) => true; // NO arrojar excepción por 4xx/5xx, así leemos body

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          // LOG DE SALIDA
          // TIP: quita datos sensibles si los hubiera
          // ignore: avoid_print
          print('[REQ] ${options.method} ${options.uri}');
          print('[REQ] headers: ${options.headers}');
          print('[REQ] data: ${options.data}');
          handler.next(options);
        },
        onResponse: (response, handler) {
          // ignore: avoid_print
          print('[RES] ${response.statusCode} ${response.requestOptions.uri}');
          print('[RES] data: ${response.data}');
          handler.next(response);
        },
        onError: (e, handler) {
          // ignore: avoid_print
          print('[ERR] ${e.response?.statusCode} ${e.requestOptions.uri}');
          print('[ERR] data: ${e.response?.data}');
          handler.next(e);
        },
      ),
    );
  }


  Future<Response<T>> get<T>(String path, {Map<String, dynamic>? query}) =>
      _dio.get(path, queryParameters: query);
  Future<Response<T>> post<T>(String path, {dynamic data}) =>
      _dio.post(path, data: data);
  Future<Response<T>> put<T>(String path, {dynamic data}) =>
      _dio.put(path, data: data);
  Future<Response<T>> delete<T>(String path) => _dio.delete(path);
}
