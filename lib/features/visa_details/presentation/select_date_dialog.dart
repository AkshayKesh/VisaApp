import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:register_visa_web_app/core/constants/app_color.dart';
import 'package:register_visa_web_app/core/constants/font_family.dart';
import 'package:register_visa_web_app/core/utils/spacing_extension.dart';
import 'package:register_visa_web_app/core/utils/text_theme_extension.dart';
import 'package:register_visa_web_app/core/utils/utils.dart';

import 'package:register_visa_web_app/features/visa_details/domain/visa_details_model.dart';
import 'package:register_visa_web_app/features/visa_details/providers/details_provider.dart';
import 'package:register_visa_web_app/shared/widgets/app_button.dart';
import 'package:register_visa_web_app/shared/widgets/date_widget.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class SelectDateDialog extends ConsumerWidget {
  final ValueChanged<String>? onDateSelected;
  final Function(AvailableDate selectedDate) onContinue;
  final String id;

  const SelectDateDialog({
    super.key,

    this.onDateSelected,
    required this.onContinue,
    required this.id,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 600; // Define small screen for dialog

    return ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: isSmallScreen ? screenWidth * 0.2 : screenWidth * .36,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Select Available Date',
              style: context.titleLarge?.copyWith(
                color: AppColors.darkBackground,
                fontFamily: FontFamily.outfitSemiBold,
                letterSpacing: .1,
              ),
            ),
            5.ht,
            Text(
              'Choose your preferred travel date from the available options',
              style: context.bodyMedium?.copyWith(
                color: AppColors.lightSubText,
                fontFamily: FontFamily.outfitMedium,
              ),
            ),
            20.ht,
            Consumer(
              builder: (context, ref, child) {
                final state = ref.watch(detailsProvider(id));
                List<AvailableDate> availableDates =
                    state.data?.availableDates ?? [];
                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: availableDates.length,
                  itemBuilder: (context, index) {
                    AvailableDate data = availableDates[index];
                    return Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: data.isSelected
                            ? AppColors.primaryBlue
                            : AppColors.gradientStart,
                      ),
                      margin: EdgeInsets.symmetric(vertical: 8),
                      child: DateWidget(
                        onTap: () {
                          ref
                              .read(detailsProvider(id).notifier)
                              .updateDate(data.fromDate);
                        },
                        textColor: data.isSelected
                            ? AppColors.lightBackground
                            : AppColors.darkBackground,
                        date:
                            "${Utils.getMonths(DateTime.parse(data.fromDate).month)} ${Utils.extractDayRange(data.toDate, data.fromDate)}, ${DateTime.parse(data.toDate).year}",
                      ),
                    );
                  },
                );
              },
            ),
            30.ht,
            PrimaryButton(
              text: 'Continue',
              onPressed: () {
                final state = ref
                    .read(detailsProvider(id).notifier)
                    .selectedDate;
                onContinue(state!);
              },
              color: AppColors.primaryBlue,
              textColor: Colors.white,
              height: 4.h,
              borderRadius: 8,
            ),
          ],
        ),
      ),
    );
  }
}
