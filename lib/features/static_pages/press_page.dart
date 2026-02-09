import 'package:flutter/material.dart';
import 'package:register_visa_web_app/features/static_pages/static_page.dart';

class PressPage extends StatelessWidget {
  const PressPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const StaticPage(
      title: 'Press',
      content: 'Find our latest press releases and media kits.',
    );
  }
}
