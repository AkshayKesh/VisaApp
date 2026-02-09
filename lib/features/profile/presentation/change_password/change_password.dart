import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:register_visa_web_app/core/constants/app_color.dart';
import 'package:register_visa_web_app/core/constants/font_family.dart';
import 'package:register_visa_web_app/core/utils/spacing_extension.dart';
import 'package:register_visa_web_app/core/utils/text_theme_extension.dart';
import 'package:register_visa_web_app/features/profile/providers/change_password_provider.dart';
import 'package:register_visa_web_app/features/profile/providers/states/change_password_state.dart';
import 'package:register_visa_web_app/shared/widgets/app_text_field.dart';
import 'package:register_visa_web_app/shared/widgets/custom_icon_button.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class ForgotPasswordPage extends ConsumerWidget {
  ForgotPasswordPage({super.key});

  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(changePasswordProvider, (previous, next) {
      if (next.status == ChangePasswordStatus.success) {
      } else if (next.status == ChangePasswordStatus.error) {}
    });

    return Padding(
      padding: const EdgeInsets.all(32),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 36),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.lock_outline, color: AppColors.primaryBlue, size: 42),
            const SizedBox(height: 16),
            Text(
              'Change Password',
              style: context.titleLarge?.copyWith(
                fontFamily: FontFamily.outfitBold,
                color: AppColors.primaryBlue,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Enter your email address below and we'll send you a link to reset your password.",
              textAlign: TextAlign.center,
              style: context.bodyMedium?.copyWith(
                color: AppColors.darkSubText,
                fontFamily: FontFamily.outfitRegular,
              ),
            ),
            24.ht,
            AppTextFormField(
              title: "Old Password",
              hint: "Enter Your Old Password",
              prefixIcon: Icons.email_outlined,
              controller: _oldPasswordController,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return "Please enter your old password";
                }
                return null;
              },
              inputType: InputFieldType.email,
            ),
            10.ht,
            AppTextFormField(
              title: "New Password",
              hint: "Enter Your New Password",
              prefixIcon: Icons.email_outlined,
              controller: _newPasswordController,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return "Please enter your new password";
                }
                return null;
              },
              inputType: InputFieldType.email,
            ),
            10.ht,

            AppTextFormField(
              title: "Confirm  Password",
              hint: "Enter Your Password",
              prefixIcon: Icons.email_outlined,
              controller: _confirmPasswordController,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return "Please enter your old password";
                }
                return null;
              },
              inputType: InputFieldType.email,
            ),

            const SizedBox(height: 28),
            CustomIconButton(
              buttonState:
                  ref.watch(changePasswordProvider).status ==
                      ChangePasswordStatus.loading
                  ? true
                  : false,
              text: "Send",
              onPressed: () {
                if (_newPasswordController.text !=
                    _confirmPasswordController.text) {
                  return;
                }
                ref
                    .read(changePasswordProvider.notifier)
                    .changePassword(
                      oldPassword: _oldPasswordController.text,
                      newPassword: _newPasswordController.text,
                    );
              },
              height: 5.h,
              width: 20.w,
            ),
          ],
        ),
      ),
    );
  }
}
