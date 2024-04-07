// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'base_response_pagination_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BaseResponsePaginationDTO<T> _$BaseResponsePaginationDTOFromJson<T>(
  Map<String, dynamic> json,
  T Function(Object? json) fromJsonT,
) =>
    BaseResponsePaginationDTO<T>(
      data: (json['data'] as List<dynamic>).map(fromJsonT).toList(),
      total: json['total'] as int?,
      limit: json['limit'] as int?,
      page: json['page'] as int?,
    );

Map<String, dynamic> _$BaseResponsePaginationDTOToJson<T>(
  BaseResponsePaginationDTO<T> instance,
  Object? Function(T value) toJsonT,
) =>
    <String, dynamic>{
      'data': instance.data.map(toJsonT).toList(),
      'total': instance.total,
      'limit': instance.limit,
      'page': instance.page,
    };
