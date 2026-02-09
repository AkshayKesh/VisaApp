import 'package:flutter/material.dart';
import 'package:register_visa_web_app/core/constants/app_color.dart';
import 'package:register_visa_web_app/core/constants/font_family.dart';
import 'package:register_visa_web_app/core/utils/text_theme_extension.dart';

class PassportPhotoInstructions extends StatelessWidget {
  const PassportPhotoInstructions({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.primaryBlue.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.primaryBlue.withValues(alpha: 0.1)),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          _InstructionTitle(),
          SizedBox(height: 10),
          _InstructionText(
            "• The photograph should be in colour and of the size 2 inch x 2 inch (51 mm x 51 mm).",
          ),
          SizedBox(height: 10),
          _InstructionText(
            "• The digital file size should be between 20 KB and 600 KB.",
          ),
          SizedBox(height: 10),
          _InstructionText(
            "• Resolution: minimum 350x350 pixels, maximum 1000x1000 pixels.",
          ),
          SizedBox(height: 10),
          _InstructionText(
            "• The photo must be clear, with continuous-tone quality.",
          ),
          SizedBox(height: 10),
          _InstructionText(
            "• Full face, front view, eyes open; head centered in the frame.",
          ),
          SizedBox(height: 10),
          _InstructionText("• Background should be plain white or off-white."),
        ],
      ),
    );
  }
}

class _InstructionTitle extends StatelessWidget {
  const _InstructionTitle();

  @override
  Widget build(BuildContext context) {
    return Text(
      "Before uploading:",
      style: context.textTheme.titleMedium?.copyWith(
        fontWeight: FontWeight.bold,
      ),
    );
  }
}

class _InstructionText extends StatelessWidget {
  final String text;
  const _InstructionText(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: context.textTheme.titleSmall?.copyWith(
        fontFamily: FontFamily.outfitMedium,
        color: AppColors.darkBackground,
      ),
    );
  }
}
