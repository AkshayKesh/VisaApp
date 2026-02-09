import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:register_visa_web_app/core/constants/app_color.dart';
import 'package:register_visa_web_app/core/constants/app_constant.dart';
import 'package:register_visa_web_app/core/constants/image_url.dart';
import 'package:register_visa_web_app/core/constants/router/router_names.dart';
import 'package:register_visa_web_app/features/auth/presentation/widget/auth_buttons.dart';
import 'package:register_visa_web_app/features/auth/presentation/widget/user_view.dart';
import 'package:register_visa_web_app/features/auth/providers/auth_provider.dart';
import 'package:register_visa_web_app/features/auth/providers/signup_provider.dart';

class CustomAppBar extends ConsumerWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key, this.isScroll = false});
  final bool? isScroll;
  @override
  Size get preferredSize => const Size.fromHeight(70); // Set a fixed preferred size

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 768; // Define what a "small screen" is consistently
    return ColoredBox(
      color: AppColors.headerBackground,
      child: Row(
        children: [
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              final String location = GoRouter.of(context).location;

              if (location == "/document/passportDetails") {
                context.pop();
              }
              if (location != "/") {
                context.pushReplacement(RouterNames.home);
              }
            },
            child: Padding(padding: const EdgeInsets.all(8.0), child: Image.asset(ImageUrl.appIcon, height: 56)),
          ),
          const Spacer(),
          Consumer(
            builder: (context, ref, child) {
              return (ref.watch(loginProvider).isSuccess || ref.watch(signupProvider).isSuccess || AppConstants.authToken.isNotEmpty)
                  ? BuildUserView(isSmallScreen: isSmallScreen)
                  : BuildAuthButton(isSmallScreen: isSmallScreen);
            },
          ),

          const SizedBox(width: 10),
        ],
      ),
    );
  }
}
