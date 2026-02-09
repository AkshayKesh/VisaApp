import 'package:flutter/material.dart';
import 'package:register_visa_web_app/features/static_pages/static_page.dart';

class CookiePolicyPage extends StatelessWidget {
  const CookiePolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const StaticPage(
      title: 'Cookie Policy',
      content: 'Learn about our cookie policy.',
    );
  }
}
