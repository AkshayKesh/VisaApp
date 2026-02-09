import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:register_visa_web_app/core/constants/app_color.dart';
import 'package:register_visa_web_app/core/constants/app_constant.dart';
import 'package:register_visa_web_app/core/constants/font_family.dart';
import 'package:register_visa_web_app/core/constants/image_url.dart';
import 'package:register_visa_web_app/core/utils/app_toast.dart';
import 'package:register_visa_web_app/core/utils/spacing_extension.dart';
import 'package:register_visa_web_app/core/utils/string_logger_extension.dart';
import 'package:register_visa_web_app/core/utils/text_theme_extension.dart';
import 'package:register_visa_web_app/features/profile/presentation/document/domain/passport_listing_model.dart';
import 'package:register_visa_web_app/features/profile/presentation/document/provider/passport_listing_provide.dart';
import 'package:register_visa_web_app/features/profile/providers/document_provider.dart';
import 'package:register_visa_web_app/shared/services/image_picker_service.dart';
import 'package:register_visa_web_app/shared/widgets/app_drop_down.dart';
import 'package:register_visa_web_app/shared/widgets/app_text_field.dart';
import 'package:register_visa_web_app/shared/widgets/custom_icon_button.dart';
import 'package:register_visa_web_app/shared/widgets/image_view.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class DocumentDetailPage extends ConsumerStatefulWidget {
  DocumentDetailPage({super.key, this.model});

  PassportListingModel? model;

  @override
  ConsumerState<DocumentDetailPage> createState() => _DocumentDetailPageState();
}

class _DocumentDetailPageState extends ConsumerState<DocumentDetailPage> {
  @override
  void initState() {
    super.initState();
    ref.read(addPassportProvider).isSuccess = true;
    if (widget.model != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          ref.read(addPassportProvider.notifier).setData(widget.model!);
        }
      });
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          ref.read(addPassportProvider.notifier).reset();
        }
      });
    }
    ref.read(addPassportProvider).isSuccess = false;
  }

  @override
  Widget build(BuildContext context) {
    final controller = ref.read(addPassportProvider.notifier);
    final state = ref.watch(addPassportProvider);

    ref.listen(addPassportProvider, (previous, next) {
      if (next.isSuccess) {
        ref.invalidate(passportListingProvider);
        context.pop();
      }
      if (next.error != null) {
        AppToast.error(context, next.error ?? "");
      }
    });

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            ref.invalidate(addPassportProvider);
            Navigator.pop(context);
          },
          child: Align(
            alignment: Alignment.bottomLeft,
            child: Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(color: AppColors.lightBackground, borderRadius: BorderRadius.circular(8)),
              child: Row(
                children: [
                  Icon(Icons.arrow_back, color: AppColors.primaryBlue),
                  const SizedBox(width: 8),
                  Text('Back to Documents'),
                ],
              ),
            ),
          ),
        ),
        20.ht,
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppTextFormField(controller: controller.firstNameController, hint: "eg. Jhon smith", title: "First name"),
              10.ht,
              AppTextFormField(controller: controller.lastNameController, hint: "eg. Smith", title: "Last name"),
              10.ht,
              Text("Date of birth", style: const TextStyle(fontWeight: FontWeight.w600)),
              10.ht,

              Row(
                children: [
                  Expanded(
                    child: AppDropdown(
                      title: "Month",
                      hint: "Month",
                      items: months(),
                      onChanged: (value) {
                        controller.changeMonth(value);
                      },
                      value: safeDropdownValue(controller.birthMonth, months()),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: AppDropdown(
                      title: "Day",
                      hint: "Day",
                      items: daysByMonthYear(int.tryParse(controller.birthYear.toString()), getMonthNumber(controller.birthMonth.toString())),
                      onChanged: (value) {
                        controller.changeDay(value);
                      },
                      value: safeDropdownValue(
                        controller.birthDay,
                        daysByMonthYear(int.tryParse(controller.birthYear), getMonthNumber(controller.birthMonth)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),

                  Expanded(
                    child: AppDropdown(
                      value: safeDropdownValue(controller.birthYear, years()),
                      title: "Year",
                      items: years(),
                      onChanged: (value) {
                        controller.changeYear(value);
                      },
                      hint: "Year",
                    ),
                  ),
                ],
              ),
              10.ht,
              Consumer(
                builder: (context, ref, child) {
                  return AppCustomDropdown(
                    title: "Passport",
                    hint: "Select",
                    maxHeight: 180,
                    value: controller.country,
                    itemLabel: (value) => value,
                    onChanged: (value) {
                      controller.updateMyPassportCountry(value);
                    },
                  );
                },
              ),
              10.ht,
              AppTextFormField(controller: controller.passportNumberController, hint: "eg. GD4F56D4F56D", title: "Passport Number"),
              10.ht,
              Text("Passport expiry date", style: const TextStyle(fontWeight: FontWeight.w600)),
              10.ht,
              Row(
                children: [
                  Expanded(
                    child: AppDropdown(
                      value: safeDropdownValue(controller.passportExpiryMonth, months()),
                      title: "Month",
                      hint: "Month",
                      items: months(),
                      onChanged: (value) {
                        controller.updateExpireMonth(value ?? "1");
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: AppDropdown(
                      value: safeDropdownValue(
                        controller.passportExpiryDay,
                        daysByMonthYear(int.tryParse(controller.passportExpiryYear), getMonthNumber(controller.passportExpiryMonth)),
                      ),
                      title: "Day",
                      hint: "Day",
                      items: daysByMonthYear(
                        int.tryParse(controller.passportExpiryDay) ?? 1,
                        getMonthNumber(controller.passportExpiryMonth.toString()),
                      ),
                      onChanged: (value) {
                        controller.updateExpireDay(value);
                      },
                    ),
                  ),
                  const SizedBox(width: 12),

                  Expanded(
                    child: AppDropdown(
                      value: safeDropdownValue(controller.passportExpiryYear, years()),
                      title: "Year",
                      items: years(),
                      onChanged: (value) {
                        controller.updateExpireYear(value);
                      },
                      hint: "Year",
                    ),
                  ),
                ],
              ),
              20.ht,
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: 20,
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () async {
                              final pickedFile = await ImagePickerService().pickImageFromGallery2();
                              if (pickedFile != null) {
                                "File Picked".logI();
                                // Assume the state has a method or field to store image URL or file path
                                controller.setPassportFrontPhoto(pickedFile.path, pickedFile); // Or set a property if available
                              }
                            },
                            child: _imageCard(
                              removeImage: controller.removeFrontPhoto,
                              context: context,
                              title: "Passport - Front Photo",
                              height: 36.h,
                              imageUrl: state.addPasspoetModel?.passportFrontPhotoUrl,
                              subTitle: "Upload a clear scan of your passport photo page",
                            ),
                          ),
                        ),
                        const SizedBox(width: 24),
                        Expanded(
                          child: GestureDetector(
                            onTap: () async {
                              final pickedFile = await ImagePickerService().pickImageFromGallery2();
                              if (pickedFile != null) {
                                // Assume the state has a method or field to store image URL or file path
                                controller.setPassportbackPhoto(pickedFile.path, pickedFile); // Or set a property if available
                              }
                            },
                            child: _imageCard(
                              removeImage: controller.removeBackPhoto,
                              context: context,
                              title: "Passport - Back Photo",
                              height: 36.h,

                              imageUrl: state.addPasspoetModel?.passportBackPhotoUrl,
                              subTitle: "Upload a recent passport-size photo",
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              10.ht,
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Passport Photo", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                    20.ht,
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () async {
                            final pickedFile = await ImagePickerService().pickImageFromGallery2();
                            if (pickedFile != null) {
                              // Assume the state has a method or field to store image URL or file path
                              controller.setPassportSizePhoto(pickedFile.path, pickedFile); // Or set a property if available
                            }
                          },
                          child: _imageCard(
                            context: context,
                            title: "Passport-size Photo",
                            height: 36.h,
                            imageUrl: state.addPasspoetModel?.passportSizePhotoUrl,
                            subTitle: "Upload a recent passport-size photo",
                            removeImage: controller.removePassportPhoto,
                          ),
                        ),
                        SizedBox(width: 40),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 16.0),
                            child: Container(
                              decoration: BoxDecoration(
                                color: AppColors.primaryBlue.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: AppColors.primaryBlue.withValues(alpha: 0.1)),
                              ),
                              padding: const EdgeInsets.all(12.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Before uploading:", style: context.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                                  SizedBox(height: 10),
                                  Text(
                                    "• The photograph should be in colour and of the size 2 inch x 2 inch (51 mm x 51 mm).",
                                    style: context.textTheme.titleSmall?.copyWith(
                                      fontFamily: FontFamily.outfitMedium,
                                      color: AppColors.darkBackground,
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  Text(
                                    "• The digital file size should be between 20 KB and 600 KB.",
                                    style: context.textTheme.titleSmall?.copyWith(
                                      fontFamily: FontFamily.outfitMedium,
                                      color: AppColors.darkBackground,
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  Text(
                                    "• Resolution: minimum 350x350 pixels, maximum 1000x1000 pixels.",
                                    style: context.textTheme.titleSmall?.copyWith(
                                      fontFamily: FontFamily.outfitMedium,
                                      color: AppColors.darkBackground,
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  Text(
                                    "• The photo must be clear, with continuous-tone quality.",
                                    style: context.textTheme.titleSmall?.copyWith(
                                      fontFamily: FontFamily.outfitMedium,
                                      color: AppColors.darkBackground,
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  Text(
                                    "• Full face, front view, eyes open; head centered in the frame (top of hair to bottom of chin).",
                                    style: context.textTheme.titleSmall?.copyWith(
                                      fontFamily: FontFamily.outfitMedium,
                                      color: AppColors.darkBackground,
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  Text(
                                    "• Background should be plain white or off-white without distracting shadows.",
                                    style: context.textTheme.titleSmall?.copyWith(
                                      fontFamily: FontFamily.outfitMedium,
                                      color: AppColors.darkBackground,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              10.ht,
              if (ref.watch(addPassportProvider.notifier).passportError != null)
                Text(
                  "${ref.read(addPassportProvider.notifier).passportError}",
                  style: context.textTheme.titleSmall?.copyWith(fontFamily: FontFamily.outfitMedium, color: AppColors.redColor),
                ),
              30.ht,
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomIconButton(
                    text: 'Cancel',
                    onPressed: () {
                      controller.reset();
                      context.pop();
                    },
                    color: AppColors.lightCard,
                    textColor: AppColors.darkBackground,
                    borderRadius: 12,
                    height: 40,
                    width: 20.w,
                    textSize: 15,
                    iconSize: 24,
                    spacing: 10,
                    isButtonStypeApply: false,
                  ),
                  20.wt,
                  CustomIconButton(
                    width: 20.w,
                    text: ' ${widget.model == null ? "Add" : "Update"} Passport',
                    buttonState: state.isLoading,
                    onPressed: () async {
                      String? error = controller.checkValidataion();

                      if ((ref.watch(addPassportProvider.notifier).passportError?.isEmpty ?? false)) {
                        if (error == null) {
                          await ref.read(addPassportProvider.notifier).addPassport(passportId: widget.model?.id);
                        } else {
                          AppToast.error(context, error);
                        }
                      } else {
                        AppToast.error(context, ref.read(addPassportProvider.notifier).passportError ?? "");
                      }
                    },
                    color: AppColors.primaryBlue,
                    textColor: AppColors.lightBackground,
                    height: 40,
                    borderRadius: 12,
                  ),
                ],
              ),
              20.ht,
            ],
          ),
        ),
      ],
    );
  }

  Widget _imageCard({
    required String title,
    required String subTitle,
    required double height,
    double? width,
    String? imageUrl,
    required Function removeImage,
    required BuildContext context,
  }) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
          const SizedBox(height: 12),
          if (imageUrl == null || imageUrl.isEmpty)
            Container(
              height: height,
              width: width,
              alignment: Alignment.center,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), color: Colors.grey.shade200),
              child: Column(
                spacing: 20,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(ImageUrl.uploadIcon, color: AppColors.darkSubText, height: 26),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      subTitle,
                      textAlign: TextAlign.center,
                      style: context.textTheme.bodyLarge?.copyWith(
                        fontFamily: FontFamily.outfitRegular,
                        color: AppColors.darkSubText,
                        fontSize: 16.0,
                      ),
                    ),
                  ),
                ],
              ),
            )
          else
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadiusGeometry.circular(10),
                  child: AppCacheNetworkImage(url: imageUrl, height: height, width: width, boxFit: BoxFit.cover),
                ),
                Positioned(
                  right: 10,
                  top: 10,
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {
                      removeImage();
                    },
                    child: Container(
                      decoration: BoxDecoration(color: AppColors.lightBackground, borderRadius: BorderRadius.all(Radius.circular(20))),
                      child: Image.asset(ImageUrl.closeRedIcon, height: 26),
                    ),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  String? safeDropdownValue(String value, List<String> items) {
    return items.contains(value) ? value : null;
  }
}
