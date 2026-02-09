import 'package:flutter/material.dart';
import 'package:register_visa_web_app/core/constants/app_color.dart';
import 'package:register_visa_web_app/core/constants/font_family.dart';
import 'package:register_visa_web_app/core/utils/text_theme_extension.dart';

class Titlesection extends StatelessWidget {
  const Titlesection({super.key});

  @override
  Widget build(BuildContext context) {
    return RichText(
      maxLines: 3,
      overflow: TextOverflow.ellipsis,
      text: TextSpan(
        children: [
          TextSpan(
            text: "Popular Destinations\n",
            style: context.titleLarge?.copyWith(
              color: AppColors.blackColor,
              fontSize: 35,
              fontFamily: FontFamily.outfitBold,
            ),
          ),
          TextSpan(
            text: "Explore visa packages for trending destinations",
            style: context.labelSmall?.copyWith(
              color: AppColors.darkSubText,
              fontSize: 20,
              fontFamily: FontFamily.outfitRegular,
            ),
          ),
        ],
      ),
    );
  }
}