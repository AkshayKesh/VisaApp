import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:register_visa_web_app/core/constants/app_color.dart';
import 'package:register_visa_web_app/core/constants/app_text_style.dart';
import 'package:register_visa_web_app/core/constants/image_url.dart';
import 'package:register_visa_web_app/core/constants/router/router_names.dart';
import 'package:register_visa_web_app/core/utils/spacing_extension.dart';
import 'package:register_visa_web_app/shared/widgets/app_bar_widget.dart';
import 'package:register_visa_web_app/shared/widgets/app_footer.dart';
import 'package:register_visa_web_app/shared/widgets/custom_icon_button.dart';
import 'package:register_visa_web_app/shared/widgets/payment_widgets.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class PaymentPage extends StatelessWidget {
  const PaymentPage({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isWide = width > 900;

    return Scaffold(
      backgroundColor: AppColors.lightBackground,

      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              CustomAppBar(),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 40),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 24.0,
                      vertical: 24.0,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Image.asset(
                              ImageUrl.cardIcon,
                              width: 28,
                              height: 28,
                            ),
                            8.wt,
                            Text(
                              'Payment Details',
                              style: AppTextStyle.outFitBoldStyle.copyWith(
                                color: AppColors.lightText,
                              ),
                            ),
                          ],
                        ),

                        Text(
                          'Complete your visa application payment',
                          style: AppTextStyle.outFitRegularStyle.copyWith(
                            color: AppColors.lightSubText,
                          ),
                        ),
                        24.ht,
                        isWide ? _wideLayout(context) : _narrowLayout(context),
                        40.ht,
                        Center(
                          child: CustomIconButton(
                            text: "Make Payment",
                            onPressed: () {
                              context.pushNamed(RouterNames.paymentSubmission);
                            },
                            color: AppColors.primaryBlue,
                            textColor: AppColors.lightBackground,
                            height: 4.h,
                            width: 40.w,
                            borderRadius: 8,
                            icon: Image.asset(
                              ImageUrl.circleCheckMarkIcon,
                              color: AppColors.lightBackground,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              40.ht,
              AppFooter(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _wideLayout(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(flex: 3, child: PaymentFormCard()),
        SizedBox(width: 24),
        Expanded(flex: 2, child: PaymentSelectCard()),
      ],
    );
  }

  Widget _narrowLayout(BuildContext context) {
    return Column(
      children: [PaymentFormCard(), SizedBox(height: 16), PaymentSelectCard()],
    );
  }
}
