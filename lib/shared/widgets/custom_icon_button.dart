import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:register_visa_web_app/core/constants/app_color.dart';
import 'package:register_visa_web_app/core/constants/font_family.dart';
import 'package:register_visa_web_app/core/utils/text_theme_extension.dart';

class CustomIconButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final Widget? icon;
  final Widget? trailingIcon;
  final Color? color;
  final Color? textColor;
  final double height;
  final double? width;
  final double borderRadius;
  final double textSize;
  final double iconSize;
  final double spacing;
  final bool isButtonStypeApply;
  final bool disableHoverEffect; // New parameter to disable hover effect
  final double? elevation; // New parameter for elevation
  final bool? buttonState;

  const CustomIconButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.icon,
    this.trailingIcon,
    this.color,
    this.isButtonStypeApply = true,
    this.textColor,
    this.height = 50.0,
    this.width,
    this.borderRadius = 12.0,
    this.textSize = 15.0,
    this.iconSize = 16.0,
    this.buttonState = false,
    this.spacing = 8.0,
    this.disableHoverEffect = false, // Default to false (hover effect enabled)
    this.elevation, // Initialize new parameter
  });

  @override
  Widget build(BuildContext context) {
    final bool isLoading = buttonState ?? false;
    return SizedBox(
      height: height,
      width: width,
      child: ElevatedButton(
        onPressed: isLoading ? CupertinoActivityIndicator.new : onPressed,
        style: isButtonStypeApply
            ? ElevatedButton.styleFrom(
                backgroundColor:
                    color ?? AppColors.primaryBlue, // Default to primaryBlue
                foregroundColor: textColor ?? Colors.white, // Default to white
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(borderRadius),
                ),
                padding: EdgeInsets.symmetric(horizontal: 10),
                // .zero, // Remove default padding to control with Row spacing
                visualDensity:
                    VisualDensity.compact, // Reduce space around content
                overlayColor: disableHoverEffect
                    ? Colors.transparent
                    : null, // Disable/enable hover effect
                elevation: disableHoverEffect
                    ? 0.0
                    : elevation, // Apply elevation, disable on hover
              )
            : ElevatedButton.styleFrom(
                backgroundColor:
                    AppColors.lightBackground, // Default to primaryBlue
                foregroundColor: AppColors.darkBackground, // Default to white
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(borderRadius),
                ),
                padding: EdgeInsets.symmetric(horizontal: 10),
                // .zero, // Remove default padding to control with Row spacing
                overlayColor: AppColors.lightBackground,
                surfaceTintColor: AppColors.lightBackground,
                elevation: disableHoverEffect
                    ? 0.0
                    : elevation, // Apply elevation, disable on hover
                side: BorderSide(color: AppColors.lightGrey, width: 1.5),
              ),
        child: isLoading
            ? SizedBox(
                height: 40,
                width: 100,
                child: CupertinoActivityIndicator(
                  color: AppColors.lightBackground,
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (icon != null) ...[
                    SizedBox(height: iconSize, width: iconSize, child: icon),
                    SizedBox(width: spacing),
                  ],
                  Text(
                    text,
                    style: context.bodyMedium?.copyWith(
                      fontFamily: FontFamily.outfitMedium,
                      letterSpacing: .1,
                      color: isButtonStypeApply
                          ? textColor ?? AppColors.lightBackground
                          : AppColors.darkBackground,
                      fontSize: textSize,
                    ),
                  ),
                  if (trailingIcon != null) ...[
                    SizedBox(width: spacing),
                    SizedBox(
                      height: iconSize,
                      width: iconSize,
                      child: trailingIcon,
                    ),
                  ],
                ],
              ),
      ),
    );
  }
}
