import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:register_visa_web_app/core/constants/app_color.dart';
import 'package:register_visa_web_app/core/constants/font_family.dart';
import 'package:register_visa_web_app/core/utils/app_toast.dart';
import 'package:register_visa_web_app/core/utils/dialog_extension%20copy.dart';
import 'package:register_visa_web_app/core/utils/spacing_extension.dart';
import 'package:register_visa_web_app/core/utils/text_theme_extension.dart';
import 'package:register_visa_web_app/core/utils/utils.dart';
import 'package:register_visa_web_app/features/auth/presentation/login_dialog_view.dart';
import 'package:register_visa_web_app/features/auth/providers/auth_provider.dart';
import 'package:register_visa_web_app/shared/services/image_picker_service.dart';
import 'package:register_visa_web_app/shared/validation/form_validater.dart';
import 'package:register_visa_web_app/shared/widgets/app_text_field.dart';
import 'package:register_visa_web_app/shared/widgets/custom_icon_button.dart';
import 'package:register_visa_web_app/shared/widgets/image_view.dart';

import '../../../core/constants/image_url.dart';
import '../providers/signup_provider.dart';
import '../providers/signup_state.dart';

class SignUpDialogView extends ConsumerWidget {
  SignUpDialogView({super.key});

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final ImagePickerService _imagePickerService = ImagePickerService();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final signupState = ref.watch(signupProvider);

    ref.listen(signupProvider, (previous, SignupState next) {
      if (next.isSuccess) {
        AppToast.success(context, 'User Login successfully');
        context.pop();
      }

      if (next.error != null) {
        AppToast.success(context, '${next.error}');
      }
    });
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 600; // Define small screen for dialog

    return ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: isSmallScreen ? screenWidth * 0.9 : 600,
      ),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,

          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(ImageUrl.appIcon, height: 80),
              20.ht,
              Text(
                "Create Your Account",
                style: context.titleLarge?.copyWith(
                  color: AppColors.darkBackground,
                  fontSize: 30,
                  fontFamily: FontFamily.outfitBold,
                ), // Using extension),
              ),
              10.ht,
              Text(
                "Join us to start your visa application journey",
                style: context.bodySmall?.copyWith(
                  fontSize: 14.0,
                  fontFamily: FontFamily.outfitRegular,
                ),
              ),
              10.ht,
              Divider(),
              10.ht,
              Text(
                'Profile Picture',
                style: context.titleSmall?.copyWith(
                  color: AppColors.darkBackground,
                  fontFamily: FontFamily.outfitMedium,
                ), // Using extension
              ),
              10.ht,
              // Profile Picture Upload
              GestureDetector(
                onTap: () async {
                  try {
                    final image = await _imagePickerService
                        .pickImageFromGallery2();

                    if (image != null) {
                      String selectedImage =
                          await Utils.convertUint8ListToBase64DataUrl(
                            XFile(image.path),
                          );
                      ref
                          .read(signupProvider.notifier)
                          .updateProfileImage(selectedImage, image);
                    }
                  } catch (e) {}
                },
                child: Container(
                  height: 120,
                  width: 120,
                  decoration: BoxDecoration(
                    color: AppColors.lightCard,
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.lightGrey, width: 2),
                  ),
                  child: signupState.profileImage == null
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.camera_alt,
                              size: 30,
                              color: AppColors.lightSubText,
                            ),
                            8.ht,
                            Text(
                              'Add Photo',
                              style: context.bodySmall?.copyWith(
                                fontFamily: FontFamily.outfitMedium,
                              ),
                            ),
                          ],
                        )
                      : ClipOval(
                          child: AppCacheNetworkImage(
                            url: signupState.profileImage!,
                            height: 120,
                            width: 120,
                            boxFit: BoxFit.cover,
                          ),
                        ),
                ),
              ),
              10.ht,
              Text(
                'Click or drag to upload',
                style: context.bodySmall?.copyWith(
                  color: AppColors.lightSubText,
                  fontFamily: FontFamily.outfitRegular,
                ), // Using extension
              ),
              30.ht,
              AppTextFormField(
                title: 'Full Name',
                hint: 'Enter your full name',
                prefixIcon: Icons.person_outline,
                controller: nameController, // Placeholder controller
                validator: (value) => FormValidators.fulllNameValidation(
                  value,
                  fieldName: 'Full Name',
                ),
                isShowCounter: true,
                inputType: InputFieldType.fullName,
              ),
              20.ht,
              isSmallScreen
                  ? Column(
                      children: [
                        AppTextFormField(
                          title: 'Email',
                          hint: 'your.email@example.com',
                          prefixIcon: Icons.email_outlined,
                          controller: emailController, // Placeholder controller
                          validator: (value) => FormValidators.email(value),
                        ),
                        20.ht,
                        AppTextFormField(
                          title: 'Phone Number',
                          hint: '+1(555) 000-0000',
                          prefixIcon: Icons.phone_outlined,
                          // inputType: InputFieldType.number,
                          controller: phoneController, // Placeholder controller
                          validator: (value) => FormValidators.number(value),
                          inputType: InputFieldType.phoneNumber,
                        ),
                      ],
                    )
                  : Row(
                      children: [
                        Expanded(
                          child: AppTextFormField(
                            title: 'Email',
                            hint: 'your.email@example.com',
                            prefixIcon: Icons.email_outlined,
                            controller:
                                emailController, // Placeholder controller
                            validator: (value) => FormValidators.email(value),
                          ),
                        ),
                        20.wt,
                        Expanded(
                          child: AppTextFormField(
                            title: 'Phone Number',
                            hint: '+1(555) 000-0000',
                            prefixIcon: Icons.phone_outlined,
                            // inputType: InputFieldType.number,
                            controller:
                                phoneController, // Placeholder controller
                            validator: (value) => FormValidators.number(value),
                            inputType: InputFieldType.phoneNumber,
                          ),
                        ),
                      ],
                    ),
              20.ht,
              AppTextFormField(
                title: 'Password',
                hint: 'Create a password',
                prefixIcon: Icons.lock_outline,
                isPasswordField: true,
                isFieldRequired: true,
                controller: passwordController, // Placeholder controller
                validator: (value) => FormValidators.strongPassword(value),
              ),
              20.ht,
              AppTextFormField(
                title: 'Confirm Password',
                hint: 'Confirm your password',
                prefixIcon: Icons.lock_outline,
                isPasswordField: true,
                isFieldRequired: true,
                controller: confirmPasswordController,
                validator: (value) {
                  if (confirmPasswordController.text.trim().isEmpty) {
                    return "Confirm Password is required";
                  }
                  if (passwordController.text !=
                      confirmPasswordController.text) {
                    return "Passwords do not match";
                  }
                  return null;
                },
              ),
              30.ht,
              CustomIconButton(
                text: 'Create Account',
                buttonState: signupState.isLoading,
                onPressed: signupState.isLoading
                    ? null
                    : () {
                        if (!_formKey.currentState!.validate()) {
                          return;
                        }
                        ref
                            .watch(signupProvider.notifier)
                            .signup(
                              fullName: nameController.text.trim(),
                              email: emailController.text.trim(),
                              phone: phoneController.text.trim(),
                              password: passwordController.text.trim(),
                              profilePic: signupState.file,
                              url: "",
                            );
                      },
                color: AppColors.primaryBlue,
                textColor: AppColors.lightBackground,
                height: 40,
                borderRadius: 12,
              ),
              20.ht,
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Already have an account?',
                    style: context.bodyMedium?.copyWith(
                      fontSize: 14.0,
                      color: AppColors.lightSubText,
                      fontFamily: FontFamily.outfitRegular,
                      letterSpacing: .1,
                    ), // Using extension
                  ),
                  5.wt,
                  GestureDetector(
                    onTap: () {
                      context.pop();
                      LoginDialogView().showAsDialog(
                        context,
                        maxHeight: 800,
                        maxWidth: 500,
                        padding: const EdgeInsets.all(20),
                      );
                    },
                    child: Text(
                      'Login',
                      style: context.titleMedium?.copyWith(
                        color: AppColors.primaryBlue,
                        fontFamily: FontFamily.outfitRegular,
                        letterSpacing: .1,
                        fontSize: 14.0,
                      ), // Using extension
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
