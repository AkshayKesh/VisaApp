import 'package:flutter/material.dart';
import 'package:register_visa_web_app/core/constants/image_url.dart';
import 'package:register_visa_web_app/core/utils/spacing_extension.dart';
import 'package:register_visa_web_app/features/home/presentation/comman/left_contain.dart';

class OnlineMobileView extends StatelessWidget {
  const OnlineMobileView({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Image.asset(
          ImageUrl.visaPeopleImage,
          height: size.height * 0.5,
          width: double.infinity,
        ),
        40.ht,
        LeftContain(),
      ],
    );
  }
}