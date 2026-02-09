import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:register_visa_web_app/core/constants/app_color.dart';
import 'package:register_visa_web_app/core/constants/font_family.dart';
import 'package:register_visa_web_app/core/constants/image_url.dart';
import 'package:register_visa_web_app/core/utils/spacing_extension.dart';
import 'package:register_visa_web_app/core/utils/text_theme_extension.dart';
import 'package:register_visa_web_app/shared/validation/form_validater.dart';
import 'package:register_visa_web_app/shared/widgets/app_text_field.dart';
import 'package:register_visa_web_app/shared/widgets/custom_icon_button.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 500),
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
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
                    textAlign: TextAlign.center,
                  ),
                  10.ht,
                  Text(
                    "Sign in to continue your visa application",
                    style: context.bodyMedium?.copyWith(
                      color: AppColors.lightSubText,
                      fontFamily: FontFamily.outfitRegular,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  30.ht,
                  AppTextFormField(
                    title: "Email or Phone Number",
                    hint: "Enter Your Email or Phone Number",
                    prefixIcon: Icons.email_outlined,
                    controller: emailController,
                    validator: (value) {
                      return FormValidators.email(value);
                    },
                  ),
                  26.ht,
                  CustomIconButton(
                    text: "Continue",
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        context.pushNamed(
                          'createPassword',
                          extra: emailController.text,
                        );
                      }
                    },
                    color: AppColors.primaryBlue,
                    textColor: AppColors.lightBackground,
                    width: double.infinity,
                    height: 48,
                    borderRadius: 10,
                  ),
                  20.ht,
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
                    onPressed: () {},
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
                            recognizer: TapGestureRecognizer()..onTap = (() {}),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
