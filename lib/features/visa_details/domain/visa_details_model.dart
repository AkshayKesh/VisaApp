// Model for VisaDetails

class VisaDetailsModel {
  final String id;
  final String country;
  final String coverPhoto;
  final String title;
  final String subtitle;
  final String visaType;
  final int lengthOfStay;
  final int visaValidity;
  final List<AvailableDate> availableDates;
  final List<IncludedPlace> includedPlaces;
  final List<String> visaRequirements;
  final List<VisaProcessStep> visaProcessFlow;
  final List<String> commonVisaRejectionReasons;
  final List<Faq> faqs;
  final int pricePerPerson;
  final int visaFeePerPerson;
  final int processingFeePerPerson;
  final String status;
  final String? deletedAt;
  final String createdAt;
  final String updatedAt;
  final List<Rating> ratings;
  final List<VisaOption> availableVisaOptions;
  final List<ProcessFee> processingFee;
  int personCount;

  VisaDetailsModel({
    required this.id,
    required this.country,
    required this.coverPhoto,
    required this.title,
    required this.subtitle,
    required this.visaType,
    required this.lengthOfStay,
    required this.visaValidity,
    required this.availableDates,
    required this.includedPlaces,
    required this.visaRequirements,
    required this.visaProcessFlow,
    required this.commonVisaRejectionReasons,
    required this.faqs,
    required this.pricePerPerson,
    required this.visaFeePerPerson,
    required this.processingFeePerPerson,
    required this.status,
    required this.deletedAt,
    required this.createdAt,
    required this.updatedAt,
    required this.ratings,
    required this.availableVisaOptions,
    required this.processingFee,
    this.personCount = 1,
  });

  VisaDetailsModel copyWith({
    String? id,
    String? country,
    String? coverPhoto,
    String? title,
    String? subtitle,
    String? visaType,
    int? lengthOfStay,
    int? visaValidity,
    List<AvailableDate>? availableDates,
    List<IncludedPlace>? includedPlaces,
    List<String>? visaRequirements,
    List<VisaProcessStep>? visaProcessFlow,
    List<String>? commonVisaRejectionReasons,
    List<VisaOption>? availableVisaOptions,
    List<ProcessFee>? processingFee,
    List<Faq>? faqs,
    int? pricePerPerson,
    int? visaFeePerPerson,
    int? processingFeePerPerson,
    String? status,
    String? deletedAt,
    String? createdAt,
    String? updatedAt,
    List<Rating>? ratings,
    int? persenoCount,
  }) {
    return VisaDetailsModel(
      id: id ?? this.id,
      country: country ?? this.country,
      coverPhoto: coverPhoto ?? this.coverPhoto,
      processingFee: processingFee ?? this.processingFee,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      visaType: visaType ?? this.visaType,
      lengthOfStay: lengthOfStay ?? this.lengthOfStay,
      visaValidity: visaValidity ?? this.visaValidity,
      availableDates: availableDates ?? this.availableDates,
      includedPlaces: includedPlaces ?? this.includedPlaces,
      visaRequirements: visaRequirements ?? this.visaRequirements,
      visaProcessFlow: visaProcessFlow ?? this.visaProcessFlow,
      commonVisaRejectionReasons:
          commonVisaRejectionReasons ?? this.commonVisaRejectionReasons,
      faqs: faqs ?? this.faqs,
      pricePerPerson: pricePerPerson ?? this.pricePerPerson,
      visaFeePerPerson: visaFeePerPerson ?? this.visaFeePerPerson,
      processingFeePerPerson:
          processingFeePerPerson ?? this.processingFeePerPerson,
      status: status ?? this.status,
      deletedAt: deletedAt ?? this.deletedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      ratings: ratings ?? this.ratings,
      personCount: persenoCount ?? personCount,
      availableVisaOptions: availableVisaOptions ?? this.availableVisaOptions,
    );
  }

  factory VisaDetailsModel.fromJson(Map<String, dynamic> json) {
    return VisaDetailsModel(
      id: json['_id'] ?? '',
      country: json['country'] ?? '',
      coverPhoto: json['coverPhoto'] ?? '',
      title: json['title'] ?? '',
      subtitle: json['subtitle'] ?? '',
      visaType: json['visaType'] ?? '',
      lengthOfStay: json['lengthOfStay'] is int
          ? json['lengthOfStay']
          : int.tryParse(json['lengthOfStay'].toString()) ?? 0,
      visaValidity: json['visaValidity'] is int
          ? json['visaValidity']
          : int.tryParse(json['visaValidity'].toString()) ?? 0,
      availableDates:
          (json['availableDates'] as List<dynamic>?)
              ?.map((e) => AvailableDate.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      availableVisaOptions:
          (json['availableVisaOptions'] as List<dynamic>?)
              ?.map((e) => VisaOption.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      processingFee:
          (json['processFees'] as List<dynamic>?)
              ?.map((e) => ProcessFee.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      includedPlaces:
          (json['includedPlaces'] as List<dynamic>?)
              ?.map((e) => IncludedPlace.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      visaRequirements:
          (json['visaRequirements'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      visaProcessFlow:
          (json['visaProcessFlow'] as List<dynamic>?)
              ?.map((e) => VisaProcessStep.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      commonVisaRejectionReasons:
          (json['commonVisaRejectionReasons'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      faqs:
          (json['faqs'] as List<dynamic>?)
              ?.map((e) => Faq.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      pricePerPerson: json['pricePerPerson'] is int
          ? json['pricePerPerson']
          : int.tryParse(json['pricePerPerson'].toString()) ?? 0,
      visaFeePerPerson: json['visaFeePerPerson'] is int
          ? json['visaFeePerPerson']
          : int.tryParse(json['visaFeePerPerson'].toString()) ?? 0,
      processingFeePerPerson: json['processingFeePerPerson'] is int
          ? json['processingFeePerPerson']
          : int.tryParse(json['processingFeePerPerson'].toString()) ?? 0,
      status: json['status'] ?? '',
      deletedAt: json['deletedAt'],
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
      ratings:
          (json['ratings'] as List<dynamic>?)
              ?.map((e) => Rating.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'country': country,
      'coverPhoto': coverPhoto,
      'title': title,
      'subtitle': subtitle,
      'visaType': visaType,
      'lengthOfStay': lengthOfStay,
      'visaValidity': visaValidity,
      'availableDates': availableDates.map((e) => e.toJson()).toList(),
      'includedPlaces': includedPlaces.map((e) => e.toJson()).toList(),
      'visaRequirements': visaRequirements,
      'visaProcessFlow': visaProcessFlow.map((e) => e.toJson()).toList(),
      'availableVisaOptions': availableVisaOptions
          .map((e) => e.toJson())
          .toList(),
      "processFees": processingFee.map((e) => e.toJson()).toList(),
      'commonVisaRejectionReasons': commonVisaRejectionReasons,
      'faqs': faqs.map((e) => e.toJson()).toList(),
      'pricePerPerson': pricePerPerson,
      'visaFeePerPerson': visaFeePerPerson,
      'processingFeePerPerson': processingFeePerPerson,
      'status': status,
      'deletedAt': deletedAt,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'ratings': ratings.map((e) => e.toJson()).toList(),
    };
  }
}

class AvailableDate {
  final String fromDate;
  final String toDate;
  bool isSelected;

  AvailableDate({
    required this.fromDate,
    required this.toDate,
    this.isSelected = false,
  });

  AvailableDate copyWith({String? fromDate, String? toDate, bool? isSelected}) {
    return AvailableDate(
      fromDate: fromDate ?? this.fromDate,
      toDate: toDate ?? this.toDate,
      isSelected: isSelected ?? this.isSelected,
    );
  }

  factory AvailableDate.fromJson(Map<String, dynamic> json) {
    return AvailableDate(
      fromDate: json['fromDate'] ?? '',
      toDate: json['toDate'] ?? '',
      isSelected: json['isSelected'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {'fromDate': fromDate, 'toDate': toDate, 'isSelected': isSelected};
  }
}

class IncludedPlace {
  final String placeName;
  final String placeImage;

  const IncludedPlace({required this.placeName, required this.placeImage});

  IncludedPlace copyWith({String? placeName, String? placeImage}) {
    return IncludedPlace(
      placeName: placeName ?? this.placeName,
      placeImage: placeImage ?? this.placeImage,
    );
  }

  factory IncludedPlace.fromJson(Map<String, dynamic> json) {
    return IncludedPlace(
      placeName: json['placeName'] ?? '',
      placeImage: json['placeImage'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'placeName': placeName, 'placeImage': placeImage};
  }
}

class VisaProcessStep {
  final String stepTitle;
  final String stepDescription;

  const VisaProcessStep({
    required this.stepTitle,
    required this.stepDescription,
  });

  VisaProcessStep copyWith({String? stepTitle, String? stepDescription}) {
    return VisaProcessStep(
      stepTitle: stepTitle ?? this.stepTitle,
      stepDescription: stepDescription ?? this.stepDescription,
    );
  }

  factory VisaProcessStep.fromJson(Map<String, dynamic> json) {
    return VisaProcessStep(
      stepTitle: json['stepTitle'] ?? '',
      stepDescription: json['stepDescription'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'stepTitle': stepTitle, 'stepDescription': stepDescription};
  }
}

class Faq {
  final String question;
  final String answer;

  const Faq({required this.question, required this.answer});

  Faq copyWith({String? question, String? answer}) {
    return Faq(
      question: question ?? this.question,
      answer: answer ?? this.answer,
    );
  }

  factory Faq.fromJson(Map<String, dynamic> json) {
    return Faq(question: json['question'] ?? '', answer: json['answer'] ?? '');
  }

  Map<String, dynamic> toJson() {
    return {'question': question, 'answer': answer};
  }
}

class Rating {
  final User user;
  final String packageId;
  final double rating;
  final String review;
  final String createdAt;

  const Rating({
    required this.user,
    required this.packageId,
    required this.rating,
    required this.review,
    required this.createdAt,
  });

  Rating copyWith({
    User? user,
    String? packageId,
    double? rating,
    String? review,
    String? createdAt,
  }) {
    return Rating(
      user: user ?? this.user,
      packageId: packageId ?? this.packageId,
      rating: rating ?? this.rating,
      review: review ?? this.review,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  factory Rating.fromJson(Map<String, dynamic> json) {
    return Rating(
      user: User.fromJson(json['user'] as Map<String, dynamic>),
      packageId: json['packageId'] ?? '',
      rating: json['rating'] is double
          ? json['rating']
          : (json['rating'] is int
                ? (json['rating'] as int).toDouble()
                : double.tryParse(json['rating'].toString()) ?? 0.0),
      review: json['review'] ?? '',
      createdAt: json['createdAt'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user': user.toJson(),
      'packageId': packageId,
      'rating': rating,
      'review': review,
      'createdAt': createdAt,
    };
  }
}

class User {
  final String fullName;
  final String profilePic;

  const User({required this.fullName, required this.profilePic});

  User copyWith({String? fullName, String? profilePic}) {
    return User(
      fullName: fullName ?? this.fullName,
      profilePic: profilePic ?? this.profilePic,
    );
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      fullName: json['fullName'] ?? '',
      profilePic: json['profilePic'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'fullName': fullName, 'profilePic': profilePic};
  }
}

class VisaOption {
  VisaOption({
    required this.visaType,
    required this.lengthOfStay,
    required this.visaValidity,
    required this.visaFee,
    required this.entryType,
    required this.isActive,
  });

  final String? visaType;
  final int? lengthOfStay;
  final int? visaValidity;
  final int? visaFee;
  final String? entryType;
  final bool? isActive;

  VisaOption copyWith({
    String? visaType,
    int? lengthOfStay,
    int? visaValidity,
    int? visaFee,
    String? entryType,
    bool? isActive,
  }) {
    return VisaOption(
      visaType: visaType ?? this.visaType,
      lengthOfStay: lengthOfStay ?? this.lengthOfStay,
      visaValidity: visaValidity ?? this.visaValidity,
      visaFee: visaFee ?? this.visaFee,
      entryType: entryType ?? this.entryType,
      isActive: isActive ?? this.isActive,
    );
  }

  factory VisaOption.fromJson(Map<String, dynamic> json) {
    return VisaOption(
      visaType: json["visaType"],
      lengthOfStay: json["lengthOfStay"],
      visaValidity: json["visaValidity"],
      visaFee: json["visaFee"],
      entryType: json["entryType"],
      isActive: json["isActive"],
    );
  }

  Map<String, dynamic> toJson() => {
    "visaType": visaType,
    "lengthOfStay": lengthOfStay,
    "visaValidity": visaValidity,
    "visaFee": visaFee,
    "entryType": entryType,
    "isActive": isActive,
  };

  @override
  String toString() {
    return "$visaType, $lengthOfStay, $visaValidity, $visaFee, $entryType, $isActive, ";
  }
}

class ProcessFee {
  ProcessFee({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.price,
    required this.tags,
  });

  final String? id;
  final String? title;
  final String? subtitle;
  final int? price;
  final String? tags;

  ProcessFee copyWith({
    String? id,
    String? title,
    String? subtitle,
    int? price,
    String? tags,
  }) {
    return ProcessFee(
      id: id ?? this.id,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      price: price ?? this.price,
      tags: tags ?? this.tags,
    );
  }

  factory ProcessFee.fromJson(Map<String, dynamic> json) {
    return ProcessFee(
      id: json["id"],
      title: json["title"],
      subtitle: json["subtitle"],
      price: json["price"],
      tags: json["tags"],
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "subtitle": subtitle,
    "price": price,
    "tags": tags,
  };

  @override
  String toString() {
    return "$id, $title, $subtitle, $price, $tags, ";
  }
}
