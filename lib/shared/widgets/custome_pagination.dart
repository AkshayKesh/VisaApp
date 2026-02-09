import 'package:flutter/material.dart';
import 'package:register_visa_web_app/core/constants/app_color.dart';
import 'package:register_visa_web_app/core/constants/font_family.dart';
import 'package:register_visa_web_app/core/utils/text_theme_extension.dart';


class CustomPagination extends StatelessWidget {
  final int currentPage;
  final int pageSize;
  final int totalItems;
  final VoidCallback onPrevious;
  final VoidCallback onNext;

  const CustomPagination({
    super.key,
    required this.currentPage,
    required this.pageSize,
    required this.totalItems,
    required this.onPrevious,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    final int totalPages = (totalItems / pageSize).ceil();
    final int start = ((currentPage - 1) * pageSize) + 1;
    final int end = (currentPage * pageSize) > totalItems
        ? totalItems
        : currentPage * pageSize;

    return Row(
      children: [
        /// Left text
        Text(
          "Showing $start to $end of $totalItems entries",
          style: context.titleMedium?.copyWith(
            fontSize: 14.0,
            fontFamily: FontFamily.outfitMedium,
            color: AppColors.greyColor,
          ),
        ),

        const Spacer(),

        /// Pagination controls
        Row(
          children: [
            _iconButton(
              icon: Icons.chevron_left,
              enabled: currentPage > 1,
              onTap: onPrevious,
            ),
            const SizedBox(width: 12),
            Text(
              "Page $currentPage of $totalPages",
              style: context.titleMedium?.copyWith(
                fontSize: 14.0,
                fontFamily: FontFamily.outfitSemiBold,
                color: AppColors.blackColor,
              ),
            ),
            const SizedBox(width: 12),
            _iconButton(
              icon: Icons.chevron_right,
              enabled: currentPage < totalPages,
              onTap: onNext,
            ),
          ],
        ),
      ],
    );
  }

  Widget _iconButton({
    required IconData icon,
    required bool enabled,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: enabled ? onTap : null,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Icon(
          icon,
          size: 20,
          color: enabled ? AppColors.blackColor : AppColors.greyColor,
        ),
      ),
    );
  }
}
