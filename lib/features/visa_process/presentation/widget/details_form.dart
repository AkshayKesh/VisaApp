import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:register_visa_web_app/core/constants/app_color.dart';
import 'package:register_visa_web_app/core/utils/spacing_extension.dart';
import 'package:register_visa_web_app/core/utils/text_theme_extension.dart';
import 'package:register_visa_web_app/core/utils/utils.dart';
import 'package:register_visa_web_app/features/visa_details/providers/details_provider.dart';
import 'package:register_visa_web_app/features/visa_process/domain/traveller_model.dart';
import 'package:register_visa_web_app/features/visa_process/presentation/widget/passport_size_upload_section.dart';
import 'package:register_visa_web_app/features/visa_process/presentation/widget/passport_uplod_section.dart';
import 'package:register_visa_web_app/features/visa_process/providers/application_provider.dart';
import 'package:register_visa_web_app/shared/widgets/app_text_field.dart';
import 'package:register_visa_web_app/shared/widgets/date_widget.dart';

class TravelDetailsForm extends ConsumerWidget {
  const TravelDetailsForm({
    super.key,
    required this.context,
    required this.traveller,
    required this.isSmallScreen,
  });
  final BuildContext context;
  final Traveller traveller;
  final bool isSmallScreen;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(
      visaApplicationProvider(ref.watch(personCountProvider)),
    );
    final controller = ref.read(
      visaApplicationProvider(ref.watch(personCountProvider)).notifier,
    );
    return Consumer(
      builder: (context, ref, child) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              AppTextFormField(
                title: 'First Name*',
                hint: 'eg. Jhon',
                prefixIcon: Icons.person_outline,
                controller: traveller.firstNameController,
              ),
              20.ht,

              AppTextFormField(
                title: 'Issue Country *',
                hint: 'eg. USA',
                prefixIcon: Icons.flag,
                controller: traveller.issuedCountryController,
              ),
              20.ht,
              AppTextFormField(
                title: 'Passport Number*',
                hint: 'eg. F78FS58SSRF',
                prefixIcon: Icons.credit_card_outlined,
                controller: traveller.passportNumberController,
              ),
              20.ht,
              Row(
                children: [
                  Expanded(
                    child: DateWidget(
                      title: "Date Of Issued",
                      date: traveller.dateOfIssue,
                      onTap: () async {
                        final date = await Utils.showAppDatePicker(
                          context: context,
                        );
                        if (date != null) {
                          ref
                              .read(
                                visaApplicationProvider(
                                  ref.watch(personCountProvider),
                                ).notifier,
                              )
                              .updateDateOfIssued(traveller.id, date);
                        }
                      },
                    ),
                  ),
                  SizedBox(width: 20),
                  Expanded(
                    child: DateWidget(
                      title: "Passport Expiry Date",
                      date: traveller.passportExpiryDate,
                      onTap: () async {
                        final date = await Utils.showAppDatePicker(
                          context: context,
                        );
                        if (date != null) {
                          ref
                              .read(
                                visaApplicationProvider(
                                  ref.watch(personCountProvider),
                                ).notifier,
                              )
                              .updatePassportExpiryDate(traveller.id, date);
                        }
                      },
                    ),
                  ),
                ],
              ),
              20.ht,
              PassportUploadSection(
                backLoading: state.backPhotoUrlLoading,
                context: context,
                controller: controller,
                frontLoading: state.frontPhotoUrlLoading,
                traveller: traveller,
              ),

              const SizedBox(height: 5),

              20.ht,
              PassportSizeUploadSection(
                state: state,
                controller: controller,
                traveller: traveller,
              ),

              if (controller.passportPhotoError?.isNotEmpty ?? false)
                Text(
                  "${controller.passportPhotoError}",
                  style: context.bodyMedium?.copyWith(
                    color: AppColors.redColor,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
