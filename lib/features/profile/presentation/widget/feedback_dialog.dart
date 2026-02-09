import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:go_router/go_router.dart';
import 'package:register_visa_web_app/core/constants/app_color.dart';
import 'package:register_visa_web_app/core/utils/spacing_extension.dart';
import 'package:register_visa_web_app/core/utils/text_theme_extension.dart';
import 'package:register_visa_web_app/shared/widgets/app_text_field.dart';
import 'package:register_visa_web_app/shared/widgets/custom_icon_button.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

// ignore: must_be_immutable
class FeedbackDialog extends StatelessWidget {
  FeedbackDialog({super.key});
  TextEditingController feedBackController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text("Give Your Feedback", style: context.bodyLarge),
        20.ht,
        RatingBar.builder(
          initialRating: 3,
          minRating: 1,
          direction: Axis.horizontal,
          allowHalfRating: true,
          itemCount: 5,
          itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
          itemBuilder: (context, _) =>
              Icon(Icons.star, color: AppColors.primaryBlue),
          onRatingUpdate: (rating) {},
        ),
        20.ht,
        AppTextFormField(
          title: "",
          hint: "Enter Feedback Details",
          controller: feedBackController,
          maxLines: 3,
        ),
        18.ht,
        CustomIconButton(
          text: "Submit",
          onPressed: () {
            context.pop();
          },
          width: 10.w,
          height: 4.h,
          borderRadius: 8,
        ),
      ],
    );
  }
}
