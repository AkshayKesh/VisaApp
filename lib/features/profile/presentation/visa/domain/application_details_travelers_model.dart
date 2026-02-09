class ApplicationDetailsTravelers {
  ApplicationDetailsTravelers({
    required this.id,
    required this.userId,
    required this.selectedVisaOption,
    required this.packageId,
    required this.noOfTraveller,
    required this.travellerId,
    required this.visaFee,
    required this.status,
    required this.submittedDate,
    required this.createdAt,
    required this.updatedAt,
    required this.applicationId,
    required this.cardId,
    required this.paidProcessingFee,
    required this.paymentId,
    required this.selectedProcessFee,
    required this.packageDetails,
    required this.travellerDetails,
  });

  final String? id;
  final String? userId;
  final SelectedVisaOption? selectedVisaOption;
  final String? packageId;
  final int? noOfTraveller;
  final List<String> travellerId;
  final int? visaFee;
  final String? status;
  final DateTime? submittedDate;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? applicationId;
  final String? cardId;
  final int? paidProcessingFee;
  final String? paymentId;
  final SelectedProcessFee? selectedProcessFee;
  final PackageDetails? packageDetails;
  final List<TravellerDetail> travellerDetails;

  ApplicationDetailsTravelers copyWith({
    String? id,
    String? userId,
    SelectedVisaOption? selectedVisaOption,
    String? packageId,
    int? noOfTraveller,
    List<String>? travellerId,
    int? visaFee,
    String? status,
    DateTime? submittedDate,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? applicationId,
    String? cardId,
    int? paidProcessingFee,
    String? paymentId,
    SelectedProcessFee? selectedProcessFee,
    PackageDetails? packageDetails,
    List<TravellerDetail>? travellerDetails,
  }) {
    return ApplicationDetailsTravelers(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      selectedVisaOption: selectedVisaOption ?? this.selectedVisaOption,
      packageId: packageId ?? this.packageId,
      noOfTraveller: noOfTraveller ?? this.noOfTraveller,
      travellerId: travellerId ?? this.travellerId,
      visaFee: visaFee ?? this.visaFee,
      status: status ?? this.status,
      submittedDate: submittedDate ?? this.submittedDate,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      applicationId: applicationId ?? this.applicationId,
      cardId: cardId ?? this.cardId,
      paidProcessingFee: paidProcessingFee ?? this.paidProcessingFee,
      paymentId: paymentId ?? this.paymentId,
      selectedProcessFee: selectedProcessFee ?? this.selectedProcessFee,
      packageDetails: packageDetails ?? this.packageDetails,
      travellerDetails: travellerDetails ?? this.travellerDetails,
    );
  }

  factory ApplicationDetailsTravelers.fromJson(Map<String, dynamic> json) {
    return ApplicationDetailsTravelers(
      id: json["_id"],
      userId: json["userId"],
      selectedVisaOption: json["selectedVisaOption"] == null ? null : SelectedVisaOption.fromJson(json["selectedVisaOption"]),
      packageId: json["packageId"],
      noOfTraveller: json["noOfTraveller"],
      travellerId: json["travellerId"] == null ? [] : List<String>.from(json["travellerId"]!.map((x) => x)),
      visaFee: json["visaFee"],
      status: json["status"],
      submittedDate: DateTime.tryParse(json["submittedDate"] ?? ""),
      createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
      updatedAt: DateTime.tryParse(json["updatedAt"] ?? ""),
      applicationId: json["applicationId"],
      cardId: json["cardId"],
      paidProcessingFee: json["paidProcessingFee"],
      paymentId: json["paymentId"],
      selectedProcessFee: json["selectedProcessFee"] == null ? null : SelectedProcessFee.fromJson(json["selectedProcessFee"]),
      packageDetails: json["packageDetails"] == null ? null : PackageDetails.fromJson(json["packageDetails"]),
      travellerDetails: json["travellerDetails"] == null
          ? []
          : List<TravellerDetail>.from(json["travellerDetails"]!.map((x) => TravellerDetail.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() => {
    "_id": id,
    "userId": userId,
    "selectedVisaOption": selectedVisaOption?.toJson(),
    "packageId": packageId,
    "noOfTraveller": noOfTraveller,
    "travellerId": travellerId.map((x) => x).toList(),
    "visaFee": visaFee,
    "status": status,
    "submittedDate": submittedDate?.toIso8601String(),
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
    "applicationId": applicationId,
    "cardId": cardId,
    "paidProcessingFee": paidProcessingFee,
    "paymentId": paymentId,
    "selectedProcessFee": selectedProcessFee?.toJson(),
    "packageDetails": packageDetails?.toJson(),
    "travellerDetails": travellerDetails.map((x) => x.toJson()).toList(),
  };

  @override
  String toString() {
    return "$id, $userId, $selectedVisaOption, $packageId, $noOfTraveller, $travellerId, $visaFee, $status, $submittedDate, $createdAt, $updatedAt, $applicationId, $cardId, $paidProcessingFee, $paymentId, $selectedProcessFee, $packageDetails, $travellerDetails, ";
  }
}

class PackageDetails {
  PackageDetails({required this.id, required this.country, required this.coverPhoto, required this.title, required this.subtitle});

  final String? id;
  final String? country;
  final String? coverPhoto;
  final String? title;
  final String? subtitle;

  PackageDetails copyWith({String? id, String? country, String? coverPhoto, String? title, String? subtitle}) {
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

  Map<String, dynamic> toJson() => {"_id": id, "country": country, "coverPhoto": coverPhoto, "title": title, "subtitle": subtitle};

  @override
  String toString() {
    return "$id, $country, $coverPhoto, $title, $subtitle, ";
  }
}

class SelectedProcessFee {
  SelectedProcessFee({required this.id, required this.title, required this.subtitle, required this.price, required this.tags});

  final String? id;
  final String? title;
  final String? subtitle;
  final int? price;
  final String? tags;

  SelectedProcessFee copyWith({String? id, String? title, String? subtitle, int? price, String? tags}) {
    return SelectedProcessFee(
      id: id ?? this.id,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      price: price ?? this.price,
      tags: tags ?? this.tags,
    );
  }

  factory SelectedProcessFee.fromJson(Map<String, dynamic> json) {
    return SelectedProcessFee(id: json["id"], title: json["title"], subtitle: json["subtitle"], price: json["price"], tags: json["tags"]);
  }

  Map<String, dynamic> toJson() => {"id": id, "title": title, "subtitle": subtitle, "price": price, "tags": tags};

  @override
  String toString() {
    return "$id, $title, $subtitle, $price, $tags, ";
  }
}

class SelectedVisaOption {
  SelectedVisaOption({
    required this.visaType,
    required this.lengthOfStay,
    required this.visaValidity,
    required this.visaFee,
    required this.entryType,
  });

  final String? visaType;
  final int? lengthOfStay;
  final int? visaValidity;
  final int? visaFee;
  final String? entryType;

  SelectedVisaOption copyWith({String? visaType, int? lengthOfStay, int? visaValidity, int? visaFee, String? entryType}) {
    return SelectedVisaOption(
      visaType: visaType ?? this.visaType,
      lengthOfStay: lengthOfStay ?? this.lengthOfStay,
      visaValidity: visaValidity ?? this.visaValidity,
      visaFee: visaFee ?? this.visaFee,
      entryType: entryType ?? this.entryType,
    );
  }

  factory SelectedVisaOption.fromJson(Map<String, dynamic> json) {
    return SelectedVisaOption(
      visaType: json["visaType"],
      lengthOfStay: json["lengthOfStay"],
      visaValidity: json["visaValidity"],
      visaFee: json["visaFee"],
      entryType: json["entryType"],
    );
  }

  Map<String, dynamic> toJson() => {
    "visaType": visaType,
    "lengthOfStay": lengthOfStay,
    "visaValidity": visaValidity,
    "visaFee": visaFee,
    "entryType": entryType,
  };

  @override
  String toString() {
    return "$visaType, $lengthOfStay, $visaValidity, $visaFee, $entryType, ";
  }
}

class TravellerDetail {
  TravellerDetail({
    required this.id,
    required this.fullName,
    this.firstName,
    this.lastName,
    this.passportNumbe,
    this.issueCountry,
    this.expiryDay,
    this.expiryMonth,
    this.expiryYear,
  });

  final String? id;
  final String? fullName;
  final String? firstName;
  final String? lastName;
  final String? passportNumbe;
  final String? issueCountry;
  final String? expiryDay;
  final String? expiryMonth;
  final String? expiryYear;

  TravellerDetail copyWith({
    String? id,
    String? fullName,
    String? firstName,
    String? lastName,
    String? passportNumbe,
    String? issueCountry,
    String? expiryDay,
    String? expiryMonth,
    String? expiryYear,
  }) {
    return TravellerDetail(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      passportNumbe: passportNumbe ?? this.passportNumbe,
      issueCountry: issueCountry ?? this.issueCountry,
      expiryDay: expiryDay ?? this.expiryDay,
      expiryMonth: expiryMonth ?? this.expiryMonth,
      expiryYear: expiryYear ?? this.expiryYear,
    );
  }

  factory TravellerDetail.fromJson(Map<String, dynamic> json) {
    final firstName = json["firstName"]?.toString().trim() ?? '';
    final lastName = json["lastName"]?.toString().trim() ?? '';
    final fullName = json["fullName"]?.toString().trim() ?? "$firstName $lastName".trim();
    return TravellerDetail(
      id: json["_id"],
      fullName: fullName.isEmpty ? null : fullName,
      firstName: firstName.isEmpty ? null : firstName,
      lastName: lastName.isEmpty ? null : lastName,
      passportNumbe: json['passportNumber']?.toString(),
      issueCountry: json['issuingCountry']?.toString(),
      expiryDay: json['expiryDay']?.toString(),
      expiryMonth: json['expiryMonth']?.toString(),
      expiryYear: json['expiryYear']?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
        "_id": id,
        "fullName": fullName,
        "firstName": firstName,
        "lastName": lastName,
        "passportNumber": passportNumbe,
        "issuingCountry": issueCountry,
        "expiryDay": expiryDay,
        "expiryMonth": expiryMonth,
        "expiryYear": expiryYear,
      };

  @override
  String toString() {
    return "$id, $fullName, ";
  }
}
