import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:retrofit/dio.dart';
import 'package:sample/utils/map.dart';

class BaseRepositoryResult<T> {
  T? data;
  String? error;

  final int? total;
  final int? limit;
  final int? page;
  BaseRepositoryResult({
    this.data,
    this.error,
    this.total,
    this.limit,
    this.page,
  });
}

mixin ApiRepositoryResultMixin {
  Future<BaseRepositoryResult<T>> apiRepositoryResult<T>({
    required Future<HttpResponse<T>> Function() api,
  }) async {
    try {
      var result = await api();
      return BaseRepositoryResult(data: result.data);
    } on DioException catch (e) {
      var message =
          (e.response?.data as Map?)?.getMap('error').strOrNull('message');
      debugPrint(e.toString());
      return BaseRepositoryResult(error: message);
    } catch (e) {
      return BaseRepositoryResult(error: e.toString());
    }
  }
}
