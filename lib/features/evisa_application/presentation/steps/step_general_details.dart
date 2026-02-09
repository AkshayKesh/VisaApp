import 'package:country_pickers/country.dart';
import 'package:country_pickers/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:register_visa_web_app/core/constants/country_list.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:register_visa_web_app/core/constants/app_color.dart';
import 'package:register_visa_web_app/core/constants/font_family.dart';
import 'package:register_visa_web_app/core/utils/spacing_extension.dart';
import 'package:register_visa_web_app/core/utils/text_theme_extension.dart';
import 'package:register_visa_web_app/features/evisa_application/providers/evisa_application_provider.dart';

class StepGeneralDetails extends ConsumerStatefulWidget {
  const StepGeneralDetails({super.key});

  @override
  ConsumerState<StepGeneralDetails> createState() => _StepGeneralDetailsState();
}

class _StepGeneralDetailsState extends ConsumerState<StepGeneralDetails> {
  final _phoneController = TextEditingController(text: '');
  final _countryKey = GlobalKey();
  String? _whatsAppSms;
  String? _religion;
  Country _selectedCountry = CountryPickerUtils.getCountryByIsoCode('US');

  void _syncToState() {
    final number = _phoneController.text.trim();
    final full = number.isEmpty ? null : '${_selectedCountry.phoneCode}$number';
    ref
        .read(evisaApplicationProvider.notifier)
        .setTripDetails(
          phoneNumber: full,
          updatesOn: _whatsAppSms,
          religion: _religion,
        );
  }

  @override
  void initState() {
    super.initState();
    _phoneController.addListener(_syncToState);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final s = ref.read(evisaApplicationProvider);
      if (s.phoneNumber != null && s.phoneNumber!.isNotEmpty) {
        _applyPhoneFromState(s.phoneNumber!);
      }
      if (s.updatesOn != null) setState(() => _whatsAppSms = s.updatesOn);
      if (s.religion != null) setState(() => _religion = s.religion);
    });
  }

  void _applyPhoneFromState(String full) {
    final digits = full.replaceAll(RegExp(r'\D'), '');
    if (digits.isEmpty) return;
    Country? matched;
    int codeLen = 0;
    for (final iso in ['US', 'GB', 'IN', 'CA', 'AU', 'AE', 'SA', 'DE', 'FR', 'CN', 'JP', 'SG', 'MY', 'PK', 'BD', 'NG', 'EG', 'ZA', 'BR', 'MX', 'AR', 'RU', 'IT', 'ES', 'NL', 'PL', 'TR']) {
      final c = CountryPickerUtils.getCountryByIsoCode(iso);
      if (c.phoneCode.isNotEmpty && digits.startsWith(c.phoneCode) && c.phoneCode.length > codeLen) {
        matched = c;
        codeLen = c.phoneCode.length;
      }
    }
    if (matched != null && codeLen > 0) {
      setState(() => _selectedCountry = matched!);
      _phoneController.text = digits.substring(codeLen);
    } else {
      _phoneController.text = digits;
    }
  }

  @override
  void dispose() {
    _phoneController.removeListener(_syncToState);
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Phone number',
          style: context.titleSmall?.copyWith(fontSize: 14, fontFamily: FontFamily.outfitRegular, color: AppColors.darkTextColor),
        ),
        8.ht,
        Container(
          decoration: BoxDecoration(
            color: AppColors.lightBackground,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.textFieldBorderColor),
          ),
          child: Row(
            children: [
              GestureDetector(
                key: _countryKey,
                onTap: () async {
                  final list = allCountryList
                      .map((c) => CountryPickerUtils.getCountryByIsoCode(c.isoCode))
                      .where((c) => c.phoneCode.isNotEmpty)
                      .toList()
                    ..sort((a, b) => a.name.compareTo(b.name));
                  final box = _countryKey.currentContext?.findRenderObject() as RenderBox?;
                  if (box == null || !mounted) return;
                  final result = await showMenu<Country>(
                    context: context,
                    position: RelativeRect.fromLTRB(
                      box.localToGlobal(Offset.zero).dx,
                      box.localToGlobal(Offset.zero).dy + box.size.height,
                      box.localToGlobal(Offset.zero).dx + 280,
                      box.localToGlobal(Offset.zero).dy + box.size.height + 300,
                    ),
                    items: list
                        .map(
                          (c) => PopupMenuItem<Country>(
                            value: c,
                            child: Row(
                              children: [
                                CountryPickerUtils.getDefaultFlagImage(c),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    '+${c.phoneCode} (${c.name})',
                                    style: context.bodyMedium?.copyWith(
                                      fontFamily: FontFamily.outfitRegular,
                                      color: AppColors.darkTextColor,
                                      fontSize: 12,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                        .toList(),
                  );
                  if (result != null && mounted) {
                    setState(() => _selectedCountry = result);
                    _syncToState();
                  }
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '+${_selectedCountry.phoneCode}',
                        style: context.bodyMedium?.copyWith(
                          fontFamily: FontFamily.outfitRegular,
                          color: AppColors.darkTextColor,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Icon(Icons.keyboard_arrow_down, size: 20, color: AppColors.lightSubText),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: TextFormField(
                  controller: _phoneController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(15),
                  ],
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    hintText: '',
                  ),
                  style: context.bodyMedium?.copyWith(fontFamily: FontFamily.outfitRegular, color: AppColors.darkTextColor),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 6),
        Text(
          '(310) 359-4053 - mobile',
          style: context.bodySmall?.copyWith(color: AppColors.lightSubText, fontFamily: FontFamily.outfitRegular, fontSize: 12),
        ),
        24.ht,
        Text(
          'Do you want WhatsApp or SMS updates about your application?',
          style: context.titleSmall?.copyWith(fontSize: 14, fontFamily: FontFamily.outfitSemiBold, color: AppColors.darkTextColor),
        ),
        12.ht,
        _buildRadioOption(
          'SMS',
          () => setState(() {
            _whatsAppSms = 'SMS';
            _syncToState();
          }),
        ),
        8.ht,
        _buildRadioOption(
          'WhatsApp',
          () => setState(() {
            _whatsAppSms = 'WhatsApp';
            _syncToState();
          }),
        ),
        8.ht,
        _buildRadioOption(
          'Neither',
          () => setState(() {
            _whatsAppSms = 'Neither';
            _syncToState();
          }),
        ),
        24.ht,
        Text(
          'Religion',
          style: context.titleSmall?.copyWith(fontSize: 14, fontFamily: FontFamily.outfitRegular, color: AppColors.darkTextColor),
        ),
        8.ht,
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          decoration: BoxDecoration(
            color: AppColors.lightBackground,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.textFieldBorderColor),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _religion,
              isExpanded: true,
              hint: Text(
                'Select religion',
                style: context.bodyMedium?.copyWith(color: AppColors.lightSubText, fontFamily: FontFamily.outfitRegular),
              ),
              icon: Icon(Icons.keyboard_arrow_down, color: AppColors.lightSubText),
              items: ['Hinduism', 'Islam', 'Christianity', 'Sikhism', 'Other']
                  .map(
                    (e) => DropdownMenuItem(
                      value: e,
                      child: Text(
                        e,
                        style: TextStyle(fontSize: 12, fontFamily: FontFamily.outfitRegular, color: AppColors.darkTextColor),
                      ),
                    ),
                  )
                  .toList(),
              onChanged: (v) {
                setState(() => _religion = v);
                _syncToState();
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRadioOption(String label, VoidCallback onTap) {
    final isSelected = _whatsAppSms == label;
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
