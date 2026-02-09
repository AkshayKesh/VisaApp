import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:register_visa_web_app/core/constants/app_color.dart';
import 'package:register_visa_web_app/core/constants/font_family.dart';
import 'package:register_visa_web_app/core/constants/router/router_names.dart';
import 'package:register_visa_web_app/core/utils/app_toast.dart';
import 'package:register_visa_web_app/core/utils/spacing_extension.dart';
import 'package:register_visa_web_app/core/utils/text_theme_extension.dart';
import 'package:register_visa_web_app/features/home/providers/home_provider.dart';
import 'package:register_visa_web_app/features/visa_details/domain/visa_passing_model.dart';
import 'package:register_visa_web_app/shared/services/visa_hive_service.dart';
import 'package:register_visa_web_app/shared/widgets/app_drop_down.dart';
import 'package:register_visa_web_app/shared/widgets/custom_icon_button.dart';

final List<String> countries = ["India", "USA", "UK", "Canada", "Australia", "Germany", "France", "Japan"];

class LeftContain extends ConsumerWidget {
  const LeftContain({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final homeController = ref.watch(homeProvider.notifier);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Row(
        //   mainAxisSize: MainAxisSize.min,
        //   children: <Widget>[
        //     Text(
        //       'Online Visa For',
        //       style: context.bodyLarge?.copyWith(
        //         fontFamily: FontFamily.outfitExtraBold,
        //         fontSize: 42,
        //         color: AppColors.primaryBlue,
        //       ),
        //     ),
        //     const SizedBox(width: 20.0, height: 100.0),
        //     DefaultTextStyle(
        //       style: const TextStyle(fontSize: 40.0, fontFamily: 'Horizon'),
        //       child: AnimatedTextKit(
        //         animatedTexts: [
        //           RotateAnimatedText('Germany'),
        //           RotateAnimatedText('Japan'),
        //           RotateAnimatedText('Norway'),
        //         ],
        //         onTap: () {
        //           print("Tap Event");
        //         },
        //       ),
        //     ),
        //   ],
        // ),
        RichText(
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          text: TextSpan(
            children: [
              TextSpan(
                text: "Online Visa",
                style: context.bodyLarge?.copyWith(fontFamily: FontFamily.outfitExtraBold, fontSize: 42, color: AppColors.primaryBlue),
              ),
            ],
          ),
          textScaler: TextScaler.linear(1.2),
        ),
        AnimatedTextKit(
          animatedTexts: [
            TypewriterAnimatedText(
              'Explore Application',
              textStyle: context.bodyLarge?.copyWith(fontFamily: FontFamily.outfitExtraBold, fontSize: 42, color: AppColors.blackColor),
              speed: const Duration(milliseconds: 1000),
            ),
          ],

          totalRepeatCount: 4,
          pause: const Duration(milliseconds: 2000),
          displayFullTextOnTap: true,
          stopPauseOnTap: true,
        ),
        20.ht,
        Text(
          "Simplify your travel with our hassle-free online visa application. "
          "Get your visa approved quickly and securely from anywhere in the world.",
          style: context.bodyMedium?.copyWith(
            fontFamily: FontFamily.outfitRegular,
            fontSize: 18,
            color: AppColors.darkSubText,
            fontStyle: FontStyle.italic,
          ),
        ),
        20.ht,

        Row(
          children: [
            Expanded(
              child: Consumer(
                builder: (context, ref, child) {
                  return AppCustomDropdown(
                    title: "My Passport",
                    hint: "Select",
                    maxHeight: 180,
                    value: ref.watch(passportCountryProvider),
                    itemLabel: (value) => value,
                    onChanged: (value) {
                      ref.read(passportCountryProvider.notifier).setCountry(value);
                    },
                  );
                },
              ),
            ),
            10.wt,
            Expanded(
              child: Consumer(
                builder: (context, ref, child) {
                  return AppCustomDropdown(
                    title: 'My destination',
                    hint: 'Select',
                    maxHeight: 180,
                    value: ref.watch(destinationCountryProvider)?.name == "" ? null : ref.watch(destinationCountryProvider),
                    itemLabel: (value) => value,
                    onChanged: (value) {
                      ref.read(destinationCountryProvider.notifier).setCountry(value);
                    },
                  );
                },
              ),
            ),
          ],
        ),
        30.ht,
        CustomIconButton(
          text: "Get started",
          buttonState: ref.watch(showTravellerProvider),
          onPressed: () async {
            String? destenation = ref.watch(destinationCountryProvider)?.name;
            if (destenation == null || destenation.isEmpty) {
              AppToast.error(context, "Please select your destination");
              return;
            }
            ref.read(showTravellerProvider.notifier).state = true;
            Map<String, dynamic>? data = await homeController.getStart(destenation);
            if (data["statusCode"] == 200) {
              final id = data["data"]["_id"];
              VisaApplicationModel visaApplication = VisaApplicationModel(id: id);
              VisaHiveService.instance.saveVisa(visaApplication);
              ref.read(showTravellerProvider.notifier).state = false;
              context.pushNamed(RouterNames.viewDetails, queryParameters: {"id": id.toString()});
            } else {
              AppToast.error(context, data["message"]);
              ref.read(showTravellerProvider.notifier).state = false;
            }
          },

          trailingIcon: const Icon(Icons.arrow_forward, color: AppColors.lightBackground),
          spacing: 10,
          color: AppColors.primaryBlue,
          textColor: AppColors.lightBackground,
          borderRadius: 12,
          width: 140,
          height: 40,
          iconSize: 16,
          textSize: 13,
        ),
      ],
    );
  }
}
