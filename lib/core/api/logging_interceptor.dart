import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class LoggingInterceptor extends InterceptorsWrapper {
  final String tag = "api:completed";
  JsonEncoder encoder = const JsonEncoder.withIndent('  ');

  LoggingInterceptor();

  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    debugPrint("$tag request:");
    debugPrint("$tag ${options.method} ${options.uri}");
    options.headers[HttpHeaders.contentTypeHeader] = 'application/json';
    // TODO
    options.headers[HttpHeaders.authorizationHeader] = 'Bearer token';

    debugPrint("$tag Header ${options.headers}");
    if (options.queryParameters.isNotEmpty) {
      debugPrint("$tag queries:");
      options.queryParameters.forEach((key, value) {
        debugPrint("$tag \t$key: $value");
      });
    }
    if (options.data != null) {
      debugPrint("$tag body:");
      final data = options.data;
      if (data is! FormData) {
        try {
          debugPrint("$tag ${json.encode(data)}");
        } on Exception catch (ignore) {
          debugPrint("$tag ${data.toString()}");
          debugPrint("$tag ${ignore.toString()}");
        }
      }
    }
    return handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) async {
    debugPrint("$tag response");
    debugPrint("$tag ${response.realUri}");
    debugPrint("$tag status: ${response.statusCode} - ${response.statusMessage}");
    final data = response.data;
    if (data != null) {
      try {
        debugPrint("$tag ${json.encode(data)}");
      } on Exception catch (ignore) {
        debugPrint("$tag ${data.toString()}");
        debugPrint("$tag ${ignore.toString()}");
      }
    }
    return handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    final response = err.response;
    debugPrint("onError ${response?.realUri.toString()}");
    debugPrint("onError ${response?.statusCode}");
    debugPrint("onError ${response?.data}");
    if (response != null) {
      debugPrint("$tag status: ${response.statusCode} - ${response.statusMessage}");
      final data = response.data;
      if (data != null) {
        debugPrint("$tag body:");
        try {
          debugPrint("$tag ${json.encode(data)}");
        } on Exception catch (ignore) {
          debugPrint("$tag ${data.toString()}");
          debugPrint("$tag ${ignore.toString()}");
        }
      }
      debugPrint("$tag exception: ${err.message}");
    }
    if (err.error != null) {
      debugPrint("$tag error: ${err.error}");
    }
    return handler.next(err);
  }
  // Future refreshToken() async {
  //   var token = GetIt.instance.get<AppHive>().getRightNowSDKToken();
  //   bool hasExpired = token.isNullOrEmpty ? false : JwtDecoder.isExpired(token);
  //   if (hasExpired) {
  //     try {
  //       var result = await _refreshRightNow();
  //       var accessToken =
  //           result.bodyMap.getMap('data').strOrNull('accessToken');
  //       if (accessToken.isNullOrEmpty) {
  //         await GetIt.instance.get<RightNowAPIRepository>().logout();
  //         return false;
  //       }
  //       var user = await GetIt.instance.get<AppHive>().getUser();
  //       user!.rightNowAccessToken = accessToken!;
  //       await GetIt.instance.get<AppHive>().saveUser(user);
  //     } catch (e) {
  //       await GetIt.instance.get<RightNowAPIRepository>().logout();
  //     }
  //   }
  // }
}
