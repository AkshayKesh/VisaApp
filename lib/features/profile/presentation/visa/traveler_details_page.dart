import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:register_visa_web_app/core/constants/app_color.dart';
import 'package:register_visa_web_app/core/constants/font_family.dart';
import 'package:register_visa_web_app/core/constants/image_url.dart';
import 'package:register_visa_web_app/core/constants/router/router_names.dart';
import 'package:register_visa_web_app/core/utils/spacing_extension.dart';
import 'package:register_visa_web_app/core/utils/text_theme_extension.dart';
import 'package:register_visa_web_app/core/utils/utils.dart';
import 'package:register_visa_web_app/features/profile/presentation/visa/domain/travel_param.dart';
import 'package:register_visa_web_app/features/profile/presentation/visa/provider/application_details_provider.dart';
import 'package:register_visa_web_app/features/profile/presentation/widget/time_line_exception_tile.dart';
import 'package:register_visa_web_app/shared/widgets/custom_icon_button.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class TravelerDetailsScreen extends ConsumerStatefulWidget {
  const TravelerDetailsScreen({super.key, required this.appId});
  final String appId;

  @override
  ConsumerState<TravelerDetailsScreen> createState() =>
      _TravelerDetailsScreenState();
}

class _TravelerDetailsScreenState extends ConsumerState<TravelerDetailsScreen> {
  int selectedTraveller = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final detailsState = ref.watch(applicationDetailsProvider(widget.appId));

    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                Navigator.pop(context);
              },
              child: Align(
                alignment: Alignment.bottomLeft,
                child: Row(
                  children: [
                    Icon(Icons.arrow_back, color: AppColors.primaryBlue),
                    const SizedBox(width: 8),
                    Text('Back to Documents'),
                  ],
                ),
              ),
            ),
            20.ht,
            if (detailsState.isLoading) ...[
              const Center(child: CircularProgressIndicator()),
            ] else ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "${detailsState.data?.packageDetails?.country ?? ""} Visa Application",
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: AppColors.blackColor,
                      fontFamily: FontFamily.outfitBold,
                      fontSize: 25.0,
                    ),
                  ),
                  //if (widget.status == 'paid')
                  // Padding(
                  //   padding: const EdgeInsets.only(right: 10),
                  //   child: CustomIconButton(
                  //     text: "Give Feedback",
                  //     onPressed: () {
                  //       FeedbackDialog().showAsDialog(
                  //         context,
                  //         maxHeight: 350,
                  //         maxWidth: 400,
                  //         padding: const EdgeInsets.all(20),
                  //       );
                  //     },
                  //     width: 10.w,
                  //     height: 4.h,
                  //     borderRadius: 8,
                  //   ),
                  // ),
                ],
              ),
              10.ht,
              Text(
                "Applied on ${Utils.dateFormat(detailsState.data?.submittedDate?.toString() ?? "")}",
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.hintColor,
                ),
              ),
              24.ht,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Traveller",
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontFamily: FontFamily.outfitSemiBold,
                    ),
                  ),
                  if (detailsState.data?.status?.toLowerCase() == "draft")
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: CustomIconButton(
                        text: "Make Payment",
                        onPressed: () {
                          context.go(
                            "/visa/${RouterNames.draftPaymentPage}/${detailsState.data?.id}/${detailsState.data?.packageId}",
                          );
                        },
                        height: 36,
                        borderRadius: 4,
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 12),
              TravelerTab(
                onTap: (value) {
                  // Update the current tab on tap
                  ref.read(currentTravelerProvider.notifier).state = value;
                },
                titles: (detailsState.data?.travellerDetails ?? [])
                    .map((e) => e.fullName ?? "")
                    .toList(),

                height: 40,
              ),

              32.ht,
              Text("Your Visa Status", style: theme.textTheme.titleMedium),
              20.ht,

              // Timeline
              Consumer(
                builder: (context, ref, child) =>
                    TravelerApplicationStatusStapper(
                      travelersId: detailsState.data?.travellerId ?? [],
                      travellerId:
                          detailsState
                              .data
                              ?.travellerDetails[ref.watch(
                                currentTravelerProvider,
                              )]
                              .id ??
                          "",
                      applicaionId: detailsState.data?.id ?? "",
                      index: ref.watch(currentTravelerProvider),
                    ),
              ),
              40.ht,
              Divider(height: 1),

              //if (widget.status == 'draft')
              // Container(
              //   width: 150.w,
              //   decoration: BoxDecoration(
              //     color: AppColors.lightBackground,
              //     borderRadius: BorderRadius.circular(8),
              //     border: Border.all(color: AppColors.lightGrey100),
              //   ),
              //   padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              //   child: Column(
              //     children: [
              //       10.ht,
              //       Image.asset(ImageUrl.documentIcon, height: 50, color: AppColors.lightGrey200),
              //       10.ht,
              //       Text(
              //         "Visa document will be available once approved",
              //         style: context.titleMedium?.copyWith(color: AppColors.lightGrey200, fontFamily: FontFamily.outfitRegular, fontSize: 14.0),
              //       ),
              //       10.ht,
              //     ],
              //   ),
              // ),
              // else ...[
              //   20.ht,
              //   Text("Visa Document", style: theme.textTheme.titleMedium),
              //   12.ht,
              //   CustomIconButton(
              //     text: "View Visa",
              //     onPressed: () {},
              //     width: 10.w,
              //     height: 34.0,
              //     icon: Icon(Icons.download_outlined),
              //   ),
              // ],
            ],
          ],
        ),
      ),
    );
  }
}

class TravelerApplicationStatusStapper extends ConsumerStatefulWidget {
  const TravelerApplicationStatusStapper({
    super.key,
    required this.travellerId,
    required this.applicaionId,
    required this.index,
    required this.travelersId,
  });
  final String travellerId;
  final String applicaionId;
  final int index;
  final List<String> travelersId;

  @override
  ConsumerState<TravelerApplicationStatusStapper> createState() =>
      _TravelerApplicationStatusStapperState();
}

class _TravelerApplicationStatusStapperState
    extends ConsumerState<TravelerApplicationStatusStapper> {
  late TravelerIdParam params;

  @override
  void initState() {
    super.initState();
    params = TravelerIdParam(
      travellerId: widget.travelersId[widget.index],
      applicationId: widget.applicaionId,
    );
  }

  @override
  void didUpdateWidget(covariant TravelerApplicationStatusStapper oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.index != oldWidget.index) {
      // Update param to use the new index/value from widget
      params = TravelerIdParam(
        travellerId: widget.travelersId[widget.index],
        applicationId: widget.applicaionId,
      );
      ref.invalidate(travelerApplicationStatusStaper(params));
    }
  }

  @override
  Widget build(BuildContext context) {
    final applicationStatusState = ref.watch(
      travelerApplicationStatusStaper(params),
    );

    // if (applicationStatusState.isLoading) {
    //   return const Center(child: CircularProgressIndicator());
    if (applicationStatusState.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    final data = applicationStatusState.data;
    if (data == null) {
      return const Center(child: Text('No timeline data found.'));
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: data.length,
      itemBuilder: (context, index) {
        return TimelineExpansionTile(
          index: index,
          item: data[index]);
      },
    );
  }
}

class TravelerTab extends ConsumerWidget {
  const TravelerTab({
    super.key,
    required this.titles,
    required this.onTap,
    this.height = 40,
  });

  final List<String> titles;
  final Function(int) onTap;
  final double height;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(currentTravelerProvider);

    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        height: height,
        padding: const EdgeInsets.all(3),
        decoration: BoxDecoration(
          color: const Color(0xfff1f3f6),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(titles.length, (index) {
            final isActive = index == currentIndex;
            return InkWell(
              borderRadius: BorderRadius.circular(8),
              onTap: () {
                ref.read(currentTravelerProvider.notifier).state = index;
                onTap(index);
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeOut,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: isActive ? Colors.white : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: isActive
                      ? const [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 4,
                            offset: Offset(0, 2),
                          ),
                        ]
                      : null,
                ),
                child: Center(
                  child: Text(
                    titles[index],
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
