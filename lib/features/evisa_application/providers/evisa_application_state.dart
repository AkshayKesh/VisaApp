class PassportBioData {
  final String? firstName;
  final String? lastName;
  final String? issueCountry;
  final String? number;
  final String? expiryDate;
  final String? expiryDay;
  final String? expiryMonth;
  final String? expiryYear;
  final String? frontImageUrl;
  final String? backImageUrl;

  const PassportBioData({
    this.firstName,
    this.lastName,
    this.issueCountry,
    this.number,
    this.expiryDate,
    this.expiryDay,
    this.expiryMonth,
    this.expiryYear,
    this.frontImageUrl,
    this.backImageUrl,
  });

  Map<String, dynamic> toJson() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'issueCountry': issueCountry,
      'number': number,
      'expiryDate': expiryDate,
      'expiryDay': expiryDay,
      'expiryMonth': expiryMonth,
      'expiryYear': expiryYear,
      'frontImageUrl': frontImageUrl,
      'backImageUrl': backImageUrl,
    };
  }

  PassportBioData copyWith({
    String? firstName,
    String? lastName,
    String? issueCountry,
    String? number,
    String? expiryDate,
    String? expiryDay,
    String? expiryMonth,
    String? expiryYear,
    String? frontImageUrl,
    String? backImageUrl,
  }) {
    return PassportBioData(
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      issueCountry: issueCountry ?? this.issueCountry,
      number: number ?? this.number,
      expiryDate: expiryDate ?? this.expiryDate,
      expiryDay: expiryDay ?? this.expiryDay,
      expiryMonth: expiryMonth ?? this.expiryMonth,
      expiryYear: expiryYear ?? this.expiryYear,
      frontImageUrl: frontImageUrl ?? this.frontImageUrl,
      backImageUrl: backImageUrl ?? this.backImageUrl,
    );
  }
}

class PersonDetails {
  final bool? parentsFromPakistan;
  final String? gender;
  final String? countryBirth;
  final bool? anotherNationality;
  final String? maritalStatus;
  final String? residenceCountry;
  final String? homeAddress;
  final String? homeCity;
  final String? homeState;
  final String? homeZip;
  final String? employmentStatus;
  final String? employeeName;
  final String? employeeAddress;
  final String? universityName;
  final String? universityAddress;
  final String? city;
  final String? state;
  final String? zipCode;
  final bool? policeOrMilitary;
  final String? fatherFullName;
  final String? fatherNationality;
  final String? fatherCountryBirth;
  final String? motherFullName;
  final String? motherNationality;
  final String? motherCountryBirth;
  final bool? lastSixDayVisitOtherCountry;
  final String? parentsDetailsOption;

  const PersonDetails({
    this.parentsFromPakistan,
    this.gender,
    this.countryBirth,
    this.anotherNationality,
    this.maritalStatus,
    this.residenceCountry,
    this.homeAddress,
    this.homeCity,
    this.homeState,
    this.homeZip,
    this.employmentStatus,
    this.employeeName,
    this.employeeAddress,
    this.universityName,
    this.universityAddress,
    this.city,
    this.state,
    this.zipCode,
    this.policeOrMilitary,
    this.fatherFullName,
    this.fatherNationality,
    this.fatherCountryBirth,
    this.motherFullName,
    this.motherNationality,
    this.motherCountryBirth,
    this.lastSixDayVisitOtherCountry,
    this.parentsDetailsOption,
  });

  PersonDetails copyWith({
    bool? parentsFromPakistan,
    String? gender,
    String? countryBirth,
    bool? anotherNationality,
    String? maritalStatus,
    String? residenceCountry,
    String? homeAddress,
    String? homeCity,
    String? homeState,
    String? homeZip,
    String? employmentStatus,
    String? employeeName,
    String? employeeAddress,
    String? universityName,
    String? universityAddress,
    String? city,
    String? state,
    String? zipCode,
    bool? policeOrMilitary,
    String? fatherFullName,
    String? fatherNationality,
    String? fatherCountryBirth,
    String? motherFullName,
    String? motherNationality,
    String? motherCountryBirth,
    bool? lastSixDayVisitOtherCountry,
    String? parentsDetailsOption,
  }) {
    return PersonDetails(
      parentsFromPakistan: parentsFromPakistan ?? this.parentsFromPakistan,
      gender: gender ?? this.gender,
      countryBirth: countryBirth ?? this.countryBirth,
      anotherNationality: anotherNationality ?? this.anotherNationality,
      maritalStatus: maritalStatus ?? this.maritalStatus,
      residenceCountry: residenceCountry ?? this.residenceCountry,
      homeAddress: homeAddress ?? this.homeAddress,
      homeCity: homeCity ?? this.homeCity,
      homeState: homeState ?? this.homeState,
      homeZip: homeZip ?? this.homeZip,
      employmentStatus: employmentStatus ?? this.employmentStatus,
      employeeName: employeeName ?? this.employeeName,
      employeeAddress: employeeAddress ?? this.employeeAddress,
      universityName: universityName ?? this.universityName,
      universityAddress: universityAddress ?? this.universityAddress,
      city: city ?? this.city,
      state: state ?? this.state,
      zipCode: zipCode ?? this.zipCode,
      policeOrMilitary: policeOrMilitary ?? this.policeOrMilitary,
      fatherFullName: fatherFullName ?? this.fatherFullName,
      fatherNationality: fatherNationality ?? this.fatherNationality,
      fatherCountryBirth: fatherCountryBirth ?? this.fatherCountryBirth,
      motherFullName: motherFullName ?? this.motherFullName,
      motherNationality: motherNationality ?? this.motherNationality,
      motherCountryBirth: motherCountryBirth ?? this.motherCountryBirth,
      lastSixDayVisitOtherCountry: lastSixDayVisitOtherCountry ?? this.lastSixDayVisitOtherCountry,
      parentsDetailsOption: parentsDetailsOption ?? this.parentsDetailsOption,
    );
  }
}

class EvisaApplicationState {
  static const List<String> defaultUploadApplicantNames = ['Daniel Yom', 'Miya kaif', 'Jhon Smith'];

  final int sectionIndex;
  final int subStepIndex;
  final String applicantName;
  final List<String> uploadApplicantNames;
  final List<String?> applicantPhotoUrlByIndex;
  final List<PassportBioData?> passportBioByIndex;
  final String? packageCountry;
  final String? phoneNumber;
  final String? updatesOn;
  final String? religion;
  final String? arrivalDate;
  final String? arrivalPoint;
  final List<String>? countryBefore;
  final PersonDetails? personDetails;

  EvisaApplicationState({
    this.sectionIndex = 0,
    this.subStepIndex = 0,
    this.applicantName = 'Daniel Yom',
    List<String>? uploadApplicantNames,
    List<String?>? applicantPhotoUrlByIndex,
    List<PassportBioData?>? passportBioByIndex,
    this.packageCountry,
    this.phoneNumber,
    this.updatesOn,
    this.religion,
    this.arrivalDate,
    this.arrivalPoint,
    List<String>? countryBefore,
    this.personDetails,
  }) : uploadApplicantNames = uploadApplicantNames ?? defaultUploadApplicantNames,
       applicantPhotoUrlByIndex = applicantPhotoUrlByIndex ?? List.filled(defaultUploadApplicantNames.length, null),
       passportBioByIndex = passportBioByIndex ?? List.filled(defaultUploadApplicantNames.length, null),
       countryBefore = countryBefore ?? [];

  EvisaApplicationState copyWith({
    int? sectionIndex,
    int? subStepIndex,
    String? applicantName,
    List<String>? uploadApplicantNames,
    List<String?>? applicantPhotoUrlByIndex,
    List<PassportBioData?>? passportBioByIndex,
    String? packageCountry,
    String? phoneNumber,
    String? updatesOn,
    String? religion,
    String? arrivalDate,
    String? arrivalPoint,
    List<String>? countryBefore,
    PersonDetails? personDetails,
  }) {
    return EvisaApplicationState(
      sectionIndex: sectionIndex ?? this.sectionIndex,
      subStepIndex: subStepIndex ?? this.subStepIndex,
      applicantName: applicantName ?? this.applicantName,
      uploadApplicantNames: uploadApplicantNames ?? this.uploadApplicantNames,
      applicantPhotoUrlByIndex: applicantPhotoUrlByIndex ?? this.applicantPhotoUrlByIndex,
      passportBioByIndex: passportBioByIndex ?? this.passportBioByIndex,
      packageCountry: packageCountry ?? this.packageCountry,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      updatesOn: updatesOn ?? this.updatesOn,
      religion: religion ?? this.religion,
      arrivalDate: arrivalDate ?? this.arrivalDate,
      arrivalPoint: arrivalPoint ?? this.arrivalPoint,
      countryBefore: countryBefore ?? this.countryBefore,
      personDetails: personDetails ?? this.personDetails,
    );
  }
}
