import 'package:flutter/material.dart';
import 'package:register_visa_web_app/features/static_pages/static_page.dart';

class HelpCenterPage extends StatelessWidget {
  const HelpCenterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const StaticPage(
      title: 'Help Center',
      content: 'Find answers to your questions and get support.',
    );
  }
}
