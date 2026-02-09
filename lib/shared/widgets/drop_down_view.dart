import 'package:flutter/material.dart';
import 'package:register_visa_web_app/core/constants/app_color.dart';
import 'package:register_visa_web_app/core/constants/font_family.dart';
import 'package:register_visa_web_app/core/utils/text_theme_extension.dart';

class DropDownView extends StatelessWidget {
  const DropDownView({
    super.key,
    this.title,
    required this.hint,
    required this.items,
    this.style,
    this.titleStyle,
    this.value,
    this.onChanged,
    this.isDisable = false,
  });
  final String hint;
  final List<String> items;
  final TextStyle? style;
  final TextStyle? titleStyle;
  final String? value;
  final String? title;
  final bool isDisable;
  final void Function(String?)? onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null) ...[
          Text(
            title!,
            style:
                titleStyle ??
                context.titleSmall?.copyWith(
                  fontSize: 13.0,
                  fontFamily: FontFamily.outfitRegular,
                  letterSpacing: 0.1,
                ),
          ),
          const SizedBox(height: 8),
        ],
        IgnorePointer(
          ignoring: isDisable,
          child: Container(
            height: 46,
            decoration: BoxDecoration(
              color: isDisable
                  ? AppColors.primaryBlue.withValues(alpha: 0.1)
                  : null,
              border: Border.all(color: AppColors.darkText),
              borderRadius: BorderRadius.circular(10),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                icon: Icon(
                  Icons.keyboard_arrow_down_sharp,
                  color: AppColors.darkSubText,
                  size: 18.0,
                ),
                isExpanded: true,
                style:
                    style ??
                    context.textTheme.bodyMedium!.copyWith(
                      fontFamily: FontFamily.outfitMedium,
                      fontSize: 13,
                    ),
                hint: Text(hint, style: style),
                value: (value != null && items.contains(value)) ? value : null,
                elevation: 1,
                autofocus: false,
                enableFeedback: false,
                focusColor: Colors.transparent,
                dropdownColor: Colors.white,
                underline: const SizedBox(),
                items: items
                    .toSet()
                    .toList()
                    .map(
                      (item) => DropdownMenuItem<String>(
                        value: item,
                        child: Text(item),
                      ),
                    )
                    .toList(),
                onChanged: (selectedValue) {
                  if (selectedValue != null && items.contains(selectedValue)) {
                    onChanged?.call(selectedValue);
                  } else {
                    onChanged?.call(null);
                  }
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}
