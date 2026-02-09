

class ApplicationsModle {
  ApplicationsModle({
    required this.id,
    required this.noOfTraveller,
    required this.status,
    required this.submittedDate,
    required this.applicationId,
    required this.packageDetails,
    required this.travellerDetails,
  });

  final String? id;
  static const String idKey = "_id";

  final int? noOfTraveller;
  static const String noOfTravellerKey = "noOfTraveller";

  final String? status;
  static const String statusKey = "status";

  final DateTime? submittedDate;
  static const String submittedDateKey = "submittedDate";

  final String? applicationId;
  static const String applicationIdKey = "applicationId";

  final PackageDetails? packageDetails;
  static const String packageDetailsKey = "packageDetails";

  final List<TravellerDetail> travellerDetails;
  static const String travellerDetailsKey = "travellerDetails";

  ApplicationsModle copyWith({
    String? id,
    int? noOfTraveller,
    String? status,
    DateTime? submittedDate,
    String? applicationId,
    PackageDetails? packageDetails,
    List<TravellerDetail>? travellerDetails,
  }) {
    return ApplicationsModle(
      id: id ?? this.id,
      noOfTraveller: noOfTraveller ?? this.noOfTraveller,
      status: status ?? this.status,
      submittedDate: submittedDate ?? this.submittedDate,
      applicationId: applicationId ?? this.applicationId,
      packageDetails: packageDetails ?? this.packageDetails,
      travellerDetails: travellerDetails ?? this.travellerDetails,
    );
  }

  factory ApplicationsModle.fromJson(Map<String, dynamic> json) {
    return ApplicationsModle(
      id: json["_id"],
      noOfTraveller: json["noOfTraveller"],
      status: json["status"],
      submittedDate: DateTime.tryParse(json["submittedDate"] ?? ""),
      applicationId: json["applicationId"],
      packageDetails: json["packageDetails"] == null
          ? null
          : PackageDetails.fromJson(json["packageDetails"]),
      travellerDetails: json["travellerDetails"] == null
          ? []
          : List<TravellerDetail>.from(
              json["travellerDetails"]!.map((x) => TravellerDetail.fromJson(x)),
            ),
    );
  }

  Map<String, dynamic> toJson() => {
    "_id": id,
    "noOfTraveller": noOfTraveller,
    "status": status,
    "submittedDate": submittedDate?.toIso8601String(),
    "applicationId": applicationId,
    "packageDetails": packageDetails?.toJson(),
    "travellerDetails": travellerDetails.map((x) => x.toJson()).toList(),
  };
}

class PackageDetails {
  PackageDetails({
    required this.id,
    required this.country,
    required this.coverPhoto,
    required this.title,
    required this.subtitle,
  });

  final String? id;
  static const String idKey = "_id";

  final String? country;
  static const String countryKey = "country";

  final String? coverPhoto;
  static const String coverPhotoKey = "coverPhoto";

  final String? title;
  static const String titleKey = "title";

  final String? subtitle;
  static const String subtitleKey = "subtitle";

  PackageDetails copyWith({
    String? id,
    String? country,
    String? coverPhoto,
    String? title,
    String? subtitle,
  }) {
    return PackageDetails(
      id: id ?? this.id,
      country: country ?? this.country,
      coverPhoto: coverPhoto ?? this.coverPhoto,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
    );
  }

  factory PackageDetails.fromJson(Map<String, dynamic> json) {
    return PackageDetails(
      id: json["_id"],
      country: json["country"],
      coverPhoto: json["coverPhoto"],
      title: json["title"],
      subtitle: json["subtitle"],
    );
  }

  Map<String, dynamic> toJson() => {
    "_id": id,
    "country": country,
    "coverPhoto": coverPhoto,
    "title": title,
    "subtitle": subtitle,
  };
}

class TravellerDetail {
  TravellerDetail({required this.id, required this.fullName});

  final String? id;
  static const String idKey = "_id";

  final String? fullName;
  static const String fullNameKey = "firstName";

  TravellerDetail copyWith({String? id, String? fullName}) {
    return TravellerDetail(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
    );
  }

  factory TravellerDetail.fromJson(Map<String, dynamic> json) {
    return TravellerDetail(id: json["_id"], fullName: json["firstName"]);
  }

  Map<String, dynamic> toJson() => {"_id": id, "firstName": fullName};
}
