import 'package:flutter/material.dart';
import 'package:register_visa_web_app/core/constants/image_url.dart';
import 'package:register_visa_web_app/features/home/presentation/comman/left_contain.dart';

class OnlineDesktopView extends StatelessWidget {
  const OnlineDesktopView({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
    
      children: [
        Expanded(child: LeftContain()),
        Expanded(
          child: Image.asset(
            ImageUrl.visaPeopleImage,
            height: size.height * 0.65,
            width: double.infinity,
          ),
        ),
      ],
    );
  }
}
