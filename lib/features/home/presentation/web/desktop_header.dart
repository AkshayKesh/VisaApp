import 'package:flutter/material.dart';
import 'package:register_visa_web_app/features/home/presentation/comman/arrow_section.dart';
import 'package:register_visa_web_app/features/home/presentation/comman/titleSection.dart';

class DesktopHeader extends StatelessWidget {
  const DesktopHeader({
    super.key,
    required this.onForward,
    required this.onBackWord,
  });

  final Function onForward;
  final Function onBackWord;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Titlesection(),
        ArrowSection(onForward: onForward, onBackWord: onBackWord),
      ],
    );
  }
}
