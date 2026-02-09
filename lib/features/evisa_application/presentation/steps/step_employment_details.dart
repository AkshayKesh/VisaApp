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

class StepEmploymentDetails extends ConsumerStatefulWidget {
  const StepEmploymentDetails({super.key});

  @override
  ConsumerState<StepEmploymentDetails> createState() => _StepEmploymentDetailsState();
}

class _StepEmploymentDetailsState extends ConsumerState<StepEmploymentDetails> {
  String? _employmentStatus;
  String? _militaryPolice;
  final _employerNameController = TextEditingController();
  final _employerAddressController = TextEditingController();
  final _employerCityController = TextEditingController();
  final _employerStateController = TextEditingController();
  final _employerZipController = TextEditingController();
  String? _employerCountry;

  void _syncToState() {
    final isStudent = _employmentStatus == 'Student';
    ref
        .read(evisaApplicationProvider.notifier)
        .setPersonDetails(
          PersonDetails(
            employmentStatus: _employmentStatus,
            employeeName: _employerNameController.text.trim().isEmpty ? null : _employerNameController.text.trim(),
            employeeAddress: _employerAddressController.text.trim().isEmpty ? null : _employerAddressController.text.trim(),
            universityName: isStudent ? (_employerNameController.text.trim().isEmpty ? null : _employerNameController.text.trim()) : null,
            universityAddress: isStudent ? (_employerAddressController.text.trim().isEmpty ? null : _employerAddressController.text.trim()) : null,
            city: (showOrgFields ? (_employerCityController.text.trim().isEmpty ? null : _employerCityController.text.trim()) : null),
            state: (showOrgFields ? (_employerStateController.text.trim().isEmpty ? null : _employerStateController.text.trim()) : null),
            zipCode: (showOrgFields ? (_employerZipController.text.trim().isEmpty ? null : _employerZipController.text.trim()) : null),
            policeOrMilitary: _militaryPolice == null ? null : _militaryPolice == 'Yes',
          ),
        );
  }

  bool get showOrgFields => _employmentStatus == 'Employed' || _employmentStatus == 'Student';

  @override
  void initState() {
    super.initState();
    _employerNameController.addListener(_syncToState);
    _employerAddressController.addListener(_syncToState);
    _employerCityController.addListener(_syncToState);
    _employerStateController.addListener(_syncToState);
    _employerZipController.addListener(_syncToState);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final p = ref.read(evisaApplicationProvider).personDetails;
      if (p != null) {
        if (p.employmentStatus != null) setState(() => _employmentStatus = p.employmentStatus);
        if (p.policeOrMilitary != null) setState(() => _militaryPolice = p.policeOrMilitary! ? 'Yes' : 'No');
        if (p.employmentStatus == 'Student') {
          if (p.universityName != null) _employerNameController.text = p.universityName!;
          if (p.universityAddress != null) _employerAddressController.text = p.universityAddress!;
        } else {
          if (p.employeeName != null) _employerNameController.text = p.employeeName!;
          if (p.employeeAddress != null) _employerAddressController.text = p.employeeAddress!;
        }
        if (p.city != null) _employerCityController.text = p.city!;
        if (p.state != null) _employerStateController.text = p.state!;
        if (p.zipCode != null) _employerZipController.text = p.zipCode!;
      }
    });
  }

  @override
  void dispose() {
    _employerNameController.removeListener(_syncToState);
    _employerAddressController.removeListener(_syncToState);
    _employerCityController.removeListener(_syncToState);
    _employerStateController.removeListener(_syncToState);
    _employerZipController.removeListener(_syncToState);
    _employerNameController.dispose();
    _employerAddressController.dispose();
    _employerCityController.dispose();
    _employerStateController.dispose();
    _employerZipController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isStudent = _employmentStatus == 'Student';
    final nameLabel = isStudent ? 'University Name' : "Employer's name";
    final addressLabel = isStudent ? 'University Address' : "What's your employer's address?";
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Employment status',
          style: context.titleSmall?.copyWith(fontSize: 14, fontFamily: FontFamily.outfitSemiBold, color: AppColors.darkTextColor),
        ),
        12.ht,
        _buildRadioOption('Employed', _employmentStatus == 'Employed', () {
          setState(() => _employmentStatus = 'Employed');
          _syncToState();
        }),
        8.ht,
        _buildRadioOption('Unemployed', _employmentStatus == 'Unemployed', () {
          setState(() => _employmentStatus = 'Unemployed');
          _syncToState();
        }),
        8.ht,
        _buildRadioOption('Student', _employmentStatus == 'Student', () {
          setState(() => _employmentStatus = 'Student');
          _syncToState();
        }),
        8.ht,
        _buildRadioOption('Retired', _employmentStatus == 'Retired', () {
          setState(() => _employmentStatus = 'Retired');
          _syncToState();
        }),
        if (showOrgFields) ...[
          24.ht,
          _buildLabel(nameLabel),
          8.ht,
          _buildTextField(controller: _employerNameController, hint: nameLabel),
          24.ht,
          _buildLabel(addressLabel),
          8.ht,
          _buildTextField(
            controller: _employerAddressController,
            hint: isStudent ? 'University address' : '1234 Sesame St. Ste. 100, Springtown, IL 55555',
          ),
          24.ht,
          _buildLabel('City or town'),
          8.ht,
          _buildTextField(controller: _employerCityController, hint: ''),
          24.ht,
          _buildLabel('State or province'),
          8.ht,
          _buildTextField(controller: _employerStateController, hint: ''),
          24.ht,

          AppCustomDropdown<String>(
            title: 'Country',
            hint: 'Select country',
            maxHeight: 180,
            value: countryFromName(_employerCountry),
            itemLabel: (v) => v,
            onChanged: (c) {
              setState(() => _employerCountry = c.name);
              _syncToState();
            },
          ),
          24.ht,
          _buildLabel('ZIP or postcode'),
          8.ht,
          _buildTextField(controller: _employerZipController, hint: ''),
        ],
        24.ht,
        Text(
          'Have you served in the military or police?',
          style: context.titleSmall?.copyWith(fontSize: 14, fontFamily: FontFamily.outfitRegular, color: AppColors.darkTextColor),
        ),
        12.ht,
        Row(
          children: [
            Expanded(
              child: _buildRadioOption('Yes', _militaryPolice == 'Yes', () {
                setState(() => _militaryPolice = 'Yes');
                _syncToState();
              }),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildRadioOption('No', _militaryPolice == 'No', () {
                setState(() => _militaryPolice = 'No');
                _syncToState();
              }),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: context.titleSmall?.copyWith(fontSize: 14, fontFamily: FontFamily.outfitRegular, color: AppColors.darkTextColor),
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
}
