import 'dart:convert';

import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:register_visa_web_app/core/constants/app_color.dart';
import 'dart:html' as html;

class Utils {
  Utils._internal();

  static final Utils _instance = Utils._internal();

  factory Utils() {
    return _instance;
  }

  // Add your utility methods here
  static Future<String> convertUint8ListToBase64DataUrl(XFile image) async {
    Uint8List imageBytes = await image.readAsBytes();
    String mimeType =
        image.mimeType ?? ""; // e.g., 'image/jpeg', 'image/png', 'image/gif'
    /// Encode the image bytes to base64
    String base64Image = base64Encode(imageBytes);

    /// Convert the base64 string to a data URL with the correct MIME type
    String base64DataUrl = 'data:$mimeType;base64,$base64Image';
    return base64DataUrl;
  }

  static String getMonths(int month) {
    // Returns the three-letter month abbreviation for a given month number (1-12)
    List<String> monthNames = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];

    if (month < 1 || month > 12) {
      throw ArgumentError('Month must be between 1 and 12');
    }
    return monthNames[month - 1];
  }

  static String extractDayRange(String fromDate, String toDate) {
    try {
      final from = DateTime.parse(fromDate);
      final to = DateTime.parse(toDate);
      return '${from.day}-${to.day}';
    } catch (e) {
      // Optionally, handle parsing errors as you wish.
      return '';
    }
  }

  static String dateFormat(String value, {String? divided = '/'}) {
    try {
      final DateTime date = DateTime.parse(value);

      String twoDigit(int value) => value.toString().padLeft(2, '0');

      String month = twoDigit(date.month);
      String day = twoDigit(date.day);
      return '${date.year}$divided$month$divided$day';
    } catch (e) {
      return '';
    }
  }

  static String formatDayMonthTime(String dateTimeIso) {
    try {
      final date = DateTime.parse(dateTimeIso);
      // Day, abbreviated month
      final day = date.day.toString().padLeft(2, '0');
      const monthNames = [
        'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
        'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
      ];
      final month = monthNames[date.month - 1];

      // 12-hour format
      int hour = date.hour;
      String ampm = hour >= 12 ? 'pm' : 'am';
      int hour12 = hour % 12 == 0 ? 12 : hour % 12;
      final minute = date.minute.toString().padLeft(2, '0');

      // Result e.g. 11 Jul 06:32 pm
      return '$day $month ${hour12.toString().padLeft(2, '0')}:$minute $ampm';
    } catch (e) {
      return '';
    }
  }

  static String formatDateString(String dateIso, String format) {
    // Supports format strings with "dd", "mm", "yyyy" (case-insensitive, "-" / "/" / "." separators)
    try {
      final date = DateTime.parse(dateIso);

      String twoDigit(int n) => n.toString().padLeft(2, '0');

      String formatted = format.toLowerCase();
      formatted = formatted.replaceAll('dd', twoDigit(date.day));
      formatted = formatted.replaceAll('mm', twoDigit(date.month));
      formatted = formatted.replaceAll('yyyy', date.year.toString());

      return formatted;
    } catch (e) {
      // If parsing fails, return empty string or handle as needed
      return '';
    }
  }

  static String getInitials(String fullName) {
    if (fullName.trim().isEmpty) return "";
    final parts = fullName.trim().split(RegExp(r"\s+"));
    String initials = "";
    if (parts.length == 1) {
      initials = parts.first.substring(0, 1).toUpperCase();
    } else {
      initials =
          parts[0].substring(0, 1).toUpperCase() +
          parts[1].substring(0, 1).toUpperCase();
    }
    return initials;
  }

  static Future<DateTime?> showAppDatePicker({
    required BuildContext context,
    DateTime? initialDate,
    DateTime? firstDate,
    DateTime? lastDate,
  }) {
    return showDatePicker(
      context: context,
      initialDate: initialDate ?? DateTime.now(),
      firstDate: firstDate ?? DateTime(2000),
      lastDate: lastDate ?? DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColors.primaryBlue, // header & selected date
              onPrimary: Colors.white, // header text
              //onSurface: AppColors.lightBackground, // body text
              surface: AppColors.lightBackground, // dialog background
              onSurface:
                  AppColors.darkBackground, // day numbers and general text
              // Also apply text theme using context
              // Since this is inside Theme.of(context).copyWith(), we can provide a textTheme:
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: AppColors.primaryBlue,
                textStyle: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
            dialogTheme: DialogThemeData(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
          child: child!,
        );
      },
    );
  }

   static String getErrorMessage(dynamic response) {
    if (response is Map<String, dynamic>) {
      final data = response['data'];

      if (data is List && data.isNotEmpty) {
        return data.first.toString();
      }

      return response['message']?.toString() ?? 'Something went wrong';
    }

    return 'Something went wrong';
  }

  static Future<void> downloadFileWebUsingDio(
    String url,
    String fileName,
  ) async {
    final dio = Dio();

    final response = await dio.get<List<int>>(
      url,
      options: Options(responseType: ResponseType.bytes),
    );

    final bytes = Uint8List.fromList(response.data!);

    final blob = html.Blob([bytes]);
    final blobUrl = html.Url.createObjectUrlFromBlob(blob);

    final anchor = html.AnchorElement(href: blobUrl)
      ..setAttribute("download", fileName)
      ..style.display = "none";

    html.document.body!.children.add(anchor);
    anchor.click();

    html.document.body!.children.remove(anchor);
    html.Url.revokeObjectUrl(blobUrl);
  }
}

enum ScreenSize { small, normal, large, extraLarge }

ScreenSize screenSize = ScreenSize.small;

ScreenSize getSize(BuildContext context) {
  double deviceWidth = MediaQuery.of(context).size.shortestSide;

  if (deviceWidth > 900) return ScreenSize.extraLarge;
  if (deviceWidth > 600) return ScreenSize.large;
  if (deviceWidth > 300) return ScreenSize.normal;

  return ScreenSize.small;
}


