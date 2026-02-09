import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:register_visa_web_app/core/constants/app_color.dart';
import 'package:register_visa_web_app/core/constants/app_text_style.dart';
import 'package:register_visa_web_app/core/constants/font_family.dart';
import 'package:register_visa_web_app/core/constants/router/router_names.dart';
import 'package:register_visa_web_app/core/utils/spacing_extension.dart';
import 'package:register_visa_web_app/core/utils/text_theme_extension.dart';
import 'package:register_visa_web_app/features/profile/presentation/document/domain/passport_listing_model.dart';
import 'package:register_visa_web_app/features/profile/presentation/document/provider/passport_listing_provide.dart';
import 'package:register_visa_web_app/shared/widgets/custom_icon_button.dart';
import 'package:register_visa_web_app/shared/widgets/image_view.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class MyDocumentsPage extends ConsumerWidget {
  const MyDocumentsPage({super.key});

  // final items = [
  //   VisaApplication(
  //     travelerName: 'John Doe',
  //     appliedDate: '01/15/2030',
  //     country: 'United States',
  //     status: 'Active',
  //   ),
  //   VisaApplication(
  //     travelerName: 'Jane Smith',
  //     appliedDate: '06/20/2029',
  //     country: 'United Kingdom',
  //     status: 'Active',
  //   ),
  // ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(passportListingProvider);

    return SingleChildScrollView(
      padding: EdgeInsets.all(2.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _headerSection(context),
          20.ht,

          state.when(
            data: (data) => _documentsGrid(context, data.passportList ?? []),
            error: (error, stackTrace) => Text("$error"),
            loading: () => Center(child: CircularProgressIndicator()),
          ),
        ],
      ),
    );
  }

  // ---------------------- HEADER ---------------------- //

  Widget _headerSection(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 2.h),

      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('My Documents', style: context.bodyLarge?.copyWith(fontFamily: FontFamily.outfitSemiBold)),
                10.ht,
                Text('Manage your passport documents', style: context.bodyMedium?.copyWith(color: AppColors.lightSubText)),
              ],
            ),
          ),

          // Right button
          CustomIconButton(
            icon: Icon(Icons.add),
            text: 'Add Passport',
            onPressed: () {
              context.go("/document/${RouterNames.passportDetails}");
            },
            color: AppColors.primaryBlue,
            textColor: Colors.white,
            width: 140,
            height: 40,
            borderRadius: 8,
          ),
        ],
      ),
    );
  }

  // ---------------------- GRID SECTION ---------------------- //

  Widget _documentsGrid(BuildContext context, List<PassportListingModel> visaList) {
    final width = MediaQuery.of(context).size.width;
    int crossAxis = width > 1200
        ? 4
        : width > 900
        ? 3
        : width > 600
        ? 2
        : 1;
    return Wrap(
      spacing: 16,
      runSpacing: 16,
      crossAxisAlignment: WrapCrossAlignment.start,
      children: visaList.map((v) {
        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            context.push("/document/${RouterNames.passportDetails}", extra: v);
          },
          child: _documentCard(context, v, crossAxis),
        );
      }).toList(),
    );
  }

  Widget _documentCard(BuildContext context, PassportListingModel v, int crossAxis) {
    return Container(
      width: 300,
      decoration: BoxDecoration(
        color: AppColors.lightBackground,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.lightGrey100),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: imageHeight(crossAxis),
            width: double.infinity,
            decoration: BoxDecoration(color: AppColors.lightGrey100, borderRadius: BorderRadius.circular(10)),
            child: AppCacheNetworkImage(url: "${v.passportFrontPhoto}", boxFit: BoxFit.cover),
          ),
          8.ht,
          Text("${v.firstNameController ?? ''} ${v.lastNameController ?? ''}", style: AppTextStyle.outFitSemiBoldStyle),
          8.ht,
          Text(v.passportNumberController ?? "", style: AppTextStyle.outFitRegularStyle.copyWith(color: AppColors.lightSubText)),
          8.ht,
          Row(
            children: [
              Expanded(
                child: Text(
                  v.isseuCountry ?? "",
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyle.outFitRegularStyle.copyWith(color: AppColors.lightSubText),
                ),
              ),
              4.wt,
              Expanded(
                child: Text(
                  overflow: TextOverflow.ellipsis,
                  'Exp: ${v.passportExpiryDay}/${v.passportExpiryMonth}/${v.passportExpiryYear}',
                  style: AppTextStyle.outFitRegularStyle.copyWith(color: AppColors.lightSubText),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  double imageHeight(int crossAxis) {
    switch (crossAxis) {
      case 4:
        return 140;
      case 3:
        return 160;
      case 2:
        return 180;
      default:
        return 200;
    }
  }
}
