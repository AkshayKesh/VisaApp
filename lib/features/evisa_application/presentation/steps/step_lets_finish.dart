import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:register_visa_web_app/core/constants/app_color.dart';
import 'package:register_visa_web_app/core/constants/font_family.dart';
import 'package:register_visa_web_app/core/utils/spacing_extension.dart';
import 'package:register_visa_web_app/core/utils/text_theme_extension.dart';
import 'package:register_visa_web_app/features/evisa_application/providers/evisa_application_provider.dart';
import 'package:register_visa_web_app/shared/widgets/app_button.dart';

class StepLetsFinish extends ConsumerWidget {
  const StepLetsFinish({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.read(evisaApplicationProvider.notifier);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Icon(Icons.schedule, size: 18, color: AppColors.lightSubText),
            const SizedBox(width: 6),
            Text(
              'Takes 10 minutes or less',
              style: context.bodySmall?.copyWith(color: AppColors.lightSubText, fontFamily: FontFamily.outfitRegular, fontSize: 14),
            ),
          ],
        ),
        24.ht,
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.lightBackground,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.textFieldBorderColor),
            boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 8, offset: const Offset(0, 2))],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'We still need the following',
                style: context.bodyMedium?.copyWith(color: AppColors.darkTextColor, fontFamily: FontFamily.outfitRegular, fontSize: 14),
              ),
              20.ht,
              _TaskRow(
                icon: Icons.person_outline,
                iconColor: AppColors.primaryBlue,
                title: 'Personal Details',
                description: 'Provide remaining personal and trip details',
              ),
              16.ht,
              _TaskRow(
                icon: Icons.folder_outlined,
                iconColor: AppColors.primaryBlue,
                title: 'Supporting documents',
                description: null,
                bullets: const ['Upload your documents', "Applicant's Photo", 'Passport Bio Page'],
              ),
            ],
          ),
        ),
        24.ht,
        PrimaryButton(
          text: 'Continue',
          color: AppColors.primaryBlue,
          textColor: AppColors.lightBackground,
          onPressed: () => controller.nextStep(),
          height: 48,
          borderRadius: 8,
          horizontalPadding: 24,
        ),
      ],
    );
  }
}

class _TaskRow extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String? description;
  final List<String>? bullets;

  const _TaskRow({required this.icon, required this.iconColor, required this.title, this.description, this.bullets});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(color: AppColors.primaryBlue.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(8)),
          child: Icon(icon, size: 22, color: iconColor),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: context.titleSmall?.copyWith(color: AppColors.darkTextColor, fontFamily: FontFamily.outfitSemiBold, fontSize: 14),
              ),
              if (description != null) ...[
                4.ht,
                Text(
                  description!,
                  style: context.bodySmall?.copyWith(color: AppColors.lightSubText, fontFamily: FontFamily.outfitRegular, fontSize: 13),
                ),
              ],
              if (bullets != null && bullets!.isNotEmpty) ...[
                8.ht,
                ...bullets!.map(
                  (b) => Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '• ',
                          style: context.bodySmall?.copyWith(color: AppColors.darkTextColor, fontFamily: FontFamily.outfitRegular),
                        ),
                        Expanded(
                          child: Text(
                            b,
                            style: context.bodySmall?.copyWith(color: AppColors.darkTextColor, fontFamily: FontFamily.outfitRegular, fontSize: 13),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
