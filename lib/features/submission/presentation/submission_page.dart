import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:register_visa_web_app/core/constants/app_color.dart';
import 'package:register_visa_web_app/core/constants/app_text_style.dart';
import 'package:register_visa_web_app/core/constants/font_family.dart';
import 'package:register_visa_web_app/core/constants/image_url.dart';
import 'package:register_visa_web_app/core/constants/router/router_names.dart';
import 'package:register_visa_web_app/core/utils/text_theme_extension.dart';
import 'package:register_visa_web_app/core/utils/utils.dart';
import 'package:register_visa_web_app/shared/widgets/app_bar_widget.dart';
import 'package:register_visa_web_app/shared/widgets/app_footer.dart';
import 'package:register_visa_web_app/shared/widgets/custom_icon_button.dart';

class SubmissionPage extends StatefulWidget {
  const SubmissionPage({super.key});

  @override
  State<SubmissionPage> createState() => _SubmissionPageState();
}

class _SubmissionPageState extends State<SubmissionPage> {
  @override
  Widget build(BuildContext context) {
    screenSize = getSize(context);

    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final width = constraints.maxWidth;
          final isMobile = width < 600;

          return SingleChildScrollView(
            child: Column(
              children: [
                const CustomAppBar(),
                const SizedBox(height: 32),

                /// 🔹 CENTER CONTENT WITH MAX WIDTH
                Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 1100),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: isMobile ? 16 : 32),
                      child: Column(
                        children: [
                          Image.asset(
                            ImageUrl.submitApplicationIcon,
                            width: isMobile ? 64 : 80,
                            height: isMobile ? 64 : 80,
                            color: AppColors.darkBackground,
                          ),

                          const SizedBox(height: 20),

                          Text(
                            'Your Visa Application Has\nBeen Submitted!',
                            textAlign: TextAlign.center,
                            style: context.titleLarge?.copyWith(fontSize: isMobile ? 18 : 22, fontFamily: FontFamily.outfitSemiBold),
                          ),

                          const SizedBox(height: 8),

                          Text(
                            'You can track your application status anytime from the Settings → Visa section.',
                            textAlign: TextAlign.center,
                            style: context.titleSmall?.copyWith(fontSize: isMobile ? 12 : 14, color: AppColors.lightGrey200),
                          ),

                          const SizedBox(height: 28),

                          /// 🔹 ACTION BUTTONS
                          isMobile ? _mobileButtons(context) : _desktopButtons(context),

                          const SizedBox(height: 32),

                          /// 🔹 INFO CARD
                          _infoCard(context, isMobile),

                          const SizedBox(height: 40),
                        ],
                      ),
                    ),
                  ),
                ),

                const AppFooter(),
              ],
            ),
          );
        },
      ),
    );
  }
}

Widget _mobileButtons(BuildContext context) {
  return Column(
    children: [
      CustomIconButton(
        text: "View Status",
        onPressed: () => context.go(RouterNames.visaPage),
        color: AppColors.primaryBlue,
        textColor: AppColors.lightBackground,
        height: 48,
        width: double.infinity,
        borderRadius: 8,
        icon: Image.asset(ImageUrl.searchDocumnetIcon, color: AppColors.lightBackground),
      ),
      const SizedBox(height: 12),
      CustomIconButton(
        text: "Back to Home",
        onPressed: () => context.pushReplacement(RouterNames.home),
        color: AppColors.lightBackground,
        textColor: AppColors.blackColor,
        height: 48,
        width: double.infinity,
        borderRadius: 8,
        icon: Image.asset(ImageUrl.homeIcon, color: AppColors.darkBackground, height: 22),
      ),
    ],
  );
}

Widget _desktopButtons(BuildContext context) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      CustomIconButton(
        text: "View Status",
        onPressed: () => context.go(RouterNames.visaPage),
        color: AppColors.primaryBlue,
        textColor: AppColors.lightBackground,
        height: 48,
        width: 180,
        borderRadius: 8,
        icon: Image.asset(ImageUrl.searchDocumnetIcon, color: AppColors.lightBackground),
      ),
      const SizedBox(width: 16),
      CustomIconButton(
        text: "Back to Home",
        onPressed: () => context.pushReplacement(RouterNames.home),
        color: AppColors.lightBackground,
        textColor: AppColors.blackColor,
        height: 48,
        width: 180,
        borderRadius: 8,
        icon: Image.asset(ImageUrl.homeIcon, color: AppColors.darkBackground, height: 22),
      ),
    ],
  );
}

Widget _infoCard(BuildContext context, bool isMobile) {
  return Card(
    elevation: 0,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
      side: BorderSide(color: AppColors.primaryBlue.withValues(alpha: .25), width: 2),
    ),
    child: Padding(
      padding: EdgeInsets.symmetric(horizontal: isMobile ? 16 : 40, vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Image.asset(ImageUrl.clockIcon, height: 22),
              const SizedBox(width: 8),
              Text('What Happens Next?', style: context.titleLarge?.copyWith(fontFamily: FontFamily.outfitSemiBold)),
            ],
          ),
          const SizedBox(height: 16),

          _buildStep(context, 1, 'Application Review', 'Our visa experts will review your application within 24–48 hours.'),
          const SizedBox(height: 16),

          _buildStep(context, 2, 'Embassy Submission', 'We submit your application and notify you by email.'),
          const SizedBox(height: 16),

          _buildStep(context, 3, 'Visa Delivery', 'Your approved visa is delivered within the guaranteed timeline.'),
        ],
      ),
    ),
  );
}

Widget _buildStep(BuildContext context, int number, String title, String desc) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      CircleAvatar(
        radius: 14,
        backgroundColor: AppColors.lightCard,
        child: Text(number.toString(), style: AppTextStyle.outFitMediumStyle),
      ),
      const SizedBox(width: 12),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: context.titleMedium?.copyWith(fontFamily: FontFamily.outfitRegular, fontSize: 14)),
            const SizedBox(height: 4),
            Text(
              desc,
              style: context.titleMedium?.copyWith(fontFamily: FontFamily.outfitLight, fontSize: 12, color: AppColors.lightGrey200),
            ),
          ],
        ),
      ),
    ],
  );
}
