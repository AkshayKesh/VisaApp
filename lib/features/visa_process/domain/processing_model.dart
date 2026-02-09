import 'package:flutter/material.dart';

class ProcessingOption {
  final String id;
  final String value;
  final String title;
  final String subtitle;
  final Widget? trailing;

  const ProcessingOption({
    required this.id,
    required this.value,
    required this.title,
    required this.subtitle,
    this.trailing,
  });
}
