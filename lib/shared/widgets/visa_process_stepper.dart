import 'package:flutter/material.dart';
import 'package:register_visa_web_app/core/constants/app_color.dart';
import 'package:register_visa_web_app/core/constants/font_family.dart';
import 'package:register_visa_web_app/core/utils/spacing_extension.dart';
import 'package:register_visa_web_app/core/utils/text_theme_extension.dart';
import 'package:register_visa_web_app/core/utils/utils.dart';
import 'package:register_visa_web_app/features/visa_details/domain/visa_details_model.dart';

class VisaProcessStepper extends StatelessWidget {
  final List<VisaProcessStep> steps;

  const VisaProcessStepper({super.key, required this.steps});

  @override
  Widget build(BuildContext context) {
    screenSize = getSize(context);
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: steps.length,
      itemBuilder: (context, index) {
        final step = steps[index];
        final isLastStep = index == steps.length - 1;

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                Container(
                  height: 35,
                  width: 50,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: AppColors.primaryBlue,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(80 / 2),
                      bottomLeft: Radius.circular(80 / 2),
                      topRight: Radius.circular(80 / 2),
                      bottomRight: Radius.circular(80 / 2),
                    ),
                  ),

                  child: Text(
                    "${index + 1}",
                    style: context.bodyMedium?.copyWith(color: Colors.white, fontFamily: FontFamily.outfitSemiBold),
                  ),
                ),
                if (!isLastStep)
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 6),
                    width: 4,
                    height: 50, // Adjust height based on content or make it dynamic
                    color: AppColors.greyColor,
                  ),
              ],
            ),
            20.wt,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    step.stepTitle,
                    style: context.titleSmall?.copyWith(color: AppColors.darkTextColor, fontFamily: FontFamily.outfitSemiBold, fontSize: 16),
                  ),
                  5.ht,
                  Text(
                    step.stepDescription,
                    style: context.bodySmall?.copyWith(color: AppColors.lightGrey200, fontFamily: FontFamily.outfitRegular, fontSize: 14),
                  ),
                  if (!isLastStep) 20.ht, // Add spacing between steps
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
