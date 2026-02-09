import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:register_visa_web_app/core/constants/app_color.dart';
import 'package:register_visa_web_app/core/constants/font_family.dart';
import 'package:register_visa_web_app/core/constants/router/router_names.dart';
import 'package:register_visa_web_app/core/utils/app_toast.dart';
import 'package:register_visa_web_app/core/utils/text_theme_extension.dart';
import 'package:register_visa_web_app/core/utils/utils.dart';
import 'package:register_visa_web_app/features/profile/domain/card_model.dart';
import 'package:register_visa_web_app/features/profile/presentation/card/card_page.dart';
import 'package:register_visa_web_app/features/profile/providers/card_provider.dart';
import 'package:register_visa_web_app/features/visa_details/domain/visa_details_model.dart';
import 'package:register_visa_web_app/features/visa_details/providers/details_provider.dart';
import 'package:register_visa_web_app/features/visa_process/domain/processing_model.dart';
import 'package:register_visa_web_app/features/visa_process/domain/traveller_model.dart';
import 'package:register_visa_web_app/features/visa_process/providers/application_provider.dart';
import 'package:register_visa_web_app/features/visa_process/providers/application_state.dart';
import 'package:register_visa_web_app/shared/services/visa_hive_service.dart';
import 'package:register_visa_web_app/shared/widgets/custom_icon_button.dart';

class CheckOutPage extends ConsumerStatefulWidget {
  const CheckOutPage({super.key});

  @override
  ConsumerState<CheckOutPage> createState() => _CheckOutPageState();
}

class _CheckOutPageState extends ConsumerState<CheckOutPage> {
  late String visaId;

  @override
  void initState() {
    super.initState();
    visaId = VisaHiveService.instance.getVisaById()!;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.invalidate(detailsProvider(visaId));
    });
  }

  @override
  Widget build(BuildContext context) {
    final detailsState = ref.watch(detailsProvider(visaId));

    screenSize = getSize(context);
    final state = ref.watch(
      visaApplicationProvider(ref.watch(personCountProvider)),
    );

    final controller = ref.read(
      visaApplicationProvider(ref.watch(personCountProvider)).notifier,
    );

    // Setup listener only once per widget lifecycle (safe for hot reloads)

    ref.listen(visaApplicationProvider(ref.watch(personCountProvider)), (
      previous,
      next,
    ) {
      if (next.isMakePaymentSuccess) {
        final appId = ref
            .read(
              visaApplicationProvider(ref.watch(personCountProvider)).notifier,
            )
            .applicationId;
        Future.delayed(Duration(seconds: 1), () {
          VisaHiveService.instance.clearAll();
          ref.invalidate(activeStepProvider);
          ref.invalidate(cardProvider);
          ref
              .read(
                visaApplicationProvider(
                  ref.watch(personCountProvider),
                ).notifier,
              )
              .clearState();
          AppToast.success(context, next.successPaymentMessage ?? "");
          final uri = appId != null && appId.isNotEmpty
              ? Uri(
                  path: RouterNames.evisaApplication,
                  queryParameters: {'applicationId': appId},
                )
              : Uri(path: RouterNames.evisaApplication);
          context.go(uri.toString());
        });
      }
      if (next.makePaymentError?.isNotEmpty ?? false) {
        AppToast.error(context, next.makePaymentError ?? "");
      }
    });

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final isMobile = width < 600;

        if (detailsState.isLoading) {
          return Center(child: CircularProgressIndicator());
        }

        return SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal:
                  (screenSize == ScreenSize.small ||
                      screenSize == ScreenSize.normal)
                  ? 10
                  : 140,
              vertical: 24,
            ),
            child: Column(
              children: [
                /// 🔹 MAIN CONTENT
                (screenSize == ScreenSize.small ||
                        screenSize == ScreenSize.normal)
                    ? _mobileLayout(
                        state,
                        (model) => controller.upatdeCard(model.id),
                        detailsState.data?.processingFee ?? [],
                      )
                    : _desktopLayout(
                        state,
                        (model) => controller.upatdeCard(model.id),
                        detailsState.data?.processingFee ?? [],
                      ),

                const SizedBox(height: 32),

                /// 🔹 PAY BUTTON
                Align(
                  alignment:
                      (screenSize == ScreenSize.small ||
                          screenSize == ScreenSize.normal)
                      ? Alignment.center
                      : Alignment.centerRight,
                  child: CustomIconButton(
                    buttonState: state.isMakePaymentLoading,
                    text: "Make Payment",
                    width: isMobile ? double.infinity : 180,
                    height: 48,

                    onPressed: () async {
                      if (controller.cardId == null ||
                          controller.cardId!.isEmpty) {
                        AppToast.error(context, "Please select a card");
                        return;
                      }
                      if (controller.processId == null ||
                          controller.processId!.isEmpty) {
                        AppToast.error(
                          context,
                          "Please select a processing time",
                        );
                        return;
                      }
                      await controller.makePayment();
                    },
                    color: AppColors.primaryBlue,
                    textColor: AppColors.lightCard,
                    trailingIcon: const Icon(Icons.credit_card_rounded),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );

    // return Container(
    //   decoration: BoxDecoration(),
    //   child: Column(
    //     children: [
    //       Padding(
    //         padding: EdgeInsets.symmetric(horizontal: 8.w),
    //         child: Row(
    //           crossAxisAlignment: CrossAxisAlignment.start,
    //           children: [
    //             /// LEFT SIDE
    //             Expanded(
    //               flex: 2,
    //               child: Column(
    //                 children: [
    //                   VisaSummaryCard(),
    //                   SizedBox(height: 20),
    //                   ProcessingTimeCard(
    //                     noOfTraveler: state.travellers.length.toString(),
    //                   ),
    //                 ],
    //               ),
    //             ),

    //             const SizedBox(width: 24),

    //             /// RIGHT SIDE
    //             Expanded(
    //               flex: 5,
    //               child: CardPage(
    //                 isFromChcekOut: true,
    //                 onSelectPaymentCard: (card) {
    //                   controller.upatdeCard(card.id);
    //                 },
    //               ),
    //             ),
    //           ],
    //         ),
    //       ),
    //       CustomIconButton(
    //         buttonState: state.isMakePaymentLoading,
    //         text: "Make Payment",
    //         width: 160,
    //         height: 5.h,
    //         onPressed: () async {
    //           await controller.makePayment();
    //         },
    //         color: AppColors.darkBackground,
    //         textColor: AppColors.lightCard,
    //         trailingIcon: Icon(Icons.credit_card_rounded),
    //       ),
    //     ],
    //   ),
    // );
  }
}

class VisaSummaryCard extends ConsumerWidget {
  const VisaSummaryCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final travelerState = ref.watch(
      visaApplicationProvider(ref.watch(personCountProvider)),
    );
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          Text(
            "${VisaHiveService.instance.getCountry()} ${VisaHiveService.instance.getVisaType()}",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          SizedBox(height: 6),
          Text(
            "Valid for ${VisaHiveService.instance.getVisaValidity()} days after arrival",
            style: TextStyle(color: Colors.grey),
          ),
          Divider(height: 12),
          ListView.separated(
            separatorBuilder: (context, index) =>
                Divider(color: AppColors.darkSubText.withValues(alpha: 0.3)),
            shrinkWrap: true,
            itemCount: travelerState.travellers.length,
            itemBuilder: (context, index) {
              final Traveller traveler = travelerState.travellers[index];

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    leading: CircleAvatar(
                      backgroundColor: AppColors.darkText,
                      child: Text(
                        "${index + 1}",
                        style: context.bodyMedium?.copyWith(
                          color: AppColors.blackColor,
                          fontFamily: FontFamily.outfitMedium,
                        ),
                      ),
                    ),
                    title: RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: traveler.firstNameController.text,
                            style: context.bodyMedium?.copyWith(
                              color: AppColors.blackColor,
                              fontFamily: FontFamily.outfitMedium,
                            ),
                          ),
                        ],
                      ),
                    ),
                    subtitle: RichText(
                      text: TextSpan(
                        children: [
                          // TextSpan(
                          //   text: "Passport Number: ",
                          //   style: context.bodyMedium?.copyWith(
                          //     color: AppColors.darkSubText,
                          //   ),
                          // ),
                          TextSpan(
                            text: traveler.passportNumberController.text,
                            style: context.bodyMedium?.copyWith(
                              color: AppColors.blackColor,
                              fontFamily: FontFamily.outfitMedium,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class ProcessingTimeCard extends ConsumerStatefulWidget {
  const ProcessingTimeCard({
    super.key,
    required this.noOfTraveler,
    required this.processingFee,
  });
  final String noOfTraveler;
  final List<ProcessFee> processingFee;

  @override
  ConsumerState<ProcessingTimeCard> createState() => _ProcessingTimeCardState();
}

class _ProcessingTimeCardState extends ConsumerState<ProcessingTimeCard> {
  final String _selected = "standard"; // default selected
  final List<ProcessingOption> processingOptions = [];
  @override
  void dispose() {
    super.dispose();
  }

  bool hasTag(dynamic tag) {
    return tag != null && tag.toString().trim().isNotEmpty;
  }

  @override
  void initState() {
    for (var element in widget.processingFee) {
      processingOptions.add(
        ProcessingOption(
          id: element.id!,
          value: element.price.toString(),
          title: element.title!,
          subtitle: element.subtitle!,
          trailing: hasTag(element.tags)
              ? SizedBox()
              : Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.primaryBlue,
              borderRadius: BorderRadius.all(Radius.circular(20)),
            ),
            child: Text(
              "${element.tags}",
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColors.lightBackground,
              ),
            ),
          ),
        ),
      );
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final selected = ref.watch(processingTypeProvider);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          
          const Text(
            "Choose a processing time",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 6),
          const Text(
            "Expected delivery date: Wed, Jan 21, 2026",
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 16),

          // _radioTile(
          //   value: "standard",
          //   title: "Standard",
          //   subtitle: "Get it in 5 days",
          // ),
          // _radioTile(
          //   value: "rush",
          //   title: "Rush",
          //   subtitle: "Get it in 4 days",
          // ),
          // _radioTile(
          //   value: "super_rush",
          //   title: "Super Rush",
          //   subtitle: "Get it in 3 days",
          //   trailing: const Text(
          //     "⚡ Fastest",
          //     style: TextStyle(color: Colors.blue, fontWeight: FontWeight.w500),
          //   ),
          // ),
          ListView.builder(
            itemCount: processingOptions.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              final item = processingOptions[index];
              final isSelected = selected == item.value;

              return _radioTile(
                ref: ref,
                value: item.value,
                title: item.title,
                subtitle: item.subtitle,
                trailing: item.trailing,
                isSelected: isSelected,
                onChange: () {
                  ref
                          .read(
                            visaApplicationProvider(
                              ref.watch(personCountProvider),
                            ).notifier,
                          )
                          .processId =
                      item.id;
                  ref.read(processingFeeProvider.notifier).state = item.value;
                },
              );
            },
          ),

          const Divider(height: 32),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Total (${widget.noOfTraveler} Traveler)",
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              Text(
                "\$${ref.watch(processingFeeProvider)} USD",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _radioTile({
    required WidgetRef ref,
    required String value,
    required String title,
    required String subtitle,
    required bool isSelected,

    Widget? trailing,
    required Function onChange,
  }) {
    return GestureDetector(
      onTap: () {
        ref.read(processingTypeProvider.notifier).state = value;
        onChange();
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.primaryBlue : Colors.grey.shade300,
            width: 1.5,
          ),
          color: isSelected
              ? AppColors.primaryBlue.withValues(alpha: .03)
              : Colors.transparent,
        ),
        child: Row(
          children: [
            Radio<String>(
              value: value,
              groupValue: ref.watch(processingTypeProvider),
              onChanged: (val) {
                ref.read(processingTypeProvider.notifier).state = val;
              },
              activeColor: AppColors.primaryBlue,
              fillColor: WidgetStatePropertyAll(AppColors.primaryBlue),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 4),
                  Text(subtitle, style: const TextStyle(color: Colors.grey)),
                ],
              ),
            ),
            if (trailing != null) trailing,
          ],
        ),
      ),
    );
  }
}

BoxDecoration _cardDecoration() {
  return BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(16),
    border: Border.all(color: Colors.grey.shade300),
  );
}

Widget _mobileLayout(
  VisaApplicationState state,
  Function(PaymentCardModel model) onSelectPaymentCard,
  List<ProcessFee> processingFee,
) {
  return Column(
    children: [
      const VisaSummaryCard(),
      const SizedBox(height: 16),
      ProcessingTimeCard(
        noOfTraveler: state.travellers.length.toString(),
        processingFee: processingFee,
      ),
      const SizedBox(height: 16),
      CardPage(
        isFromChcekOut: true,
        onSelectPaymentCard: (card) {
          onSelectPaymentCard(card);
        },
      ),
    ],
  );
}

Widget _desktopLayout(
  VisaApplicationState state,
  Function(PaymentCardModel model) onSelectPaymentCard,
  List<ProcessFee> processingFee,
) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      /// LEFT
      Expanded(
        flex: 3,
        child: Column(
          children: [
            const VisaSummaryCard(),
            const SizedBox(height: 20),
            ProcessingTimeCard(
              noOfTraveler: state.travellers.length.toString(),
              processingFee: processingFee,
            ),
          ],
        ),
      ),

      const SizedBox(width: 24),

      /// RIGHT
      Expanded(
        flex: 5,
        child: CardPage(
          isFromChcekOut: true,
          onSelectPaymentCard: (card) {
            onSelectPaymentCard(card);
          },
        ),
      ),
    ],
  );
}
