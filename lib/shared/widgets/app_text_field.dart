import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:register_visa_web_app/core/constants/app_color.dart';
import 'package:register_visa_web_app/core/constants/font_family.dart';
import 'package:register_visa_web_app/core/utils/text_theme_extension.dart';
import 'package:register_visa_web_app/shared/validation/form_validater.dart';

enum InputFieldType {
  text,
  number,
  email,
  decimal,
  noSpecialCharacter,
  phoneNumber,
  fullName,
}

class AppTextFormField extends StatefulWidget {
  final String? title;
  final String hint;
  final IconData? prefixIcon; // Made optional
  final IconData? suffixIcon; // New optional suffix icon
  final bool isPasswordField;
  final TextEditingController controller;
  final InputFieldType inputType; // Use enum to specify field type
  final bool isFieldRequired;
  final FormFieldValidator<String>? validator;
  final int? maxLines;
  final Function(String)? onChanged;
  final Function()? onTap;
  final int? maxLength;
  final bool isShowCounter;
  final bool isReadOnly;
  final List<TextInputFormatter>? inputFormatters;

  const AppTextFormField({
    super.key,
    required this.title,
    required this.hint,
    this.isFieldRequired = false,
    this.prefixIcon, // Removed required
    this.suffixIcon, // Initialize new parameter
    required this.controller,
    this.isPasswordField = false,
    this.validator,
    this.inputType = InputFieldType.text,
    this.maxLines = 1,
    this.onChanged,
    this.onTap,
    this.maxLength,
    this.isShowCounter = false,
    this.isReadOnly = false,
    this.inputFormatters,
  });

  @override
  State<AppTextFormField> createState() => _AppTextFormFieldState();
}

class _AppTextFormFieldState extends State<AppTextFormField> {
  bool obscure = true;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // determine keyboard type and input formatters based on `inputType`
    TextInputType keyboard = _mapInputTypeToKeyboard(widget.inputType);
    List<TextInputFormatter>? formatters =
        widget.inputFormatters ?? _mapInputTypeToFormatters(widget.inputType);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.title != null) ...[
          Text(
            widget.isFieldRequired ? '${widget.title} *' : widget.title!,
            style: context.titleSmall?.copyWith(
              fontSize: 14.0,
              fontFamily: FontFamily.outfitRegular,
              letterSpacing: 0.1,
            ),
          ),
          const SizedBox(height: 8),
        ],
        TextFormField(
          style: context.titleSmall?.copyWith(
            fontFamily: FontFamily.outfitRegular,
            fontSize: 14,
            color: widget.isReadOnly
                ? AppColors.lightGrey150
                : AppColors.blackColor,
          ),
          onTap: widget.onTap,
          onChanged: widget.onChanged,
          readOnly: widget.isReadOnly,
          controller: widget.controller,
          keyboardType: keyboard,
          inputFormatters: formatters,
          maxLines: widget.maxLines,
          maxLength: widget.maxLength,
          obscureText: widget.isPasswordField ? obscure : false,
          validator: (value) {
            // Custom validator has priority
            if (widget.validator != null) {
              return widget.validator!(value);
            }

            // Required validation
            if (widget.isFieldRequired) {
              final error = FormValidators.required(
                value,
                fieldName: widget.title ?? 'Field',
              );
              if (error != null) return error;
            }

            // Type-based validation
            switch (widget.inputType) {
              case InputFieldType.email:
                return FormValidators.email(value);

              case InputFieldType.number:
                return FormValidators.number(
                  value,
                  fieldName: widget.title ?? 'Number',
                );

              default:
                return null;
            }
          },
          decoration: InputDecoration(
            counterText: '',
            fillColor: Colors.white,
            hintText: widget.hint,
            hintStyle: context.bodyMedium?.copyWith(
              fontFamily: FontFamily.outfitRegular,
              color: AppColors.lightSubText,
              letterSpacing: .1,
            ),
            prefixIcon: widget.prefixIcon != null
                ? Icon(widget.prefixIcon, color: AppColors.lightSubText)
                : null,
            suffixIcon: widget.isPasswordField
                ? IconButton(
                    icon: Icon(
                      obscure ? Icons.visibility_off : Icons.visibility,
                      color: AppColors.lightSubText,
                    ),
                    onPressed: () {
                      setState(() {
                        obscure = !obscure;
                      });
                    },
                  )
                : (widget.suffixIcon != null
                      ? Icon(widget.suffixIcon, color: AppColors.lightSubText)
                      : null), // Add suffix icon
            // 🔲 Borders
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(
                color: AppColors.textFieldBorderColor,
                width: 1.0,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(
                color: AppColors.textFieldBorderColor,
                width: 1.0,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Colors.red, width: 1.4),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Colors.red, width: 1.6),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Colors.red, width: 1.6),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 16,
            ),
          ),
        ),
        if (widget.isShowCounter && widget.maxLength != null)
          Padding(
            padding: const EdgeInsets.only(top: 2),
            child: Align(
              alignment: Alignment.centerRight,
              child: Text(
                '${widget.controller.text.length}/${widget.maxLength}',
                style: context.bodySmall?.copyWith(
                  fontSize: 11,
                  color: AppColors.lightSubText,
                  fontFamily: FontFamily.outfitMedium,
                ),
              ),
            ),
          ),
      ],
    );
  }

  TextInputType _mapInputTypeToKeyboard(InputFieldType t) {
    switch (t) {
      case InputFieldType.fullName:
        return TextInputType.text;
      case InputFieldType.number:
        return TextInputType.number;
      case InputFieldType.phoneNumber:
        return TextInputType.number;
      case InputFieldType.email:
        return TextInputType.emailAddress;
      case InputFieldType.decimal:
        return const TextInputType.numberWithOptions(decimal: true);
      case InputFieldType.noSpecialCharacter:
        return TextInputType.text;
      case InputFieldType.text:
        return TextInputType.text;
    }
  }

  List<TextInputFormatter>? _mapInputTypeToFormatters(InputFieldType t) {
    switch (t) {
      case InputFieldType.fullName:
        // Allow letters, spaces, and require at least 3 characters
        return <TextInputFormatter>[
          FilteringTextInputFormatter.allow(RegExp(r"[a-zA-Z\s]")),
          LengthLimitingTextInputFormatter(40), // Optionally limit max length
        ];
      case InputFieldType.phoneNumber:
        // Allow only digits and limit to 12 digits for mobile number input
        return <TextInputFormatter>[
          FilteringTextInputFormatter.digitsOnly,
          LengthLimitingTextInputFormatter(12),
        ];
      case InputFieldType.number:
        return <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly];
      case InputFieldType.decimal:
        // allow digits and decimal point
        return <TextInputFormatter>[
          FilteringTextInputFormatter.allow(RegExp(r'[0-9\.]')),
        ];
      case InputFieldType.noSpecialCharacter:
        // allow letters, numbers and space only
        return <TextInputFormatter>[
          FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9 ]')),
        ];
      case InputFieldType.email:
      default:
        InputFieldType.text;
    }
    return null;
  }
}
