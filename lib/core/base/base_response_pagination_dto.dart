import 'package:json_annotation/json_annotation.dart';

part 'base_response_pagination_dto.g.dart';

@JsonSerializable(explicitToJson: true, genericArgumentFactories: true)
class BaseResponsePaginationDTO<T> {
  final List<T> data;
  int? total;
  int? limit;
  int? page;

  BaseResponsePaginationDTO({
    required this.data,
    this.total,
    this.limit,
    this.page,
  });
  factory BaseResponsePaginationDTO.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT,
  ) =>
      _$BaseResponsePaginationDTOFromJson(json, fromJsonT);

  Map<String, dynamic> toJson(Object Function(T value) toJsonT) =>
      _$BaseResponsePaginationDTOToJson(this, toJsonT);
}
