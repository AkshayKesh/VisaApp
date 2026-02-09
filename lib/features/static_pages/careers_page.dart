import 'package:flutter/material.dart';
import 'package:register_visa_web_app/features/static_pages/static_page.dart';

class CareersPage extends StatelessWidget {
  const CareersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const StaticPage(
      title: 'Careers',
      content: 'Explore job opportunities at Register Visa.',
    );
  }
}
