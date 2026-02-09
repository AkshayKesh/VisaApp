import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:register_visa_web_app/core/constants/app_color.dart';
import 'package:register_visa_web_app/core/constants/country_list.dart';
import 'package:register_visa_web_app/core/constants/font_family.dart';
import 'package:register_visa_web_app/core/utils/spacing_extension.dart';
import 'package:register_visa_web_app/core/utils/text_theme_extension.dart';
import 'package:register_visa_web_app/features/evisa_application/providers/evisa_application_provider.dart';
import 'package:register_visa_web_app/features/evisa_application/providers/evisa_application_state.dart';
import 'package:register_visa_web_app/shared/widgets/app_drop_down.dart';

class StepHomeAddressDetails extends ConsumerStatefulWidget {
  const StepHomeAddressDetails({super.key});

  @override
  ConsumerState<StepHomeAddressDetails> createState() => _StepHomeAddressDetailsState();
}

class _StepHomeAddressDetailsState extends ConsumerState<StepHomeAddressDetails> {
  String? _countryOfResidence;
  final _homeAddressController = TextEditingController();
  final _cityController = TextEditingController();
  final _stateController = TextEditingController();
  final _zipController = TextEditingController();

  void _syncToState() {
    ref
        .read(evisaApplicationProvider.notifier)
        .setPersonDetails(
          PersonDetails(
            residenceCountry: _countryOfResidence,
            homeAddress: _homeAddressController.text.trim().isEmpty ? null : _homeAddressController.text.trim(),
            homeCity: _cityController.text.trim().isEmpty ? null : _cityController.text.trim(),
            homeState: _stateController.text.trim().isEmpty ? null : _stateController.text.trim(),
            homeZip: _zipController.text.trim().isEmpty ? null : _zipController.text.trim(),
          ),
        );
  }

  @override
  void initState() {
    super.initState();
    _homeAddressController.addListener(_syncToState);
    _cityController.addListener(_syncToState);
    _stateController.addListener(_syncToState);
    _zipController.addListener(_syncToState);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final p = ref.read(evisaApplicationProvider).personDetails;
      if (p != null) {
        if (p.residenceCountry != null) setState(() => _countryOfResidence = p.residenceCountry);
        if (p.homeAddress != null) _homeAddressController.text = p.homeAddress!;
        if (p.homeCity != null) _cityController.text = p.homeCity!;
        if (p.homeState != null) _stateController.text = p.homeState!;
        if (p.homeZip != null) _zipController.text = p.homeZip!;
      }
    });
  }

  @override
  void dispose() {
    _homeAddressController.removeListener(_syncToState);
    _cityController.removeListener(_syncToState);
    _stateController.removeListener(_syncToState);
    _zipController.removeListener(_syncToState);
    _homeAddressController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _zipController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        8.ht,
        AppCustomDropdown<String>(
          title: 'Country of residence',
          hint: 'Select country',
          maxHeight: 180,
          value: countryFromName(_countryOfResidence),
          itemLabel: (v) => v,
          onChanged: (c) {
            setState(() => _countryOfResidence = c.name);
            _syncToState();
          },
        ),
        const SizedBox(height: 6),
        _buildHelper('Select the country where you live permanently, not temporarily.'),
        24.ht,
        _buildLabel("What's your home address?"),
        8.ht,
        _buildTextField(controller: _homeAddressController, hint: '1234 Sesame St. Apt. 3, Springtown, IL 55555', onChanged: _syncToState),
        const SizedBox(height: 6),
        _buildHelper('The address must be in the country where you live.'),
        24.ht,
        _buildLabel('City or town'),
        8.ht,
        _buildTextField(controller: _cityController, hint: '', onChanged: _syncToState),
        24.ht,
        _buildLabel('State or province'),
        8.ht,
        _buildTextField(controller: _stateController, hint: '', onChanged: _syncToState),
        24.ht,
        _buildLabel('ZIP or postcode'),
        8.ht,
        _buildTextField(
          controller: _zipController,
          hint: '',
          onChanged: _syncToState,
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(8),
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

  Widget _buildHelper(String text) {
    return Text(
      text,
      style: context.bodySmall?.copyWith(color: AppColors.lightSubText, fontFamily: FontFamily.outfitRegular, fontSize: 12),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    VoidCallback? onChanged,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.lightBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.textFieldBorderColor),
      ),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        inputFormatters: inputFormatters,
        onChanged: onChanged != null ? (_) => onChanged() : null,
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
