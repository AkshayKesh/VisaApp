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

class StepFamilyDetails extends ConsumerStatefulWidget {
  const StepFamilyDetails({super.key});

  @override
  ConsumerState<StepFamilyDetails> createState() => _StepFamilyDetailsState();
}

const String _latinHelper = 'Enter their name using Latin characters (A-Z).';

class _StepFamilyDetailsState extends ConsumerState<StepFamilyDetails> {
  String? _parentsDetails;
  final _fatherNameController = TextEditingController();
  final _motherNameController = TextEditingController();
  String? _fatherNationality;
  String? _fatherCountryOfBirth;
  String? _motherNationality;
  String? _motherCountryOfBirth;

  void _syncToState() {
    final showFather = _showFather;
    final showMother = _showMother;
    ref
        .read(evisaApplicationProvider.notifier)
        .setPersonDetails(
          PersonDetails(
            parentsDetailsOption: _parentsDetails,
            fatherFullName: showFather ? (_fatherNameController.text.trim().isEmpty ? null : _fatherNameController.text.trim()) : null,
            fatherNationality: showFather ? _fatherNationality : null,
            fatherCountryBirth: showFather ? _fatherCountryOfBirth : null,
            motherFullName: showMother ? (_motherNameController.text.trim().isEmpty ? null : _motherNameController.text.trim()) : null,
            motherNationality: showMother ? _motherNationality : null,
            motherCountryBirth: showMother ? _motherCountryOfBirth : null,
          ),
        );
  }

  bool get _showFather => _parentsDetails == 'Yes, both parents' || _parentsDetails == 'Only my father';
  bool get _showMother => _parentsDetails == 'Yes, both parents' || _parentsDetails == 'Only my mother';

  @override
  void initState() {
    super.initState();
    _fatherNameController.addListener(_syncToState);
    _motherNameController.addListener(_syncToState);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final p = ref.read(evisaApplicationProvider).personDetails;
      if (p != null) {
        if (p.parentsDetailsOption != null) setState(() => _parentsDetails = p.parentsDetailsOption);
        if (p.fatherFullName != null) _fatherNameController.text = p.fatherFullName!;
        if (p.fatherNationality != null) setState(() => _fatherNationality = p.fatherNationality);
        if (p.fatherCountryBirth != null) setState(() => _fatherCountryOfBirth = p.fatherCountryBirth);
        if (p.motherFullName != null) _motherNameController.text = p.motherFullName!;
        if (p.motherNationality != null) setState(() => _motherNationality = p.motherNationality);
        if (p.motherCountryBirth != null) setState(() => _motherCountryOfBirth = p.motherCountryBirth);
      }
    });
  }

  @override
  void dispose() {
    _fatherNameController.removeListener(_syncToState);
    _motherNameController.removeListener(_syncToState);
    _fatherNameController.dispose();
    _motherNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const options = ['Yes, both parents', 'Only my mother', 'Only my father', "No, I don't have information about either"];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Can you give details about your parents?',
          style: context.titleSmall?.copyWith(fontSize: 14, fontFamily: FontFamily.outfitRegular, color: AppColors.darkTextColor),
        ),
        12.ht,
        ...options.map(
          (label) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: _buildRadioOption(label, _parentsDetails == label, () {
              setState(() => _parentsDetails = label);
              _syncToState();
            }),
          ),
        ),
        if (_showFather) ...[
          24.ht,
          _buildLabel("Father's first and last name"),
          8.ht,
          _buildTextField(controller: _fatherNameController, hint: ''),
          _buildLearnMore(_latinHelper),

          8.ht,
          AppCustomDropdown<String>(
            title: "Father's nationality",
            hint: 'Select country',
            maxHeight: 180,
            value: countryFromName(_fatherNationality),
            itemLabel: (v) => v,
            onChanged: (c) {
              setState(() => _fatherNationality = c.name);
              _syncToState();
            },
          ),
          24.ht,

          AppCustomDropdown<String>(
            title: "Father's country of birth",
            hint: 'Select country',
            maxHeight: 180,
            value: countryFromName(_fatherCountryOfBirth),
            itemLabel: (v) => v,
            onChanged: (c) {
              setState(() => _fatherCountryOfBirth = c.name);
              _syncToState();
            },
          ),
        ],
        if (_showMother) ...[
          24.ht,
          _buildLabel("Mother's first and last name"),
          8.ht,
          _buildTextField(controller: _motherNameController, hint: ''),
          _buildLearnMore(_latinHelper),
          24.ht,

          AppCustomDropdown<String>(
            title: "Mother's nationality",
            hint: 'Select country',
            maxHeight: 180,
            value: countryFromName(_motherNationality),
            itemLabel: (v) => v,
            onChanged: (c) {
              setState(() => _motherNationality = c.name);
              _syncToState();
            },
          ),
          24.ht,

          AppCustomDropdown<String>(
            title: "Mother's country of birth",
            hint: 'Select country',
            maxHeight: 180,
            value: countryFromName(_motherCountryOfBirth),
            itemLabel: (v) => v,
            onChanged: (c) {
              setState(() => _motherCountryOfBirth = c.name);
              _syncToState();
            },
          ),
        ],
      ],
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: context.titleSmall?.copyWith(fontSize: 14, fontFamily: FontFamily.outfitRegular, color: AppColors.darkTextColor),
    );
  }

  Widget _buildLearnMore(String helperText) {
    return Padding(
      padding: const EdgeInsets.only(top: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () {},
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.info_outline, size: 16, color: AppColors.primaryBlue),
                const SizedBox(width: 4),
                Text(
                  'Learn More',
                  style: context.bodySmall?.copyWith(color: AppColors.primaryBlue, fontFamily: FontFamily.outfitMedium, fontSize: 12),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              helperText,
              style: context.bodySmall?.copyWith(color: AppColors.lightSubText, fontFamily: FontFamily.outfitRegular, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({required TextEditingController controller, required String hint}) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.lightBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.textFieldBorderColor),
      ),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          hintText: hint.isEmpty ? null : hint,
          hintStyle: context.bodyMedium?.copyWith(color: AppColors.lightSubText, fontFamily: FontFamily.outfitRegular),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
        style: context.bodyMedium?.copyWith(fontFamily: FontFamily.outfitRegular, color: AppColors.darkTextColor),
      ),
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
