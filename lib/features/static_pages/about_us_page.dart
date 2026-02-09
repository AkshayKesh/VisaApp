import 'package:flutter/material.dart';
import 'package:register_visa_web_app/features/static_pages/static_page.dart';

class AboutUsPage extends StatelessWidget {
  const AboutUsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const StaticPage(
      title: 'About Us',
      content: 'Learn more about Register Visa and our mission.',
    );
  }
}
