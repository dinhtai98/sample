import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:sample/utils/app_log.dart';

class AppErrorException implements Exception {
  static const num noInternetCode = -1;
  static const String noInternetMessage = 'No internet';

  final dynamic errorType;
  final num? code;
  final String? message;
  final dynamic extraData;

  AppErrorException({
    this.code,
    this.message,
    this.extraData,
    this.errorType,
  });

  factory AppErrorException.noInternet() {
    return AppErrorException(
      code: noInternetCode,
      message: noInternetMessage,
    );
  }

  factory AppErrorException.commonError([String? extraInfo]) {
    return AppErrorException(
      code: 1000,
    );
  }

  @override
  String toString() {
    return message ?? '';
  }

  String toObjectMessage() {
    return 'AppErrorException(errorType: $errorType, code: $code, message: $message, extraData: $extraData)';
  }
}

mixin ApiMixin {
  Future<T> protectRunApi<T>({
    required Future<T> Function() action,
    required String errorTag,
    ValueChanged<dynamic>? onError,
    VoidCallback? onFinally,
  }) async {
    try {
      return await action();
    } on DioException catch (e, s) {
      AppLog.e(
        errorTag,
        '[$errorTag] - DioError - ${e.response?.statusMessage} - $s',
        e,
        s,
      );
      onError?.call(e);
      if (e.error is SocketException) {
        throw AppErrorException.noInternet();
      }
      //* No internet message while uploading pre signed url
      if (e.message == 'Software caused connection abort') {
        throw AppErrorException.noInternet();
      }
      final responseData = e.response?.data;
      String? serverErrorMessage = e.message;
      try {
        if (responseData is Map && responseData.containsKey('error')) {
          final errorData = responseData['error'];
          serverErrorMessage = errorData['message'] ?? e.message;
        }
      } catch (_) {}
      throw AppErrorException(
        code: e.response?.statusCode,
        message: serverErrorMessage,
        extraData: e.response?.data,
        errorType: e,
      );
    } on AppErrorException catch (_) {
      rethrow;
    } catch (e, s) {
      AppLog.e(
        errorTag,
        '[$errorTag] - Exception - $e - $s',
        e,
        s,
      );
      onError?.call(e);
      throw AppErrorException(
        code: e.hashCode,
        message: e.toString(),
        errorType: e,
      );
    } finally {
      onFinally?.call();
    }
  }
}

class ArgumentUtils {
  static checkArgument(
    Object? argument, {
    String? argumentName,
  }) {
    String missingArgumentContent = '';
    if (argumentName != null) {
      missingArgumentContent = ' - Missing param $argumentName';
    }
    if (argument == null) {
      throw AppErrorException(
        message:
            'Something went wrong! Please try again$missingArgumentContent',
      );
    }

    if (argument is List && argument.isEmpty) {
      throw AppErrorException(
        message:
            'Something went wrong! Please try again$missingArgumentContent',
      );
    }
    if (argument is String && argument.trim().isEmpty) {
      throw AppErrorException(
        message:
            'Something went wrong! Please try again$missingArgumentContent',
      );
    }
  }

  static checkArguments(List<Object> arguments, {List<String>? argumentsName}) {
    for (var index = 0; index < arguments.length; index++) {
      final argument = arguments[index];
      bool isValidArgumentName = index < (argumentsName?.length ?? -1);
      checkArgument(
        argument,
        argumentName:
            (isValidArgumentName ? argumentsName?.elementAt(index) : null),
      );
    }
  }
}

class ErrorUtils {}
