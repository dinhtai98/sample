import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sample/core/api/dynamic_api/response_wrapper.dart';
import 'package:sample/core/api/logging_interceptor.dart';

class AppApi {
  Dio? _dio;

  void setServiceUrl(String url) {
    _dio = Dio(BaseOptions(
      contentType: Headers.jsonContentType,
      baseUrl: url,
      connectTimeout: const Duration(seconds: 20000),
      receiveTimeout: const Duration(seconds: 20000),
    ));
    _dio?.interceptors.add(LoggingInterceptor());
    // _dio?.interceptors.add(
    //   PrettyDioLogger(
    //     requestHeader: true,
    //     requestBody: true,
    //     logPrint: (log) => debugPrint(log.toString()),
    //   ),
    // );
  }

  void setBaseHeader(Map<String, dynamic> headers) {
    _dio?.options.headers = headers;
  }

  Future<ResponseWrapper> get(
    String url, {
    Function(Map<String, dynamic>)? headers,
    Map<String, dynamic>? params,
  }) async {
    try {
      final result = await _dio!.get(url, queryParameters: params);
      return ResponseWrapper.success(result);
    } on DioException catch (e) {
      return ResponseWrapper.failure(e);
    }
  }

  Future<ResponseWrapper> post(
    String url, {
    Function(Map<String, dynamic>)? headers,
    dynamic body,
  }) async {
    try {
      dynamic result = await _dio!.post(url,
          data: body,
          options: Options(
            contentType: Headers.jsonContentType,
          ));
      return ResponseWrapper.success(result);
    } on DioException catch (e) {
      return ResponseWrapper.failure(e);
    }
  }

  Future<ResponseWrapper> put(
    String url, {
    Function(Map<String, dynamic>)? headers,
    Map<String, dynamic>? body,
  }) async {
    try {
      final result = await _dio!.put(url, data: body);
      return ResponseWrapper.success(result);
    } on DioException catch (e) {
      return ResponseWrapper.failure(e);
    }
  }

  Future<ResponseWrapper> delete(
    String url, {
    Function(Map<String, dynamic>)? headers,
    Map<String, dynamic>? body,
  }) async {
    try {
      final result = await _dio!.delete(url, data: body);
      return ResponseWrapper.success(result);
    } on DioException catch (e) {
      return ResponseWrapper.failure(e);
    }
  }

  Future<Response?> download(
    String url, {
    required fileName,
    Map<String, dynamic>? body,
  }) async {
    try {
      Directory dir = await getTemporaryDirectory();
      final response = await _dio?.download(
        'https://pub.dev/',
        "${dir.path}$fileName",
      );
      return response;
    } on DioException catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  Future<ResponseWrapper> patch(
    String url, {
    Function(Map<String, dynamic>)? headers,
    dynamic body,
  }) async {
    try {
      dynamic result = await _dio!.patch(url,
          data: body,
          options: Options(
            contentType: Headers.jsonContentType,
          ));
      return ResponseWrapper.success(result);
    } on DioException catch (e) {
      return ResponseWrapper.failure(e);
    }
  }
}
