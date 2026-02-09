import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:register_visa_web_app/core/constants/app_color.dart';
import 'package:register_visa_web_app/core/constants/font_family.dart';
import 'package:register_visa_web_app/core/constants/router/router_names.dart';
import 'package:register_visa_web_app/core/utils/app_toast.dart';
import 'package:register_visa_web_app/core/utils/string_logger_extension.dart';
import 'package:register_visa_web_app/core/utils/text_theme_extension.dart';
import 'package:register_visa_web_app/core/utils/utils.dart';
import 'package:register_visa_web_app/features/profile/domain/card_model.dart';
import 'package:register_visa_web_app/features/profile/presentation/card/card_page.dart';
import 'package:register_visa_web_app/features/profile/presentation/visa/domain/visa_list_param.dart';
import 'package:register_visa_web_app/features/profile/presentation/visa/provider/application_details_provider.dart';
import 'package:register_visa_web_app/features/profile/presentation/visa/provider/application_lisitng_provider.dart';
import 'package:register_visa_web_app/features/profile/providers/card_provider.dart';
import 'package:register_visa_web_app/features/visa_details/domain/visa_details_model.dart';
import 'package:register_visa_web_app/features/visa_details/providers/details_provider.dart';
import 'package:register_visa_web_app/features/visa_process/domain/processing_model.dart';
import 'package:register_visa_web_app/features/visa_process/providers/application_provider.dart';
import 'package:register_visa_web_app/features/visa_process/providers/application_state.dart';
import 'package:register_visa_web_app/shared/services/visa_hive_service.dart';
import 'package:register_visa_web_app/shared/widgets/custom_icon_button.dart';

class DraftPaymentPage extends ConsumerStatefulWidget {
  const DraftPaymentPage({super.key, required this.appId, required this.packageId});

  final String appId;
  final String packageId;
  @override
  ConsumerState<DraftPaymentPage> createState() => _CheckOutPageState();
}

class _CheckOutPageState extends ConsumerState<DraftPaymentPage> {
  late String visaId;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    screenSize = getSize(context);
    "BUILD ${widget.appId}  PACKAGE ID ${widget.packageId}".logE();

    final detailsState = ref.watch(detailsProvider(widget.packageId));
    ref.listen(visaApplicationProvider(ref.watch(personCountProvider)), (previous, next) {
      if (next.isMakePaymentSuccess) {
        Future.delayed(Duration(seconds: 1), () {
          VisaHiveService.instance.clearAll();
          ref.invalidate(cardProvider);

          ref.read(applicationStatusFilterProvider.notifier).state = VisaListParam(status: "close", page: 1);
          AppToast.error(context, next.successPaymentMessage ?? "");
          context.pop();
        });
      }
      if (next.makePaymentError?.isNotEmpty ?? false) {
        AppToast.error(context, next.makePaymentError ?? "");
      }
    });
    final state = ref.watch(visaApplicationProvider(ref.watch(personCountProvider)));
    final controller = ref.read(visaApplicationProvider(ref.watch(personCountProvider)).notifier);

    /// ✅ SAFE LISTENER
    ref.listen<VisaApplicationState>(visaApplicationProvider(ref.watch(personCountProvider)), (previous, next) async {
      if (!mounted) return;

      if (next.isMakePaymentSuccess) {
        VisaHiveService.instance.clearAll();
        controller.clearState();

        AppToast.success(context, next.successPaymentMessage ?? "Payment Success");

        if (!mounted) return;
        context.go(RouterNames.paymentSubmission);
      }

      if (next.makePaymentError?.isNotEmpty ?? false) {
        if (!mounted) return;
        AppToast.error(context, next.makePaymentError ?? "Payment Failed");
      }
    });

    if (detailsState.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (detailsState.isSuccess) {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: (screenSize == ScreenSize.small || screenSize == ScreenSize.normal) ? 10 : 140, vertical: 24),
        child: Column(
          children: [
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                context.pop();
              },
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.arrow_back, color: AppColors.darkSubText),
                  ),
                  Text("Back to visa "),
                ],
              ),
            ),
            SizedBox(height: 20),
            (screenSize == ScreenSize.small || screenSize == ScreenSize.normal)
                ? _mobileLayout(state, (model) => controller.upatdeCard(model.id), detailsState.data?.processingFee ?? [], widget.appId)
                : _desktopLayout(state, (model) => controller.upatdeCard(model.id), detailsState.data?.processingFee ?? [], widget.appId),

            const SizedBox(height: 32),

            /// 🔹 PAY BUTTON
            Align(
              alignment: (screenSize == ScreenSize.small || screenSize == ScreenSize.normal) ? Alignment.center : Alignment.centerRight,
              child: CustomIconButton(
                buttonState: state.isMakePaymentLoading,
                text: "Make Payment",
                width: 180,
                height: 48,

                onPressed: () async {
                  controller.applicationId = widget.appId;
                  if (controller.cardId == null || controller.cardId!.isEmpty) {
                    AppToast.error(context, "Please select a card");
                    return;
                  }
                  if (controller.processId == null || controller.processId!.isEmpty) {
                    AppToast.error(context, "Please select a processing time");
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
      );
    }

    return SizedBox();

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
  const VisaSummaryCard({super.key, required this.appId});
  final String? appId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final applicationDetail = ref.watch(applicationDetailsProvider(appId!));
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration(),
      child: applicationDetail.isLoading
          ? SizedBox.shrink()
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                Text(
                  "${applicationDetail.data?.packageDetails?.country} ${applicationDetail.data?.selectedVisaOption?.entryType}",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                SizedBox(height: 6),
                Text(
                  //"Valid for ${VisaHiveService.instance.getVisaValidity()} days after arrival",
                  "Valid for ${applicationDetail.data?.selectedVisaOption?.lengthOfStay} days after arrival",
                  style: TextStyle(color: Colors.grey),
                ),
                Divider(height: 12),
                ListView.separated(
                  separatorBuilder: (context, index) => Divider(color: AppColors.darkSubText.withValues(alpha: 0.3)),
                  shrinkWrap: true,
                  itemCount: applicationDetail.data?.travellerDetails.length ?? 0,
                  itemBuilder: (context, index) {
                    final traveler = applicationDetail.data?.travellerDetails[index];
                    if (traveler == null) {
                      return const SizedBox.shrink();
                    }

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ListTile(
                          leading: CircleAvatar(
                            backgroundColor: AppColors.darkText,
                            child: Text(
                              "${index + 1}",
                              style: context.bodyMedium?.copyWith(color: AppColors.blackColor, fontFamily: FontFamily.outfitMedium),
                            ),
                          ),
                          title: RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: traveler.fullName,
                                  style: context.bodyMedium?.copyWith(color: AppColors.blackColor, fontFamily: FontFamily.outfitMedium),
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
                                  text: traveler.passportNumbe,
                                  style: context.bodyMedium?.copyWith(color: AppColors.blackColor, fontFamily: FontFamily.outfitMedium),
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
  const ProcessingTimeCard({super.key, required this.noOfTraveler, required this.processingFee});
  final String noOfTraveler;
  final List<ProcessFee> processingFee;

  @override
  ConsumerState<ProcessingTimeCard> createState() => _ProcessingTimeCardState();
}

class _ProcessingTimeCardState extends ConsumerState<ProcessingTimeCard> {
  final List<ProcessingOption> processingOptions = [];
  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    for (var element in widget.processingFee) {
      processingOptions.add(ProcessingOption(id: element.id!, value: element.price.toString(), title: element.title!, subtitle: element.subtitle!));
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
          const Text("Choose a processing time", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
          const SizedBox(height: 6),
          const Text("Expected delivery date: Wed, Jan 21, 2026", style: TextStyle(color: Colors.grey)),
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
                  ref.read(visaApplicationProvider(
                              ref.watch(personCountProvider),
                            ).notifier).processId = item.id;
                  ref.read(processingFeeProvider.notifier).state = item.value;
                },
              );
            },
          ),

          const Divider(height: 32),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Total (${widget.noOfTraveler} Traveler)", style: TextStyle(fontWeight: FontWeight.w600)),
              Text("\$${ref.watch(processingFeeProvider)} USD", style: TextStyle(fontWeight: FontWeight.bold)),
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
          border: Border.all(color: isSelected ? AppColors.primaryBlue : Colors.grey.shade300, width: 1.5),
          color: isSelected ? AppColors.primaryBlue.withValues(alpha: .03) : Colors.transparent,
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
                  Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
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

Widget _mobileLayout(VisaApplicationState state, Function(PaymentCardModel model) onSelectPaymentCard, List<ProcessFee> processingFee, String appId) {
  return Column(
    children: [
      VisaSummaryCard(appId: appId),
      const SizedBox(height: 16),
      ProcessingTimeCard(noOfTraveler: state.travellers.length.toString(), processingFee: processingFee),
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
  String appId,
) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      /// LEFT
      Expanded(
        flex: 3,
        child: Column(
          children: [
            VisaSummaryCard(appId: appId),
            const SizedBox(height: 20),
            ProcessingTimeCard(noOfTraveler: state.travellers.length.toString(), processingFee: processingFee),
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
