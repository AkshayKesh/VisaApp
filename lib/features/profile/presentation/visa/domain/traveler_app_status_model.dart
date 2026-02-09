

class TravelerAppStatusModel {
  TravelerAppStatusModel({
    required this.id,
    required this.applicationId,
    required this.travellerId,
    required this.title,
    required this.description,
    required this.documentUrl,
    required this.statusId,
    required this.createdAt,
    required this.updatedAt,
    required this.statusDetails,
  });

  final String? id;
  final String? applicationId;
  final String? travellerId;
  final String? title;
  final String? description;
  final String? documentUrl;
  final String? statusId;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final StatusDetails? statusDetails;

  TravelerAppStatusModel copyWith({
    String? id,
    String? applicationId,
    String? travellerId,
    String? title,
    String? description,
    String? documentUrl,
    String? statusId,
    DateTime? createdAt,
    DateTime? updatedAt,
    StatusDetails? statusDetails,
  }) {
    return TravelerAppStatusModel(
      id: id ?? this.id,
      applicationId: applicationId ?? this.applicationId,
      travellerId: travellerId ?? this.travellerId,
      title: title ?? this.title,
      description: description ?? this.description,
      documentUrl: documentUrl ?? this.documentUrl,
      statusId: statusId ?? this.statusId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      statusDetails: statusDetails ?? this.statusDetails,
    );
  }

  factory TravelerAppStatusModel.fromJson(Map<String, dynamic> json) {
    return TravelerAppStatusModel(
      id: json["_id"],
      applicationId: json["applicationId"],
      travellerId: json["travellerId"],
      title: json["title"],
      description: json["description"],
      documentUrl: json["documentUrl"],
      statusId: json["statusId"],
      createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
      updatedAt: DateTime.tryParse(json["updatedAt"] ?? ""),
      statusDetails: json["statusDetails"] == null
          ? null
          : StatusDetails.fromJson(json["statusDetails"]),
    );
  }

  Map<String, dynamic> toJson() => {
    "_id": id,
    "applicationId": applicationId,
    "travellerId": travellerId,
    "title": title,
    "description": description,
    "documentUrl": documentUrl,
    "statusId": statusId,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
    "statusDetails": statusDetails?.toJson(),
  };

  @override
  String toString() {
    return "$id, $applicationId, $travellerId, $title, $description, $documentUrl, $statusId, $createdAt, $updatedAt, $statusDetails, ";
  }
}

class StatusDetails {
  StatusDetails({required this.statusName});

  final String? statusName;

  StatusDetails copyWith({String? statusName}) {
    return StatusDetails(statusName: statusName ?? this.statusName);
  }

  factory StatusDetails.fromJson(Map<String, dynamic> json) {
    return StatusDetails(statusName: json["statusName"]);
  }

  Map<String, dynamic> toJson() => {"statusName": statusName};

  @override
  String toString() {
    return "$statusName, ";
  }
}
