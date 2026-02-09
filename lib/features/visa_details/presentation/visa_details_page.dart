import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:register_visa_web_app/core/constants/app_color.dart';
import 'package:register_visa_web_app/core/constants/font_family.dart';
import 'package:register_visa_web_app/core/constants/image_url.dart';
import 'package:register_visa_web_app/core/constants/visa_type_enum.dart';
import 'package:register_visa_web_app/core/utils/spacing_extension.dart';
import 'package:register_visa_web_app/core/utils/text_theme_extension.dart';
import 'package:register_visa_web_app/core/utils/utils.dart';
import 'package:register_visa_web_app/features/visa_details/domain/visa_details_model.dart'; // Import VisaDetailsModel
import 'package:register_visa_web_app/features/visa_details/providers/details_provider.dart';
import 'package:register_visa_web_app/shared/services/visa_hive_service.dart';
import 'package:register_visa_web_app/shared/widgets/app_bar_widget.dart';
import 'package:register_visa_web_app/shared/widgets/app_footer.dart';
import 'package:register_visa_web_app/shared/widgets/drop_down_view.dart';
import 'package:register_visa_web_app/shared/widgets/visa_process_stepper.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../core/constants/app_constant.dart';
import '../../../core/constants/router/router_names.dart';
import '../../../core/utils/app_toast.dart';
import '../../../core/utils/dialog_extension copy.dart';
import '../../../core/utils/string_extension.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/app_drop_down.dart';
import '../../auth/presentation/login_dialog_view.dart';
import '../../home/providers/home_provider.dart';

class VisaDetailsPage extends ConsumerWidget {
  const VisaDetailsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detailsState = ref.watch(
      detailsProvider(VisaHiveService.instance.getVisaById()),
    );
    final screenWidth = MediaQuery.of(context).size.width;

    final isSmallScreen = screenWidth < 768;

    // Handle loading state
    if (detailsState.isLoading) {
      return _buildLoadingView(context);
    }

    // Handle error state
    if (detailsState.error != null) {
      return _buildErrorView(context, detailsState.error!, ref);
    }

    // Handle success state with data
    if (detailsState.isSuccess && detailsState.data != null) {
      return _buildSuccessView(context, detailsState.data!, isSmallScreen);
    }

    // Default loading state
    return _buildLoadingView(context);
  }

  Widget _buildLoadingView(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      body: const Center(
        child: CircularProgressIndicator(color: AppColors.primaryBlue),
      ),
    );
  }

  Widget _buildErrorView(BuildContext context, String error, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: AppColors.redColor),
            const SizedBox(height: 16),
            Text(
              'Failed to load visa details',
              style: context.titleLarge?.copyWith(
                color: AppColors.darkTextColor,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              error,
              style: context.bodyMedium?.copyWith(
                color: AppColors.lightSubText,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                ref
                    .read(
                      detailsProvider(
                        VisaHiveService.instance.getVisaById(),
                      ).notifier,
                    )
                    .fetchDetails(VisaHiveService.instance.getVisaById()!);
              },
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSuccessView(
    BuildContext context,
    VisaDetailsModel viewDetails,
    bool isSmallScreen,
  ) {
    screenSize = getSize(context);

    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomAppBar(),
            // Header Section
            _buildHeader(context, isSmallScreen, viewDetails),

            // Main Content Area
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 4.h),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  if (constraints.maxWidth > 900) {
                    return _buildLargeScreenLayout(context, viewDetails);
                  } else {
                    return _buildSmallScreenLayout(context, viewDetails);
                  }
                },
              ),
            ),

            AppFooter(), // Reusing the AppFooter
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(
    BuildContext context,
    bool isSmallScreen,
    VisaDetailsModel viewDetails,
  ) {
    return Container(
      height: isSmallScreen ? 200 : 400,
      width: double.infinity,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: NetworkImage(viewDetails.coverPhoto), // Use dynamic image URL
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.black.withValues(alpha: 0.5), Colors.transparent],
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
          ),
        ),
        child: Stack(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 4.h),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    viewDetails.title, // Use dynamic title
                    style: context.headlineLarge?.copyWith(
                      color: AppColors.lightBackground,
                      fontFamily: FontFamily.outfitBold,
                    ),
                  ),
                  5.ht,
                  Text(
                    viewDetails.subtitle, // Use dynamic subtitle
                    style: context.labelSmall?.copyWith(
                      color: AppColors.lightBackground,
                      fontFamily: FontFamily.outfitRegular,
                      fontSize: 15.0,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLargeScreenLayout(
    BuildContext context,
    VisaDetailsModel viewDetails,
  ) {
    return _buildStartApplicationCard(context, viewDetails);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildStartApplicationCard(context, viewDetails),
        // Expanded(
        //   flex: 2,
        //   child: Column(
        //     crossAxisAlignment: CrossAxisAlignment.start,
        //     children: [
        //       // /_buildVisaInformationCard(context, viewDetails),
        //       20.ht,
        //       //_buildIncludedPlacesCard(context, viewDetails),
        //       20.ht,
        //       //_buildVisaRequirementsCard(context, viewDetails),
        //       20.ht,
        //       //_buildVisaProcessFlowCard(context, viewDetails),
        //       20.ht,
        //       //_buildRejectionReasonsCard(context, viewDetails),
        //       20.ht,
        //       //_buildFAQSection(context, viewDetails),
        //       if (viewDetails.ratings.isNotEmpty) ...[20.ht, _buildRatingsReviewsSection(context, viewDetails)],
        //       20.ht,
        //     ],
        //   ),
        // ),
        // 20.wt,
        // Expanded(flex: 1, child: _buildStartApplicationCard(context, viewDetails)),
      ],
    );
  }

  Widget _buildSmallScreenLayout(
    BuildContext context,
    VisaDetailsModel viewDetails,
  ) {
    return _buildStartApplicationCard(context, viewDetails);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // _buildVisaInformationCard(context, viewDetails),
        20.ht,
        _buildIncludedPlacesCard(context, viewDetails),
        20.ht,
        _buildVisaRequirementsCard(context, viewDetails),
        20.ht,
        _buildVisaProcessFlowCard(context, viewDetails),
        20.ht,
        _buildRejectionReasonsCard(context, viewDetails),
        20.ht,
        _buildFAQSection(context, viewDetails),
        if (viewDetails.ratings.isNotEmpty) ...[
          20.ht,
          _buildRatingsReviewsSection(context, viewDetails),
        ],
        20.ht,
        _buildStartApplicationCard(
          context,
          viewDetails,
        ), // Appears at bottom on small screens
      ],
    );
  }

  Widget _buildIncludedPlacesCard(
    BuildContext context,
    VisaDetailsModel viewDetails,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.lightBackground, // Background for tile
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.textFieldBorderColor),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Image.asset(ImageUrl.locationIcon, height: 21),
                6.wt,
                Text(
                  'Included Places',
                  style: context.titleMedium?.copyWith(
                    color: AppColors.darkTextColor,
                    fontFamily: FontFamily.outfitSemiBold,
                  ),
                ),
              ],
            ),
            20.ht,
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: viewDetails.includedPlaces
                    .map(
                      (place) => _buildPlaceItem(
                        context,
                        place.placeName,
                        place.placeImage,
                      ),
                    )
                    .toList(), // Use dynamic data
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceItem(BuildContext context, String name, String imageUrl) {
    screenSize = getSize(context);

    return Container(
      margin: EdgeInsets.only(
        left: screenSize == ScreenSize.extraLarge ? 20 : 10,
      ),
      decoration: BoxDecoration(
        color: AppColors.lightBackground, // Background for tile
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.textFieldBorderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: CachedNetworkImage(
              height:
                  (screenSize == ScreenSize.extraLarge ||
                      screenSize == ScreenSize.large)
                  ? 160
                  : 100,
              width:
                  (screenSize == ScreenSize.extraLarge ||
                      screenSize == ScreenSize.large)
                  ? 450
                  : 400,
              imageUrl: imageUrl,
              fit: BoxFit.cover,
              placeholder: (context, url) => Container(
                color: Colors.grey.shade300,
                child: const Center(child: CircularProgressIndicator()),
              ),
              errorWidget: (context, url, error) => Container(
                color: Colors.grey.shade300,
                child: const Icon(
                  Icons.image_not_supported,
                  color: Colors.grey,
                  size: 48,
                ),
              ),
            ),
          ),
          8.ht,
          Padding(
            padding: EdgeInsetsGeometry.only(left: 8, top: 8, bottom: 8),
            child: Text(
              name,
              style: context.bodyMedium?.copyWith(
                color: AppColors.darkBackground,
                fontFamily: FontFamily.outfitMedium,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVisaRequirementsCard(
    BuildContext context,
    VisaDetailsModel viewDetails,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.lightBackground, // Background for tile
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.textFieldBorderColor),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Image.asset(ImageUrl.documentIcon, height: 21),
                6.wt,
                Text(
                  'Visa Requirements',
                  style: context.titleMedium?.copyWith(
                    color: AppColors.darkTextColor,
                    fontFamily: FontFamily.outfitSemiBold,
                  ),
                ),
              ],
            ),
            10.ht,
            ...viewDetails.visaRequirements.map(
              (req) => _buildRequirementItem(context, req),
            ), // Use dynamic data
          ],
        ),
      ),
    );
  }

  Widget _buildRequirementItem(BuildContext context, String requirement) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        children: [
          Image.asset(ImageUrl.checkMarkIcon, height: 21),
          10.wt,
          Expanded(
            child: Text(
              requirement,
              style: context.bodyMedium?.copyWith(
                color: AppColors.darkTextColor,
                fontFamily: FontFamily.outfitRegular,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVisaProcessFlowCard(
    BuildContext context,
    VisaDetailsModel viewDetails,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.lightBackground, // Background for tile
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.textFieldBorderColor),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Visa Process Flow',
              style: context.titleMedium?.copyWith(
                color: AppColors.darkTextColor,
                fontFamily: FontFamily.outfitSemiBold,
              ),
            ),
            20.ht,
            VisaProcessStepper(
              steps: viewDetails.visaProcessFlow,
            ), // Use the new stepper widget
          ],
        ),
      ),
    );
  }

  Widget _buildRejectionReasonsCard(
    BuildContext context,
    VisaDetailsModel viewDetails,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.lightBackground, // Background for tile
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.textFieldBorderColor),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Image.asset(ImageUrl.closeRedIcon, height: 24),
                8.wt,
                Text(
                  'Common Visa Rejection Reasons',
                  style: context.titleMedium?.copyWith(
                    color: AppColors.darkBackground,
                    fontFamily: FontFamily.outfitSemiBold,
                  ),
                ),
              ],
            ),
            10.ht,
            ...viewDetails.commonVisaRejectionReasons.map(
              (reason) => _buildRejectionReasonItem(context, reason),
            ), // Use dynamic data
          ],
        ),
      ),
    );
  }

  Widget _buildRejectionReasonItem(BuildContext context, String reason) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        children: [
          Icon(Icons.circle, color: AppColors.redColor, size: 6),
          10.wt,
          Expanded(
            child: Text(
              reason,
              style: context.bodyMedium?.copyWith(
                color: AppColors.darkTextColor,
                fontFamily: FontFamily.outfitRegular,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFAQSection(BuildContext context, VisaDetailsModel viewDetails) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.lightBackground, // Background for tile
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.textFieldBorderColor),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Frequently Asked Questions',
              style: context.titleMedium?.copyWith(
                color: AppColors.darkBackground,
                fontFamily: FontFamily.outfitSemiBold,
              ),
            ),
            20.ht,
            ...viewDetails.faqs.map(
              (faq) => _buildExpansionTile(
                context,
                faq.question,
                faq.answer,
              ), // Pass disableHoverEffect
            ), // Use dynamic data
          ],
        ),
      ),
    );
  }

  Widget _buildExpansionTile(
    BuildContext context,
    String question,
    String answer,
  ) {
    ValueNotifier isExpanded = ValueNotifier(false);
    return Theme(
      data: Theme.of(context).copyWith(
        hoverColor: AppColors.lightBackground,
        dividerColor: Colors.transparent,
      ),
      child: ValueListenableBuilder(
        valueListenable: isExpanded,
        builder: (context, value, child) => ExpansionTile(
          onExpansionChanged: (value) {
            isExpanded.value = !isExpanded.value;
          },
          iconColor: AppColors.blackColor,
          trailing: Icon(
            isExpanded.value
                ? Icons.keyboard_arrow_up
                : Icons.keyboard_arrow_down,
            color: AppColors.blackColor,
          ),

          title: Text(
            question,
            style: context.titleMedium?.copyWith(
              color: AppColors.darkBackground,
              fontFamily: FontFamily.outfitMedium,
            ),
          ),
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.only(top: 10.0, left: 20),
                child: Text(
                  answer,
                  style: context.bodyMedium?.copyWith(
                    color: AppColors.lightSubText,
                    fontFamily: FontFamily.outfitRegular,
                  ),
                ),
              ),
            ),
            8.wt,
          ],
        ),
      ),
    );
  }

  Widget _buildRatingsReviewsSection(
    BuildContext context,
    VisaDetailsModel viewDetails,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.lightBackground, // Background for tile
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.textFieldBorderColor),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Image.asset(ImageUrl.fillStarIcon, height: 18),
                8.wt,
                Text(
                  'Ratings & Reviews',
                  style: context.titleMedium?.copyWith(
                    color: AppColors.darkBackground,
                    fontFamily: FontFamily.outfitSemiBold,
                  ),
                ),
              ],
            ),
            20.ht,
            ...viewDetails.ratings.map(
              (review) => _buildReviewItem(
                context,
                review.user.fullName,
                review.rating.toInt(),
                review.review,
              ),
            ), // Use dynamic data
          ],
        ),
      ),
    );
  }

  Widget _buildReviewItem(
    BuildContext context,
    String name,
    int rating,
    String comment,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                backgroundColor: AppColors.primaryBlue.withValues(alpha: 0.2),
                child: Text(
                  name[0],
                  style: context.titleSmall?.copyWith(
                    color: AppColors.primaryBlue,
                    fontFamily: FontFamily.outfitMedium,
                  ),
                ),
              ),
              10.wt,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: context.titleSmall?.copyWith(
                        color: AppColors.darkBackground,
                      ),
                    ),
                    5.ht,
                    Row(
                      children: List.generate(5, (index) {
                        return Image.asset(ImageUrl.fillStarIcon, height: 18);
                      }),
                    ),
                    5.ht,
                  ],
                ),
              ),
            ],
          ),
          Text(
            comment,
            style: context.labelSmall?.copyWith(
              color: AppColors.lightSubText,
              fontFamily: FontFamily.outfitRegular,
              fontSize: 13.0,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStartApplicationCard(
    BuildContext context,
    VisaDetailsModel viewDetails,
  ) {
    screenSize = getSize(context);

    VisaOption visaOption = viewDetails.availableVisaOptions
        .where((e) => e.isActive ?? false)
        .first;

    return Consumer(
      builder: (context, ref, child) {
        final state = ref.watch(
          selectedVisaTypeProvider(visaOption.visaType ?? ""),
        );
        return (screenSize == ScreenSize.large ||
                screenSize == ScreenSize.extraLarge)
            ? Column(
                children: [
                  Row(
                    spacing: 20,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 3,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Apply now for your ${viewDetails.country} ${state?.visaType ?? ""}",
                              style: context.bodyLarge?.copyWith(
                                fontSize: 23,
                                color: AppColors.lightGrey200,
                                fontFamily: FontFamily.outfitRegular,
                              ),
                            ),
                            10.ht,
                            Text(
                              "The ${viewDetails.country} ${state?.visaType ?? ""} is mandatory for ${ref.watch(passportCountryProvider).name} passport holders travelling to ${viewDetails.country}",
                              style: context.bodyLarge?.copyWith(
                                fontSize: 13,
                                color: AppColors.blackColor,
                                fontFamily: FontFamily.outfitRegular,
                              ),
                            ),
                            20.ht,
                            Consumer(
                              builder: (context, ref, child) {
                                return AppCustomDropdown(
                                  title: "Your Passport",
                                  hint: "Select",
                                  maxHeight: 180,
                                  value: ref.watch(passportCountryProvider),
                                  itemLabel: (value) => value,
                                  onChanged: (value) {
                                    ref
                                        .read(passportCountryProvider.notifier)
                                        .setCountry(value);
                                  },
                                );
                              },
                            ),
                            20.ht,
                            DropDownView(
                              title: "Applying Visa",
                              hint: "Select",
                              titleStyle: context.labelMedium?.copyWith(
                                fontFamily: FontFamily.outfitSemiBold,
                                fontSize: 16.0,
                              ),
                              items: viewDetails.availableVisaOptions
                                  .where((e) => e.isActive ?? false)
                                  .map(
                                    (e) =>
                                        VisaType.getLabelFromKey(e.visaType) ??
                                        "",
                                  )
                                  .toList(),
                              style: context.textTheme.bodyMedium!.copyWith(
                                fontFamily: FontFamily.outfitMedium,
                                fontSize: 13,
                              ),
                              value: state?.visaType == null
                                  ? null
                                  : VisaType.getLabelFromKey(
                                      (ref
                                          .watch(
                                            selectedVisaTypeProvider(
                                              visaOption.visaType!,
                                            ),
                                          )
                                          ?.visaType),
                                    ),
                              onChanged: (value) {
                                ref
                                    .read(
                                      selectedVisaTypeProvider(
                                        visaOption.visaType!,
                                      ).notifier,
                                    )
                                    .state = getVisaOptionByType(
                                  value!,
                                  viewDetails.availableVisaOptions,
                                );
                              },
                            ),
                            20.ht,
                            Container(
                              width: 120,
                              decoration: BoxDecoration(
                                color: AppColors.lightBackground,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: AppColors.textFieldBorderColor,
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  GestureDetector(
                                    behavior: HitTestBehavior.opaque,
                                    onTap: () {
                                      if (ref.watch(personCountProvider).count >
                                          1) {
                                        ref
                                            .read(personCountProvider.notifier)
                                            .state = ref
                                            .read(personCountProvider.notifier)
                                            .state
                                            .copyWith(
                                              count:
                                                  ref
                                                      .watch(
                                                        personCountProvider,
                                                      )
                                                      .count -
                                                  1,
                                            );
                                      }
                                    },
                                    child: Container(
                                      margin: EdgeInsets.only(
                                        left: 5,
                                        top: 2,
                                        bottom: 2,
                                      ),

                                      decoration: BoxDecoration(
                                        color:
                                            ref
                                                    .watch(personCountProvider)
                                                    .count ==
                                                1
                                            ? AppColors.greyColor
                                            : AppColors.lightBackground,
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(
                                          color: AppColors.textFieldBorderColor,
                                        ),
                                      ),

                                      child: Padding(
                                        padding: const EdgeInsets.all(6.0),
                                        child: Image.asset(
                                          ImageUrl.minusImage,
                                          height: 24,
                                          width: 24,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Text(
                                    "${ref.watch(personCountProvider).count}",
                                    style: context.bodyMedium?.copyWith(
                                      color: AppColors.blackColor,
                                      fontFamily: FontFamily.outfitMedium,
                                      fontSize: 20.0,
                                    ),
                                  ),

                                  GestureDetector(
                                    behavior: HitTestBehavior.opaque,
                                    onTap: () {
                                      ref
                                          .read(personCountProvider.notifier)
                                          .state = ref
                                          .read(personCountProvider.notifier)
                                          .state
                                          .copyWith(
                                            count:
                                                ref
                                                    .watch(personCountProvider)
                                                    .count +
                                                1,
                                          );
                                    },
                                    child: Container(
                                      margin: EdgeInsets.only(
                                        right: 5,
                                        top: 2,
                                        bottom: 2,
                                      ),

                                      decoration: BoxDecoration(
                                        color: AppColors.lightBackground,
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(
                                          color: AppColors.textFieldBorderColor,
                                        ),
                                      ),

                                      child: Padding(
                                        padding: const EdgeInsets.all(6.0),
                                        child: Image.asset(
                                          ImageUrl.addImage,
                                          height: 24,
                                          width: 24,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppColors
                                .lightBackground, // Background for tile
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: AppColors.textFieldBorderColor,
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "${viewDetails.country} ${state?.visaType ?? ""}",
                                  style: context.bodyLarge?.copyWith(
                                    fontSize: 23,
                                    color: AppColors.blackColor,
                                    fontFamily: FontFamily.outfitRegular,
                                  ),
                                ),
                                8.ht,
                                Divider(
                                  height: 2,
                                  color: AppColors.lightGrey200,
                                ),
                                20.ht,
                                Row(
                                  children: [
                                    Container(
                                      height: 46,
                                      width: 46,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: AppColors.darkSubText.withValues(
                                          alpha: 0.1,
                                        ),
                                      ),
                                      padding: EdgeInsets.all(11),
                                      child: Image.asset(
                                        ImageUrl.travelIcon,
                                        height: 26,
                                        width: 26,
                                      ),
                                    ),
                                    10.wt,
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Type of entity",
                                            style: context.bodyMedium?.copyWith(
                                              color: AppColors.darkTextColor,
                                              fontFamily:
                                                  FontFamily.outfitRegular,
                                            ),
                                          ),
                                          Text(
                                            state?.entryType?.toCamelCase() ??
                                                "",
                                            style: context.bodyMedium?.copyWith(
                                              color: AppColors.blackColor,
                                              fontSize: 16.0,
                                              fontFamily:
                                                  FontFamily.outfitMedium,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                20.ht,
                                Row(
                                  children: [
                                    Container(
                                      height: 46,
                                      width: 46,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: AppColors.darkSubText.withValues(
                                          alpha: 0.1,
                                        ),
                                      ),
                                      padding: EdgeInsets.all(11),
                                      child: Image.asset(
                                        ImageUrl.calenderIcon,
                                        height: 24,
                                        width: 24,
                                      ),
                                    ),
                                    10.wt,
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Visa Validity",
                                            style: context.bodyMedium?.copyWith(
                                              color: AppColors.darkTextColor,
                                              fontFamily:
                                                  FontFamily.outfitRegular,
                                            ),
                                          ),
                                          Text(
                                            "${state?.visaValidity ?? ""}",
                                            style: context.bodyMedium?.copyWith(
                                              color: AppColors.blackColor,
                                              fontSize: 16.0,
                                              fontFamily:
                                                  FontFamily.outfitMedium,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                20.ht,
                                Row(
                                  children: [
                                    Container(
                                      height: 46,
                                      width: 46,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: AppColors.darkSubText.withValues(
                                          alpha: 0.1,
                                        ),
                                      ),
                                      padding: EdgeInsets.all(11),
                                      child: Image.asset(
                                        ImageUrl.markIcon,
                                        height: 24,
                                        width: 24,
                                      ),
                                    ),
                                    10.wt,
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Length Of Stay",
                                            style: context.bodyMedium?.copyWith(
                                              color: AppColors.darkTextColor,
                                              fontFamily:
                                                  FontFamily.outfitRegular,
                                            ),
                                          ),
                                          Text(
                                            "${state?.lengthOfStay ?? ""}",
                                            style: context.bodyMedium?.copyWith(
                                              color: AppColors.blackColor,
                                              fontSize: 16.0,
                                              fontFamily:
                                                  FontFamily.outfitMedium,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                30.ht,
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  20.ht,
                  Row(
                    spacing: 20,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Expanded(flex: 3, child: SizedBox()),
                      Expanded(
                        child: PrimaryButton(
                          text: 'Start Application',
                          onPressed: () {
                            if (AppConstants.authToken.isNotEmpty) {
                              final selectedVisaOption = ref.read(
                                selectedVisaTypeProvider(visaOption.visaType!),
                              );
                              if (selectedVisaOption == null) {
                                AppToast.error(context, 'Visa Type Required');

                                return;
                              }
                              if (selectedVisaOption.lengthOfStay == null ||
                                  selectedVisaOption.lengthOfStay == 0) {
                                AppToast.error(
                                  context,
                                  'Length of Stay Required',
                                );
                                return;
                              }
                              if (selectedVisaOption.visaValidity == null ||
                                  selectedVisaOption.visaValidity == 0) {
                                AppToast.error(
                                  context,
                                  'Visa Validity Required',
                                );

                                return;
                              }
                              if (selectedVisaOption.visaFee == null ||
                                  selectedVisaOption.visaFee == 0) {
                                AppToast.error(context, 'Visa Fee Required');
                                return;
                              }
                              if (selectedVisaOption.entryType == null ||
                                  selectedVisaOption.entryType!.isEmpty) {
                                AppToast.error(context, "Entry Type Required");
                                return;
                              }

                              final visaType = (ref
                                  .read(
                                    selectedVisaTypeProvider(
                                      visaOption.visaType!,
                                    ),
                                  )
                                  ?.visaType);
                              final lengthOfStay = (ref
                                  .read(
                                    selectedVisaTypeProvider(
                                      visaOption.visaType!,
                                    ),
                                  )
                                  ?.lengthOfStay);
                              final visaValidity = (ref
                                  .read(
                                    selectedVisaTypeProvider(
                                      visaOption.visaType!,
                                    ),
                                  )
                                  ?.visaValidity);
                              final visaFee = (ref
                                  .read(
                                    selectedVisaTypeProvider(
                                      visaOption.visaType!,
                                    ),
                                  )
                                  ?.visaFee);
                              final entryType = (ref
                                  .read(
                                    selectedVisaTypeProvider(
                                      visaOption.visaType!,
                                    ),
                                  )
                                  ?.entryType);

                              VisaHiveService.instance.updateVisaApplication(
                                visaType ?? "",
                                lengthOfStay ?? 0,
                                visaValidity ?? 0,
                                viewDetails.country,
                                entryType ?? '',
                                visaFee ?? 0,
                              );

                              ref.read(personCountProvider.notifier).state = ref
                                  .read(personCountProvider.notifier)
                                  .state
                                  .copyWith(
                                    count: ref.watch(personCountProvider).count,
                                    country: ref.watch(passportCountryProvider),
                                  );
                              context.goNamed(RouterNames.applicationPage);
                            } else {
                              LoginDialogView().showAsDialog(
                                context,
                                maxHeight: 800,
                                maxWidth: 500,
                                padding: const EdgeInsets.all(20),
                              );
                            }
                          },
                          color: AppColors.primaryBlue,
                          textColor: Colors.white,
                          height: 44,
                          borderRadius: 8,
                        ),
                      ),
                    ],
                  ),
                ],
              )
            : Column(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Apply now for your ${viewDetails.country} ${state?.visaType ?? ""}",
                        style: context.bodyLarge?.copyWith(
                          fontSize: 23,
                          color: AppColors.lightGrey200,
                          fontFamily: FontFamily.outfitRegular,
                        ),
                      ),
                      10.ht,
                      Text(
                        "The ${viewDetails.country} ${state?.visaType ?? ""} is mandatory for ${ref.watch(passportCountryProvider).name} passport holders travelling to ${viewDetails.country}",
                        style: context.bodyLarge?.copyWith(
                          fontSize: 13,
                          color: AppColors.blackColor,
                          fontFamily: FontFamily.outfitRegular,
                        ),
                      ),
                      20.ht,
                      Consumer(
                        builder: (context, ref, child) {
                          return AppCustomDropdown(
                            title: "Your Passport",
                            hint: "Select",
                            maxHeight: 180,
                            value: ref.watch(passportCountryProvider),
                            itemLabel: (value) => value,
                            onChanged: (value) {
                              ref
                                  .read(passportCountryProvider.notifier)
                                  .setCountry(value);
                            },
                          );
                        },
                      ),
                      20.ht,
                      DropDownView(
                        title: "Applying Visa",
                        hint: "Select",
                        titleStyle: context.labelMedium?.copyWith(
                          fontFamily: FontFamily.outfitSemiBold,
                          fontSize: 16.0,
                        ),
                        items: viewDetails.availableVisaOptions
                            .where((e) => e.isActive ?? false)
                            .map(
                              (e) => VisaType.getLabelFromKey(e.visaType) ?? "",
                            )
                            .toList(),
                        style: context.textTheme.bodyMedium!.copyWith(
                          fontFamily: FontFamily.outfitMedium,
                          fontSize: 13,
                        ),
                        value: state?.visaType == null
                            ? null
                            : VisaType.getLabelFromKey(
                                (ref
                                    .watch(
                                      selectedVisaTypeProvider(
                                        visaOption.visaType!,
                                      ),
                                    )
                                    ?.visaType),
                              ),
                        onChanged: (value) {
                          ref
                              .read(
                                selectedVisaTypeProvider(
                                  visaOption.visaType!,
                                ).notifier,
                              )
                              .state = getVisaOptionByType(
                            value!,
                            viewDetails.availableVisaOptions,
                          );
                        },
                      ),
                      20.ht,
                      Container(
                        width: 120,
                        decoration: BoxDecoration(
                          color: AppColors.lightBackground,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: AppColors.textFieldBorderColor,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              behavior: HitTestBehavior.opaque,
                              onTap: () {
                                if (ref.watch(personCountProvider).count > 1) {
                                  ref
                                      .read(personCountProvider.notifier)
                                      .state
                                      .count--;
                                }
                              },
                              child: Container(
                                margin: EdgeInsets.only(
                                  left: 5,
                                  top: 2,
                                  bottom: 2,
                                ),

                                decoration: BoxDecoration(
                                  color:
                                      ref.watch(personCountProvider).count == 1
                                      ? AppColors.greyColor
                                      : AppColors.lightBackground,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: AppColors.textFieldBorderColor,
                                  ),
                                ),

                                child: Padding(
                                  padding: const EdgeInsets.all(6.0),
                                  child: Image.asset(
                                    ImageUrl.minusImage,
                                    height: 24,
                                    width: 24,
                                  ),
                                ),
                              ),
                            ),

                            // Text(
                            //   "${ref.watch(personCountProvider).count}",
                            //   style: context.bodyMedium?.copyWith(
                            //     color: AppColors.blackColor,
                            //     fontFamily: FontFamily.outfitMedium,
                            //     fontSize: 20.0,
                            //   ),
                            // ),
                            GestureDetector(
                              behavior: HitTestBehavior.opaque,
                              onTap: () {
                                ref
                                    .read(personCountProvider.notifier)
                                    .state
                                    .count++;
                              },
                              child: Container(
                                margin: EdgeInsets.only(
                                  right: 5,
                                  top: 2,
                                  bottom: 2,
                                ),

                                decoration: BoxDecoration(
                                  color: AppColors.lightBackground,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: AppColors.textFieldBorderColor,
                                  ),
                                ),

                                child: Padding(
                                  padding: const EdgeInsets.all(6.0),
                                  child: Image.asset(
                                    ImageUrl.addImage,
                                    height: 24,
                                    width: 24,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 20),
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.lightBackground, // Background for tile
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppColors.textFieldBorderColor),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${ref.watch(passportCountryProvider).name} ${state?.visaType ?? ""}",
                            style: context.bodyLarge?.copyWith(
                              fontSize: 23,
                              color: AppColors.blackColor,
                              fontFamily: FontFamily.outfitRegular,
                            ),
                          ),
                          8.ht,
                          Divider(height: 2, color: AppColors.lightGrey200),
                          20.ht,
                          Row(
                            children: [
                              Container(
                                height: 46,
                                width: 46,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: AppColors.darkSubText.withValues(
                                    alpha: 0.1,
                                  ),
                                ),
                                padding: EdgeInsets.all(11),
                                child: Image.asset(
                                  ImageUrl.travelIcon,
                                  height: 26,
                                  width: 26,
                                ),
                              ),
                              10.wt,
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Type of entity",
                                    style: context.bodyMedium?.copyWith(
                                      color: AppColors.darkTextColor,
                                      fontFamily: FontFamily.outfitRegular,
                                    ),
                                  ),
                                  Text(
                                    state?.entryType?.toCamelCase() ?? "",
                                    style: context.bodyMedium?.copyWith(
                                      color: AppColors.blackColor,
                                      fontSize: 16.0,
                                      fontFamily: FontFamily.outfitMedium,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          20.ht,
                          Row(
                            children: [
                              Container(
                                height: 46,
                                width: 46,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: AppColors.darkSubText.withValues(
                                    alpha: 0.1,
                                  ),
                                ),
                                padding: EdgeInsets.all(11),
                                child: Image.asset(
                                  ImageUrl.calenderIcon,
                                  height: 24,
                                  width: 24,
                                ),
                              ),
                              10.wt,
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Visa Validity",
                                    style: context.bodyMedium?.copyWith(
                                      color: AppColors.darkTextColor,
                                      fontFamily: FontFamily.outfitRegular,
                                    ),
                                  ),
                                  Text(
                                    "${state?.visaValidity ?? ""}",
                                    style: context.bodyMedium?.copyWith(
                                      color: AppColors.blackColor,
                                      fontSize: 16.0,
                                      fontFamily: FontFamily.outfitMedium,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          20.ht,
                          Row(
                            children: [
                              Container(
                                height: 46,
                                width: 46,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: AppColors.darkSubText.withValues(
                                    alpha: 0.1,
                                  ),
                                ),
                                padding: EdgeInsets.all(11),
                                child: Image.asset(
                                  ImageUrl.markIcon,
                                  height: 24,
                                  width: 24,
                                ),
                              ),
                              10.wt,
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Length Of Stay",
                                    style: context.bodyMedium?.copyWith(
                                      color: AppColors.darkTextColor,
                                      fontFamily: FontFamily.outfitRegular,
                                    ),
                                  ),
                                  Text(
                                    "${state?.lengthOfStay ?? ""}",
                                    style: context.bodyMedium?.copyWith(
                                      color: AppColors.blackColor,
                                      fontSize: 16.0,
                                      fontFamily: FontFamily.outfitMedium,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          30.ht,
                        ],
                      ),
                    ),
                  ),
                  20.ht,
                  PrimaryButton(
                    text: 'Start Application',
                    onPressed: () {
                      if (AppConstants.authToken.isNotEmpty) {
                        final selectedVisaOption = ref.read(
                          selectedVisaTypeProvider(visaOption.visaType!),
                        );
                        if (selectedVisaOption == null) {
                          AppToast.error(context, 'Visa Type Required');

                          return;
                        }
                        if (selectedVisaOption.lengthOfStay == null ||
                            selectedVisaOption.lengthOfStay == 0) {
                          AppToast.error(context, 'Length of Stay Required');
                          return;
                        }
                        if (selectedVisaOption.visaValidity == null ||
                            selectedVisaOption.visaValidity == 0) {
                          AppToast.error(context, 'Visa Validity Required');

                          return;
                        }
                        if (selectedVisaOption.visaFee == null ||
                            selectedVisaOption.visaFee == 0) {
                          AppToast.error(context, 'Visa Fee Required');
                          return;
                        }
                        if (selectedVisaOption.entryType == null ||
                            selectedVisaOption.entryType!.isEmpty) {
                          AppToast.error(context, "Entry Type Required");
                          return;
                        }

                        final visaType = (ref
                            .read(
                              selectedVisaTypeProvider(visaOption.visaType!),
                            )
                            ?.visaType);
                        final lengthOfStay = (ref
                            .read(
                              selectedVisaTypeProvider(visaOption.visaType!),
                            )
                            ?.lengthOfStay);
                        final visaValidity = (ref
                            .read(
                              selectedVisaTypeProvider(visaOption.visaType!),
                            )
                            ?.visaValidity);
                        final visaFee = (ref
                            .read(
                              selectedVisaTypeProvider(visaOption.visaType!),
                            )
                            ?.visaFee);
                        final entryType = (ref
                            .read(
                              selectedVisaTypeProvider(visaOption.visaType!),
                            )
                            ?.entryType);

                        VisaHiveService.instance.updateVisaApplication(
                          visaType ?? "",
                          lengthOfStay ?? 0,
                          visaValidity ?? 0,
                          viewDetails.country,
                          entryType ?? '',
                          visaFee ?? 0,
                        );
                        int count = ref
                            .read(personCountProvider.notifier)
                            .state
                            .count;
                        ref
                            .read(personCountProvider.notifier)
                            .state
                            .copyWith(
                              count: count,
                              country: ref.watch(passportCountryProvider),
                            );
                        context.goNamed(RouterNames.applicationPage);
                      } else {
                        LoginDialogView().showAsDialog(
                          context,
                          maxHeight: 800,
                          maxWidth: 500,
                          padding: const EdgeInsets.all(20),
                        );
                      }
                    },
                    color: AppColors.primaryBlue,
                    textColor: Colors.white,
                    height: 44,
                    borderRadius: 8,
                  ),
                ],
              );
      },
    );
  }
}
