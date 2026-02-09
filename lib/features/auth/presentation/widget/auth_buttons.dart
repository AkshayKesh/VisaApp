import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:register_visa_web_app/core/constants/app_color.dart';
import 'package:register_visa_web_app/core/constants/font_family.dart';
import 'package:register_visa_web_app/core/utils/dialog_extension.dart';
import 'package:register_visa_web_app/core/utils/text_theme_extension.dart';
import 'package:register_visa_web_app/features/auth/presentation/login_dialog_view.dart';
import 'package:register_visa_web_app/features/auth/presentation/sign_up_dialog_view.dart';
import 'package:register_visa_web_app/features/auth/providers/auth_provider.dart';
import 'package:register_visa_web_app/shared/widgets/custom_icon_button.dart';

class BuildAuthButton extends ConsumerWidget {
  const BuildAuthButton({super.key, required this.isSmallScreen});

  final bool isSmallScreen;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: () {
            LoginDialogView().showAsDialog(
              context,
              maxHeight: 800,
              maxWidth: 500,
              padding: const EdgeInsets.all(20),
              onClose: () {
                ref.invalidate(loginProvider);
              },
            );
          },
          child: SizedBox(
            width: 100,
            child: Row(
              children: [
                Icon(Icons.login),
                SizedBox(width: 10),
                Text(
                  "Login",
                  style: context.bodyLarge?.copyWith(
                    color: AppColors.darkTextColor,
                    fontSize: 12,
                    fontFamily: FontFamily.outfitRegular,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 10), // Add spacing between buttons
        CustomIconButton(
          text: "Sign Up",
          onPressed: () {
            SignUpDialogView().showAsDialog(
              context,
              maxHeight: 800,
              maxWidth: 600,
              padding: const EdgeInsets.all(20),
            );
          },
          icon: const Icon(
            Icons.person_add_alt_rounded,
            color: AppColors.lightBackground,
          ),
          color: AppColors.primaryBlue,
          textColor: AppColors.lightBackground,
          borderRadius: 12,
          width: 100,
          height: 36,
          iconSize: 16,
          textSize: 13,
        ),
      ],
    );
  }
}
