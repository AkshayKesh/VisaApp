import 'package:register_visa_web_app/features/profile/presentation/visa/domain/application_details_travelers_model.dart';

class ApplicationDetailsTravelersStatus {
  ApplicationDetailsTravelersStatus({
     this.isLoading=false,
     this.sucess=false,
     this.error,
     this.statuCode,
     this.data,
  });

  final bool isLoading;
  final bool sucess;
  final String? error;
  final int? statuCode;
  final ApplicationDetailsTravelers? data;

  ApplicationDetailsTravelersStatus copyWith({
    bool? isLoading,
    bool? sucess,
    String? error,
    int? statuCode,
    ApplicationDetailsTravelers? data,
  }) {
    return ApplicationDetailsTravelersStatus(
      isLoading: isLoading ?? this.isLoading,
      sucess: sucess ?? this.sucess,
      error: error ?? this.error,
      statuCode: statuCode ?? this.statuCode,
      data: data ?? this.data,
    );
  }

  factory ApplicationDetailsTravelersStatus.fromJson(
    Map<String, dynamic> json,
  ) {
    return ApplicationDetailsTravelersStatus(
      isLoading: json["isLoading"],
      sucess: json["sucess"],
      error: json["error"],
      statuCode: json["statuCode"],
      data: json["data"] == null
          ? null
          : ApplicationDetailsTravelers.fromJson(json["data"]),
    );
  }

  Map<String, dynamic> toJson() => {
    "isLoading": isLoading,
    "sucess": sucess,
    "error": error,
    "statuCode": statuCode,
    "data": data?.toJson(),
  };

  @override
  String toString() {
    return "$isLoading, $sucess, $statuCode, $data, ";
  }
}
