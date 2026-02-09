import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:register_visa_web_app/features/evisa_application/domain/step_config.dart';
import 'package:register_visa_web_app/features/evisa_application/providers/evisa_application_state.dart';

class EvisaApplicationController extends Notifier<EvisaApplicationState> {
  static const List<StepSection> _baseSections = [
    StepSection(sectionIndex: 0, title: 'Trip details', subSteps: ["Let's finish your application", 'General details', 'Trip details']),
    StepSection(
      sectionIndex: 1,
      title: '',
      subSteps: ['Personal details', 'Home address details', 'Employment details', 'Family details', 'Trip details'],
    ),
    StepSection(sectionIndex: 2, title: 'Upload Documents', subSteps: []),
  ];

  List<StepSection> get sections {
    final name = state.applicantName.isNotEmpty ? state.applicantName : 'Applicant';
    final uploadNames = state.uploadApplicantNames;
    final uploadSubSteps = [StepSection.uploadIntroStepTitle, ...uploadNames.expand((_) => StepSection.uploadStepTitles)];
    return [
      _baseSections[0],
      StepSection(sectionIndex: 1, title: name, subSteps: _baseSections[1].subSteps),
      StepSection(sectionIndex: 2, title: _baseSections[2].title, subSteps: uploadSubSteps, applicantNames: uploadNames),
    ];
  }

  @override
  EvisaApplicationState build() => EvisaApplicationState();

  void setApplicantName(String name) {
    state = state.copyWith(applicantName: name);
  }

  void setPackageCountry(String? country) {
    state = state.copyWith(packageCountry: country);
  }

  void setTripDetails({
    String? phoneNumber,
    String? updatesOn,
    String? religion,
    String? arrivalDate,
    String? arrivalPoint,
    List<String>? countryBefore,
  }) {
    state = state.copyWith(
      phoneNumber: phoneNumber ?? state.phoneNumber,
      updatesOn: updatesOn ?? state.updatesOn,
      religion: religion ?? state.religion,
      arrivalDate: arrivalDate ?? state.arrivalDate,
      arrivalPoint: arrivalPoint ?? state.arrivalPoint,
      countryBefore: countryBefore ?? state.countryBefore,
    );
  }

  void setPersonDetails(PersonDetails details) {
    final current = state.personDetails;
    state = state.copyWith(
      personDetails: (current ?? const PersonDetails()).copyWith(
        parentsFromPakistan: details.parentsFromPakistan ?? current?.parentsFromPakistan,
        gender: details.gender ?? current?.gender,
        countryBirth: details.countryBirth ?? current?.countryBirth,
        anotherNationality: details.anotherNationality ?? current?.anotherNationality,
        maritalStatus: details.maritalStatus ?? current?.maritalStatus,
        residenceCountry: details.residenceCountry ?? current?.residenceCountry,
        homeAddress: details.homeAddress ?? current?.homeAddress,
        homeCity: details.homeCity ?? current?.homeCity,
        homeState: details.homeState ?? current?.homeState,
        homeZip: details.homeZip ?? current?.homeZip,
        employmentStatus: details.employmentStatus ?? current?.employmentStatus,
        employeeName: details.employeeName ?? current?.employeeName,
        employeeAddress: details.employeeAddress ?? current?.employeeAddress,
        universityName: details.universityName ?? current?.universityName,
        universityAddress: details.universityAddress ?? current?.universityAddress,
        city: details.city ?? current?.city,
        state: details.state ?? current?.state,
        zipCode: details.zipCode ?? current?.zipCode,
        policeOrMilitary: details.policeOrMilitary ?? current?.policeOrMilitary,
        fatherFullName: details.fatherFullName ?? current?.fatherFullName,
        fatherNationality: details.fatherNationality ?? current?.fatherNationality,
        fatherCountryBirth: details.fatherCountryBirth ?? current?.fatherCountryBirth,
        motherFullName: details.motherFullName ?? current?.motherFullName,
        motherNationality: details.motherNationality ?? current?.motherNationality,
        motherCountryBirth: details.motherCountryBirth ?? current?.motherCountryBirth,
        lastSixDayVisitOtherCountry: details.lastSixDayVisitOtherCountry ?? current?.lastSixDayVisitOtherCountry,
        parentsDetailsOption: details.parentsDetailsOption ?? current?.parentsDetailsOption,
      ),
    );
  }

  void setUploadApplicantNames(List<String> names) {
    final photoList = List<String?>.from(state.applicantPhotoUrlByIndex);
    while (photoList.length < names.length) photoList.add(null);
    final bioList = List<PassportBioData?>.from(state.passportBioByIndex);
    while (bioList.length < names.length) bioList.add(null);
    state = state.copyWith(
      uploadApplicantNames: names,
      applicantPhotoUrlByIndex: photoList.length > names.length ? photoList.sublist(0, names.length) : photoList,
      passportBioByIndex: bioList.length > names.length ? bioList.sublist(0, names.length) : bioList,
    );
  }

  void setApplicantPhotoUrl(int index, String? url) {
    final list = List<String?>.from(state.applicantPhotoUrlByIndex);
    while (list.length <= index) list.add(null);
    list[index] = url;
    state = state.copyWith(applicantPhotoUrlByIndex: list);
  }

  void setPassportBio(int index, PassportBioData data) {
    final list = List<PassportBioData?>.from(state.passportBioByIndex);
    while (list.length <= index) list.add(null);
    list[index] = data;
    state = state.copyWith(passportBioByIndex: list);
  }

  void setStep(int sectionIndex, int subStepIndex) {
    state = state.copyWith(sectionIndex: sectionIndex, subStepIndex: subStepIndex);
  }

  void nextStep() {
    final section = sections[state.sectionIndex];
    if (state.subStepIndex < section.subSteps.length - 1) {
      state = state.copyWith(subStepIndex: state.subStepIndex + 1);
    } else if (state.sectionIndex < sections.length - 1) {
      state = state.copyWith(sectionIndex: state.sectionIndex + 1, subStepIndex: 0);
    }
  }

  void previousStep() {
    if (state.subStepIndex > 0) {
      state = state.copyWith(subStepIndex: state.subStepIndex - 1);
    } else if (state.sectionIndex > 0) {
      final prevSection = sections[state.sectionIndex - 1];
      state = state.copyWith(sectionIndex: state.sectionIndex - 1, subStepIndex: prevSection.subSteps.length - 1);
    }
  }

  bool get canGoBack => state.sectionIndex > 0 || state.subStepIndex > 0;
  bool get canGoNext {
    final section = sections[state.sectionIndex];
    final isLastSub = state.subStepIndex >= section.subSteps.length - 1;
    final isLastSection = state.sectionIndex >= sections.length - 1;
    return !(isLastSub && isLastSection);
  }

  bool get isLastStep {
    if (state.sectionIndex != sections.length - 1) return false;
    final section = sections[state.sectionIndex];
    return state.subStepIndex >= section.subSteps.length - 1;
  }

  void reset() {
    state = EvisaApplicationState();
  }
}
