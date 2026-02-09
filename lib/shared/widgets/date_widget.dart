import 'package:flutter/material.dart';
import 'package:register_visa_web_app/core/constants/app_color.dart';
import 'package:register_visa_web_app/core/constants/font_family.dart';
import 'package:register_visa_web_app/core/utils/spacing_extension.dart';
import 'package:register_visa_web_app/core/utils/text_theme_extension.dart';


// ignore: must_be_immutable
class DateWidget extends StatelessWidget {
  final String date;
  final String? title;
  final bool isFieldRequired;
  Color? textColor;
  Function? onTap;
  DateWidget({
    super.key,
    required this.date,
    this.title,
    this.isFieldRequired = false,
    this.textColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null) ...[
          Text(
            isFieldRequired ? '$title *' : title!,
            style: context.titleSmall?.copyWith(
              fontSize: 14.0,
              fontFamily: FontFamily.outfitRegular,
              letterSpacing: 0.1,
            ),
          ),
          const SizedBox(height: 8),
        ],
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            onTap?.call();
          },
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.textFieldBorderColor),
            ),
            child: Row(
              children: [
                8.wt,
                Icon(
                  Icons.calendar_today_outlined,
                  color: textColor ?? AppColors.darkBackground,
                ),
                8.wt,
                Text(
                  date.isEmpty ? 'Select Date' : date,
                  style: date.isEmpty
                      ? context.bodyMedium?.copyWith(
                          fontFamily: FontFamily.outfitRegular,
                          color: AppColors.lightSubText,
                          letterSpacing: .1,
                        )
                      : context.titleLarge?.copyWith(
                          color: textColor ?? AppColors.darkBackground,
                          fontFamily: FontFamily.outfitRegular,
                          fontSize: 13.0,
                        ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
