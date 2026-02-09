import 'package:flutter/material.dart';
import 'package:register_visa_web_app/core/constants/app_color.dart';
import 'package:register_visa_web_app/core/constants/font_family.dart';
import 'package:register_visa_web_app/core/utils/spacing_extension.dart';
import 'package:register_visa_web_app/core/utils/text_theme_extension.dart';

class PassportPhototUpload extends StatelessWidget {
  const PassportPhototUpload({super.key, required this.context, required this.isSmallScreen, required this.photoUrl});
  final BuildContext context;
  final bool isSmallScreen;
  final String photoUrl;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.lightCard,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.lightGrey,
          style: BorderStyle.solid,
        ), // Changed to solid
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Passport Photo *',
            style: context.bodyLarge?.copyWith(
              color: AppColors.darkBackground,
              fontFamily: FontFamily.outfitMedium,
            ),
          ),
          20.ht,
          Center(
            child: Column(
              children: [
                const Icon(
                  Icons.upload_file,
                  size: 40,
                  color: AppColors.lightSubText,
                ),
                10.ht,
                Text(
                  'Drag & drop or click to upload',
                  style: context.bodyMedium?.copyWith(
                    color: AppColors.lightSubText,
                  ),
                ),
                5.ht,
                Text(
                  'JPG, PNG (Max 5MB)',
                  style: context.bodySmall?.copyWith(
                    color: AppColors.lightSubText,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
