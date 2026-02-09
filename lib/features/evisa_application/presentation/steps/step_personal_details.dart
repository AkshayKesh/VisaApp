import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:register_visa_web_app/core/constants/app_color.dart';
import 'package:register_visa_web_app/core/constants/country_list.dart';
import 'package:register_visa_web_app/core/constants/font_family.dart';
import 'package:register_visa_web_app/core/utils/spacing_extension.dart';
import 'package:register_visa_web_app/core/utils/text_theme_extension.dart';
import 'package:register_visa_web_app/features/evisa_application/providers/evisa_application_provider.dart';
import 'package:register_visa_web_app/features/evisa_application/providers/evisa_application_state.dart';
import 'package:register_visa_web_app/shared/widgets/app_drop_down.dart';

class StepPersonalDetails extends ConsumerStatefulWidget {
  const StepPersonalDetails({super.key});

  @override
  ConsumerState<StepPersonalDetails> createState() => _StepPersonalDetailsState();
}

class _StepPersonalDetailsState extends ConsumerState<StepPersonalDetails> {
  String? _pakistanAnswer;
  String? _gender;
  String? _countryOfBirth;
  String? _anotherNationality;
  String? _maritalStatus;

  void _syncToState() {
    ref
        .read(evisaApplicationProvider.notifier)
        .setPersonDetails(
          PersonDetails(
            parentsFromPakistan: _pakistanAnswer == 'Yes',
            gender: _gender,
            countryBirth: _countryOfBirth,
            anotherNationality: _anotherNationality == 'Yes',
            maritalStatus: _maritalStatus,
          ),
        );
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final p = ref.read(evisaApplicationProvider).personDetails;
      if (p != null) {
        setState(() {
          _pakistanAnswer = p.parentsFromPakistan == true ? 'Yes' : (p.parentsFromPakistan == false ? 'No' : null);
          _gender = p.gender;
          _countryOfBirth = p.countryBirth;
          _anotherNationality = p.anotherNationality == true ? 'Yes' : (p.anotherNationality == false ? 'No' : null);
          _maritalStatus = p.maritalStatus;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Were your parents or grandparents born in Pakistan, or did they live there permanently?',
          style: context.titleSmall?.copyWith(fontSize: 14, fontFamily: FontFamily.outfitRegular, color: AppColors.darkTextColor),
        ),
        12.ht,
        _buildRadioRow(['Yes', 'No'], _pakistanAnswer, (v) {
          setState(() => _pakistanAnswer = v);
          _syncToState();
        }),
        24.ht,
        Text(
          'Gender',
          style: context.titleSmall?.copyWith(fontSize: 14, fontFamily: FontFamily.outfitRegular, color: AppColors.darkTextColor),
        ),
        12.ht,
        _buildRadioRow(['Male', 'Female'], _gender, (v) {
          setState(() => _gender = v);
          _syncToState();
        }),
        24.ht,

        AppCustomDropdown<String>(
          title: 'Country of birth',
          hint: 'Select country',
          maxHeight: 180,
          value: countryFromName(_countryOfBirth),
          itemLabel: (v) => v,
          onChanged: (c) {
            setState(() => _countryOfBirth = c.name);
            _syncToState();
          },
        ),
        24.ht,
        Text(
          'Do you have another nationality?',
          style: context.titleSmall?.copyWith(fontSize: 14, fontFamily: FontFamily.outfitRegular, color: AppColors.darkTextColor),
        ),
        12.ht,
        _buildRadioRow(['Yes', 'No'], _anotherNationality, (v) {
          setState(() => _anotherNationality = v);
          _syncToState();
        }),
        24.ht,
        Text(
          'Marital status',
          style: context.titleSmall?.copyWith(fontSize: 14, fontFamily: FontFamily.outfitRegular, color: AppColors.darkTextColor),
        ),
        12.ht,
        _buildRadioOption('Married', _maritalStatus == 'Married', () {
          setState(() => _maritalStatus = 'Married');
          _syncToState();
        }),
        8.ht,
        _buildRadioOption('Single', _maritalStatus == 'Single', () {
          setState(() => _maritalStatus = 'Single');
          _syncToState();
        }),
        8.ht,
        _buildRadioOption('Divorced', _maritalStatus == 'Divorced', () {
          setState(() => _maritalStatus = 'Divorced');
          _syncToState();
        }),
        8.ht,
        _buildRadioOption('Widowed', _maritalStatus == 'Widowed', () {
          setState(() => _maritalStatus = 'Widowed');
          _syncToState();
        }),
      ],
    );
  }

  Widget _buildRadioRow(List<String> options, String? value, ValueChanged<String> onSelect) {
    return Row(
      children: options
          .map(
            (label) => Expanded(
              child: Padding(
                padding: EdgeInsets.only(right: label != options.last ? 12 : 0),
                child: _buildRadioOption(label, value == label, () => onSelect(label)),
              ),
            ),
          )
          .toList(),
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
            Expanded(
              child: Text(
                label,
                style: context.bodyMedium?.copyWith(fontFamily: FontFamily.outfitRegular, color: AppColors.darkTextColor),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
