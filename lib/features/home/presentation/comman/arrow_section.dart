import 'package:flutter/material.dart';
import 'package:register_visa_web_app/core/constants/app_color.dart';

class ArrowSection extends StatelessWidget {
  const ArrowSection({
    super.key,
    required this.onForward,
    required this.onBackWord,
  });
  final Function onForward;
  final Function onBackWord;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => onBackWord(),
          child: Container(
            padding: EdgeInsets.all(12),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: AppColors.primaryBlue,
            ),
            child: Icon(
              Icons.arrow_back_ios_new,
              color: AppColors.lightBackground,
              size: 16,
            ),
          ),
        ),
        SizedBox(width: 20),
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => onForward(),
          child: Container(
            padding: EdgeInsets.all(12),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: AppColors.primaryBlue,
            ),
            child: Icon(
              Icons.arrow_forward_ios,
              color: AppColors.lightBackground,
              size: 16,
            ),
          ),
        ),
      ],
    );
  }
}
