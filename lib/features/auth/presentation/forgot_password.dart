import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:register_visa_web_app/core/constants/app_color.dart';
import 'package:register_visa_web_app/core/constants/font_family.dart';
import 'package:register_visa_web_app/core/utils/dialog_extension.dart';
import 'package:register_visa_web_app/core/utils/spacing_extension.dart';
import 'package:register_visa_web_app/core/utils/text_theme_extension.dart';
import 'package:register_visa_web_app/features/auth/presentation/login_dialog_view.dart';
import 'package:register_visa_web_app/shared/widgets/app_text_field.dart';

class ForgotPasswordView extends StatefulWidget {
  const ForgotPasswordView({super.key});

  @override
  State<ForgotPasswordView> createState() => _ForgotPasswordViewState();
}

class _ForgotPasswordViewState extends State<ForgotPasswordView> {
  final TextEditingController emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  String? errorText, infoText;

  void submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      isLoading = true;
      errorText = null;
      infoText = null;
    });

    // Simulate a network call for demo purposes
    await Future.delayed(const Duration(seconds: 2));
    // For demonstration: if email contains '@', we consider it found.
    if (emailController.text.contains('@')) {
      setState(() {
        infoText = 'Password reset link sent to your email!';
      });
    } else {
      setState(() {
        errorText = 'No user found with this email.';
      });
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Forgot Password",
              style: context.titleLarge?.copyWith(
                fontFamily: FontFamily.outfitBold,
                color: AppColors.primaryBlue,
                fontSize: 22,
                letterSpacing: 0.2,
              ),
            ),
            10.ht,
            Text(
              "Enter your registered email address to receive a password reset link.",
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
                if (value == null || value.trim().isEmpty) {
                  return "Please enter your email";
                }
                if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value.trim())) {
                  return "Please enter a valid email address";
                }
                return null;
              },
              inputType: InputFieldType.email,
            ),
            20.ht,
            if (errorText != null)
              Text(
                errorText!,
                style: context.bodyMedium?.copyWith(
                  color: Colors.red,
                  fontFamily: FontFamily.outfitRegular,
                ),
              ),
            if (infoText != null)
              Text(
                infoText!,
                style: context.bodyMedium?.copyWith(
                  color: Colors.green,
                  fontFamily: FontFamily.outfitRegular,
                ),
              ),
            24.ht,
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: isLoading ? null : submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryBlue,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 0,
                ),
                child: isLoading
                    ? SizedBox(
                        height: 22,
                        width: 22,
                        child: CircularProgressIndicator(
                          color: AppColors.lightBackground,
                          strokeWidth: 2.2,
                        ),
                      )
                    : Text(
                        "Send Reset Link",
                        style: context.titleMedium?.copyWith(
                          color: AppColors.lightBackground,
                          fontFamily: FontFamily.outfitBold,
                        ),
                      ),
              ),
            ),
            18.ht,
            Center(
              child: GestureDetector(
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
                  "Back to Login",
                  style: context.titleSmall?.copyWith(
                    color: AppColors.primaryBlue,
                    fontFamily: FontFamily.outfitRegular,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
