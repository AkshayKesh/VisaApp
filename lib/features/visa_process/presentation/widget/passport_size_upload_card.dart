import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:register_visa_web_app/core/constants/app_color.dart';
import 'package:register_visa_web_app/core/constants/font_family.dart';
import 'package:register_visa_web_app/core/constants/image_url.dart';
import 'package:register_visa_web_app/core/utils/text_theme_extension.dart';
import 'package:register_visa_web_app/shared/widgets/image_view.dart';

class PassportSizeUploadCard extends StatelessWidget {
  final bool isLoading;
  final String? imageUrl;
  final Uint8List? imageBytes;
  final VoidCallback onTap;
  final VoidCallback onRemove;
  final double height;
  final double width;

  const PassportSizeUploadCard({
    super.key,
    required this.isLoading,
    required this.imageUrl,
    this.imageBytes,
    required this.onTap,
    required this.onRemove,
    required this.height,
    required this.width,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: isLoading
          ? Container(
              height: height,
              width: width,
              alignment: Alignment.center,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: const CircularProgressIndicator(),
            )
          : _imageCard(
              context: context,
              title: "Passport-size Photo",
              subTitle: "Upload a recent passport-size photo",
              height: height,
              width: width,
              imageUrl: imageUrl,
              imageBytes: imageBytes,
              isLoading: isLoading,
              removeImage: onRemove,
            ),
    );
  }
}

Widget _imageCard({
  required String title,
  required String subTitle,
  required double height,
  double? width,
  String? imageUrl,
  Uint8List? imageBytes,
  bool? isLoading = false,
  required Function removeImage,
  required BuildContext context,
}) {
  final hasImage = (imageBytes != null && imageBytes.isNotEmpty) || (imageUrl != null && imageUrl.isNotEmpty);

  return Consumer(
    builder: (context, ref, child) {
      return Container(
          width: width,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: context.titleSmall?.copyWith(
                  fontSize: 14.0,
                  fontFamily: FontFamily.outfitRegular,
                  letterSpacing: 0.1,
                ),
                textAlign: TextAlign.right,
              ),
              const SizedBox(height: 12),
              if (!hasImage)
                Container(
                  height: height,
                  width: width,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.grey.shade200,
                  ),
                  child: Column(
                    spacing: 20,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        ImageUrl.uploadIcon,
                        color: AppColors.darkSubText,
                        height: 26,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          subTitle,
                          textAlign: TextAlign.center,
                          style: context.textTheme.bodyLarge?.copyWith(
                            fontFamily: FontFamily.outfitRegular,
                            color: AppColors.darkSubText,
                            fontSize: 16.0,
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              else
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: imageBytes != null && imageBytes.isNotEmpty
                          ? Image.memory(
                              imageBytes,
                              height: height,
                              width: width ?? double.infinity,
                              fit: BoxFit.contain,
                            )
                          : AppCacheNetworkImage(
                              url: imageUrl ?? '',
                              height: height,
                              width: width ?? double.infinity,
                              boxFit: BoxFit.contain,
                            ),
                    ),
                    Positioned(
                      right: 10,
                      top: 10,
                      child: GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () => removeImage(),
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppColors.lightBackground,
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                          ),
                          child: Image.asset(ImageUrl.closeRedIcon, height: 26),
                        ),
                      ),
                    ),
                  ],
                ),
            ],
          ),
        );
    },
  );
}
