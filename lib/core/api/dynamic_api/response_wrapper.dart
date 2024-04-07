import 'package:dio/dio.dart';

class ResponseWrapper {
  Response<dynamic>? response;
  DioException? exception;

  ResponseWrapper.success(this.response);

  ResponseWrapper.failure(this.exception);

  int get code => response?.statusCode ?? exception?.response?.statusCode ?? 0;

  String? get message => response?.statusMessage;

  dynamic get body => response?.data;

  Map? get bodyMap => body is Map ? body : null;

  dynamic get errorBody => exception?.response?.data;

  bool get isSuccessfully => (code >= 200 && code <= 299);
}
