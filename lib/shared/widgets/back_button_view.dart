import 'package:flutter/material.dart';
import 'package:register_visa_web_app/core/constants/app_color.dart';

class BackButtonView extends StatelessWidget {
  const BackButtonView({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        Navigator.pop(context);
      },
      child: Container(
        alignment: Alignment.center,
        margin: EdgeInsets.only(top: 20, left: 20),
        height: 40,
        width: 40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: AppColors.lightBackground.withValues(alpha: .6),
        ),
        child: Icon(
          Icons.arrow_back_ios_new_rounded,
          color: AppColors.lightBackground,
        ),
      ),
    );
  }
}
