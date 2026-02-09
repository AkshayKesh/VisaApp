import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:register_visa_web_app/core/constants/app_color.dart';
import 'package:register_visa_web_app/core/constants/font_family.dart';
import 'package:register_visa_web_app/core/utils/spacing_extension.dart';
import 'package:register_visa_web_app/core/utils/text_theme_extension.dart';
import 'package:register_visa_web_app/features/evisa_application/providers/evisa_application_provider.dart';
import 'package:register_visa_web_app/features/evisa_application/providers/evisa_application_state.dart';

class StepApplicantTripDetails extends ConsumerStatefulWidget {
  const StepApplicantTripDetails({super.key});

  @override
  ConsumerState<StepApplicantTripDetails> createState() => _StepApplicantTripDetailsState();
}

class _StepApplicantTripDetailsState extends ConsumerState<StepApplicantTripDetails> {
  String? _visitedOtherCountries;

  void _syncToState() {
    ref
        .read(evisaApplicationProvider.notifier)
        .setPersonDetails(PersonDetails(lastSixDayVisitOtherCountry: _visitedOtherCountries == null ? null : _visitedOtherCountries == 'Yes'));
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final p = ref.read(evisaApplicationProvider).personDetails;
      if (p?.lastSixDayVisitOtherCountry != null) {
        setState(() => _visitedOtherCountries = p!.lastSixDayVisitOtherCountry! ? 'Yes' : 'No');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Have you visited other countries or regions in the last 6 days?',
          style: context.titleSmall?.copyWith(fontSize: 14, fontFamily: FontFamily.outfitRegular, color: AppColors.darkTextColor),
        ),
        12.ht,
        Row(
          children: [
            Expanded(
              child: _buildRadioOption('Yes', _visitedOtherCountries == 'Yes', () {
                setState(() => _visitedOtherCountries = 'Yes');
                _syncToState();
              }),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildRadioOption('No', _visitedOtherCountries == 'No', () {
                setState(() => _visitedOtherCountries = 'No');
                _syncToState();
              }),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildRadioOption(String label, bool isSelected, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.lightBackground,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: isSelected ? AppColors.primaryBlue : AppColors.textFieldBorderColor),
        ),
        child: Row(
          children: [
            Icon(
              isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
              size: 22,
              color: isSelected ? AppColors.primaryBlue : AppColors.lightSubText,
            ),
            const SizedBox(width: 12),
            Text(
              label,
              style: context.bodyMedium?.copyWith(fontFamily: FontFamily.outfitRegular, color: AppColors.darkTextColor),
            ),
          ],
        ),
      ),
    );
  }
}
