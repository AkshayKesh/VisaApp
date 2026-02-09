import 'package:register_visa_web_app/features/profile/presentation/visa/domain/traveler_app_status_model.dart';

class TravelerAppStatus {
  TravelerAppStatus({this.isLoading = false, this.sucess = false, this.error, this.statuCode, this.data});

  final bool isLoading;
  final bool sucess;
  final String? error;
  final int? statuCode;
  final List<TravelerAppStatusModel>? data;

  TravelerAppStatus copyWith({bool? isLoading, bool? sucess, String? error, int? statuCode, List<TravelerAppStatusModel>? data}) {
    return TravelerAppStatus(
      isLoading: isLoading ?? this.isLoading,
      sucess: sucess ?? this.sucess,
      error: error ?? this.error,
      statuCode: statuCode ?? this.statuCode,
      data: data ?? this.data,
    );
  }

  factory TravelerAppStatus.fromJson(Map<String, dynamic> json) {
    return TravelerAppStatus(
      isLoading: json["isLoading"],
      sucess: json["sucess"],
      error: json["error"],
      statuCode: json["statuCode"],
      data: json["data"] == null ? null : (json["data"] as List).map((e) => TravelerAppStatusModel.fromJson(e)).toList(),
    );
  }

  Map<String, dynamic> toJson() => {
    "isLoading": isLoading,
    "sucess": sucess,
    "error": error,
    "statuCode": statuCode,
    "data": data?.map((e) => e.toJson()).toList(),
  };

  @override
  String toString() {
    return "$isLoading, $sucess, $statuCode, $data, ";
  }
}
