import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:register_visa_web_app/core/constants/app_color.dart';

import 'package:register_visa_web_app/core/constants/font_family.dart';
import 'package:register_visa_web_app/core/utils/app_toast.dart';
import 'package:register_visa_web_app/core/utils/dialog_extension.dart';
import 'package:register_visa_web_app/core/utils/text_theme_extension.dart';
import 'package:register_visa_web_app/features/auth/presentation/forgot_password.dart';
import 'package:register_visa_web_app/features/auth/presentation/sign_up_dialog_view.dart';

import 'package:register_visa_web_app/features/auth/providers/auth_provider.dart';
import 'package:register_visa_web_app/shared/validation/form_validater.dart';
import 'package:register_visa_web_app/shared/widgets/app_text_field.dart';
import 'package:register_visa_web_app/shared/widgets/custom_icon_button.dart';

import '../../../core/constants/image_url.dart';
import '../../../core/utils/spacing_extension.dart';

class LoginDialogView extends ConsumerWidget {
  LoginDialogView({super.key});

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loginState = ref.watch(loginProvider);
    ref.listen(loginProvider, (previous, next) {
      // Listen to changes in the loginProvider's state
      if (next.isSuccess) {
        AppToast.success(context, 'User Login successfully');
        context.pop();
      }
      // if (next.infoMessage != null) {
      //   AppToast.warning(context, next.infoMessage!);
      // }
    });
    return SizedBox(
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(child: Image.asset(ImageUrl.appIcon, scale: 3.0)),
              30.ht,
              Text(
                "Welcome Back",
                style: context.titleLarge?.copyWith(
                  fontFamily: FontFamily.outfitBold,
                  fontSize: 32.0,
                  letterSpacing: -1,
                ),
              ),
              10.ht,
              Text(
                "Sign in to continue your visa application",
                style: context.bodyMedium?.copyWith(
                  color: AppColors.lightSubText,
                  fontFamily: FontFamily.outfitRegular,
                ),
              ),
              30.ht,
              AppTextFormField(
                title: "Email",
                hint: "Enter Your Email",
                prefixIcon: Icons.email_outlined,
                controller: emailController,
                validator: (value) {
                  return FormValidators.email(value);
                },
              ),
              //if (loginState.requiresLoginPassword) ...[
              20.ht,
              AppTextFormField(
                title: "Password",
                hint: "Enter Your Password",
                isFieldRequired: true,
                isPasswordField: true,
                prefixIcon: Icons.lock,
                controller: passwordController,
                validator: (value) {
                  if (emailController.text.trim().isEmpty) {
                    return "Please Enter Password";
                  }
                  // if (value == null || value.length < 8) {
                  //   return 'Password must be at least 8 characters';
                  // }
                  return null;
                },
              ),
              if (ref.watch(loginProvider).error != null) ...[
                20.ht,
                Text(
                  ref.watch(loginProvider).error!,
                  style: context.bodyMedium?.copyWith(
                    color: Colors.red,
                    fontFamily: FontFamily.outfitRegular,
                  ),
                ),
              ],

              // ],
              // if (loginState.isPasswordNotSet) ...[
              //   20.ht,
              //   AppTextFormField(
              //     title: "New Password",
              //     hint: "Enter New Password",
              //     isFieldRequired: true,
              //     isPasswordField: true,
              //     prefixIcon: Icons.lock,
              //     controller: passwordController,
              //     validator: (value) {
              //       if (emailController.text.trim().isEmpty) {
              //         return "Please Enter Password";
              //       }
              //       // if (value == null || value.length < 8) {
              //       //   return 'Password must be at least 8 characters';
              //       // }
              //       return null;
              //     },
              //   ),
              // ],
              26.ht,
              CustomIconButton(
                text: "Continue",
                buttonState: ref.watch(loginProvider).isLoading,
                onPressed: () {
                  if (!_formKey.currentState!.validate()) {
                    return;
                  }
                  ref
                      .read(loginProvider.notifier)
                      .emailLogin(
                        email: emailController.text,
                        password: passwordController.text,
                      );
                  // if (loginState.requiresLoginPassword) {
                  //   ref
                  //       .read(loginProvider.notifier)
                  //       .emailLogin(
                  //         email: emailController.text,
                  //         password: passwordController.text,
                  //       );
                  // } else if (loginState.isPasswordNotSet) {
                  //   ref
                  //       .read(loginProvider.notifier)
                  //       .updatePassword(email: emailController.text);
                  // } else {
                  //   ref
                  //       .read(loginProvider.notifier)
                  //       .checkUserOrRegister(email: emailController.text);
                  // }
                },
                color: AppColors.primaryBlue,
                textColor: AppColors.lightBackground,
                width: double.infinity,
                height: 40,
                borderRadius: 10,
                spacing: 10,
              ),
              26.ht,
              // CustomIconButton(
              //   text: "Login",
              //   buttonState: ref.watch(loginProvider).isLoading,
              //   onPressed: () {
              //     if (!_formKey.currentState!.validate()) {
              //       return;
              //     }
              //     ref
              //         .read(loginProvider.notifier)
              //         .emailLogin(
              //           email: emailController.text,
              //           password: passwordController.text,
              //         );
              //   },
              //   color: AppColors.primaryBlue,
              //   textColor: AppColors.lightBackground,
              //   width: double.infinity,
              //   height: 40,
              //   borderRadius: 10,
              //   spacing: 10,
              // ),
              20.ht,
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  context.pop();
                  ForgotPasswordView().showAsDialog(
                    context,
                    maxHeight: 400,
                    maxWidth: 500,
                    padding: const EdgeInsets.all(20),
                  );
                },
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Text("Forgot Password?"),
                ),
              ),
              10.ht,
              Row(
                children: [
                  Expanded(
                    child: Divider(color: AppColors.lightGrey, height: 1),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Or continue with".toUpperCase(),
                      style: context.bodyMedium?.copyWith(
                        color: AppColors.lightSubText,
                        fontFamily: FontFamily.outfitRegular,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Divider(color: AppColors.lightGrey, height: 1),
                  ),
                ],
              ),
              20.ht,
              CustomIconButton(
                text: 'Continue With Google',
                onPressed: () {
                  ref
                      .read(loginProvider.notifier)
                      .googleLogin(
                        email: emailController.text,
                        password: passwordController.text,
                      );
                },
                icon: Image.asset(ImageUrl.googleIcon, scale: 2.0),
                color: AppColors.lightBackground,
                textColor: AppColors.primaryBlue,

                height: 45,
                borderRadius: 10,
              ),
              20.ht,
              Center(
                child: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: "Don't have an account? ",
                        style: context.bodyMedium?.copyWith(
                          fontSize: 14.0,
                          color: AppColors.lightSubText,
                          fontFamily: FontFamily.outfitRegular,
                          letterSpacing: .1,
                        ),
                      ),
                      TextSpan(
                        text: 'Sign Up',
                        style: context.titleMedium?.copyWith(
                          color: AppColors.primaryBlue,
                          fontFamily: FontFamily.outfitRegular,
                          letterSpacing: .1,
                          fontSize: 14.0,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = (() => {
                            context.pop(),
                            SignUpDialogView().showAsDialog(
                              context,
                              maxHeight: 800,
                              maxWidth: 600,
                              padding: const EdgeInsets.all(20),
                            ),
                          }),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
