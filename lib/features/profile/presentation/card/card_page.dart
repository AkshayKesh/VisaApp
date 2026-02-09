import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:register_visa_web_app/core/constants/app_color.dart';
import 'package:register_visa_web_app/core/constants/app_text_style.dart';
import 'package:register_visa_web_app/core/utils/app_toast.dart';
import 'package:register_visa_web_app/features/profile/domain/card_model.dart';
import 'package:register_visa_web_app/features/profile/presentation/widget/payment_card_item.dart';
import 'package:register_visa_web_app/features/profile/providers/card_provider.dart';
import 'package:register_visa_web_app/shared/widgets/custom_icon_button.dart';
import 'package:webviewx2/webviewx2.dart';

// ignore: must_be_immutable
class CardPage extends ConsumerStatefulWidget {
  const CardPage({super.key, this.isFromChcekOut = false, this.onSelectPaymentCard});
  final bool isFromChcekOut;
  final Function(PaymentCardModel card)? onSelectPaymentCard;

  @override
  ConsumerState<CardPage> createState() => _CardPageState();
}

class _CardPageState extends ConsumerState<CardPage> {
  @override
  void initState() {
    _refreshCall();
    super.initState();
  }

  static Future<void> _showStripeCardAddPopup(BuildContext context, String cardUrl) {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (ctx) => Dialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: Container(
          width: double.maxFinite,
          height: MediaQuery.of(ctx).size.height * 0.85,
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Add Card', style: AppTextStyle.outFitBoldStyle.copyWith(fontSize: 18)),
                    IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.of(ctx).pop()),
                  ],
                ),
              ),
              const Divider(height: 1),
              Expanded(
                child: LayoutBuilder(
                  builder: (_, constraints) {
                    final w = (constraints.maxWidth.isFinite && constraints.maxWidth > 0)
                        ? constraints.maxWidth
                        : 800.0;
                    final h = (constraints.maxHeight.isFinite && constraints.maxHeight > 0)
                        ? constraints.maxHeight
                        : 600.0;
                    return SizedBox(
                      width: w,
                      height: h,
                      child: WebViewX(
                        initialContent: 'about:blank',
                        initialSourceType: SourceType.url,
                        width: w,
                        height: h,
                        onWebViewCreated: (controller) {
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            controller.loadContent(cardUrl, SourceType.url);
                          });
                        },
                        onPageFinished: (_) {},
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _refreshCall() {
    // Add a post-frame callback to listen for URL changes when returning from Stripe

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.invalidate(cardProvider);
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(cardProvider);
    final controler = ref.read(cardProvider.notifier);
    // Add a listener to check if controler.cardUrl has a value, and if so, open it in a new window

    return state.when(
      data: (data) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Card', style: AppTextStyle.outFitBoldStyle.copyWith(fontSize: 20)),
                        if (!widget.isFromChcekOut) ...[
                          SizedBox(height: 8),
                          Text('Manage Your Cards', style: AppTextStyle.outFitRegularStyle.copyWith(color: AppColors.lightSubText)),
                        ],
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 20),
                    child: CustomIconButton(
                      icon: Icon(Icons.add),
                      text: "Add Card",
                      onPressed: () async {
                        ref.read(onLoadingButtonProvider.notifier).state = true;
                        String? cardUrl = await controler.getCardUrl();
                        ref.read(onLoadingButtonProvider.notifier).state = false;
                        if (cardUrl != null && cardUrl.isNotEmpty && context.mounted) {
                          await _showStripeCardAddPopup(context, cardUrl);
                          if (context.mounted) ref.invalidate(cardProvider);
                        } else if (cardUrl == null || cardUrl.isEmpty) {
                          AppToast.error(context, "Please try again after sometime");
                        }
                      },
                      color: AppColors.primaryBlue,
                      buttonState: ref.watch(onLoadingButtonProvider),
                      textColor: Colors.white,
                      width: 120,
                      height: 40,
                      borderRadius: 8,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(16),
                // decoration: BoxDecoration(
                //   border: Border.all(color: Colors.grey.shade300),
                //   borderRadius: BorderRadius.circular(12),
                // ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    Row(
                      children: [
                        const Icon(Icons.folder_open, size: 20),
                        const SizedBox(width: 8),
                        Text('Payment Cards (${data.cards.length})', style: Theme.of(context).textTheme.titleMedium),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // Wrap Cards
                    Wrap(
                      spacing: 16,
                      runSpacing: 16,
                      children: data.cards
                          .map(
                            (card) => PaymentCardItem(
                              isFromChckOut: widget.isFromChcekOut,
                              card: card,
                              onCardSelect: (card) {
                                // Set isSelected on the chosen card, unselect others
                                final newCards = data.cards.map((c) {
                                  if (c.id == card.id) {
                                    return c.copyWith(isSelected: true);
                                  } else {
                                    return c.copyWith(isSelected: false);
                                  }
                                }).toList();
                                ref.read(cardProvider.notifier).updateCards(newCards);
                                widget.onSelectPaymentCard?.call(card);
                              },
                            ),
                          )
                          .toList(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
      error: (error, stackTrace) {
        return Text("data");
      },
      loading: () => SizedBox(
        width: double.infinity,
        height: 600,
        child: Center(child: SpinKitFadingCircle(color: AppColors.primaryBlue, size: 40)),
      ),
    );
  }
}
