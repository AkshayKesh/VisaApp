import 'package:country_pickers/country.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:register_visa_web_app/core/constants/app_color.dart';
import 'package:register_visa_web_app/core/constants/font_family.dart';
import 'package:register_visa_web_app/core/constants/router/router_names.dart';
import 'package:register_visa_web_app/core/utils/spacing_extension.dart';
import 'package:register_visa_web_app/core/utils/text_theme_extension.dart';
import 'package:register_visa_web_app/features/home/presentation/comman/testimonial_view.dart';
import 'package:register_visa_web_app/features/home/presentation/mobile/mobiel_header.dart';
import 'package:register_visa_web_app/features/home/presentation/mobile/online_mobile_view.dart';
import 'package:register_visa_web_app/features/home/presentation/web/desktop_header.dart';
import 'package:register_visa_web_app/features/home/presentation/web/online_desktop_view.dart';
import 'package:register_visa_web_app/features/home/providers/home_provider.dart';
import 'package:register_visa_web_app/features/visa_details/domain/visa_passing_model.dart';
import 'package:register_visa_web_app/shared/services/visa_hive_service.dart';
import 'package:register_visa_web_app/shared/widgets/app_bar_widget.dart';
import 'package:register_visa_web_app/shared/widgets/app_footer.dart';

import 'package:register_visa_web_app/shared/widgets/visa_card_skeleton.dart';

import 'package:register_visa_web_app/shared/widgets/visa_destination_card.dart';

import 'package:responsive_sizer/responsive_sizer.dart';

class MyHomePage extends ConsumerStatefulWidget {
  const MyHomePage({super.key});

  @override
  ConsumerState<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends ConsumerState<MyHomePage> {
  final List<String> items = ['Item1', 'Item2', 'Item3', 'Item4'];
  Country? selectedValue;
  @override
  Widget build(BuildContext context) {
    final homeState = ref.watch(homeProvider);
    final homeController = ref.watch(homeProvider.notifier);
    bool isWeb(BuildContext context) =>
        MediaQuery.of(context).size.width >= 1000;

    final bool isDesktop = isWeb(context);
    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      appBar: CustomAppBar(),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            10.ht,
            homeState.when(
              loading: () => SizedBox(height: 40.h, child: VisaSkeletonGrid()),
              error: (error, stackTrace) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 48,
                      color: Colors.red,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Failed to load packages',
                      style: context.headlineMedium?.copyWith(
                        color: Colors.red,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      error.toString(),
                      style: context.bodyMedium,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => ref.invalidate(homeProvider),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
              data: (homeData) {
                return Padding(
                  padding: EdgeInsetsGeometry.symmetric(
                    horizontal: isDesktop ? 40 : 10,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      //
                      isDesktop ? OnlineDesktopView() : OnlineMobileView(),
                      if (homeData.data!.data.isNotEmpty)
                        Padding(
                          padding: EdgeInsets.only(
                            right: isDesktop ? 40 : 16,
                            left: isDesktop ? 0 : 16,
                            top: 20,
                            bottom: 20,
                          ),
                          child: isDesktop
                              ? DesktopHeader(
                                  onForward: () =>
                                      homeController.scrollForward(),
                                  onBackWord: () => homeController.scrollBack(),
                                )
                              : MobileHeader(
                                  onForward: () =>
                                      homeController.scrollForward(),
                                  onBackWord: () => homeController.scrollBack(),
                                ),
                        ),
                      20.ht,
                      SizedBox(
                        height: 230, // must match card height
                        width: double.infinity,
                        child: Row(
                          children: [
                            Expanded(
                              child: ListView.builder(
                                shrinkWrap: true,
                                controller: homeController.scrollController,
                                scrollDirection: Axis.horizontal,
                                itemCount: homeData.data!.data.length,
                                itemBuilder: (context, index) {
                                  final package = homeData.data!.data[index];
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 6,
                                    ),
                                    child: SizedBox(
                                      width: 400,
                                      child: VisaDestinationCard(
                                        height: 230,
                                        imageUrl: package.coverPhoto,
                                        badgeText: "",
                                        title: package.title,
                                        subtitle: package.subtitle,
                                        onTap: () {
                                          VisaApplicationModel visaApplication =
                                              VisaApplicationModel(
                                                id: package.id,
                                              );
                                          VisaHiveService.instance.saveVisa(
                                            visaApplication,
                                          );
                                          context.pushNamed(
                                            RouterNames.viewDetails,
                                            queryParameters: {
                                              "id": package.id.toString(),
                                            },
                                          );
                                        },
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      40.ht,
                      Text(
                        "What Our Customers Say ",
                        style: context.titleLarge?.copyWith(
                          color: AppColors.blackColor,
                          fontSize: 35,
                          fontFamily: FontFamily.outfitBold,
                        ),
                        textAlign: TextAlign.start,
                      ),
                      10.ht,
                      Text(
                        "4.8 (5+ reviews) Thousands of happy travelers have trusted us with their visa applications",
                        style: context.labelSmall?.copyWith(
                          color: AppColors.darkSubText,
                          fontSize: 20,
                          fontFamily: FontFamily.outfitRegular,
                        ),
                        textAlign: TextAlign.start,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(24),
                        child: Wrap(
                          spacing: 20,
                          runSpacing: 20,
                          children: homeController.testimonials.map((item) {
                            return SizedBox(
                              width: 320,
                              height: 250,
                              child: TestimonialCard(data: item),
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            10.ht,
            const AppFooter(), // Add the footer here
          ],
        ),
      ),
    );
  }
}
