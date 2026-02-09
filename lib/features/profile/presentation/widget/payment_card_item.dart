import 'package:flutter/material.dart';
import 'package:register_visa_web_app/core/constants/app_color.dart';
import 'package:register_visa_web_app/core/constants/font_family.dart';
import 'package:register_visa_web_app/core/utils/text_theme_extension.dart';
import 'package:register_visa_web_app/features/profile/domain/card_model.dart';

class PaymentCardItem extends StatelessWidget {
  final PaymentCardModel card;
  final Function(PaymentCardModel card)? onCardSelect;
  final bool isFromChckOut;

  const PaymentCardItem({super.key, required this.card, this.onCardSelect, this.isFromChckOut = false});

  @override
  Widget build(BuildContext context) {
    if (!isFromChckOut) {
      card.isSelected = false;
    }
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        if (isFromChckOut) {
          onCardSelect?.call(card);
        }
      },
      child: Container(
        width: 300,
        margin: EdgeInsetsGeometry.symmetric(horizontal: 10),
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(colors: card.isSelected ? [AppColors.primaryBlue, Colors.black] : [Colors.grey.shade50, Colors.grey.shade100]),
          border: Border.all(color: card.isSelected ? AppColors.primaryBlue : AppColors.greyColor, width: card.isSelected ? 2 : 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(Icons.credit_card_outlined, color: card.isSelected ? AppColors.lightBackground : AppColors.primaryBlue, size: 26),
                Text(
                  card.brand,
                  style: context.titleSmall?.copyWith(
                    fontSize: 13,
                    fontFamily: FontFamily.outfitMedium,
                    color: card.isSelected ? AppColors.lightBackground : AppColors.lightSubText,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            /// CARD NUMBER
            Text(
              "**** **** **** ${card.last4}",
              style: context.titleSmall?.copyWith(
                fontSize: 18,
                letterSpacing: 2,
                fontFamily: FontFamily.outfitSemiBold,
                color: card.isSelected ? AppColors.lightBackground : AppColors.darkCard,
              ),
            ),
            const SizedBox(height: 15),
            Row(
              children: [
                Expanded(
                  child: TitleAndSubTitleTextWidget(title: "Card Holder", subTitle: card.holderName, isSelected: card.isSelected),
                ),
                TitleAndSubTitleTextWidget(title: "Expires", subTitle: "${card.expMonth}/${card.expYear.toString()}", isSelected: card.isSelected),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class TitleAndSubTitleTextWidget extends StatelessWidget {
  TitleAndSubTitleTextWidget({
    super.key,
    required this.title,
    required this.subTitle,
    this.titleTextStyle,
    this.subTextStyle,
    this.isSelected = false,
  });
  final String title;
  final String subTitle;
  final TextStyle? titleTextStyle;
  final TextStyle? subTextStyle;
  bool isSelected;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style:
              titleTextStyle ??
              context.titleMedium?.copyWith(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                fontFamily: FontFamily.outfitMedium,
                color: isSelected ? AppColors.lightBackground : AppColors.lightSubText,
              ),
        ),
        // SizedBox(height: 2),
        Text(
          subTitle,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style:
              subTextStyle ??
              context.titleMedium?.copyWith(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                fontFamily: FontFamily.outfitSemiBold,
                color: isSelected ? AppColors.lightBackground : AppColors.blackColor,
              ),
        ),
      ],
    );
  }
}
