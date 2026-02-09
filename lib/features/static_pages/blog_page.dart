import 'package:flutter/material.dart';
import 'package:register_visa_web_app/features/static_pages/static_page.dart';

class BlogPage extends StatelessWidget {
  const BlogPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const StaticPage(
      title: 'Blog',
      content: 'Read our articles and insights.',
    );
  }
}
