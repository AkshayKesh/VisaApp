import 'package:flutter/material.dart';

@immutable
class TravelerIdParam {
  final String applicationId;
  final String travellerId;

  const TravelerIdParam({
    required this.applicationId,
    required this.travellerId,
  });
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TravelerIdParam &&
          applicationId == other.applicationId &&
          travellerId == other.travellerId;

  @override
  int get hashCode => Object.hash(applicationId, travellerId);
}
