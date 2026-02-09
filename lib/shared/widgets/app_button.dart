import 'package:flutter/material.dart';
import 'package:register_visa_web_app/core/constants/app_text_style.dart';

class PrimaryButton extends StatelessWidget {
  final String text; // required label
  final VoidCallback? onPressed;
  final Color color; // Now required
  final Color textColor; // Now required
  final Color? borderColor; // New optional border color
  final double height;
  final double? width;
  final double borderRadius;
  final double horizontalPadding;
  final double spacing; // space between icon and text
  final bool isLoading;

  const PrimaryButton({
    super.key,
    required this.text,
    required this.onPressed,
    required this.color,
    required this.textColor,
    this.borderColor, // Initialize new parameter
    this.height = 56.0,
    this.width,
    this.borderRadius = 28.0,
    this.horizontalPadding = 24.0,
    this.isLoading = false,
    this.spacing = 12.0,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width ?? double.infinity,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: textColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
            side: borderColor != null
                ? BorderSide(color: borderColor!)
                : BorderSide.none,
          ),
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
        ),
        child: isLoading
            ? SizedBox(
                height: height,
                width: width,
                child: CircularProgressIndicator(color: textColor),
              )
            : Text(
                text,
                style: AppTextStyle.buttonTextStyle.copyWith(color: textColor),
              ),
      ),
    );
  }
}
