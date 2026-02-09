import 'package:flutter/material.dart';
import 'package:register_visa_web_app/features/home/presentation/comman/arrow_section.dart';
import 'package:register_visa_web_app/features/home/presentation/comman/titleSection.dart';

class MobileHeader extends StatelessWidget {
  const MobileHeader({super.key, required this.onForward, required this.onBackWord});
   final Function onForward;
  final Function onBackWord;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Titlesection(),
        const SizedBox(height: 16),
        Align(
          alignment: Alignment.centerRight,
          child: ArrowSection(onBackWord:onBackWord ,onForward: onForward,),
        ),
      ],
    );
  }
}
