import 'package:flutter/material.dart';
import 'package:register_visa_web_app/core/constants/app_color.dart';
import 'package:register_visa_web_app/core/constants/app_text_style.dart';
import 'package:register_visa_web_app/core/constants/font_family.dart';
import 'package:register_visa_web_app/core/constants/image_url.dart';
import 'package:register_visa_web_app/core/utils/spacing_extension.dart';
import 'package:register_visa_web_app/core/utils/string_extension.dart';
import 'package:register_visa_web_app/core/utils/text_theme_extension.dart';
import 'package:register_visa_web_app/core/utils/utils.dart';

class VisaRow extends StatelessWidget {
  const VisaRow({
    super.key,

    required this.status,
    required this.appId,
    required this.fullName,
    required this.country,
    required this.appliedData,
    required this.applicationId,
    required this.onTap,
  });
  final String status;
  final String appId;
  final String fullName;
  final String country;
  final String appliedData;
  final String applicationId;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    screenSize = getSize(context);
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        onTap();
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.lightBackground,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.lightGrey100),
        ),
        child:
            (screenSize == ScreenSize.large ||
                screenSize == ScreenSize.extraLarge)
            ? Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 8,
                      children: [
                        Text(
                          'Application Id',
                          style: context.bodySmall?.copyWith(
                            fontFamily: FontFamily.outfitMedium,
                            color: AppColors.lightSubText,
                          ),
                        ),
                        Text(
                          applicationId,
                          style: context.bodyMedium?.copyWith(
                            fontFamily: FontFamily.outfitMedium,
                            color: AppColors.blackColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 8,
                      children: [
                        Text(
                          'Traveller',
                          style: context.bodySmall?.copyWith(
                            fontFamily: FontFamily.outfitMedium,
                            color: AppColors.lightSubText,
                          ),
                        ),
                        Text(
                          fullName,
                          style: context.bodyMedium?.copyWith(
                            fontFamily: FontFamily.outfitMedium,
                            color: AppColors.blackColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 8,
                      children: [
                        Text(
                          'Applied Date',
                          style: context.bodySmall?.copyWith(
                            fontFamily: FontFamily.outfitMedium,
                            color: AppColors.lightSubText,
                          ),
                        ),
                        Row(
                          children: [
                            Image.asset(
                              ImageUrl.dateIcon,
                              scale: 3.6,
                              color: AppColors.blackColor,
                            ),
                            6.wt,
                            Text(
                              Utils.formatDateString(appliedData, "dd/mm/yyyy"),
                              style: context.bodyMedium?.copyWith(
                                fontFamily: FontFamily.outfitRegular,
                                color: AppColors.blackColor,
                                letterSpacing: -1,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      spacing: 8,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Country',
                          style: context.bodySmall?.copyWith(
                            fontFamily: FontFamily.outfitMedium,
                            color: AppColors.lightSubText,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Image.asset(
                              ImageUrl.locationIcon,
                              scale: 3.6,
                              color: AppColors.blackColor,
                            ),
                            6.wt,
                            Text(
                              country,
                              style: context.bodyMedium?.copyWith(
                                fontFamily: FontFamily.outfitRegular,
                                color: AppColors.blackColor,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      spacing: 8,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Status',
                          style: context.bodySmall?.copyWith(
                            fontFamily: FontFamily.outfitMedium,
                            color: AppColors.lightSubText,
                          ),
                        ),
                        StatusWidget(status: status),
                      ],
                    ),
                  ),
                ],
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _labelValue('Application Id', applicationId),
                      _labelValue('Traveller', fullName),
                    ],
                  ),
                  Divider(color: AppColors.greyColor),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _labelValue(
                        'Applied Date',
                        Utils.formatDateString(appliedData, "dd/MM/yyyy"),
                      ),
                      _labelValue('Country', country),
                    ],
                  ),
                  Divider(color: AppColors.greyColor),
                  const SizedBox(height: 8),
                  Center(child: _statusChip(context, status)),
                ],
              ),
      ),
    );
  }
}

class StatusWidget extends StatelessWidget {
  const StatusWidget({super.key, required this.status});

  final String status;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: status == "paid"
            ? AppColors.greenColor10.withValues(alpha: 0.1)
            : AppColors.grey.withValues(alpha: 0.6),
        border: Border.all(
          color: status == "paid" ? AppColors.greenColor : AppColors.grey,
        ),
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            ImageUrl.checkMarkIcon,
            height: 16,
            color: status == "paid"
                ? AppColors.greenColor
                : AppColors.blackColor,
          ),
          4.wt,
          Text(
            status.toCamelCase(),
            style: context.bodyMedium?.copyWith(
              fontFamily: FontFamily.outfitMedium,
              color: status == "paid"
                  ? AppColors.greenColor
                  : AppColors.blackColor,
            ),
          ),
        ],
      ),
    );
  }
}

Widget _labelValue(String label, String value) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 6),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(label, style: AppTextStyle.outFitMediumStyle),
        Text(value, style: AppTextStyle.outFitRegularStyle),
      ],
    ),
  );
}

Widget _statusChip(BuildContext context, String status) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(12),
      color: status == 'paid'
          ? AppColors.greenColor10
          : AppColors.grey.withValues(alpha: 0.2),
    ),
    child: Text(status.toCamelCase(), style: context.bodyMedium),
  );
}
