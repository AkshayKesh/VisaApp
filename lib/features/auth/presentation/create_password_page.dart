import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:register_visa_web_app/core/constants/app_color.dart';
import 'package:register_visa_web_app/core/constants/font_family.dart';
import 'package:register_visa_web_app/core/constants/image_url.dart';
import 'package:register_visa_web_app/core/constants/router/router_names.dart';
import 'package:register_visa_web_app/core/utils/app_toast.dart';
import 'package:register_visa_web_app/core/utils/spacing_extension.dart';
import 'package:register_visa_web_app/core/utils/text_theme_extension.dart';
import 'package:register_visa_web_app/features/auth/providers/auth_provider.dart';
import 'package:register_visa_web_app/shared/widgets/app_text_field.dart';
import 'package:register_visa_web_app/shared/widgets/custom_icon_button.dart';
import 'package:register_visa_web_app/shared/validation/form_validater.dart';

class CreatePasswordPage extends ConsumerStatefulWidget {
  final String email;

  const CreatePasswordPage({super.key, required this.email});

  @override
  ConsumerState<CreatePasswordPage> createState() => _CreatePasswordPageState();
}

class _CreatePasswordPageState extends ConsumerState<CreatePasswordPage> {
  final passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    passwordController.dispose();
    super.dispose();
  }

  void _generateStrongPassword() {
    const length = 12;
    const lowerCase = 'abcdefghijklmnopqrstuvwxyz';
    const upperCase = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    const numbers = '0123456789';
    const specialChars = r'!@#$&*~_()[]:;,.<>?';

    String chars = lowerCase + upperCase + numbers + specialChars;
    Random rnd = Random();

    // Ensure at least one of each required type
    String password = '';
    password += lowerCase[rnd.nextInt(lowerCase.length)];
    password += upperCase[rnd.nextInt(upperCase.length)];
    password += numbers[rnd.nextInt(numbers.length)];
    password += specialChars[rnd.nextInt(specialChars.length)];

    // Fill the rest
    for (int i = 4; i < length; i++) {
      password += chars[rnd.nextInt(chars.length)];
    }

    // Shuffle
    List<String> list = password.split('');
    list.shuffle();
    password = list.join('');

    setState(() {
      passwordController.text = password;
    });
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(loginProvider, (previous, next) {
      if (next.isSuccess) {
        AppToast.success(context, 'User Login successfully');
        context.go(RouterNames.home);
      }
    });

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
                    "Create Password",
                    style: context.titleLarge?.copyWith(fontFamily: FontFamily.outfitBold, fontSize: 32.0, letterSpacing: -1),
                    textAlign: TextAlign.center,
                  ),
                  10.ht,
                  Text(
                    "Create a secure password for ${widget.email}",
                    style: context.bodyMedium?.copyWith(color: AppColors.lightSubText, fontFamily: FontFamily.outfitRegular),
                    textAlign: TextAlign.center,
                  ),
                  30.ht,
                  AppTextFormField(
                    title: "Password",
                    hint: "Enter or Generate Password",
                    isFieldRequired: true,
                    isPasswordField: true,
                    prefixIcon: Icons.lock,
                    controller: passwordController,
                    validator: (value) {
                      return FormValidators.strongPassword(value);
                    },
                  ),
                  10.ht,
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton.icon(
                      onPressed: _generateStrongPassword,
                      icon: const Icon(Icons.vpn_key_outlined, size: 16),
                      label: const Text("Generate Strong Password"),
                      style: TextButton.styleFrom(foregroundColor: AppColors.primaryBlue),
                    ),
                  ),
                  if (ref.watch(loginProvider).error != null) ...[
                    20.ht,
                    Text(
                      ref.watch(loginProvider).error!,
                      style: context.bodyMedium?.copyWith(color: Colors.red, fontFamily: FontFamily.outfitRegular),
                    ),
                  ],
                  20.ht,
                  CustomIconButton(text: "Set Password & Login", buttonState: ref.watch(loginProvider).isLoading, onPressed: () {}, color: AppColors.primaryBlue, textColor: AppColors.lightBackground, width: double.infinity, height: 48, borderRadius: 10, spacing: 10),
                  20.ht,
                  TextButton.icon(
                    onPressed: () {
                      context.pop();
                    },
                    icon: Icon(Icons.arrow_back, size: 16, color: AppColors.primaryBlue),
                    label: Text("Back to Email", style: TextStyle(color: AppColors.primaryBlue)),
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
