import 'package:flutter/material.dart';
import 'package:register_visa_web_app/core/constants/app_color.dart';
import 'package:register_visa_web_app/core/constants/app_text_style.dart';
import 'package:register_visa_web_app/core/constants/font_family.dart';
import 'package:register_visa_web_app/core/utils/text_theme_extension.dart';
import 'package:register_visa_web_app/features/static_pages/cookie_policy_page.dart';
import 'package:register_visa_web_app/features/static_pages/privacy_policy_page.dart';
import 'package:register_visa_web_app/features/static_pages/safety_center_page.dart';
import 'package:register_visa_web_app/features/static_pages/terms_of_service_page.dart';
import 'package:register_visa_web_app/features/static_pages/about_us_page.dart';
import 'package:register_visa_web_app/features/static_pages/careers_page.dart';
import 'package:register_visa_web_app/features/static_pages/press_page.dart';
import 'package:register_visa_web_app/features/static_pages/blog_page.dart';
import 'package:register_visa_web_app/features/static_pages/help_center_page.dart';
import 'package:register_visa_web_app/features/static_pages/community_page.dart';

class AppFooter extends StatelessWidget {
  const AppFooter({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 768;

    return Container(
      padding: EdgeInsets.symmetric(
        vertical: isSmallScreen ? 20 : 30,
        horizontal: isSmallScreen ? 10 : 20,
      ),
      color: AppColors.lightCard, // A light grey background for the footer
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: 1200,
          ), // Max width for content
          child: Column(
            children: [
              isSmallScreen
                  ? _buildSmallScreenLayout(context)
                  : _buildLargeScreenLayout(context),

              Divider(color: AppColors.lightGrey),
              const SizedBox(height: 20),
              Text(
                '© 2025 Register Visa. All rights reserved.',
                style: AppTextStyle.outFitRegularStyle.copyWith(
                  color: AppColors.lightSubText,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLargeScreenLayout(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildCompanySection(context),
        _buildSupportSection(context),
        _buildLegalSection(context),
        _buildContactSection(context),
      ],
    );
  }

  Widget _buildSmallScreenLayout(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildCompanySection(context),
        const SizedBox(height: 20),
        _buildSupportSection(context),
        const SizedBox(height: 20),
        _buildLegalSection(context),
        const SizedBox(height: 20),
        _buildContactSection(context),
      ],
    );
  }

  Widget _buildCompanySection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Company',
          style: AppTextStyle.outFitSemiBoldStyle.copyWith(
            color: AppColors.darkTextColor,
            fontSize: 16,
            fontFamily: FontFamily.outfitSemiBold,
          ),
        ),
        const SizedBox(height: 10),
        _buildFooterLink(context, 'About Us', const AboutUsPage()),
        _buildFooterLink(context, 'Careers', const CareersPage()),
        _buildFooterLink(context, 'Press', const PressPage()),
        _buildFooterLink(context, 'Blog', const BlogPage()),
      ],
    );
  }

  Widget _buildSupportSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Support',
          style: AppTextStyle.outFitSemiBoldStyle.copyWith(
            color: AppColors.darkTextColor,
            fontSize: 16,
            fontFamily: FontFamily.outfitSemiBold,
          ),
        ),
        const SizedBox(height: 10),
        _buildFooterLink(context, 'Help Center', const HelpCenterPage()),
        _buildFooterLink(context, 'Safety Center', const SafetyCenterPage()),
        _buildFooterLink(context, 'Community', const CommunityPage()),
      ],
    );
  }

  Widget _buildLegalSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Legal',
          style: AppTextStyle.outFitSemiBoldStyle.copyWith(
            color: AppColors.darkTextColor,
            fontSize: 16,
            fontFamily: FontFamily.outfitSemiBold,
          ),
        ),
        const SizedBox(height: 10),
        _buildFooterLink(context, 'Privacy Policy', const PrivacyPolicyPage()),
        _buildFooterLink(
          context,
          'Terms of Service',
          const TermsOfServicePage(),
        ),
        _buildFooterLink(context, 'Cookie Policy', const CookiePolicyPage()),
      ],
    );
  }

  Widget _buildContactSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Contact',
          style: AppTextStyle.outFitSemiBoldStyle.copyWith(
            color: AppColors.darkTextColor,
            fontSize: 16,
            fontFamily: FontFamily.outfitSemiBold,
          ),
        ),
        const SizedBox(height: 10),
        _buildContactInfo(context, Icons.email, 'register@visa.com'),
        _buildContactInfo(context, Icons.phone, '+1(555) 123-4567'),
        _buildContactInfo(context, Icons.location_on, 'San Francisco, CA'),
      ],
    );
  }

  Widget _buildFooterLink(BuildContext context, String text, Widget page) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: InkWell(
        onTap: () {
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(builder: (context) => page),
          // );
        },
        child: Text(
          text,
          style: context.titleSmall?.copyWith(
            color: AppColors.lightSubText,
            fontSize: 14,
            fontFamily: FontFamily.outfitLight,
          ),
        ),
      ),
    );
  }

  Widget _buildContactInfo(BuildContext context, IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, color: AppColors.lightSubText, size: 16),
          const SizedBox(width: 8),
          Text(
            text,
            style: context.titleSmall?.copyWith(
              color: AppColors.lightSubText,
              fontSize: 14,
              fontFamily: FontFamily.outfitLight,
            ),
          ),
        ],
      ),
    );
  }
}
