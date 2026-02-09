import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';

class AppToast {
  static void success(BuildContext context, String message) {
    toastification.show(
      context: context,
      title: const Text('Success'),
      description: Text(message),
      alignment: Alignment.bottomRight,
      type: ToastificationType.success,
      autoCloseDuration: const Duration(seconds: 3),
    );
  }

  static void error(BuildContext context, String message) {
    toastification.show(
      context: context,
      title: const Text('Error'),
      description: Text(message),
      alignment: Alignment.bottomRight,
      type: ToastificationType.error,
      autoCloseDuration: const Duration(seconds: 3),
    );
  }

  static void warning(BuildContext context, String message) {
    toastification.show(
      context: context,
      title: const Text('Warning'),
      description: Text(message),
      alignment: Alignment.bottomRight,
      type: ToastificationType.warning,
    );
  }
}
