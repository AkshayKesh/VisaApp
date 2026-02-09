import 'package:flutter/material.dart';
import 'package:register_visa_web_app/core/constants/app_color.dart';
import 'package:register_visa_web_app/core/constants/font_family.dart';
import 'package:register_visa_web_app/core/utils/spacing_extension.dart';
import 'package:register_visa_web_app/core/utils/text_theme_extension.dart';
import 'package:register_visa_web_app/core/utils/utils.dart';

class Header extends StatelessWidget {
  const Header({
    super.key,
    required this.context,
    required this.isSmallScreen,
    required this.data,
  });
  final BuildContext context;
  final bool isSmallScreen;
  final Map<String, dynamic> data;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.lightBackground, // A light background for the header
        border: Border(bottom: BorderSide(color: AppColors.lightBackground)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            '${DateTime.now().day} ${Utils.getMonths(DateTime.now().month)}, ${DateTime.now().hour}:${DateTime.now().minute.toString().padLeft(2, '0')} ${DateTime.now().hour >= 12 ? 'PM' : 'AM'}',
            style: context.headlineMedium?.copyWith(
              color: AppColors.darkTextColor,
              fontFamily: FontFamily.outfitExtraBold,
            ),
          ),
          20.ht,
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.darkTextColor),
                ),
                child: Icon(
                  Icons.edit_outlined,
                  color: AppColors.lightSubText,
                  size: 20,
                ),
              ),
              20.wt,
              Column(
                children: [
                  Text(
                    'Valid From',
                    style: context.bodyMedium?.copyWith(
                      color: AppColors.lightSubText,
                      fontFamily: FontFamily.outfitMedium,
                    ),
                  ),
                  5.ht,
                  Text(
                    '${Utils.getMonths(DateTime.parse(data['startDate']).month)} ${DateTime.parse(data['startDate']).day} ${DateTime.parse(data['startDate']).year}',
                    style: context.bodyMedium?.copyWith(
                      color: AppColors.darkTextColor,
                      fontFamily: FontFamily.outfitBold,
                    ),
                  ),
                ],
              ),
              20.wt,
              Text('--------------'),
              Icon(
                Icons.flight_takeoff,
                color: AppColors.darkBackground,
                size: 20,
              ),
              Text('--------------'),
              20.wt,
              Column(
                children: [
                  Text(
                    'Valid Till',
                    style: context.bodyMedium?.copyWith(
                      color: AppColors.lightSubText,
                      fontFamily: FontFamily.outfitMedium,
                    ),
                  ),
                  5.ht,
                  Text(
                    '${Utils.getMonths(DateTime.parse(data['endDate']).month)} ${DateTime.parse(data['endDate']).day} ${DateTime.parse(data['endDate']).year}',
                    style: context.bodyMedium?.copyWith(
                      color: AppColors.darkBackground,
                      fontFamily: FontFamily.outfitBold,
                    ),
                  ),
                ],
              ),
            ],
          ),
          20.ht,
          Container(
            width: 300,
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            decoration: BoxDecoration(
              color: AppColors.grey,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.network(
                  data['coverPhoto'],
                  height: 40,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(
                      Icons.flag,
                      size: 40,
                      color: AppColors.lightSubText,
                    );
                  },
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return const SizedBox(
                      height: 40,
                      width: 40,
                      child: CircularProgressIndicator(),
                    );
                  },
                ), // Placeholder flag
                10.wt,
                Text(
                  '${data['country']}',
                  style: context.titleMedium?.copyWith(
                    color: AppColors.darkBackground,
                    fontFamily: FontFamily.outfitSemiBold,
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
