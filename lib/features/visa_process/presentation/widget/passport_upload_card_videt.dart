import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:register_visa_web_app/core/constants/app_color.dart';
import 'package:register_visa_web_app/core/constants/font_family.dart';
import 'package:register_visa_web_app/core/constants/image_url.dart';
import 'package:register_visa_web_app/core/utils/text_theme_extension.dart';
import 'package:register_visa_web_app/shared/widgets/image_view.dart';

class PassportUploadCard extends StatelessWidget {
  final bool isLoading;
  final VoidCallback onTap;
  final VoidCallback onRemove;
  final String title;
  final String subTitle;
  final String? imageUrl;
  final double height;

  const PassportUploadCard({
    super.key,
    required this.isLoading,
    required this.onTap,
    required this.onRemove,
    required this.title,
    required this.subTitle,
    required this.height,
    this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: isLoading
          ? Container(
              height: height,
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
              title: title,
              subTitle: subTitle,
              height: height,
              imageUrl: imageUrl,
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
  bool? isLoading = false,

  required Function removeImage,
  required BuildContext context,
}) {
  return Consumer(
    builder: (context, ref, child) {
      return Container(
        alignment: Alignment.center,
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
            ),
            const SizedBox(height: 12),
            if (imageUrl == null || imageUrl.isEmpty)
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
                    borderRadius: BorderRadiusGeometry.circular(10),
                    child: AppCacheNetworkImage(
                      url: imageUrl,
                      height: height,
                      width: width ?? double.infinity,
                      boxFit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    right: 10,
                    top: 10,
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () {
                        removeImage();
                      },
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
