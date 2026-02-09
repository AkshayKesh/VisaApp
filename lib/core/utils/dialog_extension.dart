import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:register_visa_web_app/core/constants/app_color.dart';

extension WidgetToDialog on Widget {
  /// Shows any widget inside a custom AlertDialog
  Future<T?> showAsDialog<T>(
    BuildContext context, {
    bool dismissible = true,
    EdgeInsetsGeometry padding = const EdgeInsets.all(0),
    double? maxWidth,
    double? maxHeight,
    Function? onClose,
  }) {
    return showCupertinoDialog<T>(
      context: context,
      barrierDismissible: dismissible,
      builder: (context) {
        return Dialog(
          insetPadding: const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 24,
          ),
          backgroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: maxWidth ?? 1000, // perfect for web popup
              maxHeight: maxHeight ?? 600,
            ),
            child: Padding(
              padding: padding,
              child: Stack(
                children: [
                  Positioned(
                    right: 0,
                    child: IconButton(
                      icon: Icon(Icons.close, color: AppColors.darkBackground),
                      onPressed: () {
                        if (onClose != null) {
                          onClose();
                        }
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  Padding(padding: const EdgeInsets.only(top: 20), child: this),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
