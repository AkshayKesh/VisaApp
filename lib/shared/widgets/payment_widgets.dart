import 'package:flutter/material.dart';
import 'package:register_visa_web_app/core/constants/app_color.dart';
import 'package:register_visa_web_app/core/constants/font_family.dart';
import 'package:register_visa_web_app/core/constants/image_url.dart';
import 'package:register_visa_web_app/core/utils/spacing_extension.dart';
import 'package:register_visa_web_app/core/utils/text_theme_extension.dart';
import 'package:register_visa_web_app/features/payment/domain/visa_option.dart';
import 'package:register_visa_web_app/shared/widgets/app_text_field.dart';

import 'package:register_visa_web_app/shared/widgets/date_widget.dart';

class PaymentFormCard extends StatelessWidget {
  const PaymentFormCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.lightBackground, // Background for tile
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.textFieldBorderColor),
      ),

      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Card Information',
              style: context.titleLarge?.copyWith(
                fontFamily: FontFamily.outfitBold,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: AppTextFormField(
                    title: "First Name",
                    controller: TextEditingController(),
                    hint: 'First Name',
                    isFieldRequired: true,
                    inputType: InputFieldType.text,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: AppTextFormField(
                    title: "Last Name",
                    controller: TextEditingController(),
                    hint: 'First Name',
                    isFieldRequired: true,
                    inputType: InputFieldType.text,
                  ),
                ),
              ],
            ),
            20.ht,
            AppTextFormField(
              title: "Card Number",
              controller: TextEditingController(),
              hint: 'Card Number',
              isFieldRequired: true,
              inputType: InputFieldType.number,
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: DateWidget(title: "Expiry Date", date: ''),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: AppTextFormField(
                    title: "CVV",
                    controller: TextEditingController(),
                    hint: 'CVV',
                    isFieldRequired: true,
                    inputType: InputFieldType.number,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class PaymentSelectCard extends StatefulWidget {
  const PaymentSelectCard({super.key});

  @override
  State<PaymentSelectCard> createState() => _PaymentSelectCardState();
}

class _PaymentSelectCardState extends State<PaymentSelectCard> {
  int selectedIndex = 0;
  int selectedId = 0;

  final List<VisaOption> cards = [
    VisaOption(id: 0, title: 'Rigister Visa', number: '1234 5678 9015 6585'),
    VisaOption(id: 1, title: 'Rigister', number: '789 456 123 0852'),
  ];
  @override
  void initState() {
    super.initState();
    selectedId = cards.first.id; // default selection
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.lightBackground, // Background for tile
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.textFieldBorderColor),
      ),

      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Image.asset(ImageUrl.personIcon, height: 20),
                8.wt,
                Text(
                  'Select Card',
                  style: context.titleLarge?.copyWith(
                    fontFamily: FontFamily.outfitBold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ...cards.map((item) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: SelectableVisaCard(
                  title: item.title,
                  subtitle: item.number,
                  isSelected: selectedId == item.id,
                  onTap: () {
                    setState(() => selectedId = item.id);
                  },
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}

class SelectableVisaCard extends StatelessWidget {
  final bool isSelected;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const SelectableVisaCard({
    super.key,
    required this.isSelected,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.lightGrey, width: 1.5),
        ),
        child: Row(
          children: [
            Icon(
              isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
              color: isSelected ? AppColors.primaryBlue : AppColors.lightGrey,
              size: 20,
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppColors.darkTextColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(fontSize: 14, color: AppColors.lightSubText),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
