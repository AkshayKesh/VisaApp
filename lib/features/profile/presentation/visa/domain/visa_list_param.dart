import 'package:flutter/material.dart';

@immutable
class VisaListParam {
  final String status;
  final int? page;
  final int? limit;


  const VisaListParam({required this.status, this.page = 1, this.limit = 10});

  VisaListParam copyWith({String? status, int? page, int? limit}) {
    return VisaListParam(
      status: status ?? this.status,
      page: page ?? this.page,
      limit: limit ?? this.limit,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VisaListParam &&
          page == other.page &&
          limit == other.limit &&
          status == other.status;

  @override
  int get hashCode => Object.hash(status, page, limit);
}
