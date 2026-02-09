import 'package:flutter/material.dart';
import 'package:register_visa_web_app/core/constants/app_color.dart';
import 'package:register_visa_web_app/core/constants/font_family.dart';
import 'package:register_visa_web_app/core/constants/image_url.dart';
import 'package:register_visa_web_app/core/utils/spacing_extension.dart';
import 'package:register_visa_web_app/core/utils/text_theme_extension.dart';

class StepUploadDocumentsApplicant extends StatelessWidget {
  const StepUploadDocumentsApplicant({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final useRow = constraints.maxWidth > 400;
        if (useRow) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: _Instructions(theme: context.textTheme)),
              const SizedBox(width: 40),
              Image.asset(ImageUrl.selfieImage, width: 350, height: 350, fit: BoxFit.fill),
            ],
          );
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const _Instructions(theme: null),
            16.ht,
            Image.asset(ImageUrl.selfieImage, width: 350, height: 350, fit: BoxFit.fill),
          ],
        );
      },
    );
  }
}

class _Instructions extends StatelessWidget {
  final TextTheme? theme;

  const _Instructions({this.theme});

  @override
  Widget build(BuildContext context) {
    final t = theme ?? Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'We need a clear, front-facing photo. Passport photos can\'t be used.',
          style: t.bodyMedium?.copyWith(fontFamily: FontFamily.outfitSemiBold, color: AppColors.darkTextColor),
        ),
        16.ht,
        _NumberedItem(number: 1, text: 'Keep a neutral expression, don\'t smile'),
        12.ht,
        _NumberedItem(number: 2, text: 'Remove glasses, hats, and scarves'),
        12.ht,
        _NumberedItem(number: 3, text: 'Tuck hair behind ears'),
      ],
    );
  }
}

class _NumberedItem extends StatelessWidget {
  final int number;
  final String text;

  const _NumberedItem({required this.number, required this.text});

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 24,
          height: 24,
          alignment: Alignment.center,
          decoration: BoxDecoration(color: AppColors.primaryBlue, shape: BoxShape.circle),
          child: Text(
            '$number',
            style: t.bodySmall?.copyWith(fontFamily: FontFamily.outfitSemiBold, color: AppColors.lightBackground, fontSize: 12),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: t.bodyMedium?.copyWith(fontFamily: FontFamily.outfitRegular, color: AppColors.darkTextColor),
          ),
        ),
      ],
    );
  }
}
