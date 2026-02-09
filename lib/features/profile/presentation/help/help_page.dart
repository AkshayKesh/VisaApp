import 'package:flutter/material.dart';
import 'package:register_visa_web_app/core/constants/app_color.dart';
import 'package:register_visa_web_app/core/constants/app_text_style.dart';
import 'package:register_visa_web_app/core/utils/spacing_extension.dart';

class HelpPage extends StatelessWidget {
  const HelpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Help',
          style: AppTextStyle.outFitBoldStyle.copyWith(fontSize: 20),
        ),
        const SizedBox(height: 12),
        Text(
          'Get assistance with your visa applications',
          style: AppTextStyle.outFitRegularStyle.copyWith(
            color: AppColors.lightSubText,
          ),
        ),
        Card(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 100),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(Icons.help_outline),
                20.ht,
                Text('Contact support at support@registervisa.com'),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
