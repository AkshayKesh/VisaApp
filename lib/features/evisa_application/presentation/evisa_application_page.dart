import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:register_visa_web_app/core/constants/router/router_names.dart';
import 'package:register_visa_web_app/core/constants/app_color.dart';
import 'package:register_visa_web_app/core/constants/font_family.dart';
import 'package:register_visa_web_app/core/constants/image_url.dart';
import 'package:register_visa_web_app/core/utils/spacing_extension.dart';
import 'package:register_visa_web_app/core/utils/string_logger_extension.dart';
import 'package:register_visa_web_app/core/utils/text_theme_extension.dart';
import 'package:register_visa_web_app/features/evisa_application/controller/evisa_application_controller.dart';
import 'package:register_visa_web_app/features/evisa_application/domain/step_config.dart';
import 'package:register_visa_web_app/features/evisa_application/presentation/steps/step_general_details.dart';
import 'package:register_visa_web_app/features/evisa_application/presentation/steps/step_lets_finish.dart';
import 'package:register_visa_web_app/features/evisa_application/presentation/steps/step_applicant_trip_details.dart';
import 'package:register_visa_web_app/features/evisa_application/presentation/steps/step_upload_applicant_photo.dart';
import 'package:register_visa_web_app/features/evisa_application/presentation/steps/step_passport_bio_page.dart';
import 'package:register_visa_web_app/features/evisa_application/presentation/steps/step_passport_details.dart';
import 'package:register_visa_web_app/features/evisa_application/presentation/steps/step_upload_documents_applicant.dart';
import 'package:register_visa_web_app/features/evisa_application/presentation/steps/step_employment_details.dart';
import 'package:register_visa_web_app/features/evisa_application/presentation/steps/step_family_details.dart';
import 'package:register_visa_web_app/features/evisa_application/presentation/steps/step_home_address_details.dart';
import 'package:register_visa_web_app/features/evisa_application/presentation/steps/step_personal_details.dart';
import 'package:register_visa_web_app/features/evisa_application/presentation/steps/step_trip_details.dart';
import 'package:register_visa_web_app/core/utils/app_toast.dart';
import 'package:register_visa_web_app/features/evisa_application/providers/evisa_application_provider.dart';
import 'package:register_visa_web_app/features/evisa_application/providers/evisa_application_state.dart';
import 'package:register_visa_web_app/shared/widgets/app_button.dart';

class EvisaApplicationPage extends ConsumerWidget {
  const EvisaApplicationPage({super.key, this.applicationId});

  final String? applicationId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(evisaApplicationProvider);
    final controller = ref.read(evisaApplicationProvider.notifier);
    ref.listen(applicationDetailsByIdProvider(applicationId ?? ''), (
      prev,
      next,
    ) {
      next.whenData((data) {
        if (data != null) {
          final currentState = ref.read(evisaApplicationProvider);
          if (currentState.sectionIndex == 0 &&
              data.travellerDetails.isNotEmpty) {
            final names = data.travellerDetails
                .map((t) => t.fullName ?? 'Applicant')
                .toList();
            controller.setUploadApplicantNames(names);
            controller.setApplicantName(names.first);
          } else if (data.travellerDetails.isNotEmpty) {
            controller.setApplicantName(
              data.travellerDetails.first.fullName ?? 'Applicant',
            );
          }
          controller.setPackageCountry(data.packageDetails?.country);
        }
      });
    });
    final section = controller.sections[state.sectionIndex];
    final subStepTitle = section.subSteps[state.subStepIndex];

    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      body: Column(
        children: [
          _buildHeader(context),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildLeftStepPanel(context, ref, state, controller),
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.all(32),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: ConstrainedBox(
                              constraints: BoxConstraints(
                                minWidth: state.sectionIndex == 2 ? 720 : 450,
                                maxWidth: state.sectionIndex == 2 ? 720 : 450,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  if (state.sectionIndex == 1) ...[
                                    Text(
                                      section.title,
                                      style: context.titleLarge?.copyWith(
                                        color: AppColors.darkTextColor,
                                        fontFamily: FontFamily.outfitSemiBold,
                                        fontSize: 24,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Divider(
                                      color: AppColors.lightGrey,
                                      height: 1,
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      subStepTitle,
                                      style: context.titleMedium?.copyWith(
                                        color: AppColors.darkTextColor,
                                        fontFamily: FontFamily.outfitSemiBold,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ] else if (state.sectionIndex == 2) ...[
                                    Text(
                                      state.subStepIndex == 0
                                          ? 'Upload Documents'
                                          : state.uploadApplicantNames[(state
                                                        .subStepIndex -
                                                    1) ~/
                                                3],
                                      style: context.titleLarge?.copyWith(
                                        color: AppColors.darkTextColor,
                                        fontFamily: FontFamily.outfitSemiBold,
                                        fontSize: 24,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Divider(
                                      color: AppColors.lightGrey,
                                      height: 1,
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      subStepTitle,
                                      style: context.titleMedium?.copyWith(
                                        color: AppColors.darkTextColor,
                                        fontFamily: FontFamily.outfitSemiBold,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ] else ...[
                                    Text(
                                      subStepTitle,
                                      style: context.titleLarge?.copyWith(
                                        color: AppColors.darkTextColor,
                                        fontFamily: FontFamily.outfitSemiBold,
                                        fontSize: 24,
                                      ),
                                    ),
                                  ],
                                  24.ht,
                                  _buildStepContent(context, state, controller),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      if (state.sectionIndex == 0 && state.subStepIndex == 0)
                        Expanded(
                          child: Align(
                            alignment: Alignment.center,
                            child: Image.asset(
                              ImageUrl.passportImage,
                              fit: BoxFit.contain,
                              height: 400,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (!(state.sectionIndex == 0 && state.subStepIndex == 0))
            _buildBottomNav(context, ref, state, controller, applicationId),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: const BoxDecoration(
        color: AppColors.lightBackground,
        border: Border(
          bottom: BorderSide(color: AppColors.lightGrey, width: 1),
        ),
      ),
      child: Row(
        children: [
          Image.asset(ImageUrl.checkMarkIcon, height: 24, width: 24),
          const SizedBox(width: 12),
          Text(
            'India Tourist eVisa Application',
            style: context.titleMedium?.copyWith(
              color: AppColors.darkTextColor,
              fontFamily: FontFamily.outfitSemiBold,
            ),
          ),
          // const Spacer(),
          // PrimaryButton(
          //   text: 'Save & exit',
          //   color: AppColors.blackColor,
          //   textColor: AppColors.lightBackground,
          //   onPressed: () {},
          //   height: 44,
          //   width: 130,
          //   borderRadius: 8,
          //   horizontalPadding: 20,
          // ),
        ],
      ),
    );
  }

  Widget _buildLeftStepPanel(
    BuildContext context,
    WidgetRef ref,
    dynamic state,
    EvisaApplicationController controller,
  ) {
    return Container(
      width: 280,
      padding: const EdgeInsets.fromLTRB(24, 24, 0, 24),
      decoration: const BoxDecoration(
        border: Border(right: BorderSide(color: AppColors.lightGrey, width: 1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'India Tourist eVisa Application',
            style: context.bodySmall?.copyWith(
              color: AppColors.lightSubText,
              fontFamily: FontFamily.outfitRegular,
              fontSize: 12,
            ),
          ),
          20.ht,
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: controller.sections.asMap().entries.map((entry) {
                  final idx = entry.key;
                  final sec = entry.value;
                  return _buildSectionItem(
                    context,
                    sectionIndex: idx,
                    section: sec,
                    sectionsLength: controller.sections.length,
                    currentSectionIndex: state.sectionIndex,
                    currentSubStepIndex: state.subStepIndex,

                    onStepTap: controller.setStep,
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionItem(
    BuildContext context, {
    required int sectionIndex,
    required dynamic section,
    required int sectionsLength,
    required int currentSectionIndex,
    required int currentSubStepIndex,
    required void Function(int, int) onStepTap,
  }) {
    final activeColor = AppColors.primaryBlue;
    final inactiveColor = AppColors.greyColor;
    final isActiveSection = currentSectionIndex == sectionIndex;
    final isCompletedSection = currentSectionIndex > sectionIndex;
    bool isActiveSub(int si, int subIdx) =>
        currentSectionIndex == si && currentSubStepIndex == subIdx;

    final hasApplicantGroups =
        section.applicantNames != null && section.applicantNames!.isNotEmpty;
    final rowCount = hasApplicantGroups
        ? (1 + section.applicantNames!.length * 4)
        : section.subSteps.length;

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: (isActiveSection || isCompletedSection)
                      ? activeColor
                      : Colors.transparent,
                  border: Border.all(
                    color: (isActiveSection || isCompletedSection)
                        ? activeColor
                        : inactiveColor,
                    width: 1.5,
                  ),
                ),
                alignment: Alignment.center,
                child: isCompletedSection
                    ? Icon(Icons.check, color: Colors.white, size: 16)
                    : Text(
                        '${sectionIndex + 1}',
                        style: TextStyle(
                          fontSize: 12,
                          fontFamily: FontFamily.outfitSemiBold,
                          color: isActiveSection ? Colors.white : inactiveColor,
                        ),
                      ),
              ),
              if (sectionIndex < sectionsLength - 1)
                Container(
                  width: 2,
                  height: (24.0 + (rowCount * 28.0)).toDouble(),
                  color: (isActiveSection || isCompletedSection)
                      ? activeColor
                      : inactiveColor,
                ),
            ],
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  section.title,
                  style: context.titleSmall?.copyWith(
                    color: isActiveSection
                        ? AppColors.darkTextColor
                        : AppColors.darkTextColor,
                    fontFamily: FontFamily.outfitSemiBold,
                    fontWeight: isActiveSection
                        ? FontWeight.w600
                        : FontWeight.w500,
                  ),
                ),
                if (hasApplicantGroups)
                  ..._buildUploadDocumentsSubItems(
                    context,
                    section,
                    sectionIndex,
                    currentSubStepIndex,
                    activeColor,
                    isActiveSub,
                    onStepTap,
                  )
                else
                  ...section.subSteps.asMap().entries.map((subEntry) {
                    final subIdx = subEntry.key;
                    final subLabel = subEntry.value;
                    final active = isActiveSub(sectionIndex, subIdx);
                    return InkWell(
                      onTap: () => onStepTap(sectionIndex, subIdx),
                      child: Padding(
                        padding: const EdgeInsets.only(top: 6),
                        child: Row(
                          children: [
                            Container(
                              width: 6,
                              height: 6,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: active
                                    ? activeColor
                                    : AppColors.lightSubText,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              subLabel,
                              style: context.bodySmall?.copyWith(
                                color: active
                                    ? AppColors.darkTextColor
                                    : AppColors.lightSubText,
                                fontFamily: active
                                    ? FontFamily.outfitSemiBold
                                    : FontFamily.outfitRegular,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildUploadDocumentsSubItems(
    BuildContext context,
    dynamic section,
    int sectionIndex,
    int currentSubStepIndex,
    Color activeColor,
    bool Function(int, int) isActiveSub,
    void Function(int, int) onStepTap,
  ) {
    final names = section.applicantNames as List<String>;
    final stepTitles = StepSection.uploadStepTitles;
    final list = <Widget>[];
    final active0 = isActiveSub(sectionIndex, 0);
    list.add(
      InkWell(
        onTap: () => onStepTap(sectionIndex, 0),
        child: Padding(
          padding: const EdgeInsets.only(top: 6),
          child: Row(
            children: [
              Container(
                width: 6,
                height: 6,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: active0 ? activeColor : AppColors.lightSubText,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                StepSection.uploadIntroStepTitle,
                style: context.bodySmall?.copyWith(
                  color: active0
                      ? AppColors.darkTextColor
                      : AppColors.lightSubText,
                  fontFamily: active0
                      ? FontFamily.outfitSemiBold
                      : FontFamily.outfitRegular,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
      ),
    );
    for (var i = 0; i < names.length; i++) {
      list.add(
        Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Row(
            children: [
              Container(
                width: 6,
                height: 6,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.darkTextColor,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                names[i],
                style: context.bodySmall?.copyWith(
                  color: AppColors.darkTextColor,
                  fontFamily: FontFamily.outfitSemiBold,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
      );
      for (var j = 0; j < stepTitles.length; j++) {
        final subIdx = 1 + i * 3 + j;
        final active = isActiveSub(sectionIndex, subIdx);
        list.add(
          Padding(
            padding: const EdgeInsets.only(left: 16, top: 6),
            child: InkWell(
              onTap: () => onStepTap(sectionIndex, subIdx),
              child: Row(
                children: [
                  Container(
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: active ? activeColor : AppColors.lightSubText,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    stepTitles[j],
                    style: context.bodySmall?.copyWith(
                      color: active
                          ? AppColors.darkTextColor
                          : AppColors.lightSubText,
                      fontFamily: active
                          ? FontFamily.outfitSemiBold
                          : FontFamily.outfitRegular,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }
    }
    return list;
  }

  Widget _buildStepContent(
    BuildContext context,
    dynamic state,
    EvisaApplicationController controller,
  ) {
    final stepKey = ValueKey(
      'step_${state.sectionIndex}_${state.subStepIndex}',
    );
    if (state.sectionIndex == 0 && state.subStepIndex == 0) {
      return KeyedSubtree(key: stepKey, child: const StepLetsFinish());
    }
    if (state.sectionIndex == 0 && state.subStepIndex == 1) {
      return KeyedSubtree(key: stepKey, child: const StepGeneralDetails());
    }
    if (state.sectionIndex == 0 && state.subStepIndex == 2) {
      return KeyedSubtree(
        key: stepKey,
        child: StepTripDetails(
          destinationCountry: state.packageCountry ?? 'India',
        ),
      );
    }
    if (state.sectionIndex == 1 && state.subStepIndex == 0) {
      return KeyedSubtree(key: stepKey, child: const StepPersonalDetails());
    }
    if (state.sectionIndex == 1 && state.subStepIndex == 1) {
      return KeyedSubtree(key: stepKey, child: const StepHomeAddressDetails());
    }
    if (state.sectionIndex == 1 && state.subStepIndex == 2) {
      return KeyedSubtree(key: stepKey, child: const StepEmploymentDetails());
    }
    if (state.sectionIndex == 1 && state.subStepIndex == 3) {
      return KeyedSubtree(key: stepKey, child: const StepFamilyDetails());
    }
    if (state.sectionIndex == 1 && state.subStepIndex == 4) {
      return KeyedSubtree(
        key: stepKey,
        child: const StepApplicantTripDetails(),
      );
    }
    if (state.sectionIndex == 2) {
      if (state.subStepIndex == 0)
        return KeyedSubtree(
          key: stepKey,
          child: const StepUploadDocumentsApplicant(),
        );
      final applicantIndex = (state.subStepIndex - 1) ~/ 3;
      final stepInApplicant = (state.subStepIndex - 1) % 3;
      if (stepInApplicant == 0) {
        return KeyedSubtree(
          key: stepKey,
          child: StepUploadApplicantPhoto(applicantIndex: applicantIndex),
        );
      }
      if (stepInApplicant == 1) {
        return KeyedSubtree(
          key: stepKey,
          child: StepPassportBioPage(
            applicantIndex: applicantIndex,
            applicationId: applicationId,
          ),
        );
      }
      if (stepInApplicant == 2) {
        return KeyedSubtree(
          key: stepKey,
          child: StepPassportDetails(applicantIndex: applicantIndex),
        );
      }
    }
    return KeyedSubtree(
      key: stepKey,
      child: Center(
        child: Text(
          'Step content coming soon',
          style: context.bodyMedium?.copyWith(
            color: AppColors.lightSubText,
            fontFamily: FontFamily.outfitRegular,
          ),
        ),
      ),
    );
  }

  Widget _buildBottomNav(
    BuildContext context,
    WidgetRef ref,
    EvisaApplicationState state,
    EvisaApplicationController controller,
    String? applicationId,
  ) {
    final tripLoading = ref.watch(createTripDetailsLoadingProvider);
    final personLoading = ref.watch(createPersonDetailsLoadingProvider);
    final passportUpdateLoading = ref.watch(updatePassportLoadingProvider);
    final isLoading = tripLoading || personLoading || passportUpdateLoading;
    final isTripDetailsSubmit =
        state.sectionIndex == 0 && state.subStepIndex == 2;
    final isPersonDetailsSubmit =
        state.sectionIndex == 1 && state.subStepIndex == 4;
    final appDetails = ref.watch(
      applicationDetailsByIdProvider(applicationId ?? ''),
    );
    final travelerId = appDetails.value?.travellerDetails.firstOrNull?.id;
    final travellers = appDetails.value?.travellerDetails ?? [];

    String? _validateTripDetails(String? appId) {
      if (appId == null || appId.isEmpty) return 'Application ID is required';
      final phone = state.phoneNumber?.trim() ?? '';
      if (phone.isEmpty) return 'Phone number is required';
      if ((state.arrivalDate?.trim() ?? '').isEmpty)
        return 'Arrival date is required';
      if ((state.arrivalPoint?.trim() ?? '').isEmpty)
        return 'Arrival point is required';
      return null;
    }

    String? _validatePersonDetails() {
      if (applicationId == null || applicationId.isEmpty)
        return 'Application ID is required';
      if (travelerId == null || travelerId.isEmpty) return 'Traveler not found';
      final p = state.personDetails;
      if (p == null) return 'Please complete all sections';
      if ((p.gender?.trim() ?? '').isEmpty) return 'Gender is required';
      if ((p.countryBirth?.trim() ?? '').isEmpty)
        return 'Country of birth is required';
      if ((p.maritalStatus?.trim() ?? '').isEmpty)
        return 'Marital status is required';
      if ((p.residenceCountry?.trim() ?? '').isEmpty)
        return 'Country of residence is required';
      if ((p.homeAddress?.trim() ?? '').isEmpty)
        return 'Home address is required';
      if ((p.homeCity?.trim() ?? '').isEmpty) return 'City is required';
      if ((p.homeState?.trim() ?? '').isEmpty) return 'State is required';
      if ((p.homeZip?.trim() ?? '').isEmpty) return 'ZIP is required';
      if ((p.employmentStatus?.trim() ?? '').isEmpty)
        return 'Employment status is required';
      final isEmployed = p.employmentStatus == 'Employed';
      final isStudent = p.employmentStatus == 'Student';
      if (isEmployed && (p.employeeName?.trim() ?? '').isEmpty)
        return "Employer's name is required";
      if (isEmployed && (p.employeeAddress?.trim() ?? '').isEmpty)
        return "Employer's address is required";
      if (isStudent && (p.universityName?.trim() ?? '').isEmpty)
        return 'University name is required';
      if (isStudent && (p.universityAddress?.trim() ?? '').isEmpty)
        return 'University address is required';
      if ((isEmployed || isStudent) && (p.city?.trim() ?? '').isEmpty)
        return 'City or town is required';
      if ((isEmployed || isStudent) && (p.state?.trim() ?? '').isEmpty)
        return 'State or province is required';
      if ((isEmployed || isStudent) && (p.zipCode?.trim() ?? '').isEmpty)
        return 'ZIP or postcode is required';
      if (p.policeOrMilitary == null)
        return 'Please answer military/police question';
      final parentsOpt = p.parentsDetailsOption?.trim() ?? '';
      if (parentsOpt.isEmpty) return 'Please answer parents details question';
      if (parentsOpt == 'Yes, both parents') {
        if ((p.fatherFullName?.trim() ?? '').isEmpty)
          return "Father's name is required";
        if ((p.fatherNationality?.trim() ?? '').isEmpty)
          return "Father's nationality is required";
        if ((p.fatherCountryBirth?.trim() ?? '').isEmpty)
          return "Father's country of birth is required";
        if ((p.motherFullName?.trim() ?? '').isEmpty)
          return "Mother's name is required";
        if ((p.motherNationality?.trim() ?? '').isEmpty)
          return "Mother's nationality is required";
        if ((p.motherCountryBirth?.trim() ?? '').isEmpty)
          return "Mother's country of birth is required";
      } else if (parentsOpt == 'Only my father') {
        if ((p.fatherFullName?.trim() ?? '').isEmpty)
          return "Father's name is required";
        if ((p.fatherNationality?.trim() ?? '').isEmpty)
          return "Father's nationality is required";
        if ((p.fatherCountryBirth?.trim() ?? '').isEmpty)
          return "Father's country of birth is required";
      } else if (parentsOpt == 'Only my mother') {
        if ((p.motherFullName?.trim() ?? '').isEmpty)
          return "Mother's name is required";
        if ((p.motherNationality?.trim() ?? '').isEmpty)
          return "Mother's nationality is required";
        if ((p.motherCountryBirth?.trim() ?? '').isEmpty)
          return "Mother's country of birth is required";
      }
      if (p.lastSixDayVisitOtherCountry == null)
        return 'Please answer last 6 days visit question';
      return null;
    }

    Future<void> _onNextPressed() async {
      if (controller.isLastStep) return;
      if (!controller.canGoNext) return;
      if (isTripDetailsSubmit) {
        final validationError = _validateTripDetails(applicationId);
        if (validationError != null) {
          "ERROR $validationError".logE();
          AppToast.error(context, validationError);
          return;
        }
        ref.read(createTripDetailsLoadingProvider.notifier).state = true;
        try {
          final error = await createTripDetailsApi(
            applicationId!,
            ref.read(evisaApplicationProvider),
          );
          if (error != null) {
            "ERROR $validationError".logE();
            AppToast.error(context, error);
            return;
          }
          controller.nextStep();
        } finally {
          ref.read(createTripDetailsLoadingProvider.notifier).state = false;
        }
      } else if (isPersonDetailsSubmit) {
        final validationError = _validatePersonDetails();
        if (validationError != null) {
          AppToast.error(context, validationError);
          return;
        }
        ref.read(createPersonDetailsLoadingProvider.notifier).state = true;
        try {
          final error = await createPersonDetailsApi(
            applicationId!,
            travelerId!,
            ref.read(evisaApplicationProvider),
          );
          if (error != null) {
            AppToast.error(context, error);
            return;
          }
          controller.nextStep();
        } finally {
          ref.read(createPersonDetailsLoadingProvider.notifier).state = false;
        }
      } else {
        controller.nextStep();
      }
    }

    Future<void> _onSubmitPressed() async {
      if (travellers.isEmpty) {
        AppToast.error(context, 'No applicants found');
        return;
      }
      final state = ref.read(evisaApplicationProvider);
      for (var i = 0; i < travellers.length; i++) {
        final err = validatePassportForApplicant(i, state);
        if (err != null) {
          AppToast.error(
            context,
            travellers.length > 1 ? 'Applicant ${i + 1}: $err' : err,
          );
          return;
        }
      }
      ref.read(updatePassportLoadingProvider.notifier).state = true;
      try {
        for (var i = 0; i < travellers.length; i++) {
          final passportId = travellers[i].id;
          if (passportId == null || passportId.isEmpty) {
            AppToast.error(
              context,
              travellers.length > 1
                  ? 'Passport not found for applicant ${i + 1}'
                  : 'Passport not found',
            );
            return;
          }
          final error = await updatePassportApi(
            passportId,
            i,
            ref.read(evisaApplicationProvider),
          );
          if (error != null) {
            AppToast.error(
              context,
              travellers.length > 1 ? 'Applicant ${i + 1}: $error' : error,
            );
            return;
          }
        }
        AppToast.success(context, 'Submitted successfully');
        ref.read(evisaApplicationProvider.notifier).reset();
        if (context.mounted) context.go(RouterNames.paymentSubmission);
      } finally {
        ref.read(updatePassportLoadingProvider.notifier).state = false;
      }
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: AppColors.lightGrey, width: 1)),
      ),
      child: Row(
        children: [
          if (controller.canGoBack)
            PrimaryButton(
              text: 'Back',
              color: AppColors.greyColor,
              textColor: AppColors.darkTextColor,
              onPressed: isLoading ? null : () => controller.previousStep(),
              height: 48,
              width: 100,
              borderRadius: 8,
              horizontalPadding: 24,
            ),
          if (controller.canGoBack) const SizedBox(width: 16),
          PrimaryButton(
            text: controller.isLastStep ? 'Submit' : 'Next',
            color: AppColors.primaryBlue,
            textColor: AppColors.lightBackground,
            onPressed: controller.isLastStep
                ? (isLoading ? null : _onSubmitPressed)
                : (controller.canGoNext && !isLoading ? _onNextPressed : null),
            height: 48,
            width: 100,
            borderRadius: 8,
            horizontalPadding: 24,
            isLoading: isLoading,
          ),
        ],
      ),
    );
  }
}
